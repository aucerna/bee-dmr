"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSelf,
	#superclass : #OArgument,
	#category : #IR
}

{ #category : #initialization }
OSelf >> initialize [
	super initialize.
	name := #self
]

{ #category : #testing }
OSelf >> isReceiver [
	^true
]

{ #category : #printing }
OSelf >> primitivePrintString [
	^'[self]'
]

