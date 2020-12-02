"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchExpression,
	#superclass : #Object,
	#instVars : [
		'expression'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlDTDMatchExpression class >> on: anObject [
	"
	( ... )
    Delimits a group.
A
    A must occur, one time only.
A+
    A must occur one or more times.
A?
    A must occur zero or one time.
A*
    A may occur zero or more times.
+(A)
    A may occur.
-(A)
    A must not occur.
A | B
    Either A or B must occur, but not both.
A , B
    Both A and B must occur, in that order.
A & B
    Both A and B must occur, in any order.
	"
	| in seq |
	in := anObject readStream.
	seq := OrderedCollection new.
	[in atEnd] whileFalse: [
		in skipSeparators.
		in peek = $- ifTrue: [seq add: (HtmlDTDMatchDeny on: in)] ifFalse: [
			in peek = $+ ifTrue: [seq add: (HtmlDTDMatchAllow on: in)] ifFalse: [
				in peek = $(
					ifTrue: [seq
						add: (self readConstraintFor: (HtmlDTDMatchGroup on: in) from: in)]
					ifFalse: [
						('|),&' includes: in peek)
							ifTrue: [^seq last]
							ifFalse: [seq
								add: (self readConstraintFor: (HtmlDTDMatchLiteral on: in) from: in)]]]]].
	^seq size > 1 ifTrue: [self new expression: seq] ifFalse: [seq last]]

{ #category : #private }
HtmlDTDMatchExpression class >> readConstraintFor: anExpn from: aStream [
	| c |
	^('+*?' includes: aStream peek) ifFalse: [anExpn] ifTrue: [
		c := aStream next.
		c = $+ ifTrue: [HtmlDTDMatchOneOrMore new expression: anExpn] ifFalse: [
			c = $?
				ifTrue: [HtmlDTDMatchZeroOrOne new expression: anExpn]
				ifFalse: [c = $* ifTrue: [HtmlDTDMatchZeroOrMore new expression: anExpn]]]]]

{ #category : #inquiries }
HtmlDTDMatchExpression >> allowedElements [
	^expression gather: #allowedElements]

{ #category : #testing }
HtmlDTDMatchExpression >> allowsItem: item [
	^expression anySatisfy: [:e | e allowsItem: item]]

{ #category : #accessing }
HtmlDTDMatchExpression >> expression [
	^expression]

{ #category : #accessing }
HtmlDTDMatchExpression >> expression: anObject [
	expression := anObject]

{ #category : #testing }
HtmlDTDMatchExpression >> isEmpty [
	^false]

{ #category : #testing }
HtmlDTDMatchExpression >> isEnumeration [
	^false]

{ #category : #testing }
HtmlDTDMatchExpression >> isLiteral [
	^false]

{ #category : #printing }
HtmlDTDMatchExpression >> printOn: aStream [
	expression do: [:ea | 
		ea printOn: aStream.
		aStream nextPut: $ ]]

{ #category : #validation }
HtmlDTDMatchExpression >> validateChildren: aStream ofNode: aNode [
	^expression conform: [:e | e validateChildren: aStream ofNode: aNode]]

