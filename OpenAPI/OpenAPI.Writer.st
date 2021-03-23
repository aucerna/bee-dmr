"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Writer',
	#superclass : #Object,
	#instVars : [
		'document',
		'api',
		'types',
		'class'
	],
	#category : #OpenAPI
}

{ #category : #services }
OpenAPI.Writer class >> documentForAPI: aClass [
	^self new documentForAPI: aClass]

{ #category : #private }
OpenAPI.Writer >> addBodyTo: anOpenAPI.Operation [
from: aFunctionDescriptor
	| body parameter kind type schema |
	parameter := aFunctionDescriptor parameters
		detect: [:p | p name = 'body']
		ifNone: nil.
	body := OpenAPI.RequestBody new.
	body required: true.
	parameter notNil
		ifTrue: [
			kind := parameter type ifNil: ['String'].
			type := self typeNamed: kind.
			schema := self referenceToType: type.
			body description: parameter description; schema: schema]
		ifFalse: [body description: '<complete>'; plainText].
	anOpenAPI.Operation requestBody: body]

{ #category : #private }
OpenAPI.Writer >> addParametersTo: anOpenAPI.Operation [
from: aFunctionDescriptor
	aFunctionDescriptor parameters
		reject: [:p | p name = 'body']
		thenDo: [:p | | kind type schema parameter |
			kind := p type ifNil: ['String'].
			type := self typeNamed: kind.
			schema := self referenceToType: type.
			parameter := OpenAPI.Parameter new
				name: p name;
				in: 'path';
				description: p description;
				required: true;
				schema: schema.
			anOpenAPI.Operation addParameter: parameter]]

{ #category : #private }
OpenAPI.Writer >> addPaths [
	api addRoutesTo: self]

{ #category : #private }
OpenAPI.Writer >> addPathTo: uri verb: verb action: selector [
	| method descriptor tag operation path |
	method := self compiledMethodFor: selector.
	(method isNil orNot: [method isWebAPIMethod]) ifTrue: [^self].
	descriptor := method descriptor.
	tag := self tagFromURI: uri.
	operation := OpenAPI.Operation new.
	operation
		tag: tag;
		operationId: verb , '_' , selector;
		summary: descriptor description;
		description: descriptor description.
	self addParametersTo: operation from: descriptor.
	(verb = 'POST' or: [verb = 'PUT'])
		ifTrue: [self addBodyTo: operation from: descriptor].
	self addResponseTo: operation from: descriptor.
	path := document paths addPathTo: uri.
	path verb: verb operation: operation]

{ #category : #private }
OpenAPI.Writer >> addResponseTo: anOpenAPI.Operation [
from: aFunctionDescriptor
	| response type schema |
	response := anOpenAPI.Operation
		addResponse: 200
		description: 'Successful operation'.
	aFunctionDescriptor type isNil ifTrue: [^self].
	type := self typeNamed: aFunctionDescriptor type.
	type notNil ifTrue: [
		schema := self referenceToType: type.
		response jsonSchema: schema]]

{ #category : #private }
OpenAPI.Writer >> addSchemas [
	types isNil ifTrue: [^self].
	types do: [:type | | schema |
		schema := self schemaFromType: type.
		document components addSchema: schema named: type name]]

{ #category : #private }
OpenAPI.Writer >> addTags [
	| tags |
	tags := document paths tags asArray sort
		collect: [:t | OpenAPI.Tag new name: t; description: '<description>'].
	document tags: tags]

{ #category : #private }
OpenAPI.Writer >> buildDocument [
	self
		newDocument;
		addPaths;
		addSchemas;
		addTags]

{ #category : #'router compatibility' }
OpenAPI.Writer >> compiledMethodFor: aSymbol [
	| object |
	object := class isNil ifTrue: [api] ifFalse: [class].
	^object compiledMethodFor: aSymbol]

{ #category : #testing }
OpenAPI.Writer >> definesType: anEdmType [
	^types includesKey: anEdmType name]

{ #category : #services }
OpenAPI.Writer >> documentForAPI: aClass [
	api := aClass.
	types := aClass edmTypes.
	self buildDocument.
	^document]

{ #category : #private }
OpenAPI.Writer >> newDocument [
	| server contact |
	document := OpenAPI.Object new.
	document info
		title: 'This document describes the ' , (api apiName ifNil: [''])
			, ' Web API';
		version: '<version>';
		description: '<description>'.
	server := OpenAPI.Server new url: api baseUri.
	document addServer: server; addBasicAuthentication.
	contact := OpenAPI.Contact new
		name: '<company>';
		url: '<URL>';
		email: 'mail@company'.
	document info contact: contact]

{ #category : #'router compatibility' }
OpenAPI.Writer >> receiver: anObject [
	class := self receiverFrom: anObject]

{ #category : #'router compatibility' }
OpenAPI.Writer >> receiverFrom: anObject [
	| object |
	object := anObject isClosure
		ifTrue: [[anObject value]
			on: Error
			do: [anObject method classBinding instanceClass]]
		ifFalse: [anObject].
	object isClass ifTrue: [^object].
	(object isKindOf: WebAPI) ifTrue: [^object class].
	self ASSERT: false.
	^nil]

{ #category : #private }
OpenAPI.Writer >> referenceToType: anEdmType [
	(anEdmType isBasicType
		or: [anEdmType isArrayType]
		or: [anEdmType isUnionType])
		ifTrue: [^self schemaFromType: anEdmType].
	self ASSERT: (self definesType: anEdmType).
	^OpenAPI.Reference new ref: '#/components/schemas' / anEdmType name]

{ #category : #'router compatibility' }
OpenAPI.Writer >> routeDELETE: uri to: selector [
	self addPathTo: uri verb: 'DELETE' action: selector]

{ #category : #'router compatibility' }
OpenAPI.Writer >> routeGET: uri to: selector [
	self addPathTo: uri verb: 'GET' action: selector]

{ #category : #'router compatibility' }
OpenAPI.Writer >> routeHEAD: uri to: selector [
	self addPathTo: uri verb: 'HEAD' action: selector]

{ #category : #'router compatibility' }
OpenAPI.Writer >> routePOST: uri to: selector [
	self addPathTo: uri verb: 'POST' action: selector]

{ #category : #'router compatibility' }
OpenAPI.Writer >> routePUT: uri to: selector [
	self addPathTo: uri verb: 'PUT' action: selector]

{ #category : #'router compatibility' }
OpenAPI.Writer >> router [
	]

{ #category : #private }
OpenAPI.Writer >> schemaFromType: anEdmType [
	| schema type subschema options |
	schema := OpenAPI.Schema new.
	anEdmType isUnionType ifTrue: [
		options := anEdmType types collect: [:t | self referenceToType: t].
		^schema anyOf: options].
	type := self typeFrom: anEdmType.
	schema type: type.
	anEdmType isBasicType ifTrue: [
		anEdmType isBinary ifTrue: [schema format: 'binary'].
		^schema].
	anEdmType isEnumType ifTrue: [^schema].
	anEdmType isArrayType ifTrue: [
		subschema := self referenceToType: anEdmType subtype.
		^schema items: subschema].
	anEdmType allProperties do: [:p | 
		subschema := self referenceToType: p type.
		schema addPropertyNamed: p name schema: subschema].
	^schema]

{ #category : #private }
OpenAPI.Writer >> tagFromURI: uri [
	| tag |
	tag := uri.
	tag first = $/ ifTrue: [tag := tag allButFirst].
	^tag upTo: $/]

{ #category : #private }
OpenAPI.Writer >> typeFrom: anEdmType [
	| name |
	anEdmType isArrayType ifTrue: [^'array'].
	anEdmType isComplexType ifTrue: [^'object'].
	anEdmType isEnumType ifTrue: [^'string'].
	name := anEdmType name.
	name = 'Binary' ifTrue: [^'string'].
	name = 'Boolean' ifTrue: [^'boolean'].
	name = 'Byte' ifTrue: [^'byte'].
	name = 'DateTime' ifTrue: [^'string'].
	name = 'DateTimeOffset' ifTrue: [^'string'].
	name = 'Double' ifTrue: [^'number'].
	name = 'Float' ifTrue: [^'number'].
	name = 'Int32' ifTrue: [^'integer'].
	name = 'Int64' ifTrue: [^'number'].
	name = 'String' ifTrue: [^'string'].
	self ASSERT: false.
	^name asLowercase]

{ #category : #private }
OpenAPI.Writer >> typeNamed: aString [
	(EdmBasicType named: aString) ifNotNil: [:type | ^type].
	(aString beginsWith: 'Array[') ifTrue: [| id subtype |
		self ASSERT: aString last = $].
		id := aString allButLast trimPrefix: 'Array['.
		subtype := self typeNamed: id.
		^EdmArrayType of: subtype].
	^types at: aString ifAbsent: nil]

