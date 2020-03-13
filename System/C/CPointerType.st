"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #CPointerType,
	#superclass : #CType,
	#instVars : [
		'baseType',
		'indirections'
	],
	#category : #C
}

{ #category : #printing }
CPointerType >> baseType: aCType [
	baseType := aCType
]

{ #category : #private }
CPointerType >> getterBodyFor: fieldName [
	| accessor class bind |
	bind := baseType classBinding.
	accessor := (bind isClass and: [bind inheritsFrom: CharacterArray])
		ifTrue: [' fromAddress: ']
		ifFalse: [' atAddress: '].
	class := baseType == #char ifTrue: [String] ifFalse: [bind].
	class isClass ifFalse: [^'^self ' , self keyword , ' ' , fieldName].
	^String streamContents: [:strm | 
		strm
			nextPutAll: '| pointer |';
			crtab;
			nextPutAll: 'pointer := self ';
			nextPutAll: self keyword;
			space;
			nextPutAll: fieldName;
			nextPut: $.;
			crtab;
			nextPutAll: '^pointer isValid ifTrue: [';
			nextPutAll: class name;
			nextPutAll: accessor;
			nextPutAll: fieldName;
			nextPut: $]]
]

{ #category : #printing }
CPointerType >> indirections: aString [
	indirections := aString
]

{ #category : #initialization }
CPointerType >> initialize [
	super initialize.
	indirections := '*'
]

{ #category : #printing }
CPointerType >> isPointer [
	^true
]

{ #category : #testing }
CPointerType >> isUnresolved [
	^false
]

{ #category : #accessing }
CPointerType >> keyword [
	^'pointerAtOffset:'
]

{ #category : #accessing }
CPointerType >> name [
	^baseType name , '*'
]

{ #category : #printing }
CPointerType >> printOn: aStream [
	baseType printMainOn: aStream indent: 0.
	aStream nextPutAll: indirections
]

{ #category : #printing }
CPointerType >> printTextOn: aStream [
	baseType printMainTextOn: aStream indent: 0.
	aStream nextPutAll: indirections
]

{ #category : #accessing }
CPointerType >> sizeExpression [
	^'ExternalPointer sizeInBytes'
]

{ #category : #accessing }
CPointerType >> sizeInBytes [
	^translator pointerSize
]

