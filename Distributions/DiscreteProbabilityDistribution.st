"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DiscreteProbabilityDistribution,
	#superclass : #ProbabilityDistribution,
	#category : #Distributions
}

{ #category : #validation }
DiscreteProbabilityDistribution class >> cleanValues: vCollection probabilities: pCollection [
	| n vStream pStream prevV s values probabilities pairs |
	(vCollection isEmptyOrNil or: [pCollection isEmptyOrNil]) ifTrue: [^nil].
	n := vCollection size.
	n = pCollection size ifFalse: [^nil].
	vStream := (Array new: n) writeStream.
	pStream := (Array new: n) writeStream.
	prevV := nil.
	s := 0.0.
	pairs := OrderedCollection
		streamContents: [:strm | vCollection
			with: pCollection
			do: [:v :p | strm nextPut: {v. p}]].
	pairs sortBy: [:a :b | a first < b first].
	values := pairs collect: [:each | each first].
	probabilities := pairs collect: [:each | each second].
	values with: probabilities do: [:v :p | 
		(prevV notNil and: [v < prevV]) ifTrue: [^nil].
		(prevV notNil and: [prevV < v])
			ifTrue: [
				vStream nextPut: prevV.
				pStream nextPut: s.
				s := p]
			ifFalse: [s := s + p].
		prevV := v].
	vStream nextPut: prevV.
	pStream nextPut: s.
	^{vStream contents. pStream contents}]

{ #category : #converting }
DiscreteProbabilityDistribution >> asJson [
	^super asJson at: 'Continuous' put: false; yourself]

{ #category : #'probability functions' }
DiscreteProbabilityDistribution >> distributionOver: aCollection [
	^aCollection inject: 0.0 into: [:r :each | r + (self density: each)]]

{ #category : #inquiries }
DiscreteProbabilityDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber
		and: [self isConsistentWithBounds: deterministicValue]]

{ #category : #testing }
DiscreteProbabilityDistribution >> isDiscrete [
	^true]

{ #category : #estimators }
DiscreteProbabilityDistribution >> mode [
	^self subclassResponsibility]

