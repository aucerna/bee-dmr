"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlVisitor,
	#superclass : #Object,
	#category : #FML
}

{ #category : #'instance creation' }
FmlVisitor class >> new [
	^super new initialize]

{ #category : #testing }
FmlVisitor >> goesInsideVariables [
	^false]

{ #category : #visiting }
FmlVisitor >> visit: anFmlExpression [
	^anFmlExpression notNil ifTrue: [anFmlExpression acceptVisitor: self]]

{ #category : #visiting }
FmlVisitor >> visitArray: anFmlArray [
	self visitNode: anFmlArray]

{ #category : #visiting }
FmlVisitor >> visitBinary: anFmlBinaryExpression [
	self
		visitNode: anFmlBinaryExpression;
		visit: anFmlBinaryExpression left;
		visit: anFmlBinaryExpression right]

{ #category : #visiting }
FmlVisitor >> visitExternalLinkVariable: aPeepVariable [
	"
	do nothing
	"
	]

{ #category : #visiting }
FmlVisitor >> visitFmlBoolean: anFmlValue [
	self visitValue: anFmlValue]

{ #category : #visiting }
FmlVisitor >> visitFmlDate: anFmlValue [
	self visitValue: anFmlValue]

{ #category : #visiting }
FmlVisitor >> visitFmlNumber: anFmlValue [
	self visitValue: anFmlValue]

{ #category : #visiting }
FmlVisitor >> visitFmlString: anFmlValue [
	self visitValue: anFmlValue]

{ #category : #visiting }
FmlVisitor >> visitFmlUndefined: anFmlValue [
	self visitValue: anFmlValue]

{ #category : #visiting }
FmlVisitor >> visitFunctionCall: anFmlFunctionCall [
	self visitNode: anFmlFunctionCall.
	anFmlFunctionCall arguments do: [:arg | self visit: arg]]

{ #category : #visiting }
FmlVisitor >> visitNode: amFmlExpression [
	"
	nothing by default
	"
	]

{ #category : #visiting }
FmlVisitor >> visitValue: anFmlValue [
	self visitNode: anFmlValue]

{ #category : #visiting }
FmlVisitor >> visitVariable: csrVariable [
	csrVariable isBindingVariable
		ifTrue: [^csrVariable basicDefinition ifNotNil: [:v | self visit: v]].
	csrVariable hasFmlFunction ifFalse: [^self].
	csrVariable fmlExpression ifNotNil: [:fml | self visit: fml]]

{ #category : #visiting }
FmlVisitor >> visitVariableName: anFmlVariableName [
	| var |
	self visitNode: anFmlVariableName.
	var := anFmlVariableName variable.
	(self goesInsideVariables and: [var isVariable]) ifTrue: [self visit: var]]

