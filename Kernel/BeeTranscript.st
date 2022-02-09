"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #BeeTranscript,
	#superclass : #Object,
	#instVars : [
		'out'
	],
	#category : #Kernel
}

{ #category : #'open/close' }
BeeTranscript >> close [
]

{ #category : #output }
BeeTranscript >> cr [
	self output: String cr
]


