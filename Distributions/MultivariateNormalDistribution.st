"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MultivariateNormalDistribution,
	#superclass : #MultivariatedDistribution,
	#instVars : [
		'mu',
		'covariance',
		'lower',
		'inverseLower',
		'dimension',
		'standard'
	],
	#category : #Distributions
}

{ #category : #examples }
MultivariateNormalDistribution class >> example [
	^self sampleInstance]

{ #category : #'instance creation' }
MultivariateNormalDistribution class >> mean: mean covariance: covariance [
	| mu cov |
	mean isArray
		ifTrue: [
			mu := FloatMatrix rowCollection: mean numRows: mean size.
			cov := FloatMatrix rowCollection: covariance numRows: mean size]
		ifFalse: [
			mu := mean.
			cov := covariance].
	^self new mean: mu covariance: cov]

{ #category : #examples }
MultivariateNormalDistribution class >> sampleInstance [
	^self
		mean: '
			1
			2' asFloatMatrix
		covariance: '
			1    0.5
			0.5    1' asFloatMatrix]

{ #category : #'probability functions' }
MultivariateNormalDistribution >> distribution: x [
	| p |
	p := 1.0.
	inverseLower * (x - mu) do: [:zi | p := p * (standard distribution: zi)].
	^p]

{ #category : #'probability functions' }
MultivariateNormalDistribution >> inverseDistribution: u [
	| expander z |
	z := u collect: [:uij | standard inverseDistribution: uij].
	expander := FloatMatrix
		fromBlock: [:i :j | 1.0]
		numRows: 1
		columns: u numColumns.
	^lower * z + (mu * expander)]

{ #category : #inquiries }
MultivariateNormalDistribution >> isConsistentWithMean: anArray [
	| probe p |
	probe := FloatMatrix rowCollection: anArray asArray numRows: mu size.
	probe isNil ifTrue: [^false].
	p := self distribution: probe.
	^p between: 0.2 and: 0.8]

{ #category : #estimators }
MultivariateNormalDistribution >> mean [
	^mu]

{ #category : #private }
MultivariateNormalDistribution >> mean: mean covariance: matrix [
	| cholesky |
	mu := mean.
	covariance := matrix.
	cholesky := covariance cholesky.
	cholesky run.
	lower := cholesky lowerTriangular.
	inverseLower := cholesky inverseLower.
	dimension := mean size.
	standard := NormalDistribution standard uniform: uniform]

{ #category : #'random sampling' }
MultivariateNormalDistribution >> next [
	^self sample: 1]

{ #category : #printing }
MultivariateNormalDistribution >> parameterArray [
	^mu columns anyone , covariance rows]

{ #category : #'random sampling' }
MultivariateNormalDistribution >> sample: n [
	| u |
	u := FloatMatrix
		fromBlock: [:i :j | uniform next]
		numRows: dimension
		columns: n.
	^self inverseDistribution: u]

{ #category : #printing }
MultivariateNormalDistribution >> storeString [
	^self class name , ' mean: ' , mu columns anyone literalString
		, ' covariance: '
		, covariance asFloatArray literalString]

{ #category : #'distribution protocol' }
MultivariateNormalDistribution >> uniform: aRandom [
	super uniform: aRandom.
	standard uniform: aRandom]

