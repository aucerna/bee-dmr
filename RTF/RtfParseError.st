"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfParseError,
	#superclass : #Error,
	#instVars : [
		'position'
	],
	#category : #RTF
}

{ #category : #services }
RtfParseError class >> signal: aString at: anInteger [
	^self new description: aString; position: anInteger; signal]

{ #category : #accessing }
RtfParseError >> position [
	^position]

{ #category : #accessing }
RtfParseError >> position: anInteger [
	position := anInteger]

