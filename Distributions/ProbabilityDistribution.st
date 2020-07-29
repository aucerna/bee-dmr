"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProbabilityDistribution,
	#superclass : #Object,
	#instVars : [
		'uniform'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
ProbabilityDistribution class >> around: aNumber [
	^TriangularDistribution around: aNumber]

{ #category : #'instance creation' }
ProbabilityDistribution class >> around: value inRange: aRange [
	^self around: value]

{ #category : #'instance creation' }
ProbabilityDistribution class >> bernoulliWith: p [
	^BernoulliDistribution with: p]

{ #category : #'instance creation' }
ProbabilityDistribution class >> bernoulliWith: p uniform: uniform [
	^(self bernoulliWith: p) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> betaA: a b: b [
	^PertDistribution a: a b: b]

{ #category : #'instance creation' }
ProbabilityDistribution class >> betaA: a b: b uniform: uniform [
	| beta |
	beta := self betaA: a b: b.
	^beta notNil ifTrue: [beta uniform: uniform]]

{ #category : #'instance creation' }
ProbabilityDistribution class >> binomialEvents: n mean: m [
	^BinomialDistribution events: n mean: m]

{ #category : #'instance creation' }
ProbabilityDistribution class >> binomialEvents: n mean: m uniform: uniform [
	^(self binomialEvents: n mean: m) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> booleanWith: p uniform: uniform [
	| answer |
	answer := self bernoulliWith: p.
	answer notNil ifTrue: [
		answer
			uniform: uniform;
			success: true;
			failure: false].
	^answer]

{ #category : #'instance creation' }
ProbabilityDistribution class >> chiSquareDegree: deg [
	^ChiSquareDistribution degree: deg]

{ #category : #'instance creation' }
ProbabilityDistribution class >> chiSquareDegree: deg uniform: uniform [
	^(self chiSquareDegree: deg) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> classFor: aString [
	^self allSubclasses detect: [:c | c displayString = aString] ifNone: nil]

{ #category : #'instance creation' }
ProbabilityDistribution class >> cleanValues: values probabilities: probabilities [
	| n vStream pStream prevV prevP |
	(values isEmptyOrNil or: [probabilities isEmptyOrNil]) ifTrue: [^nil].
	n := values size.
	n = probabilities size ifFalse: [^nil].
	vStream := (Array new: n) writeStream.
	pStream := (Array new: n) writeStream.
	prevV := values first - (values first abs * 0.5) - 1.0.
	values with: probabilities do: [:v :p | 
		v < prevV ifTrue: [^nil].
		prevV < v
			ifTrue: [
				vStream nextPut: v.
				pStream nextPut: p]
			ifFalse: [p = prevP ifFalse: [^nil]].
		prevV := v.
		prevP := p].
	^{vStream contents. pStream contents}]

{ #category : #accessing }
ProbabilityDistribution class >> clipboardFormat [
	^self name]

{ #category : #'instance creation' }
ProbabilityDistribution class >> constant: value [
	^SampleSpace on: {value}]

{ #category : #'instance creation' }
ProbabilityDistribution class >> cumulativeProbabilities: probabilities
value: values
min: a
max: b [
	| validation addFirst answer |
	validation := self
		runValidation: #validateCumulativeProbabilities:value:min:max:
		withArguments: {probabilities. values. a. b}.
	validation hasPassed ifFalse: [^nil].
	addFirst := (values first ~ a) not.
	answer := DiscretizedDistribution
		distribution: (addFirst ifTrue: [#(0.0)] ifFalse: [#()]) , probabilities
			, #(1.0)
		values: (addFirst ifTrue: [{a}] ifFalse: [#()]) , values , {b}.
	^answer validate hasPassed ifTrue: [answer]]

{ #category : #'instance creation' }
ProbabilityDistribution class >> cumulativeProbabilities: probCollection
value: valCollection
min: a
max: b
uniform: uniform [
	| answer |
	answer := self
		cumulativeProbabilities: probCollection
		value: valCollection
		min: a
		max: b.
	^answer notNil ifTrue: [answer uniform: uniform]]

{ #category : #'instance creation' }
ProbabilityDistribution class >> dateUniformBetween: firstDate and: lastDate [
	^DateDistribution between: firstDate and: lastDate]

{ #category : #'instance creation' }
ProbabilityDistribution class >> dateUniformBetween: firstDate and: lastDate uniform: uniform [
	^(self dateUniformBetween: firstDate and: lastDate) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> discreteProbabilities: probCollection values: valCollection [
	^DiscreteDistribution values: valCollection probabilities: probCollection]

{ #category : #'instance creation' }
ProbabilityDistribution class >> discreteProbabilities: probCollection values: valCollection uniform: uniform [
	| answer |
	answer := self discreteProbabilities: probCollection values: valCollection.
	^answer notNil ifTrue: [answer uniform: uniform]]

{ #category : #'GUI support' }
ProbabilityDistribution class >> displayString [
	^(self name trimTail: 'Distribution') prettyPrint]

{ #category : #'instance creation' }
ProbabilityDistribution class >> exponentialMean: mu [
	^ExponentialDistribution mean: mu]

{ #category : #'instance creation' }
ProbabilityDistribution class >> exponentialMean: mu uniform: uniform [
	^(self exponentialMean: mu) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> fDistributionWith: a with: b [
	^FDistribution with: a with: b]

{ #category : #'instance creation' }
ProbabilityDistribution class >> fDistributionWith: a with: b uniform: uniform [
	^(self fDistributionWith: a with: b) uniform: uniform]

{ #category : #'GUI support' }
ProbabilityDistribution class >> fromClipboard [
	^Clipboard getObjectWithFormatNamed: self clipboardFormat]

{ #category : #'instance creation' }
ProbabilityDistribution class >> fromJson: aJsonObject [
	| class |
	class := self classFor: aJsonObject Type.
	^class notNil ifTrue: [class new fromJson: aJsonObject]]

{ #category : #'instance creation' }
ProbabilityDistribution class >> gammaOrder: k [
	^GammaDistribution order: k]

{ #category : #'instance creation' }
ProbabilityDistribution class >> gammaOrder: k uniform: uniform [
	^(self gammaOrder: k) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> geometricMean: mu [
	^GeometricDistribution mean: mu]

{ #category : #'instance creation' }
ProbabilityDistribution class >> geometricMean: mu uniform: uniform [
	^(self geometricMean: mu) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> integerUniformBetween: n and: m [
	^SampleSpace on: (n to: m)]

{ #category : #'instance creation' }
ProbabilityDistribution class >> integerUniformBetween: n and: m uniform: uniform [
	^(self integerUniformBetween: n and: m) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> logNormalMean: mu deviation: sigma [
	^LogNormalDistribution mean: mu deviation: sigma]

{ #category : #'instance creation' }
ProbabilityDistribution class >> logNormalMean: mu deviation: sigma uniform: uniform [
	| answer |
	answer := self logNormalMean: mu deviation: sigma.
	answer notNil ifTrue: [answer uniform: uniform].
	^answer]

{ #category : #accessing }
ProbabilityDistribution class >> modelName [
	^self displayString]

{ #category : #'instance creation' }
ProbabilityDistribution class >> new [
	^super new initialize]

{ #category : #'instance creation' }
ProbabilityDistribution class >> normalMean: mu deviation: sigma [
	^NormalDistribution mean: mu deviation: sigma]

{ #category : #'instance creation' }
ProbabilityDistribution class >> normalMean: mu deviation: sigma uniform: uniform [
	| answer |
	answer := self normalMean: mu deviation: sigma.
	answer notNil ifTrue: [answer uniform: uniform].
	^answer]

{ #category : #'instance creation' }
ProbabilityDistribution class >> pertMin: a max: b mode: c [
	^PertDistribution min: a max: b mode: c]

{ #category : #'instance creation' }
ProbabilityDistribution class >> pertMin: a
max: b
mode: m
uniform: uniform [
	| pert |
	pert := self pertMin: a max: b mode: m.
	pert notNil ifTrue: [pert uniform: uniform].
	^pert]

{ #category : #'instance creation' }
ProbabilityDistribution class >> poissonMean: mu [
	^PoissonDistribution mean: mu]

{ #category : #'instance creation' }
ProbabilityDistribution class >> poissonMean: mu uniform: uniform [
	^(self poissonMean: mu) uniform: uniform]

{ #category : #examples }
ProbabilityDistribution class >> sampleBooleanInstance [
	^BernoulliDistribution sampleInstance]

{ #category : #examples }
ProbabilityDistribution class >> sampleDateInstance [
	^DateDistribution sampleInstance]

{ #category : #examples }
ProbabilityDistribution class >> sampleInstance [
	^TriangularDistribution sampleInstance]

{ #category : #examples }
ProbabilityDistribution class >> sampleSize [
	^1000]

{ #category : #'instance creation' }
ProbabilityDistribution class >> tDistributionDegree: deg [
	^TDistribution degree: deg]

{ #category : #'instance creation' }
ProbabilityDistribution class >> tDistributionDegree: deg uniform: uniform [
	^(self tDistributionDegree: deg) uniform: uniform]

{ #category : #'instance creation' }
ProbabilityDistribution class >> triangularLeft: a mid: b right: c [
	^TriangularDistribution
		left: a
		mid: b
		right: c]

{ #category : #'instance creation' }
ProbabilityDistribution class >> triangularLeft: a
mid: b
right: c
uniform: uniform [
	| answer |
	answer := self triangularLeft: a mid: b right: c.
	answer notNil ifTrue: [answer uniform: uniform].
	^answer]

{ #category : #'instance creation' }
ProbabilityDistribution class >> truncatedLogNormalMean: mu deviation: sigma min: a max: b [
	^TruncatedLogNormalDistribution mean: mu deviation: sigma min: a max: b]

{ #category : #'instance creation' }
ProbabilityDistribution class >> truncatedLogNormalMean: mu
deviation: sigma
min: a
max: b
uniform: uniform [
	| answer |
	answer := self
		truncatedLogNormalMean: mu
		deviation: sigma
		min: a
		max: b.
	answer notNil ifTrue: [answer uniform: uniform].
	^answer]

{ #category : #'instance creation' }
ProbabilityDistribution class >> truncatedNormalMean: mu
deviation: sigma
min: a
max: b [
	^TruncatedNormalDistribution
		mean: mu
		deviation: sigma
		min: a
		max: b]

{ #category : #'instance creation' }
ProbabilityDistribution class >> truncatedNormalMean: mu
deviation: sigma
min: a
max: b
uniform: uniform [
	| answer |
	answer := self
		truncatedNormalMean: mu
		deviation: sigma
		min: a
		max: b.
	answer notNil ifTrue: [answer uniform: uniform].
	^answer]

{ #category : #'instance creation' }
ProbabilityDistribution class >> uniformBetween: a and: b [
	^UniformDistribution from: a to: b]

{ #category : #'instance creation' }
ProbabilityDistribution class >> uniformBetween: a and: b uniform: uniform [
	| answer |
	answer := self uniformBetween: a and: b.
	answer notNil ifTrue: [answer uniform: uniform].
	^answer]

{ #category : #validation }
ProbabilityDistribution class >> validatorClass [
	^ProbabilityDistributionValidator]

{ #category : #converting }
ProbabilityDistribution >> asJson [
	| json estimator |
	json := JsonObject new.
	json
		at: 'Type' put: self type displayString;
		at: 'Description' put: self explain;
		at: 'Finite' put: self isFinite.
	#(#min #max #mean #sd #variance #skewness #kurtosis)
		select: [:s | 
			(self respondsTo: s) and: [
				estimator := self perform: s.
				estimator notNil]]
		thenDo: [:s | | feature |
			feature := s == #sd ifTrue: ['SD'] ifFalse: [s asString asProperNoun].
			json at: feature put: estimator].
	^json]

{ #category : #testing }
ProbabilityDistribution >> atEnd [
	^false]

{ #category : #accessing }
ProbabilityDistribution >> basicDistribution [
	^self]

{ #category : #'probability functions' }
ProbabilityDistribution >> density: x [
	^self subclassResponsibility]

{ #category : #accessing }
ProbabilityDistribution >> deviate [
	^self]

{ #category : #estimators }
ProbabilityDistribution >> deviation [
	^self sd]

{ #category : #printing }
ProbabilityDistribution >> displayString [
	^self type displayString]

{ #category : #'probability functions' }
ProbabilityDistribution >> distribution: x [
	^self subclassResponsibility]

{ #category : #'probability functions' }
ProbabilityDistribution >> distribution: x reversed: aBoolean [
	^aBoolean
		ifTrue: [self reverseDistribution: x]
		ifFalse: [self distribution: x]]

{ #category : #'probability functions' }
ProbabilityDistribution >> distributionLeft: x [
	"
	P(X < x)
	"
	^self distribution: x]

{ #category : #printing }
ProbabilityDistribution >> explain [
	^'']

{ #category : #'file in/out' }
ProbabilityDistribution >> fileInActivate [
	"
	nothing by default
	"
	]

{ #category : #testing }
ProbabilityDistribution >> hasTable [
	^false]

{ #category : #initialization }
ProbabilityDistribution >> initialize [
	uniform := Random current]

{ #category : #'probability functions' }
ProbabilityDistribution >> inverseDistribution: u [
	^self subclassResponsibility]

{ #category : #testing }
ProbabilityDistribution >> isBernoulli [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isBernoulliDistribution [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isBounded [
	^self max notNil and: [self min notNil]]

{ #category : #inquiries }
ProbabilityDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber
		and: [self isConsistentWithMean: deterministicValue]]

{ #category : #inquiries }
ProbabilityDistribution >> isConsistentWithBounds: deterministicValue [
	self min ifNotNil: [:m | m <= deterministicValue ifFalse: [^false]].
	self max ifNotNil: [:m | ^deterministicValue <= m].
	^true]

{ #category : #inquiries }
ProbabilityDistribution >> isConsistentWithMean: deterministicValue [
	"
	Knuth V1 1.2.10: p(|X - mu| < (r*sd)) < r reciprocal squared
	"
	| r mu sd |
	r := 4.
	mu := self mean.
	sd := self sd.
	^deterministicValue between: mu - (r * sd) and: mu + (r * sd)]

{ #category : #testing }
ProbabilityDistribution >> isConstant [
	^self sd = 0.0]

{ #category : #testing }
ProbabilityDistribution >> isDateDistribution [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isDiscrete [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isDiscretized [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isFinite [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isIntegerDistribution [
	^false]

{ #category : #inquiries }
ProbabilityDistribution >> isLike: aProbabilityDistribution [
	^self class == aProbabilityDistribution class]

{ #category : #testing }
ProbabilityDistribution >> isLogNormal [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isNormal [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isStringDistribution [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isTriangular [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isTruncatedLogNormal [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isTruncatedNormal [
	^false]

{ #category : #testing }
ProbabilityDistribution >> isUniform [
	^false]

{ #category : #'random sampling' }
ProbabilityDistribution >> latinHypercubeSample: iterations [
	| increment sample unused index b a next |
	increment := 1.0 / iterations.
	sample := OrderedCollection new: iterations.
	unused := (1 to: iterations) asOrderedCollection.
	iterations timesRepeat: [
		index := unused removeAtRandom: uniform.
		b := increment * index.
		a := b - increment.
		next := self inverseDistribution: (uniform between: a and: b).
		sample add: next].
	^sample]

{ #category : #accessing }
ProbabilityDistribution >> max [
	^nil]

{ #category : #estimators }
ProbabilityDistribution >> median [
	^self percentile: 0.5]

{ #category : #accessing }
ProbabilityDistribution >> mid [
	^nil]

{ #category : #accessing }
ProbabilityDistribution >> min [
	^nil]

{ #category : #estimators }
ProbabilityDistribution >> mode [
	^nil]

{ #category : #accessing }
ProbabilityDistribution >> modelName [
	^self class modelName]

{ #category : #'random sampling' }
ProbabilityDistribution >> next [
	^self inverseDistribution: uniform next]

{ #category : #estimators }
ProbabilityDistribution >> p50 [
	^self percentile: 0.5]

{ #category : #printing }
ProbabilityDistribution >> parameterArray [
	^self subclassResponsibility]

{ #category : #printing }
ProbabilityDistribution >> parameterArrayForDateDistribution: aDateDistribution [
	^self parameterArray collect: [:v | aDateDistribution dateFrom: v]]

{ #category : #printing }
ProbabilityDistribution >> parameterArrayInUnit: unit [
	^self parameterArray collect: [:value | unit convert: value]]

{ #category : #'probability functions' }
ProbabilityDistribution >> percentile: p [
	^self inverseDistribution: p]

{ #category : #estimators }
ProbabilityDistribution >> percentiles: anInteger [
	| interval |
	anInteger = 0 ifTrue: [^#()].
	interval := 0 to: 1 by: 1.0 / anInteger.
	^interval collect: [:p | self percentile: p] thenSelect: #notNil]

{ #category : #copying }
ProbabilityDistribution >> postCopy [
	"default is do nothing"]

{ #category : #printing }
ProbabilityDistribution >> prettyPrint [
	^self asString]

{ #category : #printing }
ProbabilityDistribution >> printOn: aStream [
	aStream nextPutAll: self storeString]

{ #category : #'changes support' }
ProbabilityDistribution >> pvrStoreString [
	^'(' , self storeString , ')']

{ #category : #'probability functions' }
ProbabilityDistribution >> quantile: p [
	^self inverseDistribution: p]

{ #category : #'probability functions' }
ProbabilityDistribution >> reverseDistribution: x [
	| p |
	p := self distribution: x.
	^1 - p]

{ #category : #'random sampling' }
ProbabilityDistribution >> sample: n [
	^Array
		streamContents: [:stream | n timesRepeat: [stream nextPut: self next]]]

{ #category : #estimators }
ProbabilityDistribution >> sd [
	^self variance sqrt]

{ #category : #'random sampling' }
ProbabilityDistribution >> statistics: n [
	^SampleStatistic on: (self sample: n)]

{ #category : #printing }
ProbabilityDistribution >> storeString [
	^self subclassResponsibility]

{ #category : #accessing }
ProbabilityDistribution >> totalDeviation [
	^self deviation]

{ #category : #accessing }
ProbabilityDistribution >> totalMean [
	^self mean]

{ #category : #operations }
ProbabilityDistribution >> translateBy: delta [
	self subclassResponsibility]

{ #category : #truncation }
ProbabilityDistribution >> truncatedClass [
	^TruncatedDistribution]

{ #category : #truncation }
ProbabilityDistribution >> truncateFrom: xL to: xR [
	| validation |
	(xL isNil and: [xR isNil]) ifTrue: [^self].
	validation := self
		runValidation: #validateTruncationFrom:to:
		with: xL
		with: xR.
	^validation hasPassed
		ifTrue: [self truncatedClass with: self between: xL and: xR]]

{ #category : #accessing }
ProbabilityDistribution >> type [
	^self class]

{ #category : #accessing }
ProbabilityDistribution >> uniform [
	^uniform]

{ #category : #accessing }
ProbabilityDistribution >> uniform: aRandom [
	uniform := aRandom]

{ #category : #testing }
ProbabilityDistribution >> usesPert [
	^false]

{ #category : #validation }
ProbabilityDistribution >> validate: parameters [
	^self class validate: parameters]

{ #category : #accessing }
ProbabilityDistribution >> valuesSize [
	^self values size]

{ #category : #'backward compatibility' }
ProbabilityDistribution >> variablesDo: aBlock [
	"
	Do nothing, just support until we do migration
	"
	]

{ #category : #estimators }
ProbabilityDistribution >> variationCoefficient [
	^self mean / self sd]

