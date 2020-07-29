"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProbabilityDistributionValidator,
	#superclass : #DomainValidator,
	#category : #Distributions
}

{ #category : #root }
ProbabilityDistributionValidator >> bernoulliValidation [
	self aspect: #p; valueIsDefined; valueIsInRange: Range forProbability.
	self aspect: #failure; valueIsDefined.
	self aspect: #success; valueIsDefined]

{ #category : #root }
ProbabilityDistributionValidator >> betaValidation [
	self validateBetaA: object a b: object b.
	object usesPert ifFalse: [^self].
	self
		validatePertMin: object min
		max: object max
		mode: object mode
		lambda: object lambda]

{ #category : #root }
ProbabilityDistributionValidator >> binomialValidation [
	| n |
	self aspect: #N; valueIsDefined.
	n := self value.
	n isInteger
		ifFalse: [self failBecause: self prettyPrint , ' must be an integer']]

{ #category : #root }
ProbabilityDistributionValidator >> chiSquareValidation [
	self aspect: #gamma; valueValidate; valueHasSameUniform]

{ #category : #root }
ProbabilityDistributionValidator >> dateValidation [
	self aspect: #startDate; valueIsKindOf: Date.
	self aspect: #deviate; valueValidate; valueHasSameUniform.
	self value isDateDistribution
		ifTrue: [self
			failBecause: self prettyPrint , ' is also a Date Distribution']]

{ #category : #root }
ProbabilityDistributionValidator >> discreteValidation [
	| values probabilities |
	self
		aspect: #values;
		valuesAreDefined;
		valueIsNotEmpty;
		valuesAreIncreasing.
	values := self value.
	self
		aspect: #probabilities;
		valueIsDefined;
		valueIsNotEmpty;
		valuesAreInRange: Range forProbability;
		valuesSumIs1.
	probabilities := self value.
	values size = probabilities size ifFalse: [
		self
			failBecause: self prettyPrint , ' must have ' , values size printNLString
				, ' elements'].
	self aspect: #faultSize; valueIsDefined.
	self value = probabilities size ifFalse: [
		self
			aspect: #size;
			failBecause: self prettyPrint , ' must equal '
				, probabilities size asFloat printString]]

{ #category : #root }
ProbabilityDistributionValidator >> discretizedValidation [
	| density distribution values n |
	self aspect: #density; valueIsDefined; valueIsNotEmpty.
	density := self value.
	self
		aspect: #distribution;
		valueIsDefined;
		valueIsNotEmpty;
		valuesAreNotDecreasing;
		valuesAreInRange: Range forProbability.
	distribution := self value.
	self aspect: #cumulativeProbabilities.
	distribution first ~ 0.0
		ifFalse: [self failBecause: self prettyPrint , ' must start with 0.0'].
	(distribution last - 1.0) abs < self tolerance
		ifFalse: [self failBecause: self prettyPrint , ' must end with 1.0'].
	self
		aspect: #values;
		valuesAreDefined;
		valueIsNotEmpty;
		valuesAreDifferent;
		valuesAreIncreasing.
	values := self value.
	n := values size.
	n > 1 ifFalse: [
		self
			aspect: #table;
			failBecause: self prettyPrint , ' must have more than one row'].
	density size = n ifFalse: [
		self
			aspect: #density;
			failBecause: self prettyPrint , ' must have ' , n printNLString
				, ' elements'].
	distribution size = n ifFalse: [
		self
			aspect: #distribution;
			failBecause: self prettyPrint , ' must have ' , n printNLString
				, ' elements'].
	self validateDensity: density on: values.
	self aspect: #intervalSelector; valueIsDefined]

{ #category : #root }
ProbabilityDistributionValidator >> exponentialValidation [
	self aspect: #parameter; valueIsDefined; valueIsPositive]

{ #category : #root }
ProbabilityDistributionValidator >> fValidation [
	self aspect: #beta; valueValidate; valueHasSameUniform.
	self aspect: #nu; valueIsDefined]

{ #category : #root }
ProbabilityDistributionValidator >> gammaValidation [
	| order |
	self
		aspect: #order;
		valueIsDefined;
		valueIsInRange: (Range open: 1.0 open: nil).
	order := self value.
	self disableCode: [
		self aspect: #K; valueIsDefined.
		self value = (order - 1.0)
			ifFalse: [self
				failBecause: self prettyPrint , ' must equal the order - 1.0'].
		self aspect: #sqrt; valueIsDefined.
		self value = (2.0 * order - 1.0) sqrt ifFalse: [
			self
				failBecause: self prettyPrint
					, ' must be the square root of (2*order - 1)']]]

{ #category : #root }
ProbabilityDistributionValidator >> linkedValidation [
	self aspect: #deviate; valueValidate; valueHasSameUniform.
	self aspect: #excelVar; valueValidate]

{ #category : #root }
ProbabilityDistributionValidator >> logNormalValidation [
	| mean normal m2 s2 mu stdev |
	self aspect: #mean; valueIsDefined; valueIsPositive.
	mean := self value.
	self aspect: #sigma; valueIsDefined; valueIsPositive.
	self value <= Float maxValue sqrt ifFalse: [
		self
			failBecause: self prettyPrint , ' must be under '
				, Float maxValue sqrt printNLString].
	m2 := mean squared.
	s2 := object variance.
	mu := (m2 / (m2 + s2) sqrt) ln.
	stdev := (m2 + s2 / m2) ln sqrt.
	stdev ~ 0.0 ifTrue: [
		self
			aspect: nil;
			failBecause: self prettyPrint
				, ' has incompatible values of mean and standard deviation'].
	self aspect: #normal; valueValidate; valueHasSameUniform.
	normal := self value.
	(mu ~ normal mean and: [stdev ~ normal sigma]) ifFalse: [
		self
			failBecause: self prettyPrint , ' should have mean ' , mu printNLString
				, ' and standard deviation '
				, stdev printNLString].
	(object quantile: self lowerQuantile) < (object
		quantile: self upperQuantile)
		ifFalse: [
			self
				aspect: nil;
				failBecause: self prettyPrint , ' has none possible value with mean '
					, object mu printNLString
					, ' and deviation '
					, object sigma printNLString]]

{ #category : #accessing }
ProbabilityDistributionValidator >> lowerQuantile [
	^0.001]

{ #category : #root }
ProbabilityDistributionValidator >> normalValidation [
	| sigma msg |
	self aspect: #mean; valueIsDefined.
	self aspect: #sigma; valueIsDefined; valueIsPositive.
	sigma := self value.
	self aspect: #alpha; valueIsDefined.
	self value = (-0.5 / sigma squared) ifFalse: [
		msg := self prettyPrint.
		msg
			append: ' must be -0.5/(sigma';
			super: '2';
			append: ')'.
		self failBecause: msg].
	self aspect: #beta; valueIsDefined.
	self value ~ (1.0 / sigma / (Number pi * 2.0) sqrt) ifFalse: [
		self
			failBecause: self prettyPrint
				, ' must be the reciprocal of sigma * SQRT(Pi * 2)']]

{ #category : #root }
ProbabilityDistributionValidator >> poissonValidation [
	| mu |
	self aspect: #mean; valueIsDefined.
	mu := self value.
	self aspect: #exp; valueIsDefined.
	self value = mu negated exp
		ifFalse: [self failBecause: self prettyPrint , ' must be EXP(-mean)']]

{ #category : #root }
ProbabilityDistributionValidator >> portfolioValidation [
	self aspect: #active.
	self value notNil ifTrue: [self valueIsBoolean].
	self aspect: #interest; valueIsDefined.
	self aspect: #p; valueIsDefined; valueIsInRange: Range forProbability]

{ #category : #private }
ProbabilityDistributionValidator >> prettyPrintFor: aString [
	^aString isNil
		ifTrue: ['Distribution']
		ifFalse: ['Distribution ' , aString]]

{ #category : #root }
ProbabilityDistributionValidator >> sampleSpaceValidation [
	self aspect: #data; valueIsDefined.
	self aspect: #table; valueIsDefined.]

{ #category : #root }
ProbabilityDistributionValidator >> stringValidation [
	self stringValuesValidation.
	self aspect: #deviate; valueValidate; valueHasSameUniform]

{ #category : #root }
ProbabilityDistributionValidator >> stringValuesValidation [
	self aspect: #values; valuesAreKindOf: String; valuesAreDifferent]

{ #category : #accessing }
ProbabilityDistributionValidator >> tolerance [
	^0.009]

{ #category : #root }
ProbabilityDistributionValidator >> triangularValidation [
	| a c b |
	self aspect: #min; valueIsDefined.
	a := self value.
	self aspect: #mid; valueIsDefined.
	c := self value.
	a < c
		ifFalse: [self
			failBecause: self prettyPrint , ' must be greater than minimum value'].
	self aspect: #max; valueIsDefined.
	b := self value.
	c < b
		ifFalse: [self
			failBecause: self prettyPrint , ' must be greater than mid value'].
	self aspect: #h.
	self value = (c - a / (b - a)) ifFalse: [
		self
			failBecause: self prettyPrint
				, ' must be the quotient of mid - min divided by max - min']]

{ #category : #root }
ProbabilityDistributionValidator >> truncatedLogNormalValidation [
	]

{ #category : #root }
ProbabilityDistributionValidator >> truncatedNormalValidation [
	]

{ #category : #root }
ProbabilityDistributionValidator >> truncatedValidation [
	| deviate min max |
	self aspect: #deviate; valueValidate; valueHasSameUniform.
	deviate := self value.
	self aspect: #min.
	min := self value.
	self aspect: #max.
	max := self value.
	self aspect: #a; valueIsDefined; valueIsInRange: Range forProbability.
	min isNil
		ifTrue: [
			self value = 0.0
				ifFalse: [self failBecause: self prettyPrint , ' must be 0.0']]
		ifFalse: [
			self value = (deviate distributionLeft: min) ifFalse: [
				self
					failBecause: self prettyPrint
						, ' must be the value of the distribution to the left of minimum value']].
	self aspect: #b; valueIsDefined; valueIsInRange: Range forProbability.
	max isNil
		ifTrue: [
			self value = 1.0
				ifFalse: [self failBecause: self prettyPrint , ' must be 1.0']]
		ifFalse: [
			self value = (deviate distribution: max) ifFalse: [
				self
					failBecause: self prettyPrint
						, ' must be the value of the distribution at maximum value']]]

{ #category : #root }
ProbabilityDistributionValidator >> tValidation [
	| normal chi |
	self
		aspect: #nu;
		valueIsDefined;
		valueIsInRange: (Range open: 1.0 open: nil).
	self aspect: #normal; valueValidate; valueHasSameUniform.
	normal := self value.
	(normal mean = 0.0 and: [normal deviation = 1.0]) ifFalse: [
		self
			failBecause: self prettyPrint
				, ' must have mean 0.0 and standard deviation 1.0'].
	self aspect: #chiSquare; valueValidate; valueHasSameUniform.
	chi := self value.
	chi degree ~ object degree
		ifFalse: [self
			failBecause: self prettyPrint , ' must have the same degree']]

{ #category : #root }
ProbabilityDistributionValidator >> uniformValidation [
	| min max |
	self aspect: #min; valueValidate.
	min := self value.
	self aspect: #max; valueValidate.
	max := self value.
	min < max
		ifFalse: [self
			failBecause: self prettyPrint , ' must be greater than minimum value']]

{ #category : #accessing }
ProbabilityDistributionValidator >> upperQuantile [
	^0.999]

{ #category : #all }
ProbabilityDistributionValidator >> validate [
	self aspect: #uniform; valueIsDefined]

{ #category : #services }
ProbabilityDistributionValidator >> validateBernoulliParameter: aNumber [
	self
		aspect: #probabilityOfSuccess;
		isNumber: aNumber;
		is: aNumber inRange: Range forProbability]

{ #category : #services }
ProbabilityDistributionValidator >> validateBetaA: a b: b [
	self aspect: #a; isPositive: a.
	self aspect: #b; isPositive: b]

{ #category : #services }
ProbabilityDistributionValidator >> validateBetaWith: a with: b [
	self validateGammaOrder: a; validateGammaOrder: b]

{ #category : #services }
ProbabilityDistributionValidator >> validateBinomialEvents: n mean: m [
	self
		aspect: #events;
		isNumber: n;
		isPositive: n.
	self aspect: #mean; isNumber: m.
	m <= n
		ifFalse: [self
			failBecause: self prettyPrint , ' cannot be greater than total events']]

{ #category : #services }
ProbabilityDistributionValidator >> validateChiSquareDegree: aNumber [
	self validateGammaOrder: aNumber / 2]

{ #category : #services }
ProbabilityDistributionValidator >> validateCumulativeProbabilities: probabilities
value: values
min: a
max: b [
	self aspect: #values; isNotEmpty: values.
	values size > 1 ifFalse: [
		self
			aspect: #table;
			failBecause: self prettyPrint , ' must have more than one row']]

{ #category : #services }
ProbabilityDistributionValidator >> validateDateBetween: firstDate and: lastDate [
	self aspect: #firstDate; isDate: firstDate.
	self aspect: #lastDate; isDate: lastDate.
	firstDate <= lastDate
		ifFalse: [self
			failBecause: self prettyPrint , ' should be after first date']]

{ #category : #services }
ProbabilityDistributionValidator >> validateDateOn: distribution startDate: date [
	self aspect: #startDate; isDate: date.
	self aspect: #distribution; isDefined: distribution.
	self includeValidationOf: distribution]

{ #category : #services }
ProbabilityDistributionValidator >> validateDateTruncatedLogNormalMean: muDate
deviation: sigma
min: minDate
max: maxDate [
	| logNormalDistribution startDate left right deviate |
	self validateLogNormalNormalMean: 0 logDeviation: sigma.
	logNormalDistribution := DateDistribution
		logNormalMean: muDate
		deviation: sigma.
	self includeValidationOf: logNormalDistribution.
	startDate := logNormalDistribution startDate.
	left := minDate ifNotNil: [minDate subtractDate: startDate].
	right := maxDate ifNotNil: [maxDate subtractDate: startDate].
	self validateTruncationFrom: left to: right.
	deviate := logNormalDistribution deviate truncateFrom: left to: right.
	self includeValidationOf: deviate]

{ #category : #services }
ProbabilityDistributionValidator >> validateDateTruncatedNormalMean: muDate
deviation: sigma
min: minDate
max: maxDate [
	| startDate left right deviate normalDistribution |
	self validateNormalMean: 0 deviation: sigma.
	normalDistribution := DateDistribution normalMean: muDate deviation: sigma.
	self includeValidationOf: normalDistribution.
	startDate := normalDistribution startDate.
	left := minDate ifNotNil: [minDate subtractDate: startDate].
	right := maxDate ifNotNil: [maxDate subtractDate: startDate].
	self validateTruncationFrom: left to: right.
	deviate := normalDistribution deviate truncateFrom: left to: right.
	self includeValidationOf: deviate]

{ #category : #services }
ProbabilityDistributionValidator >> validateDensity: density on: values [
	| sum |
	self aspect: #density.
	sum := 0.0.
	2 to: density size do: [:i | | delta |
		delta := (values at: i) - (values at: i - 1).
		sum := delta * (density at: i - 1) + sum].
	(sum - 1.0) abs < self tolerance
		ifFalse: [self
			failBecause: self prettyPrint , ' function must have an area of 1.0']]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscreteBetween: n and: m steps: steps [
	m >= n ifFalse: [
		self
			aspect: #rangeValues;
			failBecause: self prettyPrint , ' are not consistent']]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscreteDistribution: probabilities on: values [
	self
		validateDiscreteDistribution: probabilities
		on: values
		checkingValuesOrder: true]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscreteDistribution: probabilities on: values checkingValuesOrder: aBoolean [
	self
		aspect: #values;
		isDefined: values;
		isNotEmpty: values.
	aBoolean ifTrue: [self areNonDecreasing: values].
	self
		aspect: #probabilities;
		isDefined: probabilities;
		isNotEmpty: probabilities;
		are: probabilities inRange: Range forProbability.
	probabilities size = values size ifFalse: [
		self
			failBecause: self prettyPrint , ' must have ' , values size printNLString
				, ' elements'].
	(probabilities sum - 1.0) abs < self tolerance
		ifFalse: [self failBecause: self prettyPrint , ' must sum 1.0']]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscreteProbability: aNumber at: index [
	| probabilities sum |
	self
		aspect: #probabilities;
		valueIsDefined;
		valueIsNotEmpty;
		valuesAreInRange: Range forProbability.
	probabilities := self value.
	self
		aspect: #index;
		is: index between: 1 and: probabilities size.
	self
		aspect: #probability;
		is: aNumber inRange: Range forProbability.
	sum := probabilities sum + aNumber - (probabilities at: index).
	self is: sum equalTo: 1.0]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscreteValue: aNumber at: index [
	^self validateDiscretizedValue: aNumber at: index]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscreteValues: values probabilities: probabilities [
	self
		validateDiscreteValues: values
		probabilities: probabilities
		checkingValuesOrder: true]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscreteValues: values probabilities: probabilities checkingValuesOrder: aBoolean [
	| array |
	self
		validateDiscreteDistribution: probabilities
		on: values
		checkingValuesOrder: aBoolean.
	array := DiscreteDistribution
		cleanValues: values
		probabilities: probabilities.
	array isNil ifTrue: [
		self
			failBecause: self prettyPrint
				, ' values and probabilities are incompatible'].
	self
		validateDiscreteDistribution: array last
		on: array first
		checkingValuesOrder: aBoolean.
	aBoolean ifTrue: [self aspect: #values; areIncreasing: array first]]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscretizedBetween: n and: m steps: steps [
	m - n / steps > 0 ifFalse: [
		self
			aspect: #rangeValues;
			failBecause: self prettyPrint , ' are not consistent']]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscretizedDensity: pdfCollection values: values [
	| array |
	self validateDiscretizedValues: values probabilities: pdfCollection.
	array := DiscretizedDistribution
		cleanValues: values
		probabilities: pdfCollection.
	self validateDensity: array last on: array first]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscretizedDistribution: pdfCollection values: values [
	| array |
	self validateDiscretizedValues: values probabilities: pdfCollection.
	array := DiscretizedDistribution
		cleanValues: values
		probabilities: pdfCollection.
	self validateDistribution: array last on: array first]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscretizedProbability: aNumber at: index [
	| probabilities |
	self
		aspect: #distribution;
		valueIsDefined;
		valueIsNotEmpty;
		valuesAreInRange: Range forProbability.
	probabilities := self value.
	self
		aspect: #index;
		is: index between: 1 and: probabilities size.
	self aspect: #probability; isDefined: aNumber.
	self is: aNumber inRange: Range forProbability.
	index = 1 ifTrue: [self is: aNumber equalTo: 0.0].
	index = probabilities size ifTrue: [self is: aNumber equalTo: 1.0].
	self
		is: aNumber
		between: (probabilities at: index - 1)
		and: (probabilities at: index + 1)]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscretizedValue: aNumber at: index [
	| values |
	self aspect: #values; valuesAreDefined; valueIsNotEmpty.
	values := self value.
	self
		aspect: #index;
		is: index between: 1 and: values size.
	values size = 1 ifTrue: [^self].
	self aspect: #xValue; isDefined: aNumber.
	index = 1 ifTrue: [
		aNumber < (values at: 2)
			ifFalse: [self
				failBecause: self prettyPrint , ' must honor values ascending order']].
	index = values size ifTrue: [
		aNumber > (values at: values size - 1)
			ifFalse: [self
				failBecause: self prettyPrint , ' must honor values ascending order']].
	self is: aNumber between: (values at: index - 1) and: (values at: index + 1)]

{ #category : #services }
ProbabilityDistributionValidator >> validateDiscretizedValues: values probabilities: probabilities [
	| n prevV prevP |
	self
		aspect: #values;
		isNotEmpty: values;
		areDefined: values;
		areNonDecreasing: values.
	self
		aspect: #probabilities;
		isNotEmpty: probabilities;
		are: probabilities inRange: Range forProbability.
	n := values size.
	probabilities size = n ifFalse: [
		self
			failBecause: self prettyPrint , ' must have ' , n printNLString
				, ' elements, like values'].
	values with: probabilities do: [:v :p | 
		(v = prevV andNot: [p = prevP]) ifTrue: [
			self
				aspect: nil;
				failBecause: self prettyPrint
					, ' has different probabilities for the same value'].
		prevV := v.
		prevP := p]]

{ #category : #services }
ProbabilityDistributionValidator >> validateDistribution: probabilities on: values [
	self
		aspect: #values;
		isDefined: values;
		isNotEmpty: values;
		areNonDecreasing: values.
	self
		aspect: #probabilities;
		isDefined: probabilities;
		isNotEmpty: probabilities;
		areNonDecreasing: probabilities;
		are: probabilities inRange: Range forProbability.
	probabilities size = values size ifFalse: [
		self
			failBecause: self prettyPrint , ' must have ' , values size printNLString
				, ' elements'].
	probabilities first ~ 0.0
		ifFalse: [self failBecause: self prettyPrint , ' must start with 0.0'].
	(probabilities last - 1.0) abs < self tolerance
		ifFalse: [self failBecause: self prettyPrint , ' must end with 1.0']]

{ #category : #services }
ProbabilityDistributionValidator >> validateExponentialParameter: aNumber [
	self aspect: #mean; isPositive: aNumber]

{ #category : #services }
ProbabilityDistributionValidator >> validateFWith: a with: b [
	| a2 b2 |
	a2 := a notNil ifTrue: [a / 2].
	b2 := a notNil ifTrue: [b / 2].
	self validateBetaWith: a2 with: b2]

{ #category : #services }
ProbabilityDistributionValidator >> validateGammaOrder: aNumber [
	self aspect: #order.
	self isNumber: aNumber.
	aNumber > 1.0
		ifFalse: [self failBecause: self prettyPrint , ' must be greater than 1.0']]

{ #category : #services }
ProbabilityDistributionValidator >> validateGammaShape: aNumber [
	self validateGammaOrder: aNumber]

{ #category : #services }
ProbabilityDistributionValidator >> validateGeometricMean: aNumber [
	self aspect: #mean; isPositive: aNumber]

{ #category : #services }
ProbabilityDistributionValidator >> validateLinkedOn: aProbabilityDistribution [
	self aspect: #distribution; includeValidationOf: aProbabilityDistribution]

{ #category : #services }
ProbabilityDistributionValidator >> validateLinkedOn: aProbabilityDistribution with: anExcelLink [
	self validateLinkedOn: aProbabilityDistribution.
	self aspect: #excelLink; includeValidationOf: anExcelLink]

{ #category : #services }
ProbabilityDistributionValidator >> validateLogNormalMean: mu deviation: sigma [
	| instance |
	self aspect: #mean; isPositive: mu.
	instance := LogNormalDistribution new mean: mu deviation: sigma.
	self includeValidationOf: instance]

{ #category : #services }
ProbabilityDistributionValidator >> validateLogNormalNormalMean: mu deviation: sigma [
	| instance |
	self aspect: #sd; isPositive: sigma.
	sigma squared <= Float maxValue ln ifFalse: [
		self
			failBecause: self prettyPrint , ' must be under '
				, Float maxValue ln sqrt printNLString].
	instance := LogNormalDistribution new normalMean: mu deviation: sigma.
	self includeValidationOf: instance]

{ #category : #services }
ProbabilityDistributionValidator >> validateLogNormalNormalMean: m logDeviation: sigma [
	| s sg2 mu stdev |
	self aspect: #mean; isPositive: m.
	sg2 := ((4.0 * s squared / (m * 2.0) exp + 1.0) sqrt + 1.0 / 2.0) ln.
	mu := (sg2 / 2.0 + m) exp.
	stdev := sg2 sqrt.
	self validateNormalMean: mu deviation: stdev]

{ #category : #services }
ProbabilityDistributionValidator >> validateLogNormalWithPercentile: p ratio: rho mean: mu [
	| range |
	self aspect: #percent; isDefined: p.
	self
		aspect: #ratio;
		isDefined: rho;
		isPositive: rho.
	range := rho > 1.0
		ifTrue: [Range open: 0.5 open: 1.0]
		ifFalse: [Range open: 0.0 open: 0.5].
	self is: p inRange: range.
	self
		aspect: #mean;
		isDefined: mu;
		isPositive: mu]

{ #category : #services }
ProbabilityDistributionValidator >> validateLogNormalWithPercentiles: p1
valued: x1
and: p2
valued: x2 [
	self aspect: #firstPercentileValue; isPositive: x1.
	x1 < x2
		ifFalse: [self
			failBecause: self prettyPrint , ' is not smaller than the second one'].
	self aspect: #lastPercentileValue; isPositive: x2.
	self aspect: #firstValue; isPositive: p1.
	p1 < p2
		ifFalse: [self
			failBecause: self prettyPrint , ' is not smaller than the second one']]

{ #category : #services }
ProbabilityDistributionValidator >> validateNormalMean: mu deviation: sigma [
	| instance |
	self aspect: #mean; isNumber: mu.
	self aspect: #sd; isPositive: sigma.
	sigma <= Float maxValue sqrt ifFalse: [
		self
			failBecause: self prettyPrint , ' must be under '
				, Float maxValue sqrt printNLString].
	instance := NormalDistribution new mean: mu deviation: sigma.
	self includeValidationOf: instance.
	(instance quantile: self lowerQuantile)
		< (instance quantile: self upperQuantile)
		ifFalse: [
			self
				aspect: nil;
				failBecause: self prettyPrint , ' has none possible value with mean '
					, mu printNLString
					, ' and deviation '
					, sigma printNLString]]

{ #category : #services }
ProbabilityDistributionValidator >> validateNormalWithPercentile: p ratio: rho mean: mu [
	| range |
	self aspect: #percent; isDefined: p.
	self aspect: #ratio; isDefined: rho.
	range := Range from: -1.0 to: 1.0.
	self is: rho notInRange: range.
	self aspect: #mean; isDefined: mu]

{ #category : #services }
ProbabilityDistributionValidator >> validatePertMin: a
max: b
mode: m
lambda: lambda [
	self aspect: #min; isDefined: a.
	self aspect: #max; isDefined: b.
	self aspect: #mode; isDefined: m.
	self aspect: #lambda; isDefined: lambda.
	self aspect: #min.
	a < m ifFalse: [
		self
			failBecause: self prettyPrint
				, ' is not smaller than the Most Likely parameter'].
	self aspect: #max.
	b > m ifFalse: [
		self
			failBecause: self prettyPrint
				, ' is not greater than the Most Likely parameter']]

{ #category : #services }
ProbabilityDistributionValidator >> validatePoissonMean: aNumber [
	self aspect: #mean; isPositive: aNumber]

{ #category : #services }
ProbabilityDistributionValidator >> validatePortfolioOn: variable probability: p [
	self aspect: #variable; isDefined: variable.
	self validatePortfolioProbability: p]

{ #category : #services }
ProbabilityDistributionValidator >> validatePortfolioProbability: p [
	self
		aspect: #probability;
		isDefined: p;
		is: p inRange: Range forProbability]

{ #category : #services }
ProbabilityDistributionValidator >> validateSampleSpaceOn: aCollection [
	self
		aspect: #values;
		isDefined: aCollection;
		isNotEmpty: aCollection]

{ #category : #services }
ProbabilityDistributionValidator >> validateStringOn: distribution values: stringCollection [
	self
		aspect: #values;
		are: stringCollection kindOf: String;
		areDifferent: stringCollection.
	self
		aspect: #deviate;
		isDefined: distribution;
		includeValidationOf: distribution]

{ #category : #services }
ProbabilityDistributionValidator >> validateStringValues: values probabilities: probabilities [
	self
		validateDiscreteValues: values
		probabilities: probabilities
		checkingValuesOrder: false]

{ #category : #services }
ProbabilityDistributionValidator >> validateTDegree: aNumber [
	self validateChiSquareDegree: aNumber]

{ #category : #services }
ProbabilityDistributionValidator >> validateTriangularLeft: a mid: b right: c [
	a isUndefinedValue | b isUndefinedValue | c isUndefinedValue
		ifTrue: [self failBecause: self prettyPrint , ' has undefined parameters'].
	self aspect: #min.
	a < b
		ifFalse: [self
			failBecause: self prettyPrint , ' should be smaller than mid'].
	self aspect: #max.
	b < c
		ifFalse: [self
			failBecause: self prettyPrint , ' should be greater than mid']]

{ #category : #services }
ProbabilityDistributionValidator >> validateTriangularMax: aNumber [
	self aspect: #max; isNumber: aNumber.
	aNumber > object mid
		ifFalse: [self
			failBecause: self prettyPrint , ' must be greater than mid value']]

{ #category : #services }
ProbabilityDistributionValidator >> validateTriangularMid: aNumber [
	self aspect: #mid; isNumber: aNumber.
	(object min < aNumber and: [aNumber < object max]) ifFalse: [
		self
			failValidationBecause: self prettyPrint
				, ' must be above Min and below Max']]

{ #category : #services }
ProbabilityDistributionValidator >> validateTriangularMin: aNumber [
	self aspect: #min; isNumber: aNumber.
	aNumber < object mid
		ifFalse: [self
			failBecause: self prettyPrint , ' must be smaller than mid value']]

{ #category : #services }
ProbabilityDistributionValidator >> validateTruncatedDistribution: aTruncatedDistribution [
	| left right |
	aTruncatedDistribution isDiscrete ifTrue: [^self].
	left := aTruncatedDistribution min isNil ifTrue: [0.001] ifFalse: [0.0].
	right := aTruncatedDistribution max isNil ifTrue: [0.999] ifFalse: [1.0].
	(aTruncatedDistribution quantile: left)
		< (aTruncatedDistribution quantile: right)
		ifFalse: [
			self
				aspect: #truncated;
				failBecause: self prettyPrint , ' has none possible value']]

{ #category : #services }
ProbabilityDistributionValidator >> validateTruncatedLogNormalBetween: n and: m [
	| around mu |
	self aspect: #lowerBound; isNumber: n.
	self aspect: #upperBound; isNumber: m.
	n < m
		ifFalse: [self
			failBecause: self prettyPrint , ' must be greater than lower bound'].
	around := (n max: 0) + m / 2.
	mu := around <= 0 ifTrue: [1.0] ifFalse: [around asFloat].
	self validateLogNormalMean: mu deviation: mu abs * 0.05.
	self validateTruncationFrom: (n max: 0) to: m]

{ #category : #services }
ProbabilityDistributionValidator >> validateTruncatedLogNormalMean: mu
deviation: sigma
min: a
max: b [
	| lognormal truncated |
	self
		validateLogNormalMean: mu deviation: sigma;
		validateTruncationFrom: a to: b.
	lognormal := LogNormalDistribution mean: mu deviation: sigma.
	truncated := TruncatedLogNormalDistribution new
		deviate: lognormal;
		min: a max: b.
	self validateTruncatedDistribution: truncated]

{ #category : #services }
ProbabilityDistributionValidator >> validateTruncatedMax: aNumber [
	| min |
	self aspect: #max; isNumber: aNumber.
	min := object instVarNamed: 'min'.
	self aspect: #min; isNumber: min.
	aNumber > min
		ifFalse: [self
			failBecause: self prettyPrint , ' must be greater than minimum value']]

{ #category : #services }
ProbabilityDistributionValidator >> validateTruncatedMin: aNumber [
	| max |
	self aspect: #min; isNumber: aNumber.
	max := object instVarNamed: 'max'.
	self aspect: #max; isNumber: max.
	aNumber < max
		ifFalse: [self
			failBecause: self prettyPrint , ' must be smaller than maximum value']]

{ #category : #services }
ProbabilityDistributionValidator >> validateTruncatedNormalBetween: n and: m [
	| mu sigma |
	self aspect: #lowerBound; isNumber: n.
	self aspect: #upperBound; isNumber: m.
	n < m
		ifFalse: [self
			failBecause: self prettyPrint , ' must be greater than lower bound'].
	mu := (n + m / 2) asFloat.
	sigma := mu = 0.0 ifTrue: [1.0] ifFalse: [mu abs * 0.05].
	self validateNormalMean: mu deviation: sigma.
	self validateTruncationFrom: (n max: 0) to: m]

{ #category : #services }
ProbabilityDistributionValidator >> validateTruncatedNormalMean: mu
deviation: sigma
min: a
max: b [
	| normal truncated |
	self
		validateNormalMean: mu deviation: sigma;
		validateTruncationFrom: a to: b.
	normal := NormalDistribution mean: mu deviation: sigma.
	truncated := TruncatedNormalDistribution new
		deviate: normal;
		min: a max: b.
	self validateTruncatedDistribution: truncated]

{ #category : #services }
ProbabilityDistributionValidator >> validateTruncationFrom: min to: max [
	(min notNil and: [max notNil] and: [min >= max]) ifTrue: [
		self
			failBecause: self prettyPrint
				, ' cannot truncate with lower bound greater or equal than upper bound']]

{ #category : #services }
ProbabilityDistributionValidator >> validateUniformFrom: start to: stop [
	self aspect: #min; isNumber: start.
	self aspect: #max; isNumber: stop.
	start >~ stop
		ifTrue: [self
			failBecause: self prettyPrint , ' should be greater than min']]

{ #category : #services }
ProbabilityDistributionValidator >> validateUniformMax: aNumber [
	self aspect: #max; isNumber: aNumber.
	aNumber > object min
		ifFalse: [self
			failBecause: self prettyPrint , ' must be greater than minimum value']]

{ #category : #services }
ProbabilityDistributionValidator >> validateUniformMin: aNumber [
	self aspect: #min; isNumber: aNumber.
	aNumber < object max
		ifFalse: [self
			failBecause: self prettyPrint , ' must be smaller than maximum value']]

{ #category : #services }
ProbabilityDistributionValidator >> valueHasSameUniform [
	self value uniform == object uniform
		ifFalse: [self
			failBecause: self prettyPrint , ' must use the same random generator']]

