"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfFormattingFinder,
	#superclass : #RtfProcessor,
	#instVars : [
		'sequence',
		'position',
		'start',
		'end'
	],
	#category : #RTF
}

{ #category : #'event handling' }
RtfFormattingFinder >> characters: aString [
	self reset]

{ #category : #'event handling' }
RtfFormattingFinder >> controlWord: aString
with: anInteger
from: startPos
to: endPos [
	(self expects: aString with: anInteger)
		ifTrue: [
			position = 1 ifTrue: [start := startPos].
			position = sequence size ifTrue: [end := endPos].
			position := position + 1]
		ifFalse: [self reset]]

{ #category : #accessing }
RtfFormattingFinder >> end [
	^end]

{ #category : #'event handling' }
RtfFormattingFinder >> endGroup [
	self reset]

{ #category : #private }
RtfFormattingFinder >> expects: word with: argument [
	| s arg offset |
	s := sequence at: position.
	(s at: 1) = $\ ifFalse: [^false].
	1 to: word size do: [:i | (s at: i + 1) = (word at: i) ifFalse: [^false]].
	argument isNil ifTrue: [^true].
	arg := argument printString.
	offset := 1 + word size.
	1
		to: arg size
		do: [:i | (arg at: i) = (s at: offset + i) ifFalse: [^false]].
	^true]

{ #category : #inquiries }
RtfFormattingFinder >> matched [
	^start isInteger and: [end isInteger]]

{ #category : #initialization }
RtfFormattingFinder >> reset [
	start := end := nil.
	position := 1]

{ #category : #accessing }
RtfFormattingFinder >> sequence: anArray [
	sequence := anArray]

{ #category : #accessing }
RtfFormattingFinder >> start [
	^start]

{ #category : #'event handling' }
RtfFormattingFinder >> startGroup [
	self reset]

