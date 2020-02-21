Class {
	#name : #DBStayConstraint,
	#superclass : #DBUnaryConstraint,
	#category : #SMDeltaBlue
}

{ #category : #'instance creation' }
DBStayConstraint class >> var: aVariable strength: strengthSymbol [
	"Install an edit constraint with the given strength on the given
	 variable."

	^(self new) var: aVariable strength: strengthSymbol
]

{ #category : #planning }
DBStayConstraint >> execute [
	"Stay constraints do nothing."
]

