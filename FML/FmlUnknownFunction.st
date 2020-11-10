"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlUnknownFunction,
	#superclass : #FmlParserError,
	#instVars : [
		'name'
	],
	#category : #FML
}

{ #category : #private }
FmlUnknownFunction class >> unknownFunction: aString in: anFmlExpression [
	^self new expression: anFmlExpression; name: aString; signal]

{ #category : #accessing }
FmlUnknownFunction >> defaultDescription [
	^'Unknown function name ' , name storeString]

{ #category : #testing }
FmlUnknownFunction >> isResumable [
	^expression functionDefinition notNil]

{ #category : #accessing }
FmlUnknownFunction >> name [
	^name]

{ #category : #accessing }
FmlUnknownFunction >> name: aString [
	name := aString]

