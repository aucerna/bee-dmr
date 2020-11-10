"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlMissingVariable,
	#superclass : #FmlEvaluationError,
	#instVars : [
		'variable'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlMissingVariable class >> signalOn: aFmlVariableName [
	self new variable: aFmlVariableName; signal]

{ #category : #'instance creation' }
FmlMissingVariable class >> signalOn: aString function: function [
	self new variable: aString; function: function; signal]

{ #category : #'instance creation' }
FmlMissingVariable class >> variable: modelName function: function signal: messageString [
	self new
		variable: modelName;
		function: function;
		description: messageString;
		signal]

{ #category : #testing }
FmlMissingVariable >> canBeIgnored [
	^false]

{ #category : #accessing }
FmlMissingVariable >> defaultDescription [
	^function isNil
		ifTrue: ['Could not find ' , variable doubleQuoted]
		ifFalse: [function variableName asString
			, ' can not be calculated because it references to the non existing variable '
			, variable doubleQuoted]]

{ #category : #accessing }
FmlMissingVariable >> variable [
	^variable]

{ #category : #accessing }
FmlMissingVariable >> variable: aString [
	variable := aString]

