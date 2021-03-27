"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataQueryTest,
	#superclass : #TestCase,
	#category : #'OData\Tests'
}

{ #category : #private }
ODataQueryTest >> testCollectionAccess [
	| query |
	query := ODataQuery new entity: 'serviceRoot'; collection: 'People'.
	self assert: query entity = 'serviceRoot/People'.
	query entity: 'serviceRoot/People'; individual: 'russellwhyte'.
	self assert: query entity = 'serviceRoot/People(''russellwhyte'')'.
	query
		entity: 'serviceRoot';
		individual: 'russellwhyte' in: 'People'.
	self assert: query entity = 'serviceRoot/People(''russellwhyte'')'.
	query
		entity: 'serviceRoot';
		property: 'Name' of: 'KSFO' in: 'Airports'.
	self assert: query entity = 'serviceRoot/Airports(''KSFO'')/Name']

{ #category : #private }
ODataQueryTest >> testEqualFilter [
	| query |
	query := ODataQuery new
		entity: 'serviceRoot';
		filter: 'People' where: 'FirstName' equals: 'Scott'.
	self
		assert: query asString
			= 'serviceRoot/People?$filter=FirstName eq ''Scott''']

{ #category : #private }
ODataQueryTest >> testOrderBy [
	| query |
	query := ODataQuery new
		entity: 'serviceRoot/People(''scottketchum'')';
		collection: 'Trips';
		orderBy: 'EndsAt'.
	self
		assert: query asString
			= 'serviceRoot/People(''scottketchum'')/Trips?$orderby=EndsAt'.
	query := ODataQuery new
		entity: 'serviceRoot/People(''scottketchum'')';
		order: 'Trips' by: 'EndsAt'.
	self
		assert: query asString
			= 'serviceRoot/People(''scottketchum'')/Trips?$orderby=EndsAt'.
	query := ODataQuery new
		entity: 'serviceRoot/People(''scottketchum'')';
		order: 'Trips' by: 'EndsAt' ascending: false.
	self
		assert: query asString
			= 'serviceRoot/People(''scottketchum'')/Trips?$orderby=EndsAt desc']

{ #category : #private }
ODataQueryTest >> testPropertyAccess [
	| query |
	query := ODataQuery new
		entity: 'serviceRoot/Airports(''KSFO'')';
		property: 'Name'.
	self assert: query entity = 'serviceRoot/Airports(''KSFO'')/Name'.
	query property: 'Name' of: 'serviceRoot/Airports(''KSFO'')'.
	self assert: query entity = 'serviceRoot/Airports(''KSFO'')/Name']

{ #category : #private }
ODataQueryTest >> testRawValueAccess [
	| query |
	query := ODataQuery new
		entity: 'serviceRoot';
		individual: 'KSFO' in: 'Airports';
		value: 'Name'.
	self assert: query asString = 'serviceRoot/Airports(''KSFO'')/Name/$value']

{ #category : #private }
ODataQueryTest >> testSearch [
	| query |
	query := ODataQuery new
		entity: 'serviceRoot';
		collection: 'People';
		search: 'Boise'.
	self assert: query asString = 'serviceRoot/People?$search=Boise'.
	query := ODataQuery new
		entity: 'serviceRoot';
		search: 'Boise' in: 'People'.
	self assert: query asString = 'serviceRoot/People?$search=Boise']

{ #category : #private }
ODataQueryTest >> testSelect [
	| query |
	query := ODataQuery new
		entity: 'serviceRoot';
		collection: 'Airports';
		select: #('Name' 'IcaoCode').
	self assert: query asString = 'serviceRoot/Airports?$select=Name, IcaoCode'.
	query := ODataQuery new
		entity: 'serviceRoot';
		select: #('Name' 'IcaoCode') from: 'Airports'.
	self assert: query asString = 'serviceRoot/Airports?$select=Name, IcaoCode']

{ #category : #private }
ODataQueryTest >> testSkip [
	| query |
	query := ODataQuery new entity: 'serviceRoot/People'; skip: 18.
	self assert: query asString = 'serviceRoot/People?$skip=18'.
	query := ODataQuery new
		entity: 'serviceRoot';
		skip: 18 from: 'People'.
	self assert: query asString = 'serviceRoot/People?$skip=18']

{ #category : #private }
ODataQueryTest >> testTop [
	| query |
	query := ODataQuery new entity: 'serviceRoot/People'; top: 2.
	self assert: query asString = 'serviceRoot/People?$top=2'.
	query := ODataQuery new
		entity: 'serviceRoot';
		top: 2 from: 'People'.
	self assert: query asString = 'serviceRoot/People?$top=2']

