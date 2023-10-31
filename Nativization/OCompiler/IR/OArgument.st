"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OArgument,
	#superclass : #OLocal,
	#category : #IR
}

{ #category : #testing }
OArgument >> isArgument [
	^true
]

{ #category : #moving }
OArgument >> lower [
	"
	if scheduled it means we are a special ABI argument, don't convert to load in that case
	"
	| pos |
	prev ifNotNil: [^self].
	pos := self function stackIndexOfArg: self.
	self allUses do: [:use | | load |
		load := OLoadOperation base: self activation slotAtImm: pos.
		use transferUseTo: load]
]

{ #category : #printing }
OArgument >> typeString [
	^'arg'
]

