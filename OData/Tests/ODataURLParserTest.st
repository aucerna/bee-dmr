"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataURLParserTest,
	#superclass : #TestCase,
	#category : #'OData\Tests'
}

{ #category : #all }
ODataURLParserTest >> testArithmeticPrecedence [
	| url expression option |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$filter=length(FirstName) eq 1 mul 2 add 3'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	option := url optionAt: '$filter'.
	expression := option value.
	self
		assert: expression isBinaryExpression;
		assert: expression left isFunctionCall;
		assert: expression left name = 'length';
		assert: expression operation = 'eq';
		assert: expression right isBinaryExpression;
		assert: expression right operation = 'mul';
		assert: expression right right isBinaryExpression;
		assert: expression right right operation = 'add']

{ #category : #postman }
ODataURLParserTest >> testClientSidePaging [
	| url top skip |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$top=2&$skip=2'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	top := url optionAt: '$top'.
	self assert: top value = 2.
	skip := url optionAt: '$skip'.
	self assert: skip value = 2]

{ #category : #postman }
ODataURLParserTest >> testCountingElementsInCollection [
	| url |
	#knownIssue.
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People/$count'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	self halt]

{ #category : #postman }
ODataURLParserTest >> testExpandRelatedEntities [
	| url expand |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$expand=Friends,Trips'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	expand := url optionAt: '$expand'.
	self assert: expand value size = 2]

{ #category : #postman }
ODataURLParserTest >> testFilterCollection [
	| url expression option |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$filter=FirstName eq ''Vincent'''.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	option := url optionAt: '$filter'.
	expression := option value.
	self
		assert: expression isBinaryExpression;
		assert: expression left asString = 'FirstName';
		assert: expression operation = 'eq';
		assert: expression right value = 'Vincent']

{ #category : #postman }
ODataURLParserTest >> testFilterEnumerationProperties [
	| url expression option |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$filter=Gender eq Microsoft.OData.SampleService.Models.TripPin.PersonGender''Female'''.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	option := url optionAt: '$filter'.
	expression := option value.
	self
		assert: expression isBinaryExpression;
		assert: expression left asString = 'Gender';
		assert: expression operation = 'eq';
		assert: expression right value first
			= 'Microsoft.OData.SampleService.Models.TripPin.PersonGender';
		assert: expression right value second = #('Female')]

{ #category : #postman }
ODataURLParserTest >> testFilterNestedStructures [
	| url expression option |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/Airports?$filter=Location/City/Region eq ''California'''.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'Airports';
		assert: url hasOptions.
	option := url optionAt: '$filter'.
	expression := option value.
	self
		assert: expression isBinaryExpression;
		assert: expression left asString = 'Location/City/Region';
		assert: expression operation = 'eq';
		assert: expression right value = 'California']

{ #category : #postman }
ODataURLParserTest >> testFilterUsingAnyAllOperators [
	| url expression option |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$filter=Emails/any(e: endswith(e, ''contoso.com''))'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	option := url optionAt: '$filter'.
	expression := option value.
	self
		assert: expression isLambdaOperator;
		assert: expression path asString = 'Emails';
		assert: expression operator = 'any';
		assert: expression variable = 'e';
		assert: expression expression isFunctionCall;
		assert: expression expression name = 'endswith';
		assert: expression expression arguments first asString = 'e';
		assert: expression expression arguments second value = 'contoso.com']

{ #category : #postman }
ODataURLParserTest >> testFilterUsingBuiltInFunctions [
	| url option expression |
	#knownIssue.
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People(''russellwhyte'')/Trips(0)/PlanItems/Microsoft.OData.SampleService.Models.TripPin.Flight'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource
			= 'People(''russellwhyte'')/Trips(0)/PlanItems/Microsoft.OData.SampleService.Models.TripPin.Flight';
		assert: url hasOptions.
	option := url optionAt: '$filter'.
	expression := option value.
	self assert: expression halt]

{ #category : #postman }
ODataURLParserTest >> testFilterUsingLogicalOperators [
	| url expression option |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$filter=not (contains(FirstName,''Q'')) and (AddressInfo/any(ai:ai/City/Region eq ''WA'') or AddressInfo/any(ai:ai/City/Region eq ''ID''))'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	option := url optionAt: '$filter'.
	expression := option value.
	self
		assert: expression isBinaryExpression;
		assert: expression left isFunctionCall;
		assert: expression left name = 'not';
		assert: expression operation = 'and';
		assert: expression right isBinaryExpression;
		assert: expression right operation = 'or']

{ #category : #all }
ODataURLParserTest >> testFilterUsingNestedAnyOperators [
	| url expression option |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$filter=Company/Employees(''Peter'')/Emails/any(e: endswith(e, ''contoso.com''))'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	option := url optionAt: '$filter'.
	expression := option value.
	self
		assert: expression isLambdaOperator;
		assert: expression path asString = 'Company/Employees(''Peter'')/Emails';
		assert: expression operator = 'any';
		assert: expression variable = 'e';
		assert: expression expression isFunctionCall;
		assert: expression expression name = 'endswith';
		assert: expression expression arguments first asString = 'e';
		assert: expression expression arguments second value = 'contoso.com']

{ #category : #postman }
ODataURLParserTest >> testGetPrimitiveProperty [
	| url |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People(''russellwhyte'')/FirstName'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People(''russellwhyte'')/FirstName';
		deny: url hasOptions]

{ #category : #postman }
ODataURLParserTest >> testGetRawValueOfPrimitiveProperty [
	| url |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People(''russellwhyte'')/FirstName/$value'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People(''russellwhyte'')/FirstName/$value';
		deny: url hasOptions]

{ #category : #postman }
ODataURLParserTest >> testGetSingleEntityFromEntitySet [
	| url |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People(''russellwhyte'')'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People(''russellwhyte'')';
		deny: url hasOptions]

{ #category : #postman }
ODataURLParserTest >> testNavigateRelatedEntities [
	| url |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People(''russellwhyte'')/Friends(''scottketchum'')/AddressInfo'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource
			= 'People(''russellwhyte'')/Friends(''scottketchum'')/AddressInfo';
		deny: url hasOptions]

{ #category : #postman }
ODataURLParserTest >> testReadEntitySet [
	| url |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		deny: url hasOptions]

{ #category : #postman }
ODataURLParserTest >> testReadServiceMetadata [
	| url |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/$metadata'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url isMetadata;
		deny: url hasOptions]

{ #category : #postman }
ODataURLParserTest >> testReadServiceRoot [
	| url |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		deny: url hasOptions]

{ #category : #postman }
ODataURLParserTest >> testSelectProperties [
	| url select |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$select=FirstName,LastName'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	select := url optionAt: '$select'.
	self assert: select value = #('FirstName' 'LastName')]

{ #category : #postman }
ODataURLParserTest >> testSortCollection [
	| url option items |
	url := ODataURLParser current
		parse: 'http://services.odata.org/V4/TripPinService/People?$orderby=length(FirstName) desc,UserName'.
	self
		assert: url root = 'http://services.odata.org/V4/TripPinService/';
		assert: url resource = 'People';
		assert: url hasOptions.
	option := url optionAt: '$orderby'.
	items := option value.
	self
		assert: items size = 2;
		assert: items first key isFunctionCall;
		assert: items first value = 'desc';
		assert: items second asString = 'UserName']

