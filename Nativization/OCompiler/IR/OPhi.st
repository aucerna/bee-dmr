"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OPhi,
	#superclass : #OInstruction,
	#instVars : [
		'variables',
		'blocks'
	],
	#category : #IR
}

{ #category : #'adding / removing' }
OPhi >> addVariable: value from: block [
	self
		_DENY: (blocks includes: block);
		_ASSERT: (self basicBlock predecessors includes: block).
	variables add: value.
	blocks add: block.
	value addUse: self at: block
]

{ #category : #inquiries }
OPhi >> atOperand: name [
	| index |
	(super atOperand: name) ifNotNil: [:op | ^op].
	index := blocks indexOf: name.
	^variables at: index
]

{ #category : #services }
OPhi >> atOperand: name put: instruction [
	| index |
	(super atOperand: name put: instruction) ifNotNil: [^self].
	index := blocks indexOf: name.
	^variables at: index put: instruction
]

{ #category : #visitor }
OPhi >> basicAcceptVisitor: aVisitor [
	^aVisitor visitPhi: self
]

{ #category : #printing }
OPhi >> basicPrintString [
	| sources |
	sources := variables size > 0
		ifTrue: [
			(variables
				with: blocks
				collect: [:var :block | block name , '->' , var primitivePrintString])
				gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : #private }
OPhi >> basicVariables: aCollection blocks: anotherCollection [
	blocks := anotherCollection.
	variables := aCollection
]

{ #category : #accessing }
OPhi >> blocks [
	^blocks
]

{ #category : #testing }
OPhi >> canHaveSideEffects [
	^false
]

{ #category : #accessing }
OPhi >> clearVariables [
	variables := OrderedCollection new.
	blocks := OrderedCollection new
]

{ #category : #copying }
OPhi >> copyTo: copy with: map [
	| b v |
	super copyTo: copy with: map.
	b := blocks collect: [:block | block duplicateWith: map].
	v := variables collect: [:variable | variable duplicateWith: map].
	copy variables: v blocks: b
]

{ #category : #initialization }
OPhi >> initialize [
	variables := OrderedCollection new.
	blocks := OrderedCollection new
]

{ #category : #testing }
OPhi >> isBoolean [
	^variables conform: [:v | v isBoolean]
]

{ #category : #testing }
OPhi >> isPhi [
	^true
]

{ #category : #enumerating }
OPhi >> operandsDo: aBlock [
	super operandsDo: aBlock.
	variables do: aBlock
]

{ #category : #services }
OPhi >> optimized [
	^variables size = 1 ifTrue: [variables first] ifFalse: [self]
]

{ #category : #printing }
OPhi >> primitivePrintString [
	^'{#phi}'
]

{ #category : #printing }
OPhi >> printStringUsing: names [
	| sources |
	sources := variables size = 0 ifTrue: ['  '] ifFalse: [
		String streamContents: [:strm | 
			variables with: blocks do: [:var :block | 
				strm
					nextPutAll: (names at: block ifAbsent: '?');
					nextPutAll: '->';
					nextPutAll: (names at: var ifAbsent: '?');
					nextPutAll: ', ']]].
	^'phi(' , (sources allButLast: 2) , ')'
]

{ #category : #enumerating }
OPhi >> realReverseDo: aBlock [
	
]

{ #category : #'adding / removing' }
OPhi >> removeBlock: removed [
	| index variable |
	index := blocks indexOf: removed.
	variable := variables at: index.
	variable removeUse: self at: removed.
	variables removeIndex: index.
	blocks removeIndex: index.
	self removeIfPossible
]

{ #category : #'adding / removing' }
OPhi >> removeIfPossible [
	variables size = 1
		ifTrue: [self replaceAllUsesWith: variables first; dissolve]
]

{ #category : #'adding / removing' }
OPhi >> removeVariable: removed at: index [
	| block |
	block := blocks at: index.
	removed removeUse: self at: block.
	variables removeIndex: index.
	blocks removeIndex: index.
	variables size = 1
		ifTrue: [self replaceAllUsesWith: variables first; dissolve]
]

{ #category : #enumerating }
OPhi >> replaceBlock: original with: new [
	blocks withIndexDo: [:block :i | | source |
		block == original ifTrue: [
			source := variables at: i.
			source updateUser: self named: original with: new.
			blocks at: i put: new]]
]

{ #category : #printing }
OPhi >> shortPrintString [
	| sources |
	sources := variables size > 0
		ifTrue: [(variables collect: #primitivePrintString) gather: [:x | x , ', ']]
		ifFalse: ['  '].
	^'[phi(' , (sources allButLast: 2) , ')]'
]

{ #category : #services }
OPhi >> sortAfter: predecessors [
	| indices |
	indices := predecessors collect: [:pred | blocks indexOf: pred].
	variables := indices collect: [:index | variables at: index].
	blocks := predecessors copy
]

{ #category : #testing }
OPhi >> usesResultOf: anInstruction [
	^variables includes: anInstruction
]

{ #category : #accessing }
OPhi >> variables [
	^variables
]

{ #category : #accessing }
OPhi >> variables: aCollection blocks: anotherCollection [
	blocks := anotherCollection.
	variables := aCollection.
	variables with: blocks do: [:var :block | var addUse: self at: block]
]

{ #category : #enumerating }
OPhi >> variablesWithBlocksDo: aBlock [
	variables with: blocks do: aBlock
]

