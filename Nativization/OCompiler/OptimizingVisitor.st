"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingVisitor,
	#superclass : #ParseTreeVisitor,
	#instVars : [
		'method',
		'currentFunction',
		'currentBlock'
	],
	#category : #OCompiler
}

{ #category : #accessing }
OptimizingVisitor >> abi [
	^method abi
]

{ #category : #inquiries }
OptimizingVisitor >> activation [
	^currentFunction activation
]

{ #category : #private }
OptimizingVisitor >> assureBlockReturn: last [
	| return value |
	return := currentFunction returnValue.
	return source ifNotNil: [^self].
	value := last ifNil: [self loadNil].
	return source: value
]

{ #category : #private }
OptimizingVisitor >> assureMethodReturn [
	| return |
	return := method returnValue.
	return source ifNil: [return source: method receiver]
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadArgument: index [
	"
	arguments cannot be reassigned, so unlike temps we don't need to load them
	"
	^currentFunction argumentAt: index
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadAssociation: anAssociation [
	| global read name |
	name := anAssociation key asString asSymbol.
	name == #WordSize ifTrue: [^self loadLiteral: self abi wordSize].
	name == #WordSizeShift ifTrue: [^self loadLiteral: self abi wordSizeShift].
	global := anAssociation asMoveConstant.
	read := OLoadOperation base: global slotAtImm: 1.
	currentBlock add: global; add: read.
	^read
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadEnvironment: envIndex [
	| result |
	result := self activation environment.
	envIndex ifNotNil: [
		result := OLoadOperation base: result slotAtImm: envIndex.
		currentBlock add: result].
	^result
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadEnvironmentTemporary: tempIndex environment: envIndex [
	| load environment |
	self error: 'non-inlined closure arguments not yet supported'.
	environment := self loadEnvironment: envIndex.
	load := OLoadOperation base: environment slotAtImm: tempIndex.
	currentBlock add: load.
	^load
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadFalse [
	^self loadLiteral: false
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadInstance: index [
	| receiver load |
	receiver := self receiver.
	load := OLoadOperation base: receiver slotAtImm: index.
	currentBlock add: load.
	^load
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadLiteral: value [
	| constant |
	constant := value asMoveConstant.
	currentBlock add: constant.
	^constant
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadNil [
	^self loadLiteral: nil
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadSelf [
	^self receiver
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadTemporary: anInteger [
	| temporary load |
	temporary := currentFunction temporaryAt: anInteger.
	load := OLoadOperation base: temporary slotAtImm: 1.
	currentBlock add: load.
	^load
]

{ #category : #'emitting - load' }
OptimizingVisitor >> loadTrue [
	^self loadLiteral: true
]

{ #category : #private }
OptimizingVisitor >> lowerSpecialABI [
	| literals i actual next load |
	literals := method baseMethod literals.
	literals size = 0 ifTrue: [^self].
	(literals at: 1) == #savePreviousSelf ifTrue: [
		self activation doSavePreviousSelf.
		load := method start detect: [:inst | inst isConstant].
		load dissolve.
		literals := literals copyFrom: 2].
	literals size = 0 ifTrue: [^self].
	(literals at: 1) == #specialABIBegin ifFalse: [^self].
	i := 2.
	[(literals at: i) == #specialABIEnd]
		whileFalse: [| name register regname arg |
			name := literals at: i.
			regname := literals at: i + 1.
			register := self registerNamed: regname.
			name == #self ifTrue: [self receiver register: register] ifFalse: [
				arg := method argumentNamed: name.
				arg register: register.
				self receiver afterInsert: arg].
			i := i + 2].
	actual := method start detect: [:inst | inst isConstant].
	[
		next := actual next.
		actual dissolve.
		actual isConstant and: [actual value == #specialABIEnd]]
		whileFalse: [actual := next]
]

{ #category : #inquiries }
OptimizingVisitor >> receiver [
	^currentFunction receiver
]

{ #category : #inquiries }
OptimizingVisitor >> registerNamed: regname [
	^self abi perform: regname
]

{ #category : #'emitting - store' }
OptimizingVisitor >> storeAssociation: association with: value [
	| global write |
	global := association asMoveConstant.
	write := OStoreOperation base: global slotAtImm: 1 put: value.
	currentBlock add: global; add: write
]

{ #category : #'emitting - store' }
OptimizingVisitor >> storeEnvironmentTemporary: tempIndex environment: envIndex with: value [
	| environment store |
	self error: 'non-inlined closure arguments not yet supported'.
	environment := self loadEnvironment: envIndex.
	store := OStoreOperation base: environment slotAtImm: tempIndex put: value.
	currentBlock add: store
]

{ #category : #'emitting - store' }
OptimizingVisitor >> storeInstance: index with: value [
	| write |
	write := OStoreOperation base: self receiver slotAtImm: index put: value.
	currentBlock add: write
]

{ #category : #'emitting - store' }
OptimizingVisitor >> storeTemporary: anInteger with: value [
	| temporary store |
	temporary := currentFunction temporaryAt: anInteger.
	store := OStoreOperation base: temporary slotAtImm: 1 put: value.
	currentBlock add: store
]

{ #category : #services }
OptimizingVisitor >> translate: anOMethod [
	method := anOMethod.
	currentFunction := method.
	currentBlock := method start.
	self visit: method baseMethod ast
]

{ #category : #visiting }
OptimizingVisitor >> visitAssignment: anAssignmentNode [
	| result |
	result := anAssignmentNode expression acceptVisitor: self.
	anAssignmentNode assignees
		do: [:node | node binding store: result using: self]
]

{ #category : #visiting }
OptimizingVisitor >> visitBlock: aBlockNode [
	| previousFunction previousBlock result |
	previousFunction := currentFunction.
	previousBlock := currentBlock.
	result := OBlockClosure new parent: currentFunction.
	currentFunction := result.
	currentBlock := currentFunction start.
	self _ASSERT: aBlockNode isInlined.
	currentFunction arguments addAll: previousFunction arguments.
	currentFunction temporaries addAll: previousFunction temporaries.
	self visitScript: aBlockNode.
	currentFunction := previousFunction.
	currentBlock := previousBlock.
	^result
]

{ #category : #visiting }
OptimizingVisitor >> visitCascade: aCascadeNode [
	| receiver arguments send block |
	block := currentBlock.
	receiver := aCascadeNode receiver acceptVisitor: self.
	aCascadeNode messages do: [:msg | 
		arguments := msg arguments collect: [:node | node acceptVisitor: self].
		send := OMessageSend
			receiver: receiver
			selector: msg selector value asSymbol
			arguments: arguments.
		block add: send].
	^send
]

{ #category : #visiting }
OptimizingVisitor >> visitIdentifier: anIdentifierNode [
	^anIdentifierNode binding loadUsing: self
]

{ #category : #visiting }
OptimizingVisitor >> visitLiteral: aLiteralNode [
	| load |
	load := aLiteralNode value asMoveConstant.
	currentBlock add: load.
	^load
]

{ #category : #visiting }
OptimizingVisitor >> visitMessage: aMessageNode [
	| receiver arguments selector instruction |
	receiver := aMessageNode receiver acceptVisitor: self.
	arguments := aMessageNode arguments
		collect: [:node | node acceptVisitor: self].
	selector := aMessageNode selector symbol.
	instruction := OMessageSend
		receiver: receiver
		selector: selector
		arguments: arguments.
	currentBlock add: instruction.
	^instruction
]

{ #category : #visiting }
OptimizingVisitor >> visitMethod: anSMethod [
	self visitScript: anSMethod; lowerSpecialABI
]

{ #category : #visiting }
OptimizingVisitor >> visitReturn: aReturnNode [
	| value |
	value := aReturnNode expression acceptVisitor: self.
	currentFunction explicitReturn: value from: currentBlock
]

{ #category : #visiting }
OptimizingVisitor >> visitScript: aScriptNode [
	| last lastnode |
	aScriptNode arguments do: [:arg | currentFunction addArgument: arg name].
	aScriptNode temporaries
		do: [:temp | currentFunction addTemporary: temp name].
	self _ASSERT: aScriptNode environmentSize = 0.
	aScriptNode statements do: [:node | 
		lastnode := node.
		last := node acceptVisitor: self].
	(lastnode isNil orNot: [lastnode isReturn])
		ifTrue: [currentFunction implicitReturn: last from: currentBlock].
	currentFunction scheduleNodes
]

{ #category : #visiting }
OptimizingVisitor >> visitSelector: aSelectorNode [
	
]

