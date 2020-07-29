"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #NormalDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'mu',
		'sigma',
		'alpha',
		'beta',
		'y'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
NormalDistribution class >> around: aNumber [
	| mu sigma |
	mu := aNumber asFloat.
	sigma := mu = 0.0 ifTrue: [1.0] ifFalse: [mu abs * 0.05].
	^self mean: mu deviation: sigma]

{ #category : #'instance creation' }
NormalDistribution class >> between: n and: m [
	^self around: n + m / 2]

{ #category : #'instance creation' }
NormalDistribution class >> default [
	^self standard]

{ #category : #examples }
NormalDistribution class >> example [
	"
	self example
	"
	^self sampleInstance]

{ #category : #'instance creation' }
NormalDistribution class >> mean: mu deviation: sigma [
	| validation |
	validation := self
		runValidation: #validateNormalMean:deviation:
		with: mu asFloat
		with: sigma asFloat.
	^validation hasPassed
		ifTrue: [self new mean: mu asFloat deviation: sigma asFloat]]

{ #category : #private }
NormalDistribution class >> percentile: p1
valued: x1
and: p2
valued: x2 [
	| s a1 a2 sigma mu |
	s := self standard.
	a1 := s inverseDistribution: p1.
	a2 := s inverseDistribution: p2.
	a1 = a2 ifTrue: [^nil].
	sigma := x1 - x2 / (a1 - a2).
	sigma < 0.0 ifTrue: [^nil].
	mu := x1 - (sigma * a1).
	^{mu. sigma}]

{ #category : #bibliography }
NormalDistribution class >> references [
	^ShellDLL current
		openWebPage: 'http://www.codeplanet.eu/files/download/accuratecumnorm.pdf']

{ #category : #examples }
NormalDistribution class >> sampleInstance [
	^self around: 100.0]

{ #category : #'instance creation' }
NormalDistribution class >> standard [
	standard isNil ifTrue: [standard := self new initializeStandard].
	^standard]

{ #category : #tests }
NormalDistribution class >> test [
	"
	self test
	"
	| instance sample high low m iterations array |
	m := 10.0.
	instance := self mean: m deviation: 0.5.
	iterations := 100.
	array := Array streamContents: [:stream | 
		iterations timesRepeat: [
			sample := instance sample: 2000.
			high := sample count: [:x | x >= m].
			low := sample size - high.
			stream nextPut: {low. high}]].
	^(array count: [:pair | pair first >= pair last]) / iterations asFloat * 100]

{ #category : #'instance creation' }
NormalDistribution class >> withPercentile: p ratio: rho mean: mu [
	"
	NormalDistribution withPercentile: 0.9 ratio: 1.1 mean: 1.1
	"
	| validation |
	validation := self
		runValidation: #validateNormalWithPercentile:ratio:mean:
		withArguments: {p. rho. mu}.
	^validation hasPassed
		ifTrue: [self new withPercentile: p ratio: rho mean: mu]]

{ #category : #'instance creation' }
NormalDistribution class >> withPercentiles: p1
valued: x1
and: p2
valued: x2 [
	| muSigma |
	muSigma := self
		percentile: p1
		valued: x1
		and: p2
		valued: x2.
	^muSigma notNil
		ifTrue: [self mean: muSigma first deviation: muSigma second]]

{ #category : #validation }
NormalDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #normalValidation]

{ #category : #services }
NormalDistribution >> arithmeticMean: n [
	| arithmetic |
	arithmetic := self class mean: mu deviation: sigma / n sqrt.
	^arithmetic uniform: uniform]

{ #category : #converting }
NormalDistribution >> asJson [
	^super asJson
		at: 'Mean' put: mu;
		at: 'SD' put: sigma;
		yourself]

{ #category : #services }
NormalDistribution >> convertValuesWith: aNumber [
	self mean: mu * aNumber deviation: sigma * aNumber abs]

{ #category : #'probability functions' }
NormalDistribution >> density: x [
	| exponent |
	exponent := (x - mu) squared * alpha.
	^exponent >= Float minPositiveValue ln
		ifTrue: [beta * exponent exp]
		ifFalse: [0.0]]

{ #category : #estimators }
NormalDistribution >> deviation [
	^sigma]

{ #category : #'probability functions' }
NormalDistribution >> distribution: x [
	^self hart: x - mu / sigma]

{ #category : #printing }
NormalDistribution >> explain [
	^'Number of times that each quantity is obtained when they are normally distributed with mean '
		, mu printString
		, ' and standard deviation '
		, sigma printString]

{ #category : #converting }
NormalDistribution >> fromJson: aJsonObject [
	self mean: aJsonObject Mean deviation: aJsonObject SD]

{ #category : #private }
NormalDistribution >> hart: x [
	| a exp build cdf |
	a := x abs.
	cdf := 37.0 < a ifTrue: [0.0] ifFalse: [
		exp := (a * a / -2.0) exp.
		a < 7.07106781186547
			ifTrue: [
				build := 0.35262496599891e-1 * a + 0.70038306444369 * a
					+ 6.37396220353165
					* a
					+ 33.912866078383
					* a
					+ 112.079291497871
					* a
					+ 221.213596169931
					* a
					+ 220.206867912376.
				cdf := exp * build.
				build := 0.88388347648318e-1 * a + 1.75566716318264 * a
					+ 16.064177579207
					* a
					+ 86.7807322029461
					* a
					+ 296.564248779674
					* a
					+ 637.333633378831
					* a
					+ 793.826512519948
					* a
					+ 440.413735824752.
				cdf / build]
			ifFalse: [
				build := a + 0.65.
				build := a + 4.0 / build.
				build := a + 3.0 / build.
				build := a + 2.0 / build.
				build := a + 1.0 / build.
				exp / build / 2.506628274631]].
	0.0 < x ifTrue: [cdf := 1.0 - cdf].
	^cdf]

{ #category : #initialization }
NormalDistribution >> initializeStandard [
	mu := 0.0.
	sigma := 1.0.
	alpha := -0.5 / sigma squared.
	beta := 1.0 / sigma / (Float pi * 2) sqrt]

{ #category : #'probability functions' }
NormalDistribution >> inverseDistribution: u [
	| x |
	x := self class standard voutier: u.
	^x * sigma + mu]

{ #category : #inquiries }
NormalDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self mean = aProbabilityDistribution mean]
		and: [self deviation = aProbabilityDistribution deviation]]

{ #category : #testing }
NormalDistribution >> isNormal [
	^true]

{ #category : #'random sampling' }
NormalDistribution >> knuthNext [
	"
	Knuth, Vol. 2, Alg. P, page 117.
	"
	| s v u |
	[
		u := uniform next * 2 - 1.
		v := uniform next * 2 - 1.
		s := v squared + u squared.
		s >= 1.0] whileTrue.
	^sigma * v * (-2.0 * s ln / s) sqrt + mu]

{ #category : #estimators }
NormalDistribution >> kurtosis [
	"http://mathworld.wolfram.com/Kurtosis.html"
	^0.0]

{ #category : #estimators }
NormalDistribution >> mean [
	^mu]

{ #category : #private }
NormalDistribution >> mean: mean deviation: deviation [
	mu := mean.
	sigma := deviation.
	sigma = 0.0 ifTrue: [^self].
	alpha := -0.5 / sigma squared.
	beta := 1.0 / sigma / (Number pi * 2.0) sqrt]

{ #category : #estimators }
NormalDistribution >> median [
	^self mean]

{ #category : #estimators }
NormalDistribution >> mode [
	^self mean]

{ #category : #accessing }
NormalDistribution >> mu [
	^mu]

{ #category : #estimators }
NormalDistribution >> mu: aNumber [
	self mean: aNumber deviation: sigma]

{ #category : #'random sampling' }
NormalDistribution >> next [
	"
	ShellDLL current
		openWebPage: 'http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform'
	"
	| u v rho theta x |
	y isNil
		ifTrue: [
			u := uniform next.
			v := uniform next.
			rho := (-2.0 * u ln) sqrt.
			theta := 2.0 * Number pi * v.
			x := rho * theta cos.
			y := rho * theta sin]
		ifFalse: [
			x := y.
			y := nil].
	^sigma * x + mu]

{ #category : #'random sampling' }
NormalDistribution >> next2 [
	"Knuth, Vol. 2, Alg. R, page 125."
	"(8 / 1 exp) sqrt = 1.71552777"
	| x v u |
	[
		u := 1 - uniform next.
		v := uniform next.
		x := 1.71552777 * (v - 0.5) / u.
		x squared <= (-4 / u ln)] whileFalse.
	^sigma * x + mu]

{ #category : #'random sampling' }
NormalDistribution >> next3 [
	"Knuth, Vol. 2, Alg. P, page 117."
	| s v u |
	[
		u := uniform next * 2 - 1.
		v := uniform next * 2 - 1.
		s := v squared + u squared.
		s >= 1] whileTrue.
	^sigma * v * (-2.0 * s ln / s) sqrt + mu]

{ #category : #printing }
NormalDistribution >> parameterArray [
	^{self mean. self deviation}]

{ #category : #printing }
NormalDistribution >> parameterArrayForDateDistribution: aDateDistribution [
	| m |
	m := aDateDistribution dateFrom: self mean.
	^{m. self deviation}]

{ #category : #accessing }
NormalDistribution >> parameters [
	| answer |
	answer := Dictionary new.
	answer
		at: 'Mean' put: self mean;
		at: 'SD' put: self deviation.
	^answer]

{ #category : #printing }
NormalDistribution >> prettyPrint [
	^self displayString , ' (' , mu printNLString , ', ' , sigma printNLString
		, ')']

{ #category : #printing }
NormalDistribution >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		print: mu;
		nextPut: $,;
		print: sigma;
		nextPut: $)]

{ #category : #accessing }
NormalDistribution >> sigma [
	^sigma]

{ #category : #estimators }
NormalDistribution >> sigma: aNumber [
	self mean: mu deviation: aNumber]

{ #category : #estimators }
NormalDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	^0.0]

{ #category : #printing }
NormalDistribution >> storeString [
	^self class name , ' mean: ' , mu storeString , ' deviation: '
		, sigma storeString]

{ #category : #operations }
NormalDistribution >> translateBy: delta [
	self mean: self mean + delta deviation: self deviation]

{ #category : #truncation }
NormalDistribution >> truncatedClass [
	^TruncatedNormalDistribution]

{ #category : #accessing }
NormalDistribution >> uniform: aRandom [
	super uniform: aRandom.
	y := nil]

{ #category : #validation }
NormalDistribution >> validateDeviation: aFloat [
	^self runValidation: #validateNormalMean:deviation: with: mu with: aFloat]

{ #category : #validation }
NormalDistribution >> validateMean: aFloat [
	^self
		runValidation: #validateNormalMean:deviation:
		with: aFloat
		with: sigma]

{ #category : #estimators }
NormalDistribution >> variance [
	^sigma squared]

{ #category : #private }
NormalDistribution >> voutier: u [
	| v |
	(0.531406836446e-297 < u and: [u < 0.0456])
		ifTrue: [^self voutierLeftTail: u].
	v := 1.0 - u.
	(0.531406836446e-297 < v and: [v < 0.0456])
		ifTrue: [^(self voutierLeftTail: v) negated].
	^self voutierCentral: u]

{ #category : #private }
NormalDistribution >> voutierCentral: u [
	| a2 aPrime0 aPrime1 b0 b1 q r |
	a2 := 1.2468997606525.
	aPrime0 := 0.19574011526979.
	aPrime1 := -0.6528713583653.
	b0 := 0.15533108162317.
	b1 := -0.83929315812226.
	q := u - 0.5.
	r := q * q.
	^aPrime1 * r + aPrime0 / (r + b1 * r + b0) + a2 * q]

{ #category : #private }
NormalDistribution >> voutierLeftTail: u [
	| c3 cPrime0 cPrime1 cPrime2 d0 d1 r |
	c3 := -1.00018251873016.
	cPrime0 := 16.68232083072.
	cPrime1 := 4.12041152393912.
	cPrime2 := 0.0298141873082.
	d0 := 7.17378766392551.
	d1 := 8.75969350895863.
	r := (u ln * -2.0) sqrt.
	^cPrime1 * r + cPrime0 / (r + d1 * r + d0) + cPrime2 + (c3 * r)]

{ #category : #private }
NormalDistribution >> withPercentile: p ratio: rho mean: mean [
	| z1 sd q |
	z1 := NormalDistribution standard inverseDistribution: 1.0 - p.
	q := rho isInfinite
		ifTrue: [rho sign negated]
		ifFalse: [1.0 - rho / (1.0 + rho)].
	sd := mean / z1 * q.
	self mean: mean deviation: sd]

