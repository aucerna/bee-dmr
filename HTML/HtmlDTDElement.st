"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDElement,
	#superclass : #HtmlDTDConstruct,
	#instVars : [
		'dtd',
		'startIsOptional',
		'endIsOptional',
		'contentRule',
		'allowedElements'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlDTDElement class >> fromParsedString: aString [
	| in tag start end contents |
	in := aString readStream.
	tag := self readExpression: in.
	start := self readExpression: in.
	end := self readExpression: in.
	contents := in upToEnd trimBlanks.
	^self new
		tag: tag;
		startIsOptional: start;
		endIsOptional: end;
		contentRule: contents]

{ #category : #testing }
HtmlDTDElement >> allowsTag: aString [
	^contentRule allowsItem: aString]

{ #category : #accessing }
HtmlDTDElement >> cacheAllowedElementsForDTD: aDTD [
	allowedElements isNil ifTrue: [
		allowedElements := Set new.
		allowedElements addAll: self contentRule allowedElements.
		allowedElements copy do: [:ea | 
			ea isLiteral ifTrue: [| el |
				el := aDTD elementForTag: ea expression.
				el startIsOptional
					ifTrue: [allowedElements addAll: (el cacheAllowedElementsForDTD: aDTD)]]]].
	^allowedElements]

{ #category : #accessing }
HtmlDTDElement >> contentRule [
	^contentRule]

{ #category : #accessing }
HtmlDTDElement >> contentRule: anObject [
	contentRule := HtmlDTDMatchExpression on: anObject]

{ #category : #accessing }
HtmlDTDElement >> endIsOptional [
	^endIsOptional first = $O]

{ #category : #accessing }
HtmlDTDElement >> endIsOptional: anObject [
	endIsOptional := anObject]

{ #category : #testing }
HtmlDTDElement >> isEmpty [
	^contentRule isEmpty]

{ #category : #printing }
HtmlDTDElement >> printOn: aStream [
	aStream nextPutAll: 'E('.
	tag printOn: aStream.
	aStream
		space;
		nextPutAll: startIsOptional;
		space;
		nextPutAll: endIsOptional;
		space.
	contentRule printOn: aStream.
	aStream nextPut: $)]

{ #category : #accessing }
HtmlDTDElement >> startIsOptional [
	^startIsOptional first = $O]

{ #category : #accessing }
HtmlDTDElement >> startIsOptional: anObject [
	startIsOptional := anObject]

