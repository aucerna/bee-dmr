Class {
	#name : #CType,
	#superclass : #Object,
	#instVars : [
		'translator',
		'binding'
	],
	#category : #C
}

{ #category : #'instance creation' }
CType class >> new [
	^super new initialize
]

{ #category : #accessing }
CType >> baseType [
	^self
]

{ #category : #accessing }
CType >> basicPrintString [
	^self name
]

{ #category : #accessing }
CType >> classBinding [
	^binding
]

{ #category : #accessing }
CType >> classBinding: aClass [
	"
	self ASSERT: (binding isNil or: [binding = aClass]).
	"
	binding := aClass
]

{ #category : #private }
CType >> classBindingFrom: aString [
	Smalltalk at: aString asSymbol ifPresent: [:class | ^class].
	((aString endsWith: 'W') or: [aString endsWith: 'A']) ifFalse: [^nil].
	^Smalltalk at: aString allButLast asSymbol ifAbsent: nil
]

{ #category : #private }
CType >> conflictiveFields [
	^#()
]

{ #category : #printing }
CType >> format [
	^String streamContents: [:strm | self printOn: strm indent: 0]
]

{ #category : #accessing }
CType >> getterBodyFor: fieldName [
	| body |
	body := '^self ' , self keyword , ' ' , fieldName.
	self classBinding isClass
		ifTrue: [body := body , ' ofClass: ' , self classBinding name].
	^body
]

{ #category : #printing }
CType >> isPointer [
	^false
]

{ #category : #printing }
CType >> isStruct [
	^false
]

{ #category : #testing }
CType >> isUnnamedStruct [
	^false
]

{ #category : #testing }
CType >> isVoid [
	^false
]

{ #category : #printing }
CType >> literals [
	^{self name}
]

{ #category : #inspecting }
CType >> loadFields [
	
]

{ #category : #accessing }
CType >> name [
	^self subclassResponsibility
]

{ #category : #accessing }
CType >> naturalAlignment [
	^self sizeInBytes
]

{ #category : #services }
CType >> pointer [
	^CPointerType new
		translationUnit: translator;
		baseType: self;
		indirections: '*'
]

{ #category : #services }
CType >> pointer: asterisks [
	^asterisks isEmpty ifTrue: [self] ifFalse: [self pointer]
]

{ #category : #printing }
CType >> printMainOn: rtf indent: n [
	^self printOn: rtf indent: n
]

{ #category : #printing }
CType >> printMainTextOn: rtf indent: n [
	^self printTextOn: rtf indent: n
]

{ #category : #printing }
CType >> printOn: aStream indent: n [
	^self printOn: aStream
]

{ #category : #printing }
CType >> printTextOn: aStream indent: n [
	^self printTextOn: aStream
]

{ #category : #inspecting }
CType >> refersToStruct [
	^false
]

{ #category : #services }
CType >> selectors [
	^self literals collect: #asSymbol
]

{ #category : #accessing }
CType >> translationUnit: aCTranslationUnit [
	translator := aCTranslationUnit
]

