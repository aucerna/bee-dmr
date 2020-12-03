"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEEnumeratingForNode,
	#superclass : #JSEForIterationNode,
	#instVars : [
		'collection'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEEnumeratingForNode >> collection [
	^collection]

{ #category : #accessing }
JSEEnumeratingForNode >> collection: aCollection [
	collection := aCollection.
	position := collection position.
	end := collection end]

