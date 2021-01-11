"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #UnexpectedInternetData,
	#superclass : #Error,
	#instVars : [
		'data'
	],
	#category : #'HTTP\Client'
}

{ #category : #accessing }
UnexpectedInternetData >> data [
	^data]

{ #category : #accessing }
UnexpectedInternetData >> data: aString [
	data := aString]

{ #category : #accessing }
UnexpectedInternetData >> saveToFile [
	| filename file |
	filename := Directory tempDir asFilename \ 'unexpected.html'.
	file := filename newFile.
	[file nextPutAll: data] ensure: [file close].
	description := self description , '. The contents has been saved to '
		, filename asString]

