"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfFormattingReplacer,
	#superclass : #RtfProcessor,
	#instVars : [
		'rtf',
		'macro',
		'replacement',
		'macro0',
		'replacement0',
		'finder',
		'edits'
	],
	#category : #RTF
}

{ #category : #services }
RtfFormattingReplacer class >> replaceFormatting: macro1 with: macro2 in: rtf [
	^self new
		rtf: rtf;
		replace: macro1 with: macro2;
		parse: rtf]

{ #category : #'event handling' }
RtfFormattingReplacer >> characters: aString [
	finder characters: aString]

{ #category : #'event handling' }
RtfFormattingReplacer >> controlWord: aString
with: anInteger
from: start
to: end [
	finder
		controlWord: aString
		with: anInteger
		from: start
		to: end.
	finder matched ifTrue: [
		finder == macro0
			ifTrue: [
				self recordEdit.
				finder := macro]
			ifFalse: [finder := macro0]]]

{ #category : #'event handling' }
RtfFormattingReplacer >> endGroup [
	finder endGroup]

{ #category : #accessing }
RtfFormattingReplacer >> output [
	| r r0 input output |
	r := String
		streamContents: [:s | replacement do: [:off | s nextPutAll: off; space]].
	r0 := String
		streamContents: [:s | replacement0 do: [:off | s nextPutAll: off; space]].
	input := rtf contents readStream.
	output := '' writeStream.
	edits do: [:edit | 
		output
			nextPutAll: (input next: edit first - input position);
			nextPutAll: r.
		input skip: edit second - edit first.
		output
			nextPutAll: (input next: edit third - edit second);
			nextPutAll: r0.
		input skip: edit fourth - edit third].
	output nextPutAll: input upToEnd.
	rtf output: output]

{ #category : #private }
RtfFormattingReplacer >> recordEdit [
	edits add: {macro start. macro end. macro0 start. macro0 end}.
	macro reset.
	macro0 reset]

{ #category : #private }
RtfFormattingReplacer >> replace: sequence1 with: sequence2 [
	macro := RtfFormattingFinder new sequence: sequence1.
	macro0 := RtfFormattingFinder new sequence: (rtf offMacroFor: sequence1).
	replacement := sequence2.
	replacement0 := rtf offMacroFor: sequence2]

{ #category : #initialization }
RtfFormattingReplacer >> reset [
	edits := OrderedCollection new.
	finder := macro]

{ #category : #accessing }
RtfFormattingReplacer >> rtf: anRtf [
	rtf := anRtf]

{ #category : #'event handling' }
RtfFormattingReplacer >> startGroup [
	finder startGroup]

