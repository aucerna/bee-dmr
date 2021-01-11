"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpVersion,
	#superclass : #HttpApiStructure,
	#category : #'HTTP\Server'
}

{ #category : #private }
HttpVersion class >> major: major minor: minor [
	^self new major: major; minor: minor]

