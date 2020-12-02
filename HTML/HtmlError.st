"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlError,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #HTML
}

{ #category : #testing }
HtmlError >> isAttributeError [
	^false]

{ #category : #testing }
HtmlError >> isCaseError [
	^false]

{ #category : #testing }
HtmlError >> isCssError [
	^false]

{ #category : #testing }
HtmlError >> isFatal [
	^false]

{ #category : #testing }
HtmlError >> isStructuralError [
	^false]

{ #category : #testing }
HtmlError >> isSyntaxError [
	^false]

{ #category : #testing }
HtmlError >> isTagError [
	^false]

{ #category : #accessing }
HtmlError >> parent [
	^parent isNil ifFalse: [parent first]]

{ #category : #accessing }
HtmlError >> parent: anObject [
	parent := WeakArray with: anObject]

{ #category : #accessing }
HtmlError >> position [
	^self parent start]

{ #category : #printing }
HtmlError >> printOn: aStream [
	self class printOn: aStream.
	aStream nextPutAll: ': Character: '.
	self position printOn: aStream.
	aStream space]

{ #category : #accessing }
HtmlError >> tag [
	^self parent tag]

{ #category : #accessing }
HtmlError >> title [
	| tt |
	tt := self class name.
	^(tt tail: tt size - 4) asCapitalizedPhrase]

{ #category : #accessing }
HtmlError >> uniqueId [
	^self parent uniqueId]

