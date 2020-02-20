Class {
	#name : #PPActionParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'#block'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPActionParser class >> on: aParser block: aBlock [
	^ (self on: aParser) setBlock: aBlock
]

{ #category : #accessing }
PPActionParser >> block [
	"Answer the action block of the receiver."

	^ block
]

{ #category : #parsing }
PPActionParser >> parseOn: aStream [
	| element |
	^ (element := parser parseOn: aStream) isPetitFailure
		ifFalse: [ block value: element ]
		ifTrue: [ element ]
]

{ #category : #printing }
PPActionParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf cr; cr; nextPutAll: '==> '.
	block printSmalltalkReceiverOn: rtf
]

{ #category : #initialization }
PPActionParser >> setBlock: aBlock [
	block := aBlock
]

