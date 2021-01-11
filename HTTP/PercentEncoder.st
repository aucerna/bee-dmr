"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PercentEncoder,
	#superclass : #Object,
	#instVars : [
		'reserved'
	],
	#classVars : [
		'Current'
	],
	#category : #HTTP
}

{ #category : #accessing }
PercentEncoder class >> current [
	Current isNil ifTrue: [Current := self new].
	^Current]

{ #category : #services }
PercentEncoder class >> decode: aString [
	^self current decode: aString]

{ #category : #services }
PercentEncoder class >> encode: aString [
	^self current encode: aString]

{ #category : #'instance creation' }
PercentEncoder class >> new [
	^super new initialize]

{ #category : #services }
PercentEncoder >> decode: aString [
	"
	PercentEncoder decode: 'this%20is%20AT+%40'
	"
	| reader raw |
	reader := aString readStream.
	raw := String streamContents: [:strm | 
		[reader atEnd] whileFalse: [| char |
			char := reader next.
			(reader position > 1 and: [char = $+]) ifTrue: [strm space] ifFalse: [| code |
				char = $%
					ifTrue: [
						code := reader next digitValue * 16 + reader next digitValue.
						strm nextBytePut: code]
					ifFalse: [strm nextPut: char]]]].
	^String fromUTF8: raw]

{ #category : #services }
PercentEncoder >> encode: aString [
	"
	PercentEncoder encode: 'this is AT @'
	"
	^String streamContents: [:strm | 
		aString do: [:char | 
			((reserved includes: char) or: [char codePoint > 127])
				ifTrue: [
					char utf8 do: [:byte | | hex |
						hex := byte hex: 2.
						strm nextPut: $%; nextPutAll: hex]]
				ifFalse: [strm nextPut: char]]]]

{ #category : #initialization }
PercentEncoder >> initialize [
	super initialize.
	self initializeReserved]

{ #category : #initialization }
PercentEncoder >> initializeReserved [
	reserved := ' ?:@&=+$#;%/\!']

