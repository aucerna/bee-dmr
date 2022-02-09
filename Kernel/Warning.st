"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Warning,
	#superclass : #Notification,
	#category : #Kernel
}

{ #category : #actions }
Warning >> defaultAction [
	Smalltalk session warnAbout: self description
]

