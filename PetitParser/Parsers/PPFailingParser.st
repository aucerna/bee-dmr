Class {
	#name : #PPFailingParser,
	#superclass : #PPParser,
	#instVars : [
		'#message'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPFailingParser class >> message: aString [
	^ self new setMessage: aString
]

{ #category : #accessing }
PPFailingParser >> message [
	"Answer the error message of the receiving parser."

	^ message
]

{ #category : #parsing }
PPFailingParser >> parseOn: aStream [
	^PPFailure message: message from: aStream
]

{ #category : #printing }
PPFailingParser >> printNameOn: aStream [
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: message
]

{ #category : #initialization }
PPFailingParser >> setMessage: aString [
	message := aString
]

