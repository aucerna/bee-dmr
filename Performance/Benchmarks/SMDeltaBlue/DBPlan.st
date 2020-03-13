"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

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

