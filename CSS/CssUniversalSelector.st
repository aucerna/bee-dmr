"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssUniversalSelector,
	#superclass : #CssSelector,
	#instVars : [
		'selectors'
	],
	#category : #CSS
}

{ #category : #'as yet unclassified' }
CssUniversalSelector class >> readFrom: in [
	in peek = $* ifTrue: [in next].
	^self new readAttributeSelectorsFrom: in]

{ #category : #comparing }
CssUniversalSelector >> = anObject [
	^self class = anObject class
		and: [selectors = anObject selectors
			and: [self element = anObject element]]]

{ #category : #accessing }
CssUniversalSelector >> addSelector: aCssSelector [
	selectors add: aCssSelector]

{ #category : #accessing }
CssUniversalSelector >> classSelectors [
	^selectors
		select: [:s | s isAttributeSelector
			and: [s attribute asLowercase = 'class']]]

{ #category : #accessing }
CssUniversalSelector >> element [
	^nil]

{ #category : #comparing }
CssUniversalSelector >> hash [
	^self class hash + selectors hash + self element hash]

{ #category : #accessing }
CssUniversalSelector >> idSelector [
	^selectors
		detect: [:s | s isAttributeSelector and: [s attribute asLowercase = 'id']]
		ifNone: nil]

{ #category : #initialization }
CssUniversalSelector >> initialize [
	super initialize.
	selectors := OrderedCollection new]

{ #category : #testing }
CssUniversalSelector >> isCSS3 [
	^selectors anySatisfy: #isCSS3]

{ #category : #testing }
CssUniversalSelector >> isSimple [
	^true]

{ #category : #testing }
CssUniversalSelector >> isValid [
	^super isValid and: [selectors conform: #isValid]]

{ #category : #accessing }
CssUniversalSelector >> keySelectors [
	^{self}]

{ #category : #testing }
CssUniversalSelector >> matches: anHtmlElement [
	^selectors conform: [:s | s matches: anHtmlElement]]

{ #category : #printing }
CssUniversalSelector >> printOn: aStream [
	aStream nextPut: $*.
	selectors do: [:s | s printOn: aStream]]

{ #category : #accessing }
CssUniversalSelector >> readAttributeSelectorsFrom: in [
	| c |
	in skipSeparators.
	c := in peek.
	[c isNil or: [c isBlank]] whileFalse: [
		c = $.
			ifTrue: [self addSelector: (CssClassSelector readFrom: in)]
			ifFalse: [
				c = $#
					ifTrue: [self addSelector: (CssIdSelector readFrom: in)]
					ifFalse: [
						c = $[
							ifTrue: [self addSelector: (CssAttributeSelector readFrom: in)]
							ifFalse: [
								c = $:
									ifTrue: [self addSelector: (CssPseudoClassSelector readFrom: in)]
									ifFalse: [^self]]]].
		c := in peek]]

{ #category : #accessing }
CssUniversalSelector >> selectors [
	^selectors]

{ #category : #accessing }
CssUniversalSelector >> selectors: aCollection [
	selectors := aCollection]

