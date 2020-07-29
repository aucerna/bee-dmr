"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BernoulliCalculator,
	#superclass : #Object,
	#instVars : [
		'pA',
		'pB',
		'conditionalBA',
		'conditionalAB',
		'conditionalBAnot',
		'pAB',
		'pABnot',
		'pBAnot',
		'pAnotBnot',
		'correlation'
	],
	#category : #Distributions
}

{ #category : #services }
BernoulliCalculator class >> pA: pA conditionalBA: conditionalBA conditionalBAnot: conditionalBAnot [
	^self new
		pA: pA;
		conditionalBA: conditionalBA;
		conditionalBAnot: conditionalBAnot;
		compute]

{ #category : #services }
BernoulliCalculator class >> pA: pA pB: pB conditionalBA: conditionalBA [
	^self new
		pA: pA;
		pB: pB;
		conditionalBA: conditionalBA;
		compute]

{ #category : #services }
BernoulliCalculator class >> pA: pA pB: pB correlation: correlation [
	^self new
		pA: pA;
		pB: pB;
		correlation: correlation;
		compute]

{ #category : #services }
BernoulliCalculator class >> pAB: pAB
pABnot: pABnot
pBAnot: pBAnot
pAnotBnot: pAnotBnot [
	^self new
		pAB: pAB;
		pABnot: pABnot;
		pBAnot: pBAnot;
		pAnotBnot: pAnotBnot;
		compute]

{ #category : #validation }
BernoulliCalculator >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	self isConditionalMode1
		ifTrue: [aCollection add: #conditionalMode1Validation].
	self isConditionalMode2
		ifTrue: [aCollection add: #conditionalMode2Validation].
	self isCorrelationMode
		ifTrue: [aCollection add: #correlationModeValidation].
	self isJointMode ifTrue: [aCollection add: #jointModeValidation]]

{ #category : #testing }
BernoulliCalculator >> canCompute [
	self isConditionalMode1 ifTrue: [^true].
	self isConditionalMode2 ifTrue: [^true].
	self isCorrelationMode ifTrue: [^true].
	self isJointMode ifTrue: [^true].
	^false]

{ #category : #private }
BernoulliCalculator >> completeJointProbabilities [
	| joint i p |
	joint := self jointProbabilities.
	i := joint findFirst: [:v | v isNil] ifAbsent: [^self].
	p := 1.0 - self definedJoint sum.
	i = 1 ifTrue: [^pAB := p].
	i = 2 ifTrue: [^pABnot := p].
	i = 3 ifTrue: [^pBAnot := p].
	i = 4 ifTrue: [^pAnotBnot := p].
	self ASSERT: false]

{ #category : #computing }
BernoulliCalculator >> compute [
	self isConditionalMode1 ifTrue: [^self computeConditionalMode1].
	self isConditionalMode2 ifTrue: [^self computeConditionalMode2].
	self isCorrelationMode ifTrue: [^self computeCorrelationMode].
	self isJointMode ifTrue: [^self computeJointMode].
	self error: 'cannot compute']

{ #category : #computing }
BernoulliCalculator >> computeConditionalMode1 [
	self computeConditionals.
	conditionalBAnot := pBAnot / (1.0 - pA)]

{ #category : #computing }
BernoulliCalculator >> computeConditionalMode2 [
	pB := conditionalBAnot * (1.0 - pA) + (conditionalBA * pA).
	self computeConditionals]

{ #category : #computing }
BernoulliCalculator >> computeConditionals [
	self computeCorrelation; computeFromCorrelation]

{ #category : #computing }
BernoulliCalculator >> computeCorrelation [
	correlation := conditionalBA - pB * pA / self sigmaA / self sigmaB]

{ #category : #computing }
BernoulliCalculator >> computeCorrelationMode [
	conditionalBA := correlation / pA * self sigmaA * self sigmaB + pB.
	self computeFromCorrelation.
	conditionalBAnot := pBAnot / (1.0 - pA)]

{ #category : #computing }
BernoulliCalculator >> computeFromCorrelation [
	pAB := conditionalBA * pA.
	pABnot := pA - pAB.
	pBAnot := pB - pAB.
	pAnotBnot := 1.0 + pAB - pA - pB.
	conditionalAB := pAB / pB]

{ #category : #computing }
BernoulliCalculator >> computeJointMode [
	self completeJointProbabilities.
	pA := pAB + pABnot.
	pB := pAB + pBAnot.
	conditionalBA := pAB / pA.
	self computeCorrelation.
	conditionalAB := pAB / pB.
	conditionalBAnot := pBAnot / (1.0 - pA).
	conditionalAB := pAB / pB]

{ #category : #accessing }
BernoulliCalculator >> conditionalAB [
	^conditionalAB]

{ #category : #accessing }
BernoulliCalculator >> conditionalAB: aNumber [
	conditionalAB := aNumber]

{ #category : #accessing }
BernoulliCalculator >> conditionalBA [
	^conditionalBA]

{ #category : #accessing }
BernoulliCalculator >> conditionalBA: aNumber [
	conditionalBA := aNumber]

{ #category : #accessing }
BernoulliCalculator >> conditionalBAnot [
	^conditionalBAnot]

{ #category : #accessing }
BernoulliCalculator >> conditionalBAnot: aNumber [
	conditionalBAnot := aNumber]

{ #category : #accessing }
BernoulliCalculator >> correlation [
	^correlation]

{ #category : #accessing }
BernoulliCalculator >> correlation: aNumber [
	correlation := aNumber]

{ #category : #private }
BernoulliCalculator >> definedJoint [
	^self jointProbabilities copyWithout: nil]

{ #category : #testing }
BernoulliCalculator >> isConditionalMode1 [
	^pA notNil and: [pB notNil] and: [conditionalBA notNil]]

{ #category : #testing }
BernoulliCalculator >> isConditionalMode2 [
	^pA notNil and: [conditionalBA notNil] and: [conditionalBAnot notNil]]

{ #category : #testing }
BernoulliCalculator >> isCorrelationMode [
	^pA notNil and: [pB notNil] and: [correlation notNil]]

{ #category : #testing }
BernoulliCalculator >> isJointMode [
	^self definedJoint size >= 3]

{ #category : #private }
BernoulliCalculator >> jointProbabilities [
	^OrderedCollection
		with: pAB
		with: pABnot
		with: pBAnot
		with: pAnotBnot]

{ #category : #accessing }
BernoulliCalculator >> pA [
	^pA]

{ #category : #accessing }
BernoulliCalculator >> pA: aNumber [
	pA := aNumber]

{ #category : #accessing }
BernoulliCalculator >> pAB [
	^pAB]

{ #category : #accessing }
BernoulliCalculator >> pAB: aNumber [
	pAB := aNumber]

{ #category : #accessing }
BernoulliCalculator >> pABnot [
	^pABnot]

{ #category : #accessing }
BernoulliCalculator >> pABnot: aNumber [
	pABnot := aNumber]

{ #category : #accessing }
BernoulliCalculator >> pAnotBnot [
	^pAnotBnot]

{ #category : #accessing }
BernoulliCalculator >> pAnotBnot: aNumber [
	pAnotBnot := aNumber]

{ #category : #accessing }
BernoulliCalculator >> pB [
	^pB]

{ #category : #accessing }
BernoulliCalculator >> pB: aNumber [
	pB := aNumber]

{ #category : #accessing }
BernoulliCalculator >> pBAnot [
	^pBAnot]

{ #category : #accessing }
BernoulliCalculator >> pBAnot: aNumber [
	pBAnot := aNumber]

{ #category : #private }
BernoulliCalculator >> sigmaA [
	^(1.0 - pA * pA) sqrt]

{ #category : #private }
BernoulliCalculator >> sigmaB [
	^(1.0 - pB * pB) sqrt]

