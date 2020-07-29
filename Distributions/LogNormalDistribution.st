"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LogNormalDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'mu',
		'sigma',
		'normal'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
LogNormalDistribution class >> around: aNumber [
	| mu |
	mu := aNumber <= 0 ifTrue: [1.0] ifFalse: [aNumber asFloat].
	^self mean: mu deviation: mu abs * 0.05]

{ #category : #'instance creation' }
LogNormalDistribution class >> between: n and: m [
	^self around: (n max: 0) + m / 2]

{ #category : #calculations }
LogNormalDistribution class >> logToNormalMu: mean sigma: deviation [
	| m2 s2 |
	m2 := mean squared.
	s2 := deviation squared.
	^{(m2 / (m2 + s2) sqrt) ln. (m2 + s2 / m2) ln sqrt}]

{ #category : #'instance creation' }
LogNormalDistribution class >> mean: mean deviation: deviation [
	| validation |
	validation := self
		runValidation: #validateLogNormalMean:deviation:
		with: mean
		with: deviation.
	^validation hasPassed ifTrue: [self new mean: mean deviation: deviation]]

{ #category : #'instance creation' }
LogNormalDistribution class >> normalMean: m deviation: s [
	"
	LogNormalDistribution normalMean: 0 deviation: 1
	"
	| validation |
	validation := self
		runValidation: #validateLogNormalNormalMean:deviation:
		with: m
		with: s.
	^validation hasPassed
		ifTrue: [self new normalMean: m asFloat deviation: s asFloat]]

{ #category : #'instance creation' }
LogNormalDistribution class >> normalMean: m logDeviation: s [
	"
	LogNormalDistribution normalMean: 0 logDeviation: 2.16119742
	"
	| validation |
	validation := self
		runValidation: #validateLogNormalNormalMean:logDeviation:
		with: m
		with: s.
	^validation hasPassed
		ifTrue: [self new normalMean: m asFloat logDeviation: s asFloat]]

{ #category : #calculations }
LogNormalDistribution class >> normalToLogMu: m sigma: s [
	| s2 mu |
	s2 := s squared.
	mu := (s2 / 2.0 + m) exp.
	^{mu. mu * (s2 exp - 1) sqrt}]

{ #category : #private }
LogNormalDistribution class >> percentile: p1
valued: x1
and: p2
valued: x2 [
	| data m s s2 mu |
	(x1 > 0.0 and: [x2 > 0.0]) ifFalse: [^nil].
	data := NormalDistribution
		percentile: p1
		valued: x1 ln
		and: p2
		valued: x2 ln.
	data isNil ifTrue: [^nil].
	m := data first.
	s := data second.
	s2 := s squared.
	mu := (s2 / 2.0 + m) exp.
	^{mu. mu * (s2 exp - 1) sqrt}]

{ #category : #examples }
LogNormalDistribution class >> sampleInstance [
	^self around: 100.0]

{ #category : #'instance creation' }
LogNormalDistribution class >> standard [
	^self normalMean: 0.0 deviation: 1.0]

{ #category : #'instance creation' }
LogNormalDistribution class >> withPercentile: p ratio: rho mean: mu [
	"
	LogNormalDistribution withPercentile: 0.9 ratio: 2 mean: 3
	"
	| validation |
	validation := self
		runValidation: #validateLogNormalWithPercentile:ratio:mean:
		withArguments: {p. rho. mu}.
	^validation hasPassed
		ifTrue: [self new withPercentile: p ratio: rho mean: mu]]

{ #category : #'instance creation' }
LogNormalDistribution class >> withPercentiles: p1
valued: x1
and: p2
valued: x2 [
	| validation muSigma |
	validation := self
		runValidation: #validateLogNormalWithPercentiles:valued:and:valued:
		withArguments: {p1. x1. p2. x2}.
	^validation hasPassed ifTrue: [
		muSigma := NormalDistribution
			percentile: p1
			valued: x1 ln
			and: p2
			valued: x2 ln.
		self normalMean: muSigma first deviation: muSigma second]]

{ #category : #validation }
LogNormalDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #logNormalValidation]

{ #category : #converting }
LogNormalDistribution >> asJson [
	^super asJson
		at: 'Mean' put: mu;
		at: 'SD' put: sigma;
		yourself]

{ #category : #services }
LogNormalDistribution >> convertValuesWith: aNumber [
	self mean: mu * aNumber deviation: sigma * aNumber abs]

{ #category : #'probability functions' }
LogNormalDistribution >> density: x [
	x <= 0.0 ifTrue: [^0.0].
	^(normal density: x ln) / x]

{ #category : #estimators }
LogNormalDistribution >> deviation [
	^sigma]

{ #category : #'probability functions' }
LogNormalDistribution >> distribution: x [
	x <= 0.0 ifTrue: [^0.0].
	^normal distribution: x ln]

{ #category : #converting }
LogNormalDistribution >> fromJson: aJsonObject [
	self mean: aJsonObject Mean deviation: aJsonObject SD]

{ #category : #services }
LogNormalDistribution >> geometricMean: n [
	| arithmetic geometric |
	arithmetic := normal arithmeticMean: n.
	geometric := self class
		normalMean: arithmetic mean
		deviation: arithmetic deviation.
	^geometric uniform: uniform]

{ #category : #'probability functions' }
LogNormalDistribution >> inverseDistribution: u [
	^(normal inverseDistribution: u) exp]

{ #category : #inquiries }
LogNormalDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber and: [
		0.0 < deterministicValue
			and: [normal isConsistentWith: deterministicValue ln]]]

{ #category : #inquiries }
LogNormalDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self mean = aProbabilityDistribution mean]
		and: [self deviation = aProbabilityDistribution deviation]]

{ #category : #testing }
LogNormalDistribution >> isLogNormal [
	^true]

{ #category : #estimators }
LogNormalDistribution >> kurtosis [
	"http://mathworld.wolfram.com/Kurtosis.html"
	| s2 |
	s2 := normal variance.
	^(4 * s2) exp + ((3 * s2) exp * 2) + ((2 * s2) exp * 3) - 6]

{ #category : #estimators }
LogNormalDistribution >> mean [
	^mu]

{ #category : #private }
LogNormalDistribution >> mean: mean deviation: deviation [
	| m2 s2 sd media validation |
	mu := mean.
	sigma := deviation.
	m2 := mean squared.
	m2 = 0.0 ifTrue: [^self].
	s2 := self variance.
	m2 + s2 = 0.0 ifTrue: [^self].
	media := (m2 / (m2 + s2) sqrt) ln.
	sd := (m2 + s2 / m2) ln sqrt.
	validation := self
		runValidation: #validateNormalMean:deviation:
		with: media
		with: sd.
	validation hasPassed ifTrue: [
		normal := NormalDistribution mean: media deviation: sd.
		normal uniform: uniform]]

{ #category : #estimators }
LogNormalDistribution >> mode [
	^(mu - sigma squared) exp]

{ #category : #accessing }
LogNormalDistribution >> mu [
	^mu]

{ #category : #accessing }
LogNormalDistribution >> mu: aNumber [
	self mean: aNumber deviation: sigma]

{ #category : #'random sampling' }
LogNormalDistribution >> next [
	^normal next exp]

{ #category : #accessing }
LogNormalDistribution >> normal [
	^normal]

{ #category : #private }
LogNormalDistribution >> normalMean: m deviation: s [
	| s2 validation |
	s2 := s squared.
	mu := (s2 / 2.0 + m) exp.
	sigma := mu * (s2 exp - 1) sqrt.
	validation := self
		runValidation: #validateNormalMean:deviation:
		with: m
		with: s.
	self ASSERT: [validation hasPassed].
	normal := NormalDistribution mean: m deviation: s]

{ #category : #private }
LogNormalDistribution >> normalMean: m logDeviation: s [
	| sg2 sd validation |
	sg2 := ((4.0 * s squared / (m * 2.0) exp + 1.0) sqrt + 1.0 / 2.0) ln.
	mu := (sg2 / 2.0 + m) exp.
	sigma := s.
	sd := sg2 sqrt.
	validation := self
		runValidation: #validateNormalMean:deviation:
		with: m
		with: sd.
	self ASSERT: [validation hasPassed].
	normal := NormalDistribution mean: m deviation: sd]

{ #category : #printing }
LogNormalDistribution >> parameterArray [
	^{self mean. self sigma}]

{ #category : #accessing }
LogNormalDistribution >> parameters [
	| answer |
	answer := Dictionary new.
	answer
		at: 'Mean' put: self mean;
		at: 'SD' put: self sigma.
	^answer]

{ #category : #copying }
LogNormalDistribution >> postCopy [
	super postCopy.
	normal := normal copy]

{ #category : #printing }
LogNormalDistribution >> prettyPrint [
	^self displayString , ' (' , mu printNLString , ', ' , sigma printNLString
		, ')']

{ #category : #estimators }
LogNormalDistribution >> sigma [
	^sigma]

{ #category : #accessing }
LogNormalDistribution >> sigma: aNumber [
	self mean: mu deviation: aNumber]

{ #category : #estimators }
LogNormalDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	| expS2 |
	expS2 := normal variance exp.
	^2 + expS2 * (expS2 - 1) sqrt]

{ #category : #printing }
LogNormalDistribution >> storeString [
	^self class name , ' mean: ' , mu storeString , ' deviation: '
		, sigma storeString]

{ #category : #accessing }
LogNormalDistribution >> totalMean [
	^normal mean]

{ #category : #operations }
LogNormalDistribution >> translateBy: delta [
	| m d |
	d := delta.
	[
		m := self mean + d.
		m <= 0]
		whileTrue: [d := d / 2.0].
	self mean: m deviation: self deviation]

{ #category : #truncation }
LogNormalDistribution >> truncatedClass [
	^TruncatedLogNormalDistribution]

{ #category : #accessing }
LogNormalDistribution >> uniform: aRandom [
	super uniform: aRandom.
	normal uniform: uniform]

{ #category : #validation }
LogNormalDistribution >> validateDeviation: aFloat [
	^self runValidation: #validateLogNormalMean:deviation: with: mu with: aFloat]

{ #category : #validation }
LogNormalDistribution >> validateMean: aFloat [
	^self
		runValidation: #validateLogNormalMean:deviation:
		with: aFloat
		with: sigma]

{ #category : #estimators }
LogNormalDistribution >> variance [
	^sigma squared]

{ #category : #private }
LogNormalDistribution >> withPercentile: p ratio: rho mean: mean [
	| standard s sd |
	standard := NormalDistribution standard.
	s := rho ln / 2.0 / (standard percentile: p).
	sd := mean * (s squared exp - 1.0) sqrt.
	self mean: mean deviation: sd]

