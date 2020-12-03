"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESwitchDefaultClause,
	#superclass : #JSESwitchClauseNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSESwitchDefaultClause >> acceptVisitor: aVisitor [
	^aVisitor acceptSwitchDefaultClause: self]

