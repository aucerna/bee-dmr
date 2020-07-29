"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GaussianCopula,
	#superclass : #MultivariatedDistribution,
	#instVars : [
		'marginals',
		'gaussians',
		'covariance'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
GaussianCopula class >> marginals: marginals fromKendall: kendall [
	^self new marginals: marginals; kendallTau: kendall]

{ #category : #'instance creation' }
GaussianCopula class >> marginals: marginals fromSpearman: spearman [
	^self new marginals: marginals; spearmanRho: spearman]

{ #category : #examples }
GaussianCopula class >> sampleInstance [
	| marginals |
	marginals := {BetaDistribution a: 30 b: 70. GammaDistribution shape: 2}.
	^self
		marginals: marginals
		fromSpearman: '
			1    0.5
			0.5    1' asFloatMatrix]

{ #category : #private }
GaussianCopula >> createCovarianceFrom: aCollection using: aBlock [
	covariance := aCollection collect: aBlock.
	self createGaussians]

{ #category : #private }
GaussianCopula >> createGaussians [
	| mean |
	mean := FloatMatrix newRows: covariance rowsSize columns: 1.
	gaussians := MultivariateNormalDistribution
		mean: mean
		covariance: covariance]

{ #category : #'probability functions' }
GaussianCopula >> distribution: aMatrix [
	| rows uniforms standard z |
	rows := OrderedCollection new.
	aMatrix rowsWithIndexDo: [:row :i | | marginal probabilities |
		marginal := marginals at: i.
		probabilities := row collect: [:x | marginal distribution: x].
		rows add: probabilities].
	uniforms := aMatrix class fromRowCollection: rows.
	standard := NormalDistribution standard.
	z := uniforms collect: [:u | standard inverseDistribution: u].
	^gaussians distribution: z]

{ #category : #'probability functions' }
GaussianCopula >> inverseDistribution: uniforms [
	| rows |
	rows := OrderedCollection new.
	uniforms rowsWithIndexDo: [:row :i | | marginal sample |
		marginal := marginals at: i.
		sample := row collect: [:u | marginal inverseDistribution: u].
		rows add: sample].
	^uniforms class fromRowCollection: rows]

{ #category : #accessing }
GaussianCopula >> kendallTau [
	| theta |
	theta := 2.0 / Number pi.
	^covariance collect: [:rho | rho arcSin * theta]]

{ #category : #accessing }
GaussianCopula >> kendallTau: aCollection [
	| theta |
	theta := Number pi / 2.0.
	self createCovarianceFrom: aCollection using: [:tau | (tau * theta) sin]]

{ #category : #accessing }
GaussianCopula >> marginals: aCollection [
	marginals := aCollection]

{ #category : #statistics }
GaussianCopula >> mean [
	^FloatMatrix
		fromBlock: [:i :j | | marginal |
			marginal := marginals at: i.
			marginal mean]
		numRows: marginals size
		columns: 1]

{ #category : #'random sampling' }
GaussianCopula >> next [
	^self sample: 1]

{ #category : #printing }
GaussianCopula >> parameterArray [
	^{marginals. covariance}]

{ #category : #printing }
GaussianCopula >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: ' of: ';
		nextPutAll: marginals printString;
		nextPutAll: ' with correlations: ';
		nextPutAll: covariance printString]

{ #category : #'random sampling' }
GaussianCopula >> sample: n [
	| normal standard uniforms |
	normal := gaussians sample: n.
	standard := NormalDistribution standard.
	uniforms := normal collect: [:z | standard distribution: z].
	^self inverseDistribution: uniforms]

{ #category : #estimators }
GaussianCopula >> sd [
	self ASSERT: false.
	^nil]

{ #category : #accessing }
GaussianCopula >> spearmanRho [
	| theta |
	theta := 6.0 / Number pi.
	^covariance collect: [:rho | (rho / 2.0) arcSin * theta]]

{ #category : #accessing }
GaussianCopula >> spearmanRho: aCollection [
	| theta |
	theta := Number pi / 6.0.
	self
		createCovarianceFrom: aCollection
		using: [:rho | (rho * theta) sin * 2.0]]

{ #category : #printing }
GaussianCopula >> storeString [
	^self class name , ' marginals: ' , marginals storeString , ' covariance: '
		, covariance storeString]

{ #category : #'distribution protocol' }
GaussianCopula >> uniform: random [
	super uniform: random.
	gaussians uniform: random.
	marginals do: [:d | d uniform: random]]

{ #category : #estimators }
GaussianCopula >> variance [
	self ASSERT: false.
	^nil]

