"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataQueryOption,
	#superclass : #Object,
	#instVars : [
		'name',
		'value'
	],
	#category : #OData
}

{ #category : #'instance creation' }
ODataQueryOption class >> name: aString value: anObject [
	^self new name: aString; value: anObject]

{ #category : #accessing }
ODataQueryOption >> name [
	^name]

{ #category : #accessing }
ODataQueryOption >> name: aString [
	name := aString]

{ #category : #printing }
ODataQueryOption >> printOn: aStream [
	aStream nextPutAll: name; nextPut: $=.
	value printOn: aStream]

{ #category : #evaluating }
ODataQueryOption >> value [
	^value]

{ #category : #evaluating }
ODataQueryOption >> value: anObject [
	value := anObject]

