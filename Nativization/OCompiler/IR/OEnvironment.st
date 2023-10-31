"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OEnvironment,
	#superclass : #OLocal,
	#category : #IR
}

{ #category : #moving }
OEnvironment >> lowerInstantiation [
	self _DENY: self isUsed
]

{ #category : #moving }
OEnvironment >> lowerLoad [
	| lowered |
	self _ASSERT: false.
	lowered := index
		ifNil: [self localEnvironment]
		ifNotNil: [OLoadOperation base: self activation slotAtImm: index + 1].
	self allUses do: [:use | 
		use user beforeInsert: lowered.
		use replaceWith: lowered]
]

{ #category : #printing }
OEnvironment >> typeString [
	^'env'
]

