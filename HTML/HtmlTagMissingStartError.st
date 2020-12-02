"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTagMissingStartError,
	#superclass : #HtmlTagStructureError,
	#instVars : [
		'position',
		'tag'
	],
	#category : #HTML
}

{ #category : #testing }
HtmlTagMissingStartError >> isStructuralError [
	^true]

{ #category : #accessing }
HtmlTagMissingStartError >> position [
	^position]

{ #category : #accessing }
HtmlTagMissingStartError >> position: anObject [
	position := anObject]

{ #category : #accessing }
HtmlTagMissingStartError >> printOn: aStream [
	aStream nextPutAll: 'Closing tag: '.
	self tag printOn: aStream.
	aStream nextPutAll: ' with no start found']

{ #category : #accessing }
HtmlTagMissingStartError >> tag [
	^tag]

{ #category : #accessing }
HtmlTagMissingStartError >> tag: aString [
	tag := aString]

{ #category : #accessing }
HtmlTagMissingStartError >> uniqueId [
	^super uniqueId , '-end']

