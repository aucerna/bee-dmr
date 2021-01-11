"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #URLParser,
	#superclass : #URLGrammar,
	#category : #HTTP
}

{ #category : #'pm support' }
URLParser class >> aboutToSaveLibrary [
	current := relative := nil]

{ #category : #accessing }
URLParser class >> current [
	current isNil ifTrue: [self initializeCurrent].
	^current]

{ #category : #initialization }
URLParser class >> initializeCurrent [
	"
	self initializeCurrent
	"
	current := self new]

{ #category : #initialization }
URLParser class >> initializeRelative [
	relative := self newStartingAt: #relativeUrl]

{ #category : #services }
URLParser class >> queryFrom: aString [
	^self new query parse: aString onError: []]

{ #category : #accessing }
URLParser class >> relative [
	relative isNil ifTrue: [self initializeRelative].
	^relative]

{ #category : #services }
URLParser class >> relativeUrlFrom: aString [
	^self relative parse: aString onError: []]

{ #category : #services }
URLParser class >> urlFrom: aString [
	^self current parse: aString onError: []]

{ #category : #productions }
URLParser >> option [
	^super option
		==> [:nodes | nodes second trimBlanks -> nodes fifth trimBlanks]]

{ #category : #productions }
URLParser >> port [
	^super port ==> [:nodes | nodes second asNumber]]

{ #category : #productions }
URLParser >> query [
	^super query ==> [:nodes | self queryFrom: nodes]]

{ #category : #private }
URLParser >> queryFrom: nodes [
	| query assoc |
	assoc := nodes second.
	assoc isAssociation ifFalse: [^assoc].
	query := OrderedCollection new.
	query add: assoc.
	nodes third collect: #second thenDo: [:option | query add: option].
	^query]

{ #category : #productions }
URLParser >> relativeUrl [
	^super relativeUrl ==> [:nodes | self relativeUrlFrom: nodes]]

{ #category : #private }
URLParser >> relativeUrlFrom: nodes [
	| url path query |
	url := URL new.
	path := nodes second.
	(nodes first notNil and: [path size = 0]) ifTrue: [path := '/'].
	url encodedPath: path.
	query := nodes third.
	query notNil ifTrue: [
		query isString
			ifTrue: [url query: query]
			ifFalse: [query
				do: [:assoc | url encodedQueryAt: assoc key put: assoc value]]].
	nodes fourth ifNotNil: [url encodedFragment: nodes fourth last].
	^url]

{ #category : #productions }
URLParser >> url [
	^super url ==> [:nodes | self urlFrom: nodes]]

{ #category : #private }
URLParser >> urlFrom: nodes [
	| url node authority userInfo password |
	url := nodes fourth.
	url scheme: nodes first.
	node := nodes third.
	node size = 2 ifTrue: [
		authority := node second.
		userInfo := authority first.
		userInfo notNil ifTrue: [
			url encodedUser: userInfo first.
			password := userInfo second ifNotNil: [:p | p second].
			password notNil ifTrue: [url encodedPassword: password]].
		url host: authority second.
		authority third notNil ifTrue: [url port: authority third]].
	^url]

