"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEArrayNode,
	#superclass : #JSELiteralNode,
	#instVars : [
		'array',
		'padBefore',
		'padAfter'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEArrayNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLiteralArray: self]

{ #category : #accessing }
JSEArrayNode >> array [
	^array]

{ #category : #accessing }
JSEArrayNode >> array: anArray [
	array := anArray ifNil: #().
	array isEmpty ifTrue: [^self].
	position := array first position - 1.
	end := array last end + 1]

{ #category : #accessing }
JSEArrayNode >> literalValue [
	^(Array new: padBefore) , array , (Array new: padAfter)]

{ #category : #accessing }
JSEArrayNode >> padAfter [
	^padAfter]

{ #category : #accessing }
JSEArrayNode >> padAfter: anInteger [
	padAfter := anInteger ifNil: 0.
	end notNil ifTrue: [end := end + padAfter]]

{ #category : #accessing }
JSEArrayNode >> padBefore [
	^padBefore]

{ #category : #accessing }
JSEArrayNode >> padBefore: anInteger [
	padBefore := anInteger ifNil: 0.
	position notNil ifTrue: [position := position - padBefore]]

