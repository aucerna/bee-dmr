"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Parameter',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'name',
		'in',
		'description',
		'required',
		'deprecated',
		'allowEmptyValue',
		'style',
		'explode',
		'allowReserved',
		'schema',
		'example',
		'examples',
		'content'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Parameter >> allowEmptyValue [
	^allowEmptyValue]

{ #category : #accessing }
OpenAPI.Parameter >> allowEmptyValue: aBoolean [
	allowEmptyValue := aBoolean]

{ #category : #accessing }
OpenAPI.Parameter >> allowReserved [
	^allowReserved]

{ #category : #accessing }
OpenAPI.Parameter >> allowReserved: aBoolean [
	allowReserved := aBoolean]

{ #category : #accessing }
OpenAPI.Parameter >> content [
	^content]

{ #category : #accessing }
OpenAPI.Parameter >> content: aDictionary [
	content := aDictionary]

{ #category : #accessing }
OpenAPI.Parameter >> deprecated [
	^deprecated]

{ #category : #accessing }
OpenAPI.Parameter >> deprecated: aBoolean [
	deprecated := aBoolean]

{ #category : #accessing }
OpenAPI.Parameter >> description [
	^description]

{ #category : #accessing }
OpenAPI.Parameter >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.Parameter >> example [
	^example]

{ #category : #accessing }
OpenAPI.Parameter >> example: anObject [
	example := anObject]

{ #category : #accessing }
OpenAPI.Parameter >> examples [
	^examples]

{ #category : #accessing }
OpenAPI.Parameter >> examples: aDictionary [
	examples := aDictionary]

{ #category : #accessing }
OpenAPI.Parameter >> explode [
	^explode]

{ #category : #accessing }
OpenAPI.Parameter >> explode: aBoolean [
	explode := aBoolean]

{ #category : #accessing }
OpenAPI.Parameter >> in [
	^in]

{ #category : #accessing }
OpenAPI.Parameter >> in: aString [
	in := aString.
	aString = 'path' ifTrue: [required := true]]

{ #category : #initialization }
OpenAPI.Parameter >> initialize [
	super initialize.
	required := deprecated := allowEmptyValue := explode := allowReserved := false]

{ #category : #accessing }
OpenAPI.Parameter >> name [
	^name]

{ #category : #accessing }
OpenAPI.Parameter >> name: aString [
	name := aString]

{ #category : #accessing }
OpenAPI.Parameter >> required [
	^required]

{ #category : #accessing }
OpenAPI.Parameter >> required: aBoolean [
	required := aBoolean]

{ #category : #accessing }
OpenAPI.Parameter >> schema [
	^schema]

{ #category : #accessing }
OpenAPI.Parameter >> schema: anOpenAPI [
.Schema
	schema := anOpenAPI.Schema]

{ #category : #accessing }
OpenAPI.Parameter >> style [
	^style]

{ #category : #accessing }
OpenAPI.Parameter >> style: aString [
	style := aString]

{ #category : #accessing }
OpenAPI.Parameter >> type: aString [
	schema := OpenAPI.Schema new.
	schema type: aString]

