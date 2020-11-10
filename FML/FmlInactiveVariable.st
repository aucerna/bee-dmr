"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlInactiveVariable,
	#superclass : #FmlMissingVariable,
	#instVars : [
		'ignore'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlInactiveVariable class >> informOn: aString function: function [
	^self new
		canBeIgnored: true;
		variable: aString;
		function: function;
		signal]

{ #category : #'instance creation' }
FmlInactiveVariable class >> signalOn: aString [
	^self new canBeIgnored: false; variable: aString; signal]

{ #category : #testing }
FmlInactiveVariable >> canBeIgnored [
	^ignore]

{ #category : #accessing }
FmlInactiveVariable >> canBeIgnored: aBoolean [
	ignore := aBoolean]

{ #category : #accessing }
FmlInactiveVariable >> defaultDescription [
	^function variableName asString
		, ' can not be calculated because it references to the inactive variable '
		, variable asString doubleQuoted]

