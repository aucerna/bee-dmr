"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MediaTypeGrammar,
	#superclass : #PPCompositeParser,
	#category : #HTTP
}

{ #category : #productions }
MediaTypeGrammar >> attribute [
	^self name]

{ #category : #productions }
MediaTypeGrammar >> attributeValue [
	^(PPPredicateObjectParser anyExceptAnyOf: ';=') plus flatten]

{ #category : #productions }
MediaTypeGrammar >> mediaType [
	^self type , $/ asParser , self tree optional , self subtype
		, self suffix optional
		, self parameters]

{ #category : #productions }
MediaTypeGrammar >> name [
	^(PPPredicateObjectParser
		on: (PPCharSetPredicate on: [:char | char isAsciiLetter or: [char = $-]])
		message: 'letter or - expected') plus flatten]

{ #category : #productions }
MediaTypeGrammar >> parameter [
	| space |
	space := #space asParser star.
	^($; asParser , space) flatten , self attribute , $= asParser
		, self attributeValue]

{ #category : #productions }
MediaTypeGrammar >> parameters [
	^self parameter star]

{ #category : #productions }
MediaTypeGrammar >> start [
	^self mediaType]

{ #category : #productions }
MediaTypeGrammar >> subtype [
	^self name]

{ #category : #productions }
MediaTypeGrammar >> suffix [
	^$+ asParser , self name]

{ #category : #productions }
MediaTypeGrammar >> tree [
	^self name , $. asParser]

{ #category : #productions }
MediaTypeGrammar >> type [
	^self name]

