"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IISLogging,
	#superclass : #HttpServerLogging,
	#category : #'HTTP\Server'
}

{ #category : #converting }
IISLogging >> asIISLogging [
	^self]

{ #category : #accessing }
IISLogging >> type [
	^#IIS]

