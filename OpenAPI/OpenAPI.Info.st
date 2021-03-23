"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Info',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'title',
		'description',
		'termsOfService',
		'contact',
		'license',
		'version'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Info >> contact [
	^contact]

{ #category : #accessing }
OpenAPI.Info >> contact: anOpenAPI [
.Contact
	contact := anOpenAPI.Contact]

{ #category : #accessing }
OpenAPI.Info >> description [
	^description]

{ #category : #accessing }
OpenAPI.Info >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.Info >> license [
	^license]

{ #category : #accessing }
OpenAPI.Info >> license: anOpenAPI [
.License
	license := anOpenAPI.License]

{ #category : #accessing }
OpenAPI.Info >> termsOfService [
	^termsOfService]

{ #category : #accessing }
OpenAPI.Info >> termsOfService: aString [
	termsOfService := termsOfService]

{ #category : #accessing }
OpenAPI.Info >> title [
	^title]

{ #category : #accessing }
OpenAPI.Info >> title: aString [
	title := aString]

{ #category : #accessing }
OpenAPI.Info >> version [
	^version]

{ #category : #accessing }
OpenAPI.Info >> version: aString [
	version := aString]

