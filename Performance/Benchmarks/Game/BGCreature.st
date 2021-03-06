"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGCreature,
	#superclass : #Object,
	#instVars : [
		'creatureName',
		'colour',
		'selfMet',
		'creaturesMet'
	],
	#category : #Game
}

{ #category : #'instance creation' }
BGCreature class >> new [
	^self basicNew initialize
]

{ #category : #'initialize-release' }
BGCreature class >> withName: aName colour: aColour [
   ^(self new initialize)
      name: aName;
      colour: aColour
]

{ #category : #accessing }
BGCreature >> colour [
   ^colour
]

{ #category : #accessing }
BGCreature >> colour: anObject [
   colour := anObject
]

{ #category : #accessing }
BGCreature >> creaturesMet [
   ^creaturesMet
]

{ #category : #accessing }
BGCreature >> creaturesMet: anObject [
   creaturesMet := anObject
]

{ #category : #'initialize-release' }
BGCreature >> initialize [
   selfMet := 0.
   creaturesMet := 0
]

{ #category : #accessing }
BGCreature >> name [
   ^creatureName
]

{ #category : #accessing }
BGCreature >> name: anObject [
   creatureName := anObject
]

{ #category : #accessing }
BGCreature >> selfMet [
   ^selfMet
]

{ #category : #accessing }
BGCreature >> selfMet: anObject [
   ^selfMet := anObject
]

{ #category : #controlling }
BGCreature >> visitMall: mall [
   
   [| partner |
   partner := mall visitWith: self.
   partner ifNotNil: 
         [colour := colour complementaryColourFor: partner colour.
         self == partner ifTrue: [selfMet := selfMet + 1].
         creaturesMet := creaturesMet + 1].
   partner isNil] 
         whileFalse
]

