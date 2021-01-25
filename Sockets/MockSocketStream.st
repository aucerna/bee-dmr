"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MockSocketStream,
	#superclass : #Stream,
	#instVars : [
		'atEnd',
		'inStream',
		'outStream'
	],
	#category : #sockets
}

{ #category : #'instance creation' }
MockSocketStream class >> new [
	^super new initialize]

{ #category : #'instance creation' }
MockSocketStream class >> on: socket [
	^self new]

{ #category : #testing }
MockSocketStream >> atEnd [
	^self inStream atEnd]

{ #category : #accessing }
MockSocketStream >> atEnd: aBoolean [
	atEnd := aBoolean]

{ #category : #'stream out' }
MockSocketStream >> cr [
	self outStream cr]

{ #category : #'stream out' }
MockSocketStream >> flush [
	self outStream flush]

{ #category : #'initialize-release' }
MockSocketStream >> initialize [
	self resetInStream.
	self resetOutStream]

{ #category : #accessing }
MockSocketStream >> inStream [
	^inStream]

{ #category : #'stream in' }
MockSocketStream >> nextLine [
	^self nextLineCrLf]

{ #category : #'stream in' }
MockSocketStream >> nextLineCrLf [
	^self upToAll: String crlf]

{ #category : #'stream out' }
MockSocketStream >> nextPutAll: aString [
	self outStream nextPutAll: aString]

{ #category : #accessing }
MockSocketStream >> outStream [
	^outStream]

{ #category : #accessing }
MockSocketStream >> readStream [
	^self]

{ #category : #'stream in' }
MockSocketStream >> resetInStream [
	inStream := '' readStream]

{ #category : #'stream out' }
MockSocketStream >> resetOutStream [
	outStream := '' writeStream]

{ #category : #'stream out' }
MockSocketStream >> sendCommand: aString [
	self outStream nextPutAll: aString; nextPutAll: String cr]

{ #category : #'stream in' }
MockSocketStream >> upToAll: delims [
	^inStream upToAll: delims]

{ #category : #accessing }
MockSocketStream >> writeStream [
	^self]

