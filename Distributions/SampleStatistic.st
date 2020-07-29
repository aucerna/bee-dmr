"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SampleStatistic,
	#superclass : #Object,
	#instVars : [
		'data',
		'size',
		'sum',
		'min',
		'max',
		'mean',
		'populationVariance',
		'populationSD',
		'skewness',
		'kurtosis',
		'outliers',
		'maxBound',
		'minBound',
		'domain',
		'frequencies',
		'percentiles',
		'bins',
		'undefined'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
SampleStatistic class >> classFor: anObject [
	anObject isString ifTrue: [^StringSampleStatistic].
	anObject isBoolean ifTrue: [^BooleanSampleStatistic].
	anObject isInteger ifTrue: [^IntegerSampleStatistic].
	^SampleStatistic]

{ #category : #'instance creation' }
SampleStatistic class >> group: sampleStatisticCollection [
	^self new group: sampleStatisticCollection]

{ #category : #'instance creation' }
SampleStatistic class >> new [
	^super new initialize]

{ #category : #'instance creation' }
SampleStatistic class >> on: aCollection [
	"
	SampleStatistic on: ((DateDistribution around: Date today) sample: 10)
	"
	| anyone class |
	anyone := aCollection detect: [:x | x isUndefinedValue not] ifNone: nil.
	(anyone isCollection andNot: [anyone isString])
		ifTrue: [anyone := anyone value
			detect: [:xi | xi isUndefinedValue not]
			ifNone: nil].
	class := self == SampleStatistic
		ifTrue: [self classFor: anyone]
		ifFalse: [self].
	^class new data: aCollection]

{ #category : #samples }
SampleStatistic class >> sampleArrayInstance [
	"
	SampleStatistic sampleArrayInstance
	"
	| single array |
	single := ProbabilityDistribution sampleInstance sample: 10.
	array := single collect: [:s | | a |
		a := FloatArray new: 10.
		a atAllPut: s].
	^self on: array]

{ #category : #samples }
SampleStatistic class >> sampleBooleanInstance [
	^BooleanSampleStatistic
		on: (ProbabilityDistribution sampleBooleanInstance sample: 10)]

{ #category : #samples }
SampleStatistic class >> sampleDateInstance [
	^self on: (ProbabilityDistribution sampleDateInstance sample: 10)]

{ #category : #samples }
SampleStatistic class >> sampleInstance [
	^self on: (ProbabilityDistribution sampleInstance sample: 10)]

{ #category : #samples }
SampleStatistic class >> sampleInstanceWith: aRandom [
	| distribution sample |
	distribution := ProbabilityDistribution sampleInstance uniform: aRandom.
	sample := distribution sample: 10.
	^self on: sample asOrderedCollection]

{ #category : #adding }
SampleStatistic >> addData: value [
	| x |
	x := value isFmlArray ifTrue: [value asResult] ifFalse: [value].
	data isArray
		ifTrue: [data := data copyWith: x]
		ifFalse: [data markDirtyAdd: x].
	^x]

{ #category : #adding }
SampleStatistic >> append: value [
	| x calculator |
	calculator := self calculator.
	x := self addData: value.
	calculator append: x.
	self invalidateEstimators]

{ #category : #private }
SampleStatistic >> arraySize [
	| array |
	max notNil ifTrue: [^max size].
	array := data detect: [:v | v isArrayValued] ifNone: [^1].
	^array size]

{ #category : #converting }
SampleStatistic >> asJson [
	| json |
	json := JsonObject new.
	json at: 'Values' put: (self data collect: #value).
	#(#min #max #mean #sd #variance #skewness #kurtosis #minBound #maxBound)
		do: [:s | | estimator feature |
			estimator := self perform: s.
			estimator notNil ifTrue: [
				feature := s == #sd ifTrue: ['SD'] ifFalse: [s asString asProperNoun].
				json at: feature put: estimator value]].
	5
		to: 100
		by: 5
		do: [:p | json at: 'P' , p asString put: (self percentile: p)].
	^json]

{ #category : #services }
SampleStatistic >> atPeriod: anInteger [
	| periods values |
	periods := self propertyAt: #periodStatistics ifAbsent: nil.
	periods notNil ifTrue: [^periods at: anInteger].
	values := self valueFrequencies ifNotNil: [:f | f at: anInteger].
	^self localCopy shallowCopy
		propertyAt: #valueFrequencies put: values;
		keepOnlyPeriod: anInteger]

{ #category : #private }
SampleStatistic >> averageRanks: ranks [
	| intervals |
	intervals := Dictionary new: data size.
	data with: ranks do: [:x :r | | scope |
		scope := intervals at: x ifAbsent: [].
		scope isArray ifTrue: [scope at: 2 put: r] ifFalse: [
			scope := scope isNil ifTrue: [r] ifFalse: [{scope. r}].
			intervals at: x put: scope]].
	^data collect: [:x | | scope a b s |
		scope := intervals at: x.
		scope isArray
			ifTrue: [
				scope sort.
				a := scope at: 1.
				b := scope at: 2.
				s := b sumFrom: a.
				s = 0
					ifTrue: [
						s := a sumFrom: b.
						s asFloat / (a - b + 1)]
					ifFalse: [s asFloat / (b - a + 1)]]
			ifFalse: [scope]]]

{ #category : #private }
SampleStatistic >> basicData: aCollection [
	data := aCollection]

{ #category : #calculations }
SampleStatistic >> calculate [
	self reset; update]

{ #category : #private }
SampleStatistic >> calculator [
	^self propertyAt: #calculator ifAbsentPut: [self createCalculator]]

{ #category : #testing }
SampleStatistic >> canComputeOutliers [
	^data notNil and: [self isSingleValued]]

{ #category : #testing }
SampleStatistic >> canRetryOn: anError [
	^self calculator canRetryOn: anError]

{ #category : #private }
SampleStatistic >> computeStats [
	| calculator |
	calculator := self calculator.
	calculator calculate.
	size := data size asFloat.
	sum := calculator sum.
	min := calculator min.
	max := calculator max.
	mean := calculator mean.
	populationVariance := calculator variance.
	populationSD := populationVariance sqrt.
	skewness := calculator skewness value.
	kurtosis := calculator kurtosis value.
	self propertyAt: #valueFrequencies put: calculator values.
	calculator calculatesPercentiles
		ifTrue: [
			percentiles := calculator percentiles.
			frequencies := calculator frequencies]
		ifFalse: [self calculateHistogram]]

{ #category : #copying }
SampleStatistic >> copy [
	| copy |
	copy := super copy.
	(self propertyAt: #calculator)
		ifNotNil: [:c | copy propertyAt: #calculator put: c].
	^copy]

{ #category : #calculations }
SampleStatistic >> correlationCoefficient: aSampleStatistic [
	^aSampleStatistic correlationCoefficientWith: self]

{ #category : #calculations }
SampleStatistic >> correlationCoefficientWith: aSampleStatistic [
	| covariance divisor |
	covariance := self covariance: aSampleStatistic.
	divisor := (self populationSD * aSampleStatistic populationSD) value.
	divisor = 0.0 ifTrue: [^0.0].
	^covariance / divisor]

{ #category : #calculations }
SampleStatistic >> covariance: aSampleStatistic [
	| s xmu ymu |
	xmu := self mean.
	ymu := aSampleStatistic mean.
	s := 0.0.
	data
		with: aSampleStatistic data
		do: [:xi :yi | s := xi - xmu * (yi - ymu) + s].
	^s / aSampleStatistic numData]

{ #category : #private }
SampleStatistic >> createCalculator [
	self shouldUseOpenCL
		ifTrue: [^(Smalltalk at: #OpenCLStatisticsCalculator) on: self].
	self isStringValued ifTrue: [^StringStatisticsCalculator on: self].
	self isDateValued ifTrue: [^DateStatisticsCalculator on: self].
	self isArrayValued ifTrue: [^ArrayStatisticsCalculator on: self].
	^StatisticsCalculator on: self]

{ #category : #accessing }
SampleStatistic >> data [
	^data]

{ #category : #accessing }
SampleStatistic >> data: aCollection [
	data := aCollection]

{ #category : #accessing }
SampleStatistic >> dataAt: i [
	^data at: i]

{ #category : #accessing }
SampleStatistic >> dataAt: i put: anObject [
	| value |
	data size < i ifTrue: [i - data size timesRepeat: [data markDirtyAdd: nil]].
	value := anObject value isBoolean
		ifTrue: [anObject asParameter]
		ifFalse: [anObject].
	data markDirtyAt: i put: value]

{ #category : #histogram }
SampleStatistic >> defaultHistogramBins [
	^20]

{ #category : #services }
SampleStatistic >> differencesWith: aSampleStatistic [
	^SampleStatisticDifferences between: self and: aSampleStatistic]

{ #category : #accessing }
SampleStatistic >> domain: anInterval [
	domain := anInterval]

{ #category : #'file in/out' }
SampleStatistic >> fileOutSurrogate [
	^self shallowCopy clearSurrogate]

{ #category : #copying }
SampleStatistic >> forIterations: aCollection [
	| iterations values |
	iterations := aCollection asSet.
	values := data withIndexSelect: [:v :i | iterations includes: i].
	^self copy basicData: values; reset]

{ #category : #accessing }
SampleStatistic >> frequencies [
	(self hasData andNot: [self isCalculated]) ifTrue: [self calculate].
	^frequencies]

{ #category : #estimators }
SampleStatistic >> group: aCollection [
	kurtosis := aCollection collect: [:x | x kurtosis].
	max := aCollection collect: [:x | x max].
	mean := aCollection collect: [:x | x mean].
	min := aCollection collect: [:x | x min].
	size := aCollection anyone numData.
	populationVariance := aCollection collect: [:x | x populationVariance].
	populationSD := aCollection collect: [:x | x populationSD].
	skewness := aCollection collect: [:x | x skewness].
	sum := aCollection collect: [:x | x sum]]

{ #category : #testing }
SampleStatistic >> hasData [
	^data isEmptyOrNil not]

{ #category : #testing }
SampleStatistic >> hasDensityData [
	| prev |
	self hasData ifFalse: [^false].
	data isEmpty ifTrue: [^false].
	data do: [:each | | value |
		value := each value.
		prev notNil ifTrue: [value ~ prev ifFalse: [^true]].
		prev := value].
	^false]

{ #category : #testing }
SampleStatistic >> hasUndefinedValues [
	^self isSingleValued
		ifTrue: [self mean isUndefinedValue]
		ifFalse: [self mean hasUndefinedValues]]

{ #category : #outliers }
SampleStatistic >> hiOutlierLimit [
	^self mean value + (3 * self sd value)]

{ #category : #outliers }
SampleStatistic >> hiOutliers [
	| limit |
	limit := self hiOutlierLimit.
	^self outliers select: [:v | v value > limit]]

{ #category : #histogram }
SampleStatistic >> histogram [
	| class values |
	self ASSERT: self isSingleValued.
	class := self histogramClass.
	values := self histogramDomain.
	self hasData
		ifTrue: [^class on: self domain: values numberOfBins: self histogramBins].
	frequencies isNil ifTrue: [
		self ASSERT: false.
		^nil].
	^class on: self domain: values frequencies: frequencies]

{ #category : #histogram }
SampleStatistic >> histogramBins [
	| k |
	self hasData ifFalse: [^bins].
	(self isArrayValued and: [self isIntegerValued or: [self isDateValued]])
		ifTrue: [
			k := self periodStatistics
				minValue: [:s | (s max - s min) value min: bins max: 1].
			^k asInteger].
	^bins]

{ #category : #histogram }
SampleStatistic >> histogramBins: anInteger [
	bins := anInteger]

{ #category : #histogram }
SampleStatistic >> histogramClass [
	domain notNil ifTrue: [^DiscreteHistogram].
	^self isDateValued
		ifTrue: [IntegerHistogram]
		ifFalse: [ContinuousHistogram]]

{ #category : #histogram }
SampleStatistic >> histogramDomain [
	^domain notNil ifTrue: [domain] ifFalse: [{self min value. self max value}]]

{ #category : #histogram }
SampleStatistic >> histograms [
	| k |
	self ASSERT: self isArrayValued.
	k := self histogramBins.
	^self periodStatistics collect: [:s | s histogramBins: k; histogram]]

{ #category : #percentiles }
SampleStatistic >> indexOfPercentile: percent [
	| index |
	index := percent * self percentileSize / 100.
	^index asInteger ~ index ifTrue: [index asInteger] ifFalse: [0]]

{ #category : #initialization }
SampleStatistic >> initialize [
	super initialize.
	data := OrderedCollection new.
	bins := self defaultHistogramBins]

{ #category : #private }
SampleStatistic >> invalidateEstimators [
	size := sum := min := max := mean := populationVariance := populationSD := skewness := kurtosis := percentiles := frequencies := nil]

{ #category : #testing }
SampleStatistic >> isArrayValued [
	^self isCalculated
		ifTrue: [max isArrayValued]
		ifFalse: [data notNil and: [data anySatisfy: #isArrayValued]]]

{ #category : #testing }
SampleStatistic >> isBooleanValued [
	^false]

{ #category : #testing }
SampleStatistic >> isCalculated [
	^mean notNil]

{ #category : #testing }
SampleStatistic >> isConstant [
	| any |
	any := data anyone.
	^data conform: [:s | s = any]]

{ #category : #testing }
SampleStatistic >> isDateValued [
	^self typeConform: #isDate]

{ #category : #testing }
SampleStatistic >> isDifferences [
	self ASSERT: false.
	^false]

{ #category : #testing }
SampleStatistic >> isIntegerValued [
	^false]

{ #category : #testing }
SampleStatistic >> isNumberValued [
	^self typeConform: [:x | x isNumber]]

{ #category : #testing }
SampleStatistic >> isSingleValued [
	^self isArrayValued not]

{ #category : #testing }
SampleStatistic >> isStringValued [
	^false]

{ #category : #testing }
SampleStatistic >> isTableValued [
	^data notNil and: [data anyone isTableValued]]

{ #category : #private }
SampleStatistic >> keepOnlyPeriod: anInteger [
	data := data notNil
		ifTrue: [data collect: [:v | (v valueAt: anInteger) value]].
	sum notNil ifTrue: [sum := (sum valueAt: anInteger) value].
	max notNil ifTrue: [max := (max valueAt: anInteger) value].
	min notNil ifTrue: [min := (min valueAt: anInteger) value].
	mean notNil ifTrue: [mean := (mean valueAt: anInteger) value].
	skewness notNil ifTrue: [skewness := (skewness valueAt: anInteger) value].
	kurtosis notNil ifTrue: [kurtosis := (kurtosis valueAt: anInteger) value].
	populationVariance notNil
		ifTrue: [populationVariance := (populationVariance valueAt: anInteger) value].
	populationSD notNil
		ifTrue: [populationSD := (populationSD valueAt: anInteger) value].
	percentiles notNil
		ifTrue: [percentiles := (percentiles at: anInteger) value].
	frequencies notNil
		ifTrue: [frequencies := (frequencies at: anInteger) value]]

{ #category : #services }
SampleStatistic >> kernelDensityWithBandwidth: smoothing [
	^self kernelDensityWithBandwidth: smoothing qualityFactor: 200]

{ #category : #services }
SampleStatistic >> kernelDensityWithBandwidth: smoothing qualityFactor: q [
	| abscissas count f values area |
	min ~ max ifTrue: [^nil].
	abscissas := data collect: [:a | a value] in: OrderedCollection new.
	abscissas sort.
	count := abscissas size.
	f := 10.0 - smoothing / 10.0 * count + count sqrt / (min - max).
	values := abscissas withIndexCollect: [:v :i | | d |
		d := 0.
		(i - q max: 1)
			to: (i + q min: count)
			do: [:j | d := d + ((abscissas at: j) - v * f) squared negated exp].
		d].
	area := (2 to: count)
		sum: [:i | (values at: i) + (values at: i - 1)
			* ((abscissas at: i) - (abscissas at: i - 1))
			/ 2].
	^abscissas with: values collect: [:d :v | d @ (v / area)]]

{ #category : #estimators }
SampleStatistic >> kurtosis [
	kurtosis isNil ifTrue: [self calculate].
	^kurtosis]

{ #category : #private }
SampleStatistic >> localCopy [
	| local copy |
	copy := self propertyAt: #localCopy.
	copy notNil ifTrue: [^copy].
	copy := self shallowCopy.
	self needsLocalCopy ifTrue: [
		local := OrderedCollection withAll: data.
		copy basicData: local.
		self propertyAt: #localCopy put: copy].
	^copy]

{ #category : #outliers }
SampleStatistic >> lowOutlierLimit [
	^self mean value - (3 * self sd value)]

{ #category : #outliers }
SampleStatistic >> lowOutliers [
	| limit |
	limit := self lowOutlierLimit.
	^self outliers select: [:v | v value < limit]]

{ #category : #estimators }
SampleStatistic >> max [
	max isNil ifTrue: [self calculate].
	^max]

{ #category : #outliers }
SampleStatistic >> maxBound [
	maxBound isNil ifTrue: [self calculate].
	^maxBound]

{ #category : #estimators }
SampleStatistic >> mean [
	mean isNil ifTrue: [self calculate].
	^mean]

{ #category : #estimators }
SampleStatistic >> min [
	min isNil ifTrue: [self calculate].
	^min]

{ #category : #outliers }
SampleStatistic >> minBound [
	minBound isNil ifTrue: [self calculate].
	^minBound]

{ #category : #private }
SampleStatistic >> needsLocalCopy [
	^data notNil and: [data isExternal]]

{ #category : #estimators }
SampleStatistic >> numData [
	size isNil ifTrue: [self calculate].
	^size]

{ #category : #outliers }
SampleStatistic >> outliers [
	outliers ifNil: [self calculate].
	^outliers]

{ #category : #calculations }
SampleStatistic >> pearsonCoff: y [
	"
	Returns the Pearson product moment correlation coefficient, r, a dimensionless
	index that ranges from -1.0 to 1.0 inclusive and reflects the extent of a linear
	relationship between two data sets.
	"
	| sumX sumY sumXY sumX2 sumY2 |
	sumX := sumY := sumXY := sumX2 := sumY2 := 0.0.
	1 to: y size do: [:i | 
		sumX := sumX + (data at: i).
		sumY := sumY + (y at: i).
		sumXY := sumXY + ((data at: i) * (y at: i)).
		sumX2 := sumX2 + (data at: i) squared.
		sumY2 := sumY2 + (y at: i) squared].
	^y size * (sumXY - (sumX * sumY))
		/ (y size * sumX2 - sumX squared * (y size * sumY2 - sumY squared)) sqrt]

{ #category : #percentiles }
SampleStatistic >> percentile: percent [
	| index |
	index := self indexOfPercentile: percent.
	index > 0 ifFalse: [^nil].
	self isSingleValued ifTrue: [^self percentiles at: index].
	^self percentiles collect: [:array | 
		array size = 1
			ifTrue: [array isUndefinedValue ifTrue: [array] ifFalse: [array anyone]]
			ifFalse: [array at: index]]]

{ #category : #private }
SampleStatistic >> percentileCount [
	^20]

{ #category : #percentiles }
SampleStatistic >> percentiles [
	(self hasData andNot: [self isCalculated]) ifTrue: [self calculate].
	^percentiles]

{ #category : #percentiles }
SampleStatistic >> percentiles: n [
	^self histogram percentiles: n]

{ #category : #percentiles }
SampleStatistic >> percentileSize [
	| collection |
	collection := self percentiles.
	^self isArrayValued
		ifTrue: [collection first size max: collection last size]
		ifFalse: [collection size]]

{ #category : #services }
SampleStatistic >> periodStatistics [
	^self propertyAt: #periodStatistics ifAbsentPut: [
		self isArrayValued
			ifTrue: [(1 to: self arraySize) collect: [:i | self atPeriod: i]]
			ifFalse: [{self localCopy}]]]

{ #category : #estimators }
SampleStatistic >> populationSD [
	populationSD isNil ifTrue: [self calculate].
	^populationSD]

{ #category : #estimators }
SampleStatistic >> populationVariance [
	populationVariance isNil ifTrue: [self calculate].
	^populationVariance]

{ #category : #services }
SampleStatistic >> rankCorrelation: statistics [
	| ranking1 ranking2 s n |
	ranking1 := self ranking.
	ranking2 := statistics ranking.
	(ranking1 hasDuplicates or: [ranking2 hasDuplicates])
		ifTrue: [^ranking1 correlationCoefficient: ranking2].
	s := 0.0.
	ranking1 with: ranking2 do: [:r1 :r2 | s := s + (r1 - r2) squared].
	n := self size.
	^1.0 - (6.0 * s / (n squared - 1 * n))]

{ #category : #services }
SampleStatistic >> ranking [
	"
	(SampleStatistic on: #(1.2 2.3 0.8 18 1.2)) ranking
	"
	| n indexes tied ranks |
	n := data size.
	indexes := (1 to: n) asArray.
	tied := false.
	indexes sortBy: [:i :j | | xi xj |
		xi := data at: i.
		xj := data at: j.
		tied := tied or: [xi = xj].
		xi value < xj value].
	ranks := Array new: n.
	1 to: n do: [:i | ranks at: (indexes at: i) put: i].
	^tied ifTrue: [self averageRanks: ranks] ifFalse: [ranks]]

{ #category : #release }
SampleStatistic >> releaseCalculator [
	self
		removeProperty: #localCopy ifAbsent: nil;
		removeProperty: #calculator ifAbsent: nil;
		removeProperty: #periodStatistics ifAbsent: nil;
		removeProperty: #valueFrequencies ifAbsent: nil]

{ #category : #release }
SampleStatistic >> releaseData [
	data isNil ifTrue: [^self].
	(self hasData andNot: [self isCalculated]) ifTrue: [self calculate].
	self releaseCalculator.
	data := nil]

{ #category : #release }
SampleStatistic >> reset [
	self invalidateEstimators; releaseCalculator]

{ #category : #private }
SampleStatistic >> resetOutliers [
	outliers := #().
	minBound := maxBound := self mean]

{ #category : #estimators }
SampleStatistic >> resetToUndefined [
	| undefineds |
	size := nil.
	self isArrayValued
		ifTrue: [
			undefineds := Array new: self arraySize withAll: nil.
			sum := min := max := mean := populationVariance := populationSD := skewness := kurtosis := percentiles := frequencies := undefineds]
		ifFalse: [sum := min := max := mean := populationVariance := populationSD := skewness := kurtosis := percentiles := frequencies := nil]]

{ #category : #estimators }
SampleStatistic >> sampleSD [
	^self sampleVariance abs sqrt * populationVariance sign]

{ #category : #estimators }
SampleStatistic >> sampleVariance [
	| n p |
	n := self numData.
	p := self populationVariance.
	^n = 1.0 ifTrue: [p] ifFalse: [p * n / (n - 1.0)]]

{ #category : #estimators }
SampleStatistic >> sd [
	^self sampleSD]

{ #category : #services }
SampleStatistic >> setSamplesDifferencesWith: aSampleStatistic [
	| mu |
	data isNil ifTrue: [^self].
	data := (aSampleStatistic hasData and: [aSampleStatistic numData = size])
		ifTrue: [data with: aSampleStatistic data collect: [:d :s | d - s]]
		ifFalse: [
			mu := aSampleStatistic mean.
			data collect: [:d | d - mu]]]

{ #category : #services }
SampleStatistic >> setSamplesDifferencesWith: aSampleStatistic coherent: aBoolean [
	| mu |
	data isNil ifTrue: [^self].
	data := aSampleStatistic hasData & aBoolean
		ifTrue: [data with: aSampleStatistic data collect: [:d :s | d - s]]
		ifFalse: [
			mu := aSampleStatistic mean.
			data collect: [:d | d - mu]]]

{ #category : #testing }
SampleStatistic >> shouldUseOpenCL [
	^self canUseOpenCL and: [self isArrayValued] and: [self isNumberValued]]

{ #category : #accessing }
SampleStatistic >> size [
	^data size]

{ #category : #estimators }
SampleStatistic >> skewness [
	skewness isNil ifTrue: [self calculate].
	^skewness]

{ #category : #estimators }
SampleStatistic >> standardError [
	"
	ShellDLL current openWebPage: 'http://mathworld.wolfram.com/StandardError.html'
	"
	^(self variance / self numData) sqrt value]

{ #category : #estimators }
SampleStatistic >> sum [
	sum isNil ifTrue: [self calculate].
	^sum]

{ #category : #testing }
SampleStatistic >> supportsStatistics [
	^self isTableValued not]

{ #category : #'file in/out' }
SampleStatistic >> surrogateFor: anArray [
	| anyone |
	anyone := anArray anyone.
	anyone isArrayValued ifTrue: [
		anArray withIndexDo: [:array :i | | surrogate |
			surrogate := self surrogateFor: array.
			anArray at: i put: surrogate].
		^anArray].
	(anArray notEmpty
		andNot: [(anyone isKindOf: Magnitude)
			or: [anyone isBoolean]
			or: [anyone isString]])
		ifTrue: [anArray withIndexDo: [:v :i | anArray at: i put: v value]].
	^self isNumberValued ifTrue: [anArray asFloatArray] ifFalse: [anArray]]

{ #category : #private }
SampleStatistic >> typeConform: evaluable [
	self isArrayValued ifTrue: [
		mean notNil ifTrue: [^mean value anySatisfy: evaluable].
		data isNil ifTrue: [^false].
		data do: [:x | 
			x isUndefinedValue ifFalse: [
				x value isArray ifFalse: [^evaluable evaluateWith: x].
				x value
					do: [:xi | xi isUndefinedValue ifFalse: [^evaluable evaluateWith: xi]]]].
		^false].
	mean notNil ifTrue: [^evaluable evaluateWith: mean].
	data isNil ifTrue: [^false].
	data do: [:x | x isUndefinedValue ifFalse: [^evaluable evaluateWith: x]].
	^false]

{ #category : #accessing }
SampleStatistic >> undefinedCount [
	^undefined]

{ #category : #private }
SampleStatistic >> update [
	[self computeStats] on: Error do: [:error | 
		ErrorNotification signalOn: error.
		(self canRetryOn: error)
			ifTrue: [self calculate]
			ifFalse: [self resetToUndefined]]]

{ #category : #private }
SampleStatistic >> updateFrom: aStatisticCalculator [
	size := data size asFloat.
	sum := aStatisticCalculator sum asFmlValue.
	min := aStatisticCalculator min asFmlValue.
	max := aStatisticCalculator max asFmlValue.
	mean := aStatisticCalculator mean asFmlValue.
	populationVariance := aStatisticCalculator variance asFmlValue.
	populationSD := populationVariance sqrt.
	skewness := aStatisticCalculator skewness value.
	kurtosis := aStatisticCalculator kurtosis value.
	percentiles := aStatisticCalculator percentiles.
	frequencies := aStatisticCalculator frequencies.
	self canComputeOutliers
		ifTrue: [
			aStatisticCalculator calculateOutliers.
			outliers := aStatisticCalculator outliers.
			minBound := aStatisticCalculator minBound.
			maxBound := aStatisticCalculator maxBound]
		ifFalse: [self resetOutliers]]

{ #category : #calculations }
SampleStatistic >> usedDevice [
	^self calculator device]

{ #category : #services }
SampleStatistic >> useLocalDataWhile: aBlock [
	| external |
	self needsLocalCopy ifTrue: [
		external := data.
		data := OrderedCollection withAll: data].
	aBlock ensure: [external notNil ifTrue: [data := external]]]

{ #category : #accessing }
SampleStatistic >> valueFrequencies [
	^self propertyAt: #valueFrequencies]

{ #category : #estimators }
SampleStatistic >> variance [
	^self sampleVariance]

