"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEStringNode,
	#superclass : #JSEPrimitiveLiteralNode,
	#instVars : [
		'delimiter',
		'source'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEStringNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLiteralString: self]

{ #category : #accessing }
JSEStringNode >> delimiter [
	^delimiter = $" ifTrue: [$"] ifFalse: [$']]

{ #category : #accessing }
JSEStringNode >> fromToken: aToken [
	super fromToken: aToken.
	source := aToken value.
	((position between: 2 and: end)
		and: [(aToken collection at: position - 1) = $"])
		ifTrue: [delimiter := $"]]

{ #category : #testing }
JSEStringNode >> isRGBColor [
	value isString ifFalse: [^false].
	value isEmpty ifTrue: [^false].
	value first = $# ifFalse: [^false].
	value size = 7 ifFalse: [^false].
	^(Integer readFrom: value allButFirst readStream radix: 16) hex
		= value allButFirst]

{ #category : #accessing }
JSEStringNode >> source [
	^source]

