"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MultivariateNormalDistributionTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #testing }
MultivariateNormalDistributionTest >> testCovariance [
	| cov mean norm n sample estimated difference lowerChi21000 upperChi21000 |
	#knownIssue.
	cov := '
		1 0.5
		0.5 1' asFloatMatrix.
	mean := '
		0 
		0' asFloatMatrix.
	norm := MultivariateNormalDistribution mean: mean covariance: cov.
	norm uniform: self random.
	n := 1000.
	sample := norm sample: n.
	estimated := sample * sample transposed * (n - 1) reciprocal.
	difference := cov - estimated.
	lowerChi21000 := 927.59.
	upperChi21000 := 1074.68.
	1 to: 2 do: [:i | | chi2 |
		chi2 := n - 1 * (estimated atRow: i column: i).
		self
			assert: chi2 > lowerChi21000;
			assert: chi2 < upperChi21000].
	self
		assert: (difference atRow: 1 column: 2) ~ (difference atRow: 1 column: 2);
		assert: (difference atRow: 1 column: 2) abs
			< ((cov atRow: 1 column: 2) * 0.5) abs]

{ #category : #testing }
MultivariateNormalDistributionTest >> testCovariance2 [
	| cov mean norm n sample estimated difference |
	cov := '
		2    -1    0
		-1    2    -1
		0    -1    2' asFloatMatrix.
	mean := '
		0 
		0 
		0' asFloatMatrix.
	norm := MultivariateNormalDistribution mean: mean covariance: cov.
	norm uniform: self random.
	n := 10000.
	sample := norm sample: n.
	estimated := sample * sample transposed * n reciprocal.
	difference := cov - estimated.
	self assert: difference max < (cov max * 0.1)]

{ #category : #testing }
MultivariateNormalDistributionTest >> testDistribution [
	| cov mean norm sample p |
	cov := '
		1    0.5
		0.5    1' asFloatMatrix.
	mean := '
		3 
		5' asFloatMatrix.
	norm := MultivariateNormalDistribution mean: mean covariance: cov.
	norm uniform: #(0.3 0.4) readStream.
	sample := norm next.
	p := norm distribution: sample.
	self assert: (0.3 * 0.4 - p) abs < (0.3 * 0.4 * 0.1)]

{ #category : #testing }
MultivariateNormalDistributionTest >> testMean [
	| cov mean norm sample n first second |
	cov := '
		1    0.8
		0.8    1' asFloatMatrix.
	mean := '
		3 
		17' asFloatMatrix.
	norm := MultivariateNormalDistribution mean: mean covariance: cov.
	norm uniform: self random.
	n := 10000.
	sample := norm sample: n.
	first := sample row: 1.
	self assert: (first mean - 3) abs * n sqrt < 1.96.
	second := sample row: 2.
	self assert: (second mean - 17) abs * n sqrt < 1.96]

