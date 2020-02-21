Class {
	#name : #DBPlan,
	#superclass : #OrderedCollection,
	#category : #SMDeltaBlue
}

{ #category : #planning }
DBPlan >> execute [
	"Execute my constraints in order."

	self do: [: c | c execute].
]

