"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchGroup,
	#superclass : #HtmlDTDMatchExpression,
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlDTDMatchGroup class >> on: aStream [
	| seq in seps |
	in := aStream readStream.
	in skipSeparators.
	seq := OrderedCollection new.
	seps := #().
	in peek = $( ifFalse: [self error: 'Groups start with $('].
	in next; skipSeparators.
	[in peek = $)] whileFalse: [
		in skipSeparators.
		seq add: (HtmlDTDMatchExpression on: in).
		in skipSeparators.
		('|&,' includes: in peek)
			ifTrue: [
				seps := seps copyWith: in next.
				in skipSeparators]
			ifFalse: [in peek = $) ifFalse: [self error: 'Huh?']]].
	in next.
	^seps isEmpty ifTrue: [seq last] ifFalse: [
		seps first = $| ifTrue: [HtmlDTDMatchOR new expression: seq] ifFalse: [
			seps first = $& ifTrue: [HtmlDTDMatchAND new expression: seq] ifFalse: [
				seps first = $,
					ifTrue: [HtmlDTDMatchSequence new expression: seq]
					ifFalse: [self error: 'Invalid group separator']]]]]

{ #category : #inquiries }
HtmlDTDMatchGroup >> allowedElements [
	| collection |
	collection := OrderedCollection new.
	expression do: [:ea | collection addAll: ea allowedElements].
	^collection asArray]

{ #category : #testing }
HtmlDTDMatchGroup >> allowsItem: item [
	^expression anySatisfy: [:e | e allowsItem: item]]

{ #category : #accessing }
HtmlDTDMatchGroup >> expression: aCollection [
	super expression: aCollection asArray]

{ #category : #printing }
HtmlDTDMatchGroup >> printOn: aStream [
	aStream nextPut: $(.
	expression do: [:e | aStream nextPutAll: e] separatedBy: [aStream space].
	aStream nextPut: $)]

{ #category : #accessing }
HtmlDTDMatchGroup >> separator [
	self subclassResponsibility]

