"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpCookie,
	#superclass : #Object,
	#instVars : [
		'name',
		'value',
		'attributes'
	],
	#category : #HTTP
}

{ #category : #'instance creation' }
HttpCookie class >> fromString: aString [
	^self new fromString: aString]

{ #category : #'instance creation' }
HttpCookie class >> new [
	^super new initialize]

{ #category : #accessing }
HttpCookie >> domain [
	^attributes valueAt: 'domain']

{ #category : #accessing }
HttpCookie >> domain: aString [
	attributes at: 'domain' put: aString]

{ #category : #accessing }
HttpCookie >> expiration: aTimestamp [
	| formatted |
	formatted := aTimestamp utc rfc822 replaceAll: '+0000' with: 'GMT'.
	self expires: formatted]

{ #category : #accessing }
HttpCookie >> expires [
	^attributes valueAt: 'expires']

{ #category : #accessing }
HttpCookie >> expires: aString [
	attributes at: 'expires' put: aString]

{ #category : #private }
HttpCookie >> fromString: aString [
	| tokens pair |
	tokens := $; split: aString.
	pair := $= split: tokens first.
	name := pair first trimBlanks.
	value := pair size = 1 ifTrue: [''] ifFalse: [pair second trimBlanks].
	tokens from: 2 do: [:attribute | | v |
		pair := $= split: attribute.
		v := pair size = 1 ifTrue: [true] ifFalse: [pair second trimBlanks].
		attributes at: pair first trimBlanks asLowercase put: v]]

{ #category : #accessing }
HttpCookie >> httpOnly [
	^attributes valueAt: 'httponly']

{ #category : #accessing }
HttpCookie >> httpOnly: aBoolean [
	attributes at: 'httponly' put: aBoolean]

{ #category : #initialization }
HttpCookie >> initialize [
	super initialize.
	attributes := Dictionary new]

{ #category : #accessing }
HttpCookie >> name [
	^name]

{ #category : #accessing }
HttpCookie >> name: aString [
	name := aString]

{ #category : #accessing }
HttpCookie >> path [
	^attributes valueAt: 'path']

{ #category : #accessing }
HttpCookie >> path: aString [
	attributes at: 'path' put: aString]

{ #category : #printing }
HttpCookie >> printOn: aStream [
	aStream
		nextPutAll: name;
		nextPut: $=;
		nextPutAll: value.
	attributes keysAndValuesDo: [:n :v | 
		aStream nextPutAll: '; '; nextPutAll: n.
		v isBoolean ifFalse: [aStream nextPut: $=; nextPutAll: v]]]

{ #category : #printing }
HttpCookie >> printTextOn: rtf [
	rtf
		bold: name;
		useColor: Color darkGray while: [rtf nextPut: $=; nextPutAll: value].
	attributes keysAndValuesDo: [:n :v | 
		rtf
			nextPutAll: '; ';
			useColor: Color darkBlue while: [rtf nextPutAll: n].
		v isBoolean
			ifFalse: [rtf
				useColor: Color darkCyan
				while: [rtf nextPut: $=; nextPutAll: v]]]]

{ #category : #accessing }
HttpCookie >> secure [
	^attributes valueAt: 'secure']

{ #category : #accessing }
HttpCookie >> secure: aBoolean [
	attributes at: 'secure' put: aBoolean]

{ #category : #accessing }
HttpCookie >> value [
	^value]

{ #category : #accessing }
HttpCookie >> value: aString [
	value := aString]

