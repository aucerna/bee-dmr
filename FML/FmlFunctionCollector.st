"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlFunctionCollector,
	#superclass : #FmlVisitor,
	#instVars : [
		'functions'
	],
	#category : #FML
}

{ #category : #accessing }
FmlFunctionCollector >> functions [
	^functions]

{ #category : #initialization }
FmlFunctionCollector >> initialize [
	super initialize.
	functions := Bag new]

{ #category : #visiting }
FmlFunctionCollector >> visitBinary: aFmlBinaryExpression [
	functions add: aFmlBinaryExpression operator.
	self visit: aFmlBinaryExpression left; visit: aFmlBinaryExpression right]

{ #category : #visiting }
FmlFunctionCollector >> visitFunctionCall: aFmlFunctionCall [
	functions add: aFmlFunctionCall functionDefinition.
	aFmlFunctionCall arguments do: [:arg | self visit: arg]]

