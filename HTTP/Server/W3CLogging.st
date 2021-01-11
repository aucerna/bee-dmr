"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #W3CLogging,
	#superclass : #HttpServerLogging,
	#category : #'HTTP\Server'
}

{ #category : #converting }
W3CLogging >> asW3CLogging [
	^self]

{ #category : #accessing }
W3CLogging >> type [
	^#W3C]

