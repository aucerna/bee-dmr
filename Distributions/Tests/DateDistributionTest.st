"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DateDistributionTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #all }
DateDistributionTest >> testCopy [
	| d copy |
	d := DateDistribution
		truncatedNormalMean: Date today
		deviation: 10
		min: nil
		max: nil.
	copy := d copy.
	d deviate mean: d deviate mean deviation: 9.
	self assert: d deviate deviation = 9; assert: copy deviate deviation = 10]

{ #category : #all }
DateDistributionTest >> testTruncated [
	| d |
	d := DateDistribution
		truncatedNormalMean: Date today
		deviation: 10
		min: nil
		max: nil.
	self shouldnt: [d distribution: Date today] raise: MessageNotUnderstood]

{ #category : #'creation tests' }
DateDistributionTest >> testTruncatedCreation [
	self
		shouldnt: [
			DateDistribution
				truncatedNormalMean: Date today
				deviation: 10
				min: nil
				max: nil]
		raise: MessageNotUnderstood.
	self
		shouldnt: [
			DateDistribution
				truncatedLogNormalMean: Date today
				deviation: 10
				min: nil
				max: nil]
		raise: MessageNotUnderstood]

