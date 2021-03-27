"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WebServiceQuery,
	#superclass : #Object,
	#instVars : [
		'entity',
		'options'
	],
	#category : #OData
}

{ #category : #'instance creation' }
WebServiceQuery class >> new [
	^super new initialize]

{ #category : #operations }
WebServiceQuery >> action: name [
	"
	(self new entity: 'serviceRoot'; action: 'Clear') entity
	"
	entity := entity / name]

{ #category : #private }
WebServiceQuery >> addOption: option [
	options := options isEmpty
		ifTrue: [option]
		ifFalse: [options , '&' , option]]

{ #category : #entity }
WebServiceQuery >> collection: name [
	"
	(self new entity: 'serviceRoot'; collection: 'People') entity
	"
	entity := entity / name]

{ #category : #accessing }
WebServiceQuery >> entity [
	^entity]

{ #category : #accessing }
WebServiceQuery >> entity: resource [
	entity := resource]

{ #category : #operations }
WebServiceQuery >> function: name [
	"
	(self new entity: 'serviceRoot'; function: 'Calculate') entity
	"
	entity := entity / name]

{ #category : #initialization }
WebServiceQuery >> initialize [
	super initialize.
	entity := ''.
	options := '']

{ #category : #printing }
WebServiceQuery >> printOn: aStream [
	aStream nextPutAll: entity.
	options isEmpty ifTrue: [^self].
	options first = $/ ifFalse: [aStream nextPut: $?].
	aStream nextPutAll: options]

