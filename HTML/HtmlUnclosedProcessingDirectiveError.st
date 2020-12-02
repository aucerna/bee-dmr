"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUnclosedProcessingDirectiveError,
	#superclass : #HtmlSyntaxError,
	#category : #HTML
}

{ #category : #testing }
HtmlUnclosedProcessingDirectiveError >> isStructuralError [
	^true]

{ #category : #printing }
HtmlUnclosedProcessingDirectiveError >> printOn: aStream [
	aStream nextPutAll: 'Processing directive not properly terminated.']

