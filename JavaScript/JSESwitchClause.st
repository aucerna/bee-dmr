"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESwitchClause,
	#superclass : #JSESwitchClauseNode,
	#instVars : [
		'clause'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSESwitchClause >> acceptVisitor: aVisitor [
	^aVisitor acceptSwitchClause: self]

{ #category : #accessing }
JSESwitchClause >> clause [
	^clause]

{ #category : #accessing }
JSESwitchClause >> clause: aClause [
	clause := aClause]

