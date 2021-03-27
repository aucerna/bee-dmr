"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataQuery,
	#superclass : #WebServiceQuery,
	#category : #OData
}

{ #category : #options }
ODataQuery >> count: collection [
	"
	self new entity: 'serviceRoot'; count: 'People'
	"
	entity := self collection: collection.
	^entity / '$count']

{ #category : #filter }
ODataQuery >> filter: collection where: property contains: value [
	"
	(self new entity: 'serviceRoot'; filter: 'Airports'  where: 'Location/Address' contains:'San Francisco') asString
	"
	self
		collection: collection;
		filterWhere: property contains: value]

{ #category : #filter }
ODataQuery >> filter: collection where: property equals: value [
	"
	(self new entity: 'serviceRoot'; filter: 'People' where: 'FirstName' equals: 'Scott') asString
	"
	self
		collection: collection;
		filterWhere: property equals: value]

{ #category : #filter }
ODataQuery >> filterWhere: property contains: value [
	self
		addOption: '$filter=contains(' , property , ', ' , value printString , ')']

{ #category : #filter }
ODataQuery >> filterWhere: property equals: value [
	self addOption: '$filter=' , property , ' eq ' , value printString]

{ #category : #entity }
ODataQuery >> individual: id [
	"
	(self new entity: 'serviceRoot/People'; individual: 'russellwhyte') entity
	"
	| key |
	key := id isString ifTrue: [id storeString] ifFalse: [id asString].
	entity := entity , '(' , key , ')']

{ #category : #entity }
ODataQuery >> individual: id in: name [
	"
	(self new entity: 'serviceRoot'; individual: 'russellwhyte' in: 'People') entity
	"
	self collection: name; individual: id]

{ #category : #ordering }
ODataQuery >> order: collection by: property [
	"
	self new entity: 'serviceRoot/People(''scottketchum'')'; order: 'Trips' by: 'EndsAt'
	"
	^self
		collection: collection;
		orderBy: property ascending: true]

{ #category : #ordering }
ODataQuery >> order: collection by: property ascending: aBoolean [
	"
	(self new entity: 'serviceRoot/People(''scottketchum'')'; order: 'Trips' by: 'EndsAt' ascending: false) asString
	"
	self
		collection: collection;
		orderBy: property ascending: aBoolean]

{ #category : #ordering }
ODataQuery >> orderBy: property [
	self orderBy: property ascending: true]

{ #category : #ordering }
ODataQuery >> orderBy: property ascending: aBoolean [
	"
	(self new entity: 'serviceRoot/People(''scottketchum'')'; collection: 'Trips'; orderBy: 'EndsAt' ascending: false) asString
	"
	| direction |
	direction := aBoolean ifTrue: [''] ifFalse: [' desc'].
	self addOption: '$orderby=' , property , direction]

{ #category : #entity }
ODataQuery >> property: name [
	"
	(self new entity: 'serviceRoot/Airports(''KSFO'')'; property: 'Name') entity
	"
	entity := entity / name]

{ #category : #entity }
ODataQuery >> property: name of: resource [
	"
	(self new property: 'Name' of: 'serviceRoot/Airports(''KSFO'')') entity
	"
	self entity: resource; property: name]

{ #category : #entity }
ODataQuery >> property: name of: id in: collection [
	"
	(self new entity: 'serviceRoot'; property: 'Name' of: 'KSFO' in: 'Airports') entity
	(self new entity: 'serviceRoot'; property: 'Location/Address' of: 'KSFO' in: 'Airports') entity
	"
	self
		individual: id in: collection;
		property: name]

{ #category : #search }
ODataQuery >> search: aString [
	"
	(self new entity: 'serviceRoot';collection: 'People'; search: 'Boise') asString
	"
	self addOption: '$search=' , aString]

{ #category : #search }
ODataQuery >> search: aString in: collection [
	"
	(self new entity: 'serviceRoot'; search: 'Boise' in: 'People') asString
	"
	self collection: collection; search: aString]

{ #category : #select }
ODataQuery >> select: properties [
	"
	(self new entity: 'serviceRoot'; select: #('Name' 'IcaoCode') from:'Airports') asString
	"
	| fields |
	fields := properties isString ifTrue: [properties] ifFalse: [
		String streamContents: [:strm | 
			properties
				do: [:p | strm nextPutAll: p]
				separatedBy: [strm nextPut: $,; space]]].
	^self addOption: '$select=' , fields]

{ #category : #select }
ODataQuery >> select: properties from: collection [
	"
	(self new entity: 'serviceRoot'; select: #('Name' 'IcaoCode') from:'Airports') asString
	"
	self collection: collection; select: properties]

{ #category : #'skip & top' }
ODataQuery >> skip: number [
	"
	(self new entity: 'serviceRoot/People'; skip: 18) asString
	"
	self addOption: '$skip=' , number asString]

{ #category : #'skip & top' }
ODataQuery >> skip: number from: collection [
	"
	(self new entity: 'serviceRoot'; skip: 18 from: 'People') asString
	"
	self collection: collection; skip: number]

{ #category : #'skip & top' }
ODataQuery >> top: number [
	"
	(self new entity: 'serviceRoot/People'; top: 2) asString
	"
	self addOption: '$top=' , number asString]

{ #category : #'skip & top' }
ODataQuery >> top: number from: collection [
	"
	(self new entity: 'serviceRoot'; top: 2 from: 'People') asString
	"
	self collection: collection; top: number]

{ #category : #value }
ODataQuery >> value: property [
	"
	(self new entity: 'serviceRoot/Airports(''KSFO'')'; value: 'Name') asString
	"
	self property: property; addOption: '/$value']

{ #category : #value }
ODataQuery >> value: property of: resource [
	"
	self new value: 'Name' of: 'serviceRoot/Airports(''KSFO'')'
	"
	self entity: resource; value: property]

{ #category : #value }
ODataQuery >> value: property of: id in: collection [
	"
	(self new entity: 'serviceRoot'; value: 'Name' of: 'KSFO' in: 'Airports') asString
	"
	self
		individual: id in: collection;
		value: property]

