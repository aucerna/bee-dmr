Extension { #name : #Set }

{ #category : '*Parsers' }
Set >> asParser [
	^ PPChoiceParser withAll: (self collect: [ :each | each asParser ])
]

