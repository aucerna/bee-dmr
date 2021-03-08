"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfFormattedTextFinder,
	#superclass : #RtfStringProcessor,
	#instVars : [
		'command',
		'command0',
		'stack',
		'position',
		'output',
		'currentText',
		'currentInterval'
	],
	#category : #RTF
}

{ #category : #services }
RtfFormattedTextFinder class >> allStringsUnder: aString in: anRtf [
	| cmd cmd0 |
	cmd := aString first = $\ ifTrue: [aString allButFirst] ifFalse: [aString].
	cmd0 := anRtf offCommandFor: cmd.
	^self new
		lineDelimiters: anRtf eol;
		command: cmd;
		offCommand: cmd0;
		parse: anRtf contents]

{ #category : #'event handling' }
RtfFormattedTextFinder >> characters: aString [
	| end |
	self ignoresCharacters ifTrue: [^self].
	end := position + aString size.
	self collectsCharacters ifTrue: [
		currentText nextPutAll: aString.
		currentInterval isNil
			ifTrue: [currentInterval := position + 1 @ end]
			ifFalse: [currentInterval y: end]].
	position := end]

{ #category : #testing }
RtfFormattedTextFinder >> collectsCharacters [
	^stack top first > 0]

{ #category : #accessing }
RtfFormattedTextFinder >> command: aString [
	command := aString]

{ #category : #'event handling' }
RtfFormattedTextFinder >> controlWord: aString
with: anInteger
from: start
to: end [
	| flag |
	super controlWord: aString with: anInteger from: start to: end.
	flag := self flagAfter: aString with: anInteger.
	flag notNil ifTrue: [
		flag ifTrue: [self startCommand] ifFalse: [self endCommand].
		self collectsCharacters ifFalse: [self flushCurrentText]]]

{ #category : #private }
RtfFormattedTextFinder >> endCommand [
	stack top at: 1 put: stack top first - 1]

{ #category : #'event handling' }
RtfFormattedTextFinder >> endGroup [
	stack pop]

{ #category : #'event handling' }
RtfFormattedTextFinder >> endIgnorable [
	stack top at: 2 put: false]

{ #category : #private }
RtfFormattedTextFinder >> flagAfter: cmd with: arg [
	(cmd = command or: [cmd = command0]) ifFalse: [^nil].
	command0 = (command , '0') ifTrue: [^arg != 0].
	command = command0 ifTrue: [^self collectsCharacters not].
	cmd = command ifTrue: [^true].
	cmd = command0 ifTrue: [^false]]

{ #category : #private }
RtfFormattedTextFinder >> flushCurrentText [
	currentInterval notNil
		ifTrue: [output
			add: {currentInterval x. currentInterval y. currentText contents}].
	self resetCurrentText]

{ #category : #testing }
RtfFormattedTextFinder >> ignoresCharacters [
	^stack top second]

{ #category : #accessing }
RtfFormattedTextFinder >> offCommand: aString [
	command0 := aString]

{ #category : #accessing }
RtfFormattedTextFinder >> output [
	^output asArray]

{ #category : #initialization }
RtfFormattedTextFinder >> reset [
	stack := Stack new push: {0. false}.
	position := 0.
	output := OrderedCollection new.
	self resetCurrentText]

{ #category : #private }
RtfFormattedTextFinder >> resetCurrentText [
	currentInterval := nil.
	currentText := String new writeStream]

{ #category : #private }
RtfFormattedTextFinder >> startCommand [
	stack top at: 1 put: stack top first + 1]

{ #category : #'event handling' }
RtfFormattedTextFinder >> startGroup [
	stack push: stack top copy]

{ #category : #'event handling' }
RtfFormattedTextFinder >> startIgnorable [
	stack top at: 2 put: true]

