"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataBinaryExpression,
	#superclass : #ODataExpression,
	#instVars : [
		'left',
		'operation',
		'right'
	],
	#category : #OData
}

{ #category : #'instance creation' }
ODataBinaryExpression class >> left: leftExpression operation: aString right: rightExpression [
	^self new
		left: leftExpression;
		operation: aString;
		right: rightExpression]

{ #category : #testing }
ODataBinaryExpression >> isBinaryExpression [
	^true]

{ #category : #accessing }
ODataBinaryExpression >> left [
	^left]

{ #category : #accessing }
ODataBinaryExpression >> left: anODataExpression [
	left := anODataExpression]

{ #category : #accessing }
ODataBinaryExpression >> operation [
	^operation]

{ #category : #accessing }
ODataBinaryExpression >> operation: aString [
	operation := aString]

{ #category : #printing }
ODataBinaryExpression >> printOn: aStream [
	left printOn: aStream.
	aStream space; nextPutAll: operation; space.
	right printOn: aStream]

{ #category : #accessing }
ODataBinaryExpression >> right [
	^right]

{ #category : #accessing }
ODataBinaryExpression >> right: anODataExpression [
	right := anODataExpression]

