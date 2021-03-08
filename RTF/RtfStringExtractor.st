"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfStringExtractor,
	#superclass : #RtfStringProcessor,
	#instVars : [
		'ignorable',
		'output'
	],
	#category : #RTF
}

{ #category : #initialization }
RtfStringExtractor class >> initialize [
	super initialize.
	self initializeSpecialChars]

{ #category : #'event handling' }
RtfStringExtractor >> characters: aString [
	ignorable ifFalse: [output nextPutAll: aString]]

{ #category : #'event handling' }
RtfStringExtractor >> endIgnorable [
	ignorable := false]

{ #category : #initialization }
RtfStringExtractor >> initialize [
	ignorable := false.
	output := '' writeStream.
	super initialize]

{ #category : #accessing }
RtfStringExtractor >> output [
	| reder n |
	n := output size - eol size.
	n >= 0 ifTrue: [
		reder := output readStream position: n.
		(reder peekForAll: eol) ifTrue: [output truncateTo: n]].
	^output contents reduced]

{ #category : #initialization }
RtfStringExtractor >> reset [
	super reset.
	ignorable := false.
	output reset]

{ #category : #'event handling' }
RtfStringExtractor >> startIgnorable [
	ignorable := true]

