"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OTemporary,
	#superclass : #OLocal,
	#category : #IR
}

{ #category : #testing }
OTemporary >> isTemporary [
	^true
]

{ #category : #moving }
OTemporary >> lower [
	| pos |
	(self users conform: [:user | user isStore])
		ifTrue: [^self usesDo: [:use | use user dissolve]].
	pos := self function stackIndexOfTemp: self.
	self usesDo: [:use | use user base: self activation; indexImm: pos]
]

{ #category : #printing }
OTemporary >> typeString [
	^'temp'
]

