"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #QuotedPrintableTest,
	#superclass : #TestCase,
	#category : #'Cryptography\Tests'
}

{ #category : #all }
QuotedPrintableTest >> testDecoderValidator [
	| validation plain stream |
	validation := QuotedPrintableValidator validate: self coded withCrLf.
	self assert: validation hasPassed.
	plain := QuotedPrintableDecoder decodeString: self coded withCrLf.
	stream := plain readStream.
	[stream atEnd] whileFalse: [
		plain := stream upTo: $=.
		stream atEnd ifFalse: [self assert: plain last = $:]]]

{ #category : #all }
QuotedPrintableTest >> testInvalid [
	| validation |
	validation := QuotedPrintableValidator validate: self coded , '='.
	self deny: validation hasPassed.
	validation := QuotedPrintableValidator validate: '=a' , self coded.
	self deny: validation hasPassed.
	validation := QuotedPrintableValidator validate: '=Ab'.
	self deny: validation hasPassed]

{ #category : #all }
QuotedPrintableTest >> testLineBreaks [
	| coded plain |
	coded := self coded2 withCrLf.
	plain := QuotedPrintableDecoder decodeString: coded.
	self assert: plain lines size = (coded lines size - 2)]

{ #category : #all }
QuotedPrintableTest >> testTrailingWhites [
	| plain |
	#knownIssue.
	plain := QuotedPrintableDecoder decodeString: 'hello 	='.
	self assert: plain = 'hello 	'.
	#knownIssue.
	plain := QuotedPrintableDecoder decodeString: 'hello 	=0D=0A '.
	self assert: plain = 'hello 	
']

