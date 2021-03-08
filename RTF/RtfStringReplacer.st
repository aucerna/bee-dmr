"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfStringReplacer,
	#superclass : #RtfStringProcessor,
	#instVars : [
		'string',
		'location',
		'replacement',
		'rtf',
		'parser',
		'position',
		'terminator',
		'ignorable'
	],
	#category : #RTF
}

{ #category : #services }
RtfStringReplacer class >> replace: aString
at: anInteger
with: anotherString
in: anRtf [
	^self new
		string: aString;
		stringLocation: anInteger;
		replacement: anotherString;
		rtf: anRtf;
		parse: anRtf contents]

{ #category : #'event handling' }
RtfStringReplacer >> characters: aString from: start to: end [
	ignorable ifTrue: [^self].
	(location between: position + 1 and: position + aString size) ifTrue: [
		self process: aString from: start to: end.
		terminator value].
	position := position + aString size]

{ #category : #'event handling' }
RtfStringReplacer >> endIgnorable [
	ignorable := false]

{ #category : #initialization }
RtfStringReplacer >> initialize [
	position := 0.
	ignorable := false]

{ #category : #parsing }
RtfStringReplacer >> parse: stringOrStream [
	terminator := [^self].
	^super parse: stringOrStream]

{ #category : #private }
RtfStringReplacer >> process: chunk from: start to: end [
	| offset length head tail encoded input output |
	offset := location - position - 1.
	length := offset + string size.
	(chunk indexOfString: string from: offset + 1 to: length) != (offset + 1)
		ifTrue: [^self error: 'Replaced string not found or non-continguous'].
	head := chunk copyFrom: 1 to: offset.
	tail := chunk allButFirst: length.
	encoded := rtf class encode: head , replacement , tail.
	input := rtf contents readStream.
	output := '' writeStream.
	output nextPutAll: (input next: start - 1).
	input skip: end - start + 1.
	output nextPutAll: encoded; nextPutAll: input upToEnd.
	rtf output: output contents appendStream]

{ #category : #accessing }
RtfStringReplacer >> replacement: aString [
	replacement := aString]

{ #category : #accessing }
RtfStringReplacer >> rtf: anRtf [
	rtf := anRtf]

{ #category : #'event handling' }
RtfStringReplacer >> startIgnorable [
	ignorable := true]

{ #category : #accessing }
RtfStringReplacer >> string [
	^string]

{ #category : #accessing }
RtfStringReplacer >> string: aString [
	string := aString]

{ #category : #accessing }
RtfStringReplacer >> stringLocation: anInteger [
	location := anInteger]

