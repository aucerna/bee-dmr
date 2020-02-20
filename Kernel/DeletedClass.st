Class {
	#name : #DeletedClass,
	#superclass : #Class,
	#type : #variable,
	#category : #Kernel
}

{ #category : #testing }
DeletedClass class >> canBeDeleted [
	^false
]

{ #category : #services }
DeletedClass >> beDeleted [
	"
]

{ #category : #testing }
DeletedClass >> isDeleted [
	^true
]
