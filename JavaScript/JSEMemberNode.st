"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEMemberNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'base',
		'member'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEMemberNode >> base [
	^base]

{ #category : #accessing }
JSEMemberNode >> base: aJSEParseNode [
	base := aJSEParseNode.
	position := base position]

{ #category : #inquiries }
JSEMemberNode >> identifier [
	^base identifier , '.' , member identifier]

{ #category : #accessing }
JSEMemberNode >> member [
	^member]

{ #category : #accessing }
JSEMemberNode >> member: aJSEParseNode [
	member := aJSEParseNode.
	end := member end]

