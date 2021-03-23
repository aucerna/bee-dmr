"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Schema',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'title',
		'multipleOf',
		'maximum',
		'exclusiveMaximum',
		'minimum',
		'exclusiveMinimum',
		'maxLength',
		'minLength',
		'pattern',
		'maxItems',
		'minItems',
		'uniqueItems',
		'maxProperties',
		'minProperties',
		'required',
		'enum',
		'type',
		'allOf',
		'oneOf',
		'anyOf',
		'not',
		'items',
		'properties',
		'additionalProperties',
		'description',
		'format',
		'default',
		'nullable',
		'discriminator',
		'readOnly',
		'writeOnly',
		'xml',
		'externalDocs',
		'example',
		'deprecated'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Schema >> addPropertyNamed: aString schema: anOpenAPI [
.Schema
	properties isNil ifTrue: [properties := OrderedDictionary new].
	properties at: aString put: anOpenAPI.Schema]

{ #category : #accessing }
OpenAPI.Schema >> anyOf: aCollection [
	anyOf := aCollection]

{ #category : #accessing }
OpenAPI.Schema >> format: aString [
	format := aString]

{ #category : #accessing }
OpenAPI.Schema >> items [
	^items]

{ #category : #accessing }
OpenAPI.Schema >> items: anOpenAPI [
.Schema
	items := anOpenAPI.Schema]

{ #category : #accessing }
OpenAPI.Schema >> mediaType [
	format = 'binary' ifTrue: [^MediaType binary].
	type = 'text' ifTrue: [^MediaType text].
	^MediaType json]

{ #category : #accessing }
OpenAPI.Schema >> type [
	^type]

{ #category : #accessing }
OpenAPI.Schema >> type: aString [
	type := aString]

