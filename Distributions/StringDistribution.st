"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #StringDistribution,
	#superclass : #DiscreteProbabilityDistribution,
	#instVars : [
		'deviate',
		'mapping'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
StringDistribution class >> around: aString [
	^self for: aString]

{ #category : #testing }
StringDistribution class >> canSample: aCsrVariable [
	^aCsrVariable isStringValued]

{ #category : #'instance creation' }
StringDistribution class >> discreteProbabilities: probCollection values: stringCollection [
	^self values: stringCollection probabilities: probCollection]

{ #category : #'instance creation' }
StringDistribution class >> for: aString [
	^self values: {aString} probabilities: #(1.0)]

{ #category : #'instance creation' }
StringDistribution class >> on: aDiscreteDistribution values: stringCollection [
	| validation |
	validation := self
		runValidation: #validateStringOn:values:
		with: aDiscreteDistribution
		with: stringCollection.
	^validation hasPassed
		ifTrue: [self new
			deviate: aDiscreteDistribution;
			mapping: stringCollection]]

{ #category : #'instance creation' }
StringDistribution class >> sampleInstance [
	^self values: #('one' 'two') probabilities: #(0.5 0.5)]

{ #category : #'instance creation' }
StringDistribution class >> values: stringCollection probabilities: probCollection [
	| indexes distribution |
	indexes := (1 to: stringCollection size) asArray.
	distribution := ProbabilityDistribution
		discreteProbabilities: probCollection
		values: indexes.
	^self on: distribution values: stringCollection]

{ #category : #validation }
StringDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #stringValidation]

{ #category : #'user commands' }
StringDistribution >> beUniform [
	deviate beUniform]

{ #category : #'probability functions' }
StringDistribution >> density: aString [
	| index |
	index := self indexFrom: aString.
	^index = 0 ifTrue: [0] ifFalse: [deviate density: index]]

{ #category : #accessing }
StringDistribution >> deviate [
	^deviate]

{ #category : #accessing }
StringDistribution >> deviate: aDiscreteDistribution [
	deviate := aDiscreteDistribution]

{ #category : #'probability functions' }
StringDistribution >> distribution [
	^deviate distribution]

{ #category : #'probability functions' }
StringDistribution >> distribution: aString [
	| index |
	index := self indexFrom: aString.
	^index = 0 ifTrue: [0] ifFalse: [deviate distribution: index]]

{ #category : #testing }
StringDistribution >> hasTable [
	^deviate hasTable]

{ #category : #private }
StringDistribution >> indexFrom: aString [
	^mapping indexOf: aString ifAbsent: 0]

{ #category : #'probability functions' }
StringDistribution >> inverseDistribution: u [
	^self stringFrom: (deviate inverseDistribution: u)]

{ #category : #inquiries }
StringDistribution >> isConsistentWith: deterministicValue [
	^mapping includes: deterministicValue]

{ #category : #testing }
StringDistribution >> isDiscrete [
	^deviate isDiscrete]

{ #category : #testing }
StringDistribution >> isDiscretized [
	^deviate isDiscretized]

{ #category : #testing }
StringDistribution >> isFinite [
	^deviate isBounded]

{ #category : #private }
StringDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [deviate isLike: aProbabilityDistribution deviate]
		and: [mapping = aProbabilityDistribution mapping]]

{ #category : #testing }
StringDistribution >> isLogNormal [
	^deviate isLogNormal]

{ #category : #testing }
StringDistribution >> isNormal [
	^deviate isNormal]

{ #category : #testing }
StringDistribution >> isStringDistribution [
	^true]

{ #category : #testing }
StringDistribution >> isTriangular [
	^deviate isTriangular]

{ #category : #testing }
StringDistribution >> isTruncatedLogNormal [
	^deviate isTruncatedLogNormal]

{ #category : #testing }
StringDistribution >> isTruncatedNormal [
	^deviate isTruncatedNormal]

{ #category : #testing }
StringDistribution >> isUniform [
	^deviate isUniform]

{ #category : #accessing }
StringDistribution >> mapping [
	^mapping]

{ #category : #accessing }
StringDistribution >> mapping: stringCollection [
	mapping := stringCollection]

{ #category : #estimators }
StringDistribution >> max [
	^mapping last]

{ #category : #estimators }
StringDistribution >> mean [
	^nil]

{ #category : #estimators }
StringDistribution >> min [
	^mapping first]

{ #category : #estimators }
StringDistribution >> mode [
	^mapping at: deviate mode ifAbsent: nil]

{ #category : #'random sampling' }
StringDistribution >> next [
	^self stringFrom: deviate next]

{ #category : #printing }
StringDistribution >> parameterArray [
	| n |
	^Array streamContents: [:stream | 
		stream nextPut: (n := mapping size).
		1 to: n do: [:i | 
			stream
				nextPut: (mapping at: i);
				nextPut: (deviate probabilities at: i)]]]

{ #category : #'probability functions' }
StringDistribution >> percentile: p [
	^self stringFrom: (deviate percentile: p)]

{ #category : #copying }
StringDistribution >> postCopy [
	super postCopy.
	deviate := deviate copy.
	mapping := mapping copy]

{ #category : #accessing }
StringDistribution >> probabilities [
	^deviate probabilities]

{ #category : #accessing }
StringDistribution >> probabilityAt: index ifAbsent: aBlock [
	^deviate probabilityAt: index ifAbsent: aBlock]

{ #category : #printing }
StringDistribution >> storeString [
	^self class name , ' on: (' , deviate storeString , ') values: '
		, mapping literalString]

{ #category : #private }
StringDistribution >> stringFrom: index [
	^mapping at: index asInteger ifAbsent: '']

{ #category : #'gui support' }
StringDistribution >> table [
	^deviate table
		collect: [:array | {self stringFrom: array first. array second}]]

{ #category : #accessing }
StringDistribution >> uniform: aRandom [
	super uniform: aRandom.
	deviate uniform: aRandom]

{ #category : #accessing }
StringDistribution >> valueAt: index ifAbsent: aBlock [
	^mapping at: index ifAbsent: aBlock]

{ #category : #accessing }
StringDistribution >> values [
	^mapping]

{ #category : #estimators }
StringDistribution >> variance [
	^deviate variance]

