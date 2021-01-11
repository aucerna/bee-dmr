"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #NCSALogging,
	#superclass : #HttpServerLogging,
	#category : #'HTTP\Server'
}

{ #category : #converting }
NCSALogging >> asNCSALogging [
	^self]

{ #category : #accessing }
NCSALogging >> type [
	^#NCSA]

