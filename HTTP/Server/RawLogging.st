"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RawLogging,
	#superclass : #HttpServerLogging,
	#category : #'HTTP\Server'
}

{ #category : #converting }
RawLogging >> asRawLogging [
	^self]

{ #category : #accessing }
RawLogging >> type [
	^#Raw]

