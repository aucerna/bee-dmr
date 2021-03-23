"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Node',
	#superclass : #Object,
	#category : #OpenAPI
}

{ #category : #'instance creation' }
OpenAPI.Node class >> new [
	^super new initialize]

{ #category : #converting }
OpenAPI.Node >> asJson [
	| json value child |
	json := JsonObject new.
	self class instVarNames
		select: [:ivar | 
			child := self instVarNamed: ivar.
			child notNil]
		thenDo: [:ivar | 
			value := self jsonFrom: child.
			json at: ivar put: value].
	^json]

{ #category : #converting }
OpenAPI.Node >> jsonFrom: anObject [
	(anObject isKindOf: OpenAPI.Node) ifTrue: [^anObject asJson].
	(anObject isCollection andNot: [anObject isString])
		ifTrue: [^anObject collect: [:value | self jsonFrom: value]].
	^anObject]

