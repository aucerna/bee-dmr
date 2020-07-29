"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DateDistribution,
	#superclass : #DiscreteProbabilityDistribution,
	#instVars : [
		'deviate',
		'startDate'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
DateDistribution class >> around: aDate [
	^self around: aDate baseClass: UniformDistribution
"
	DateDistribution around: Date today
"]

{ #category : #'instance creation' }
DateDistribution class >> around: aDate baseClass: distributionClass [
	| deviate |
	deviate := distributionClass between: 1 and: 60.
	deviate isDiscrete ifTrue: [
		deviate
			values: (deviate values collect: #asInteger)
			probabilities: deviate probabilities].
	^self on: deviate startDate: (aDate subtractDays: 31)]

{ #category : #constants }
DateDistribution class >> baseDate [
	^Date fromDays: 0]

{ #category : #'instance creation' }
DateDistribution class >> between: firstDate and: lastDate [
	"
	self between: Date today and: (Date today addDays: 10)
	"
	| validation |
	validation := self
		runValidation: #validateDateBetween:and:
		with: firstDate
		with: lastDate.
	^validation hasPassed ifTrue: [self new between: firstDate and: lastDate]]

{ #category : #testing }
DateDistribution class >> canSample: aCsrVariable [
	^aCsrVariable isDateValued]

{ #category : #'instance creation' }
DateDistribution class >> cumulativeProbabilities: probCollection
value: dateCollection
min: minDate
max: maxDate [
	| distribution startDate |
	startDate := minDate.
	distribution := ProbabilityDistribution
		cumulativeProbabilities: probCollection
		value: (dateCollection collect: [:d | d subtractDate: startDate])
		min: 0
		max: (maxDate subtractDate: startDate).
	^self on: distribution startDate: startDate]

{ #category : #'instance creation' }
DateDistribution class >> discreteProbabilities: probCollection values: dateCollection [
	| start values distribution |
	start := dateCollection first.
	values := dateCollection
		collect: [:d | d notNil ifTrue: [d subtractDate: start]].
	distribution := ProbabilityDistribution
		discreteProbabilities: probCollection
		values: values.
	^self on: distribution startDate: start]

{ #category : #examples }
DateDistribution class >> example [
	^self around: Date today]

{ #category : #'instance creation' }
DateDistribution class >> logNormalMean: muDate deviation: sigma [
	| distribution |
	distribution := LogNormalDistribution normalMean: 0 logDeviation: sigma.
	^self on: distribution startDate: muDate]

{ #category : #'instance creation' }
DateDistribution class >> normalMean: muDate deviation: sigma [
	| distribution startDate |
	startDate := muDate.
	distribution := NormalDistribution mean: 0 deviation: sigma.
	^self on: distribution startDate: startDate]

{ #category : #'instance creation' }
DateDistribution class >> on: deviate [
	^self new deviate: deviate startDate: Date baseDate]

{ #category : #'instance creation' }
DateDistribution class >> on: deviate startDate: aDate [
	| validation |
	validation := self
		runValidation: #validateDateOn:startDate:
		with: deviate
		with: aDate.
	^validation hasPassed ifTrue: [self new deviate: deviate startDate: aDate]]

{ #category : #examples }
DateDistribution class >> sampleInstance [
	^self between: Date today and: (Date today addDays: 10)]

{ #category : #'instance creation' }
DateDistribution class >> triangularLeft: aDate mid: bDate right: cDate [
	| distribution startDate |
	startDate := aDate.
	distribution := ProbabilityDistribution
		triangularLeft: 0.0
		mid: (bDate subtractDate: startDate)
		right: (cDate subtractDate: startDate).
	^self on: distribution startDate: startDate]

{ #category : #'instance creation' }
DateDistribution class >> truncatedLogNormalMean: muDate
deviation: sigma
min: minDate
max: maxDate [
	| logNormalDistribution startDate deviate validation |
	validation := self
		runValidation: #validateDateTruncatedLogNormalMean:deviation:min:max:
		withArguments: {muDate. sigma. minDate. maxDate}.
	validation hasPassed ifFalse: [^nil].
	logNormalDistribution := DateDistribution
		logNormalMean: muDate
		deviation: sigma.
	startDate := logNormalDistribution startDate.
	deviate := logNormalDistribution deviate
		truncateFrom: (minDate ifNotNil: [minDate subtractDate: startDate])
		to: (maxDate ifNotNil: [maxDate subtractDate: startDate]).
	^self on: deviate startDate: startDate]

{ #category : #'instance creation' }
DateDistribution class >> truncatedNormalMean: muDate
deviation: sigma
min: minDate
max: maxDate [
	| normalDistribution startDate deviate validation |
	validation := self
		runValidation: #validateDateTruncatedNormalMean:deviation:min:max:
		withArguments: {muDate. sigma. minDate. maxDate}.
	validation hasPassed ifFalse: [^nil].
	normalDistribution := DateDistribution normalMean: muDate deviation: sigma.
	startDate := normalDistribution startDate.
	deviate := normalDistribution deviate
		truncateFrom: (minDate ifNotNil: [minDate subtractDate: startDate])
		to: (maxDate ifNotNil: [maxDate subtractDate: startDate]).
	^self on: deviate startDate: startDate]

{ #category : #'instance creation' }
DateDistribution class >> uniformBetween: firstDate and: lastDate [
	| startDate deviate |
	startDate := firstDate.
	deviate := UniformDistribution
		between: 0.0
		and: (lastDate subtractDate: startDate).
	^self on: deviate startDate: startDate]

{ #category : #'instance creation' }
DateDistribution class >> withPercentile: p1
valued: date1
left: dateMin
right: dateMax
deviateClass: aClass [
	| delta x1 deviate |
	delta := dateMax subtractDate: dateMin.
	x1 := date1 subtractDate: dateMin.
	deviate := aClass
		withPercentile: p1
		valued: x1
		left: 0
		right: delta.
	^self on: deviate startDate: dateMin]

{ #category : #'instance creation' }
DateDistribution class >> withPercentiles: p1
valued: date1
and: p2
valued: date2
deviateClass: aClass [
	| x1 x2 deviate delta |
	delta := date2 subtractDate: date1.
	x1 := delta.
	x2 := delta * 2.0.
	deviate := aClass
		withPercentiles: p1
		valued: x1
		and: p2
		valued: x2.
	^self on: deviate startDate: (date1 subtractDays: delta)]

{ #category : #validation }
DateDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #dateValidation]

{ #category : #private }
DateDistribution >> between: firstDate and: lastDate [
	deviate := ProbabilityDistribution
		integerUniformBetween: 0
		and: (lastDate subtractDate: firstDate).
	deviate uniform: uniform.
	startDate := firstDate]

{ #category : #private }
DateDistribution >> dateFrom: aNumber [
	^startDate addDays: aNumber asInteger]

{ #category : #'probability functions' }
DateDistribution >> density: aDate [
	^deviate density: (self numberFrom: aDate)]

{ #category : #accessing }
DateDistribution >> deviate [
	^deviate]

{ #category : #private }
DateDistribution >> deviate: aProbabilityDistribution startDate: aDate [
	deviate := aProbabilityDistribution.
	uniform := deviate uniform.
	startDate := aDate]

{ #category : #'probability functions' }
DateDistribution >> distribution [
	^deviate distribution]

{ #category : #'probability functions' }
DateDistribution >> distribution: aDate [
	^deviate distribution: (self numberFrom: aDate)]

{ #category : #'probability functions' }
DateDistribution >> distributionLeft: aDate [
	^deviate distributionLeft: (self numberFrom: aDate)]

{ #category : #testing }
DateDistribution >> hasTable [
	^deviate hasTable]

{ #category : #'probability functions' }
DateDistribution >> inverseDistribution: u [
	^self dateFrom: (deviate inverseDistribution: u)]

{ #category : #inquiries }
DateDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isDate
		and: [deviate isConsistentWith: (self numberFrom: deterministicValue)]]

{ #category : #testing }
DateDistribution >> isDateDistribution [
	^true]

{ #category : #testing }
DateDistribution >> isDiscretized [
	^deviate isDiscretized]

{ #category : #testing }
DateDistribution >> isFinite [
	^deviate isBounded]

{ #category : #inquiries }
DateDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [deviate isLike: aProbabilityDistribution deviate]
		and: [startDate = aProbabilityDistribution startDate]]

{ #category : #testing }
DateDistribution >> isLogNormal [
	^deviate isLogNormal]

{ #category : #testing }
DateDistribution >> isNormal [
	^deviate isNormal]

{ #category : #testing }
DateDistribution >> isTriangular [
	^deviate isTriangular]

{ #category : #testing }
DateDistribution >> isTruncatedLogNormal [
	^deviate isTruncatedLogNormal]

{ #category : #testing }
DateDistribution >> isTruncatedNormal [
	^deviate isTruncatedNormal]

{ #category : #testing }
DateDistribution >> isUniform [
	^deviate isUniform]

{ #category : #estimators }
DateDistribution >> max [
	| maximum |
	^(maximum := deviate max) notNil ifTrue: [self dateFrom: maximum]]

{ #category : #estimators }
DateDistribution >> max: aDate [
	^deviate max: aDate - startDate]

{ #category : #estimators }
DateDistribution >> mean [
	| mean |
	^(mean := deviate mean) notNil ifTrue: [self dateFrom: mean]]

{ #category : #estimators }
DateDistribution >> mid [
	| mid |
	^(mid := deviate mid) notNil ifTrue: [self dateFrom: mid]]

{ #category : #estimators }
DateDistribution >> mid: aDate [
	^deviate mid: aDate - startDate]

{ #category : #estimators }
DateDistribution >> min [
	| minimum |
	^(minimum := deviate min) notNil ifTrue: [self dateFrom: minimum]]

{ #category : #estimators }
DateDistribution >> min: aDate [
	^deviate min: aDate - startDate]

{ #category : #estimators }
DateDistribution >> mode [
	^deviate mode ifNotNil: [:mode | self dateFrom: mode]]

{ #category : #estimators }
DateDistribution >> mu [
	| mu |
	^(mu := deviate mu) notNil ifTrue: [self dateFrom: mu]]

{ #category : #estimators }
DateDistribution >> mu: aDate [
	^deviate mu: aDate - startDate]

{ #category : #'random sampling' }
DateDistribution >> next [
	^self dateFrom: deviate next]

{ #category : #private }
DateDistribution >> numberFrom: aDate [
	^aDate subtractDate: startDate]

{ #category : #printing }
DateDistribution >> parameterArray [
	^deviate parameterArrayForDateDistribution: self]

{ #category : #printing }
DateDistribution >> parameterArrayInUnit: aUnit [
	self ASSERT: aUnit isDateUnit.
	^self parameterArray]

{ #category : #'probability functions' }
DateDistribution >> percentile: p [
	^self dateFrom: (deviate percentile: p)]

{ #category : #copying }
DateDistribution >> postCopy [
	super postCopy.
	deviate := deviate copy]

{ #category : #accessing }
DateDistribution >> probabilities [
	^deviate probabilities]

{ #category : #accessing }
DateDistribution >> probabilityAt: index ifAbsent: aBlock [
	^deviate probabilityAt: index ifAbsent: aBlock]

{ #category : #accessing }
DateDistribution >> probabilityAt: index put: aNumber [
	deviate probabilityAt: index put: aNumber]

{ #category : #accessing }
DateDistribution >> sd [
	^deviate sd]

{ #category : #estimators }
DateDistribution >> sigma [
	^deviate sigma]

{ #category : #estimators }
DateDistribution >> sigma: aNumber [
	^deviate sigma: aNumber]

{ #category : #accessing }
DateDistribution >> startDate [
	^startDate]

{ #category : #printing }
DateDistribution >> storeString [
	^self class name , ' on: (' , deviate storeString
		, ') startDate: (Date ddmmyyyy: '
		, startDate ddmmyyyy storeString
		, ')']

{ #category : #'gui support' }
DateDistribution >> table [
	^deviate table
		collect: [:array | {self dateFrom: array first. array second}]]

{ #category : #accessing }
DateDistribution >> totalDeviation [
	^deviate totalDeviation]

{ #category : #accessing }
DateDistribution >> totalMean [
	^self dateFrom: deviate totalMean]

{ #category : #operations }
DateDistribution >> translateBy: days [
	| date |
	date := self startDate addDays: days.
	self deviate: self deviate startDate: date]

{ #category : #accessing }
DateDistribution >> type [
	^deviate type]

{ #category : #accessing }
DateDistribution >> uniform: aRandom [
	uniform := aRandom.
	deviate uniform: aRandom]

{ #category : #testing }
DateDistribution >> usesPert [
	^deviate usesPert]

{ #category : #validation }
DateDistribution >> validateDeviation: aNumber [
	^deviate validateDeviation: aNumber]

{ #category : #validation }
DateDistribution >> validateMax: aNumber [
	^deviate validateMax: aNumber]

{ #category : #validation }
DateDistribution >> validateMean: aNumber [
	^deviate validateMean: aNumber]

{ #category : #validation }
DateDistribution >> validateMid: aNumber [
	^deviate validateMid: aNumber]

{ #category : #validation }
DateDistribution >> validateMin: aNumber [
	^deviate validateMin: aNumber]

{ #category : #validation }
DateDistribution >> validateProbability: aNumber at: index [
	^deviate validateProbability: aNumber at: index]

{ #category : #validation }
DateDistribution >> validateValue: aDate at: index [
	^deviate validateValue: aDate - startDate at: index]

{ #category : #accessing }
DateDistribution >> valueAt: index ifAbsent: aBlock [
	| value |
	^(value := deviate valueAt: index ifAbsent: aBlock) notNil
		ifTrue: [self dateFrom: value]]

{ #category : #accessing }
DateDistribution >> valueAt: index put: aDate [
	^deviate valueAt: index put: aDate - startDate]

{ #category : #accessing }
DateDistribution >> values [
	| minimum maximum days |
	days := (deviate isDiscrete or: [deviate isDiscretized])
		ifTrue: [deviate values]
		ifFalse: [
			(minimum := deviate min) isNil ifTrue: [^nil].
			(maximum := deviate max) isNil ifTrue: [^nil].
			minimum to: maximum].
	^days collect: [:d | self dateFrom: d]]

{ #category : #accessing }
DateDistribution >> valuesSize [
	^deviate valuesSize]

{ #category : #accessing }
DateDistribution >> variance [
	^deviate variance]

