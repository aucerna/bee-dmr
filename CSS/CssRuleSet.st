"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssRuleSet,
	#superclass : #Object,
	#instVars : [
		'idSelectors',
		'classSelectors',
		'tagSelectors',
		'otherSelectors'
	],
	#category : #CSS
}

{ #category : #accessing }
CssRuleSet >> candidateRulesForNode: aNode [

	| id classes list |

	id := aNode id.
	list := OrderedCollection new.
	list addAll: otherSelectors.
	aNode id isNil ifFalse:
	[
		list addAll: (idSelectors at: id ifAbsent:[#()]).
	].
	classes := aNode classes.
	(classes isNil or: [classes isEmpty]) ifFalse:
	[
		classes do: [:ea | list addAll: (classSelectors at: ea ifAbsent: [#()])]. 
	].
	list addAll: (tagSelectors at: aNode tag asLowercase ifAbsent: [#()]).
	^list]

{ #category : #accessing }
CssRuleSet >> classSelectors [
	^classSelectors]

{ #category : #accessing }
CssRuleSet >> classSelectors: aCollection [
	classSelectors := aCollection]

{ #category : #accessing }
CssRuleSet >> idSelectors [
	^idSelectors]

{ #category : #accessing }
CssRuleSet >> idSelectors: aCollection [
	idSelectors := aCollection]

{ #category : #initialization }
CssRuleSet >> initialize [
	super initialize.
	idSelectors := Dictionary new.
	classSelectors := Dictionary new.
	tagSelectors := Dictionary new.
	otherSelectors := OrderedCollection new]

{ #category : #accessing }
CssRuleSet >> otherSelectors [
	^otherSelectors]

{ #category : #accessing }
CssRuleSet >> otherSelectors: aCollection [
	otherSelectors := aCollection]

{ #category : #accessing }
CssRuleSet >> tagSelectors [
	^tagSelectors]

{ #category : #accessing }
CssRuleSet >> tagSelectors: aCollection [
	tagSelectors := aCollection]

