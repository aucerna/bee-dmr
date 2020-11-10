"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlEvaluationError,
	#superclass : #Error,
	#instVars : [
		'function',
		'resumable'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlEvaluationError class >> function: function signal: messageString [
	self new function: function; description: messageString; signal]

{ #category : #'instance creation' }
FmlEvaluationError class >> new [
	^super new initialize]

{ #category : #'instance creation' }
FmlEvaluationError class >> signalOn: function [
	self new function: function; signal]

{ #category : #'error handling' }
FmlEvaluationError >> defaultAction [
	^FmlUndefinedValue new]

{ #category : #'error handling' }
FmlEvaluationError >> defaultValue [
	^nil asFmlValue]

{ #category : #accessing }
FmlEvaluationError >> description [
	^function notNil
		ifTrue: [self localDescription , ' encountered while trying to evaluate '
			, function variableName printString]
		ifFalse: [super description]]

{ #category : #accessing }
FmlEvaluationError >> function [
	^function]

{ #category : #accessing }
FmlEvaluationError >> function: functionVariable [
	function := functionVariable]

{ #category : #accessing }
FmlEvaluationError >> initialize [
	super initialize.
	resumable := true]

{ #category : #testing }
FmlEvaluationError >> isResumable [
	^resumable]

{ #category : #accessing }
FmlEvaluationError >> localDescription [
	^description ifNil: [self defaultDescription]]

{ #category : #accessing }
FmlEvaluationError >> printTextOn: rtf [
	^function notNil
		ifTrue: [
			rtf
				italic: self localDescription;
				append: ' encountered while trying to evaluate ';
				useColor: Color blue
				while: [rtf append: function variableName printString]]
		ifFalse: [super printTextOn: rtf]]

{ #category : #accessing }
FmlEvaluationError >> resumable: aBoolean [
	resumable := aBoolean]

{ #category : #'error handling' }
FmlEvaluationError >> sunitExitWith: aValue [
	self isResumable ifTrue: [self resume] ifFalse: [self return: aValue]]

{ #category : #'error handling' }
FmlEvaluationError >> sunitRetry [
	self isResumable ifTrue: [self resume]]

