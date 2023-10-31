"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OMessageSend,
	#superclass : #OInstruction,
	#instVars : [
		'receiver',
		'selector',
		'arguments',
		'linker'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OMessageSend class >> receiver: receiver selector: selector arguments: arguments [
	| msg |
	msg := self new.
	^msg
		receiver: receiver;
		selector: selector;
		arguments: arguments
]

{ #category : #'instance creation' }
OMessageSend class >> receiver: receiver
selector: selector
arguments: arguments
linker: aMessageLinker [
	| msg |
	msg := self new.
	^msg
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		linker: aMessageLinker
]

{ #category : #'instance creation' }
OMessageSend class >> selector: selector [
	^self new selector: selector
]

{ #category : #accessing }
OMessageSend >> arguments [
	^arguments
]

{ #category : #accessing }
OMessageSend >> arguments: operands [
	arguments := operands.
	arguments withIndexDo: [:arg :i | arg addUse: self at: i]
]

{ #category : #inquiries }
OMessageSend >> atOperand: named [
	(super atOperand: named) ifNotNil: [:op | ^op].
	^named == #receiver ifTrue: [receiver] ifFalse: [arguments at: named]
]

{ #category : #services }
OMessageSend >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	^operandName = #receiver
		ifTrue: [receiver := instruction]
		ifFalse: [arguments at: operandName put: instruction]
]

{ #category : #visitor }
OMessageSend >> basicAcceptVisitor: aVisitor [
	^aVisitor visitMessageSend: self
]

{ #category : #printing }
OMessageSend >> basicPrintString [
	| string |
	string := arguments size > 0
		ifTrue: [' with: '
			, (arguments gather: [:arg | arg primitivePrintString , ' '])]
		ifFalse: [''].
	^'[send #' , selector , ' to ' , receiver primitivePrintString
		, string trimRight
		, ']'
]

{ #category : #testing }
OMessageSend >> canBeMetaprocessed [
	| current |
	(#(< <= = == ~= != !== => > + - * // & | bitAnd: bitOr: bitShift: bitsAt:)
		includes: selector)
		ifTrue: [^true].
	current := receiver class.
	[
		(current methodDictionary includesKey: selector) ifTrue: [^true].
		current !== ONode]
		whileTrue: [current := current superclass].
	^false
]

{ #category : #copying }
OMessageSend >> copyTo: copy with: map [
	| args |
	super copyTo: copy with: map.
	copy
		selector: selector;
		linker: linker;
		receiver: (receiver duplicateWith: map).
	args := arguments collect: [:a | a duplicateWith: map].
	copy arguments: args
]

{ #category : #services }
OMessageSend >> emitSendUsing: anAssembler [
	linker emitSend: selector using: anAssembler
]

{ #category : #testing }
OMessageSend >> isMessageSend [
	^true
]

{ #category : #testing }
OMessageSend >> isSuperSend [
	^false
]

{ #category : #accessing }
OMessageSend >> linker [
	^linker
]

{ #category : #accessing }
OMessageSend >> linker: aMessageLinker [
	linker := aMessageLinker
]

{ #category : #moving }
OMessageSend >> lowerIn: anOMethod [
	| new |
	new := arguments collect: [:argument | | push |
		push := argument insertPushBefore: self.
		argument removeUseBy: self.
		push].
	self arguments: new.
	anOMethod activation haveFrame
]

{ #category : #'own services' }
OMessageSend >> metaprocess [
	| s node optimized users |
	s := self specialSelector.
	node := receiver perform: s withArguments: arguments asArray.
	node name ifNil: [node name: s].
	optimized := node optimized.
	optimized == node ifFalse: [node release].
	users := self users.
	optimized isStore ifTrue: [self replaceAllUsesWith: optimized value].
	(optimized isMemoryOperation
		or: [optimized class == OBinaryOperation
			and: [optimized canHaveSideEffects]])
		ifTrue: [self beforeInsert: optimized].
	self replaceAllUsesWith: optimized; dissolve; optimize: users
]

{ #category : #enumerating }
OMessageSend >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: receiver.
	arguments do: aBlock
]

{ #category : #printing }
OMessageSend >> primitivePrintString [
	^'{#' , selector , '}'
]

{ #category : #printing }
OMessageSend >> printStringUsing: names [
	| string |
	string := arguments size > 0
		ifTrue: [' with: '
			, (arguments gather: [:arg | (names at: arg ifAbsent: ['?']) , ' '])]
		ifFalse: [''].
	^'send #' , selector , ' to ' , (names at: receiver ifAbsent: ['?'])
		, string trimRight
]

{ #category : #accessing }
OMessageSend >> receiver [
	^receiver
]

{ #category : #accessing }
OMessageSend >> receiver: operand [
	receiver := operand.
	receiver addUse: self at: #receiver
]

{ #category : #accessing }
OMessageSend >> selector [
	^selector
]

{ #category : #accessing }
OMessageSend >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #'own services' }
OMessageSend >> specialSelector [
	selector first == $_ ifTrue: [^selector].
	(selector == #'=' or: [selector == #'==']) ifTrue: [^#_equals:].
	(selector == #'~=' or: [selector == #'!=' or: [selector == #'!==']])
		ifTrue: [^#_notEquals:].
	selector == #'<' ifTrue: [^#_smiLessThan:].
	selector == #'<=' ifTrue: [^#_smiLessEqualThan:].
	selector == #'>=' ifTrue: [^#_smiGreaterEqualThan:].
	selector == #'>' ifTrue: [^#_smiGreaterThan:].
	selector == #'+' ifTrue: [^#_smiPlus:].
	selector == #'-' ifTrue: [^#_smiMinus:].
	selector == #'*' ifTrue: [^#_smiMultiply:].
	selector == #'//' ifTrue: [^#_smiQuotient:].
	(selector == #'&' or: [selector == #bitAnd:]) ifTrue: [^#_smiBitAnd:].
	(selector == #'|' or: [selector == #bitOr:]) ifTrue: [^#_smiBitOr:].
	selector == #bitShift: ifTrue: [^#_smiBitShift:].
	selector == #bitsAt: ifTrue: [^#_smiBitsAt:].
	self _ASSERT: false
]

{ #category : #testing }
OMessageSend >> usesResultOf: anInstruction [
	^receiver == anInstruction
		or: [arguments anySatisfy: [:argument | argument == anInstruction]]
]

