Class {
	#name : #Warning,
	#superclass : #Notification,
	#category : #Kernel
}

{ #category : #actions }
Warning >> defaultAction [
	SmalltalkSession current warnAbout: self description
]

