"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataLambdaOperator,
	#superclass : #ODataExpression,
	#instVars : [
		'path',
		'operator',
		'variable',
		'expression'
	],
	#category : #OData
}

{ #category : #accessing }
ODataLambdaOperator >> expression [
	^expression]

{ #category : #accessing }
ODataLambdaOperator >> expression: anODataExpression [
	expression := anODataExpression]

{ #category : #initialization }
ODataLambdaOperator >> initialize [
	super initialize.
	path := ODataPropertyPath new]

{ #category : #testing }
ODataLambdaOperator >> isLambdaOperator [
	^true]

{ #category : #accessing }
ODataLambdaOperator >> operator [
	^operator]

{ #category : #accessing }
ODataLambdaOperator >> operator: aString [
	operator := aString]

{ #category : #accessing }
ODataLambdaOperator >> path [
	^path]

{ #category : #accessing }
ODataLambdaOperator >> path: anODataPropertyPath [
	path := anODataPropertyPath]

{ #category : #accessing }
ODataLambdaOperator >> pathPrefix: anODataPropertyPath [
	path := anODataPropertyPath , path]

{ #category : #printing }
ODataLambdaOperator >> printOn: aStream [
	path printOn: aStream.
	aStream nextPut: $/; nextPutAll: operator.
	variable isNil ifTrue: [^self].
	aStream
		nextPut: $(;
		nextPutAll: variable;
		nextPut: $:;
		space.
	expression printOn: aStream.
	aStream nextPut: $)]

{ #category : #accessing }
ODataLambdaOperator >> variable [
	^variable]

{ #category : #accessing }
ODataLambdaOperator >> variable: aString [
	variable := aString]

