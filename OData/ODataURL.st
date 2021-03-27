"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataURL,
	#superclass : #Object,
	#instVars : [
		'root',
		'resource',
		'options'
	],
	#category : #OData
}

{ #category : #'instance creation' }
ODataURL class >> new [
	^super new initialize]

{ #category : #testing }
ODataURL >> hasOptions [
	^options isEmptyOrNil not]

{ #category : #testing }
ODataURL >> isMetadata [
	^resource = '$metadata']

{ #category : #accessing }
ODataURL >> optionAt: aString [
	^options detect: [:option | option name = aString] ifNone: nil]

{ #category : #accessing }
ODataURL >> options [
	^options]

{ #category : #accessing }
ODataURL >> options: aCollection [
	options := aCollection]

{ #category : #printing }
ODataURL >> printOptionsOn: aStream [
	options isEmptyOrNil ifTrue: [^self].
	options
		do: [:option | option printOn: aStream]
		separatedBy: [aStream nextPut: $$]]

{ #category : #printing }
ODataURL >> printTextOn: rtf [
	rtf
		useColor: Color darkGray
		while: [root notNil ifTrue: [rtf nextPutAll: root]];
		useColor: Color blue
		while: [resource notNil ifTrue: [rtf nextPutAll: resource]];
		useColor: Color darkGreen while: [self printOptionsOn: rtf]]

{ #category : #accessing }
ODataURL >> resource [
	^resource]

{ #category : #accessing }
ODataURL >> resource: aString [
	resource := aString]

{ #category : #accessing }
ODataURL >> root [
	^root]

{ #category : #accessing }
ODataURL >> root: aString [
	root := aString]

