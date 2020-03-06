Class {
	#name : #PPDelegateParser,
	#superclass : #PPParser,
	#instVars : [
		'parser'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPDelegateParser class >> on: aParser [
	^ self new setParser: aParser
]

{ #category : #accessing }
PPDelegateParser >> children [
	^{parser}
]

{ #category : #parsing }
PPDelegateParser >> parseOn: aStream [
	^ parser parseOn: aStream
]

{ #category : #initialization }
PPDelegateParser >> setParser: aParser [
	parser := aParser
]

