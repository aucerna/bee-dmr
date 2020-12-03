"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEProgramNode,
	#superclass : #JSESourceElementListNode,
	#instVars : [
		'source'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEProgramNode >> acceptVisitor: aVisitor [
	^aVisitor acceptProgram: self]

{ #category : #testing }
JSEProgramNode >> hasFinalSeparator [
	^source trimBlanks endsWith: ';']

{ #category : #printing }
JSEProgramNode >> printOn: aStream indent: anInteger [
	| visitor |
	visitor := JSEPrintSourceVisitor on: aStream.
	visitor
		indent: anInteger;
		appendSemicolon: self hasFinalSeparator;
		visit: self]

{ #category : #printing }
JSEProgramNode >> printTextOn: rtf indent: anInteger [
	| visitor |
	visitor := JSEColorPrinterVisitor on: rtf.
	visitor
		appendSemicolon: self hasFinalSeparator;
		indent: anInteger;
		visit: self]

{ #category : #accessing }
JSEProgramNode >> source: aString [
	source := aString]

