"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataExpression,
	#superclass : #Object,
	#category : #OData
}

{ #category : #'instance creation' }
ODataExpression class >> new [
	^super new initialize]

{ #category : #testing }
ODataExpression >> isBinaryExpression [
	^false]

{ #category : #testing }
ODataExpression >> isFunctionCall [
	^false]

{ #category : #testing }
ODataExpression >> isLambdaOperator [
	^false]

