"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ImageSegment,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #Kernel
}

{ #category : #accessing }
ImageSegment >> name [
	^name
]

{ #category : #accessing }
ImageSegment >> name: aString [
	name := aString
]
