"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BernoulliCalculatorTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #all }
BernoulliCalculatorTest >> testConditionalMode1 [
	| calculator |
	calculator := BernoulliCalculator pA: 0.3 pB: 0.4 conditionalBA: 0.75.
	self
		assert: calculator validate hasPassed;
		assert: calculator correlation ~ 0.46770717334674;
		assert: calculator pAB ~ 0.225;
		assert: calculator pABnot ~ 0.075;
		assert: calculator pBAnot ~ 0.175;
		assert: calculator pAnotBnot ~ 0.525]

{ #category : #all }
BernoulliCalculatorTest >> testConditionalMode2 [
	| calculator |
	calculator := BernoulliCalculator
		pA: 0.3
		conditionalBA: 0.75
		conditionalBAnot: 0.25.
	self
		assert: calculator validate hasPassed;
		assert: calculator pB ~ 0.4;
		assert: calculator correlation ~ 0.46770717334674;
		assert: calculator pAB ~ 0.225;
		assert: calculator pABnot ~ 0.075;
		assert: calculator pBAnot ~ 0.175;
		assert: calculator pAnotBnot ~ 0.525]

{ #category : #all }
BernoulliCalculatorTest >> testCorrelationMode [
	| calculator |
	calculator := BernoulliCalculator
		pA: 0.3
		pB: 0.4
		correlation: 0.46770717334674.
	self
		assert: calculator validate hasPassed;
		assert: calculator conditionalBA ~ 0.75;
		assert: calculator pAB ~ 0.225;
		assert: calculator pABnot ~ 0.075;
		assert: calculator pBAnot ~ 0.175;
		assert: calculator pAnotBnot ~ 0.525]

{ #category : #all }
BernoulliCalculatorTest >> testJointMode [
	| calculator |
	calculator := BernoulliCalculator
		pAB: 0.225
		pABnot: 0.075
		pBAnot: 0.175
		pAnotBnot: 0.525.
	self
		assert: calculator validate hasPassed;
		assert: calculator conditionalBA ~ 0.75;
		assert: calculator correlation ~ 0.46770717334674;
		assert: calculator pA ~ 0.3;
		assert: calculator pB ~ 0.4]

