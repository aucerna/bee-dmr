"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlValue,
	#superclass : #FmlExpression,
	#category : #FML
}

{ #category : #'result type' }
FmlValue class >> * resultType [
	resultType == FmlTable ifTrue: [^FmlUndefinedValue].
	^resultType]

{ #category : #constants }
FmlValue class >> defaultUnit [
	^self variableClass defaultUnit]

{ #category : #accessing }
FmlValue class >> fmlValueClass [
	^self]

{ #category : #testing }
FmlValue class >> isArrayValued [
	^false]

{ #category : #testing }
FmlValue class >> isSingleValued [
	^true]

{ #category : #testing }
FmlValue class >> isSummable [
	^false]

{ #category : #testing }
FmlValue class >> isTableValued [
	^false]

{ #category : #'instance creation' }
FmlValue class >> on: anObject [
	^self new value: anObject]

{ #category : #testing }
FmlValue class >> supportsLogicalOperations [
	^false]

{ #category : #arithmetic }
FmlValue >> - aFmlValue [
	^self invalidOperation: #'-']

{ #category : #'logical operations' }
FmlValue >> & fmlExpression [
	^self and: fmlExpression]

{ #category : #arithmetic }
FmlValue >> * aFmlValue [
	^self invalidOperation: #'*']

{ #category : #arithmetic }
FmlValue >> / aFmlValue [
	^self invalidOperation: #'/']

{ #category : #arithmetic }
FmlValue >> // aFmlValue [
	^self invalidOperation: #'//']

{ #category : #'logical operations' }
FmlValue >> | fmlExpression [
	^self or: fmlExpression]

{ #category : #arithmetic }
FmlValue >> + anFmlValue [
	^self invalidOperation: #'+']

{ #category : #comparing }
FmlValue >> < aFmlValue [
	^self cannotEvaluate: '<']

{ #category : #comparing }
FmlValue >> <= aFmlValue [
	^self cannotEvaluate: #'<=']

{ #category : #comparing }
FmlValue >> <> aFmlValue [
	"
	1 asFmlValue <> 1 asFmlValue
	1 asFmlValue <> #( 1 2 3 ) asFmlValue
	#( 1 2 3 ) asFmlValue <> 1 asFmlValue
	#( 1 2 3 ) asFmlValue <> #( 1 2 3 ) asFmlValue
	"
	^(self equals: aFmlValue) not]

{ #category : #comparing }
FmlValue >> = anObject [
	^self class == anObject class and: [self value = anObject value]]

{ #category : #comparing }
FmlValue >> > anFmlValue [
	^self cannotEvaluate: #'>']

{ #category : #comparing }
FmlValue >> >= anFmlValue [
	^self cannotEvaluate: #'>=']

{ #category : #visiting }
FmlValue >> acceptVisitor: fmlVisitor [
	fmlVisitor visitValue: self]

{ #category : #validation }
FmlValue >> addMagicConstantsTo: aCollection [
	self isMagicConstant ifFalse: [^self].
	aCollection add: self]

{ #category : #arithmetic }
FmlValue >> addTo: aMagnitude [
	^aMagnitude + self asFloat]

{ #category : #'logical operations' }
FmlValue >> and: dummy [
	^self cannotEvaluate: #and]

{ #category : #errors }
FmlValue >> argument: arg in: function shouldBeArrayOf: fmlValueClass [
	| f |
	f := self displayFunctionName: function.
	^InvalidArgumentType
		signal: 'Argument ' , arg , ' in ' , f , ' should be an array of '
			, fmlValueClass typeName asPlural]

{ #category : #errors }
FmlValue >> argumentIn: function shouldBe: fmlValueClass [
	| f |
	f := self displayFunctionName: function.
	^InvalidArgumentType
		signal: 'Arguments in ' , f , ' should be '
			, fmlValueClass typeName withArticle]

{ #category : #converting }
FmlValue >> asArray [
	^self newArray]

{ #category : #converting }
FmlValue >> asFmlValue [
	^self]

{ #category : #'string functions' }
FmlValue >> asLowercase [
	self hasStrings
		ifFalse: [self argumentIn: 'asLowercase' shouldBe: FmlString]]

{ #category : #'string functions' }
FmlValue >> asUppercase [
	self hasStrings
		ifFalse: [self argumentIn: 'asUppercase' shouldBe: FmlString]]

{ #category : #functions }
FmlValue >> atColumn: col inTable: table [
	^col atRowNumber: self inTable: table]

{ #category : #functions }
FmlValue >> atRowNumber: fmlNumber inTable: table [
	^table at: self value asInteger @ fmlNumber value asInteger]

{ #category : #functions }
FmlValue >> average: anArray [
	^self cannotEvaluate: #average]

{ #category : #testing }
FmlValue >> canBeConsideredPercent [
	^false]

{ #category : #'string functions' }
FmlValue >> capitalized [
	self hasStrings
		ifFalse: [self argumentIn: 'capitalized' shouldBe: FmlString]]

{ #category : #accessing }
FmlValue >> color [
	^Color brown darker]

{ #category : #functions }
FmlValue >> columnIndexInTable: anFmlTable [
	^FmlUndefinedValue new]

{ #category : #evaluation }
FmlValue >> columnSelectorFor: symbol [
	^(symbol numArgs = 0
		ifTrue: [symbol, 'AtColumn:']
		ifFalse: [symbol, 'atColumn:']) asSymbol]

{ #category : #functions }
FmlValue >> columnValueIn: table row: index [
	| r |
	r := self value.
	(r isNumber andNot: [r between: 1 and: table numColumns]) ifTrue: [
		self
			argument: 'returnColumn'
			in: 'vLookup'
			notBetween: 1
			and: table numColumns.
		^FmlUndefinedValue new].
	^(table atRow: index column: r asInteger) asFmlValue]

{ #category : #'array compatibility' }
FmlValue >> copy: start to: stop fill: fill [
	^self cannotEvaluate: #copy]

{ #category : #functions }
FmlValue >> cum [
	"
	0 asFmlValue cum
	"
	^self]

{ #category : #'date functions' }
FmlValue >> day [
	self cannotEvaluate: #day]

{ #category : #'date functions' }
FmlValue >> dayOfYear [
	self cannotEvaluate: #dayOfYear]

{ #category : #'date functions' }
FmlValue >> daysInYear [
	self cannotEvaluate: #daysInYear]

{ #category : #functions }
FmlValue >> db: life [
	^self db: life afterlife: false]

{ #category : #functions }
FmlValue >> db: life afterlife: aBoolean [
	^self cannotEvaluate: 'db']

{ #category : #functions }
FmlValue >> ddb: life [
	^self ddb: life afterlife: false]

{ #category : #functions }
FmlValue >> ddb: life afterlife: aBoolean [
	^self cannotEvaluate: 'ddb']

{ #category : #functions }
FmlValue >> distributionFor: aProbabilityDistribution [
	| p |
	p := aProbabilityDistribution distribution: self value.
	^p asFmlValue]

{ #category : #evaluation }
FmlValue >> doesNotUnderstand: aMessage [
	| name |
	((FmlNumber selectors includes: aMessage selector)
		or: [FmlTable selectors includes: aMessage selector]
		or: [FmlArray selectors includes: aMessage selector])
		ifTrue: [
			name := aMessage selector keywords first without: ':'.
			self cannotEvaluate: name]
		ifFalse: [super doesNotUnderstand: aMessage]]

{ #category : #comparing }
FmlValue >> equals: anFmlValue [
	^self cannotEvaluate: #'=']

{ #category : #functions }
FmlValue >> escalate: rate [
	^self cannotEvaluate: #escalate]

{ #category : #'array compatibility' }
FmlValue >> escalateReference: rate logic: aBoolean [
	^self cannotEvaluate: #escalateReference]

{ #category : #evaluation }
FmlValue >> evaluate [
	^self]

{ #category : #evaluation }
FmlValue >> evaluateAt: index [
	^self valueAt: index]

{ #category : #evaluation }
FmlValue >> evaluateLiterals [
	^self]

{ #category : #evaluation }
FmlValue >> evaluateWith: aFmlEvaluator [
	^self]

{ #category : #'array compatibility' }
FmlValue >> firstNegativeIfAbsent: defaultValue [
	^self cannotEvaluate: #firstNegative]

{ #category : #'array compatibility' }
FmlValue >> firstPositiveIfAbsent: defaultValue [
	^self cannotEvaluate: #firstPositive]

{ #category : #'array compatibility' }
FmlValue >> firstValue [
	^self]

{ #category : #functions }
FmlValue >> geometricMean: anArray [
	^self cannotEvaluate: #geometricMean]

{ #category : #testing }
FmlValue >> hasDates [
	^self isDate]

{ #category : #comparing }
FmlValue >> hash [
	^self value hash]

{ #category : #testing }
FmlValue >> hasOnlyConstants [
	^true]

{ #category : #testing }
FmlValue >> hasStrings [
	^self isString]

{ #category : #'string functions' }
FmlValue >> includesString: aString [
	self hasStrings
		ifFalse: [self argumentIn: 'includesString' shouldBe: FmlString]]

{ #category : #functions }
FmlValue >> index: row col: col [
	^self cannotEvaluate: #index]

{ #category : #functions }
FmlValue >> indexGTValue: value [
	^self indexGTValue: value ifAbsent: nil]

{ #category : #'array compatibility' }
FmlValue >> indexGTValue: value ifAbsent: default [
	^self cannotEvaluate: 'indexGTValue']

{ #category : #functions }
FmlValue >> indexLTValue: value [
	^self indexLTValue: value ifAbsent: nil]

{ #category : #'array compatibility' }
FmlValue >> indexLTValue: value ifAbsent: default [
	^self cannotEvaluate: 'indexLTValue']

{ #category : #functions }
FmlValue >> interpolate: value
on: table
returnColumn: return
extrapolate: aBoolean [
	| s |
	s := table columnFrom: self arg: 'searchColumn' function: 'interpolate'.
	s isNumber
		ifFalse: [^self
			argument: 'searchColumn'
			in: 'interpolate'
			shouldBe: FmlNumber].
	(s asInteger between: 1 and: table numColumns) ifFalse: [
		^self
			argument: 'searchColumn'
			in: 'interpolate'
			notBetween: 1
			and: table numColumns].
	^return asFmlValue
		interpolate: value
		on: table
		searchingAt: s asInteger
		extrapolate: aBoolean]

{ #category : #functions }
FmlValue >> interpolate: value
on: table
searchingAt: columnIndex
extrapolate: aBoolean [
	| r |
	r := table columnFrom: self arg: 'returnColumn' function: 'interpolate'.
	r isNumber
		ifFalse: [^self
			argument: 'returnColumn'
			in: 'interpolate'
			shouldBe: FmlNumber].
	(r asInteger between: 1 and: table numColumns) ifFalse: [
		^self
			argument: 'returnColumn'
			in: 'interpolate'
			notBetween: 1
			and: table numColumns].
	^table
		basicInterpolate: value
		searchColumn: columnIndex
		returnColumn: r asInteger
		extrapolate: aBoolean]

{ #category : #functions }
FmlValue >> interpolateUsing: aLinearInterpolatedFunction extrapolate: aBoolean [
	| x y |
	x := self value.
	y := (aLinearInterpolatedFunction isDefinedAt: x)
		ifTrue: [aLinearInterpolatedFunction valueAt: x]
		ifFalse: [
			aBoolean
				ifTrue: [aLinearInterpolatedFunction extrapolatedValueAt: x]
				ifFalse: [
					x <= aLinearInterpolatedFunction abscissas first
						ifTrue: [aLinearInterpolatedFunction ordinates first]
						ifFalse: [aLinearInterpolatedFunction ordinates last]]].
	^y asFmlValue]

{ #category : #errors }
FmlValue >> invalidOperation: aString [
	^InvalidArgumentType
		signal: 'Invalid operation sent to a ' , self typeName , ': ' , aString]

{ #category : #functions }
FmlValue >> inverseDistributionFor: aProbabilityDistribution [
	| x |
	(self value between: 0.0 and: 1.0) ifFalse: [
		^self
			argument: 'probability'
			in: 'inverseDistribution'
			notBetween: 0
			and: 1].
	x := aProbabilityDistribution inverseDistribution: self value.
	^x asFmlValue]

{ #category : #functions }
FmlValue >> irr [
	^self cannotEvaluate: #irr]

{ #category : #testing }
FmlValue >> isCloseTo: aFmlValue [
	^self value isCloseTo: aFmlValue value]

{ #category : #testing }
FmlValue >> isConstant [
	^true]

{ #category : #testing }
FmlValue >> isInfinite [
	^false]

{ #category : #testing }
FmlValue >> isInfinity [
	^false]

{ #category : #testing }
FmlValue >> isInput [
	^true]

{ #category : #testing }
FmlValue >> isLeafNode [
	^true]

{ #category : #testing }
FmlValue >> isLiteral [
	^true]

{ #category : #testing }
FmlValue >> isMagicConstant [
	^true]

{ #category : #testing }
FmlValue >> isNumeric [
	^false]

{ #category : #testing }
FmlValue >> isSingleValued [
	^self class isSingleValued]

{ #category : #testing }
FmlValue >> isSummable [
	^false]

{ #category : #testing }
FmlValue >> isTableValued [
	^self class isTableValued]

{ #category : #testing }
FmlValue >> isZero [
	^false]

{ #category : #'array compatibility' }
FmlValue >> lastNegativeIfAbsent: defaultValue [
	^self cannotEvaluate: #lastNegative]

{ #category : #'array compatibility' }
FmlValue >> lastPositiveIfAbsent: defaultValue [
	^self cannotEvaluate: #lastPositive]

{ #category : #'array compatibility' }
FmlValue >> lastValue [
	^self]

{ #category : #evaluation }
FmlValue >> lazyEvaluate [
	^self]

{ #category : #functions }
FmlValue >> log: aFmlValue [
	^self cannotEvaluate: #log]

{ #category : #functions }
FmlValue >> lognormalBayesianLearningError: error
prevMean: mu0
prevSd: sd0
P90P10: q [
	| normal p sd sigma0 |
	self isNumber ifFalse: [
		^self
			argument: 'confidence'
			in: 'lognormalBayesianEvidence'
			shouldBe: FmlNumber].
	(self value between: 0.0 and: 1.0) ifFalse: [
		^self
			argument: 'confidence'
			in: 'lognormalBayesianEvidence'
			notBetween: 0
			and: 1].
	error isNumber
		ifFalse: [^self
			argument: 'error'
			in: 'lognormalBayesianEvidence'
			shouldBe: FmlNumber].
	error value > 0.0
		ifFalse: [^self
			nonPositiveArgument: 'error'
			in: 'lognormalBayesianEvidence'].
	mu0 isNumber
		ifFalse: [^self
			argument: 'mean0'
			in: 'lognormalBayesianEvidence'
			shouldBe: FmlNumber].
	sd0 isNumber
		ifFalse: [^self
			argument: 'sd0'
			in: 'lognormalBayesianEvidence'
			shouldBe: FmlNumber].
	sd0 value > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd0' in: 'lognormalBayesianEvidence'].
	q isNumber
		ifFalse: [^self
			argument: 'P90/P10'
			in: 'lognormalBayesianEvidence'
			shouldBe: FmlNumber].
	q value > 0.0
		ifFalse: [^self
			nonPositiveArgument: 'P90/P10'
			in: 'lognormalBayesianEvidence'].
	normal := NormalDistribution standard.
	p := normal percentile: 0.9.
	sd := q value ln / p / 2.0.
	sigma0 := ((mu0 value / sd0 value) squared + 1.0) ln sqrt.
	^self
		normalBayesianLearningError: error
		prevSd: sigma0 asFmlValue
		actualSd: sd asFmlValue]

{ #category : #arithmetic }
FmlValue >> max: anFmlValue [
	^anFmlValue performOperation: #max: receiverValue: self value]

{ #category : #'array compatibility' }
FmlValue >> maxValue [
	^self]

{ #category : #comparing }
FmlValue >> min: anFmlValue [
	^anFmlValue performOperation: #min: receiverValue: self value]

{ #category : #'array compatibility' }
FmlValue >> min: aMagnitude max: otherMagnitude [
	^self value min: aMagnitude max: otherMagnitude]

{ #category : #'array compatibility' }
FmlValue >> minValue [
	^self]

{ #category : #'date functions' }
FmlValue >> month [
	self cannotEvaluate: #month]

{ #category : #functions }
FmlValue >> newArray [
	^((1 to: self periodsSize) collect: [:i | self valueAt: i]) asArray asFmlValue]

{ #category : #functions }
FmlValue >> normalBayesianLearningError: error prevSd: sd0 actualSd: sd [
	| normal b n |
	self isNumber
		ifFalse: [^self
			argument: 'confidence'
			in: 'normalBayesianEvidence'
			shouldBe: FmlNumber].
	(self value between: 0.0 and: 1.0) ifFalse: [
		^self
			argument: 'confidence'
			in: 'normalBayesianEvidence'
			notBetween: 0
			and: 1].
	error isNumber
		ifFalse: [^self
			argument: 'error'
			in: 'normalBayesianEvidence'
			shouldBe: FmlNumber].
	error value > 0.0
		ifFalse: [^self nonPositiveArgument: 'error' in: 'normalBayesianEvidence'].
	sd0 isNumber
		ifFalse: [^self
			argument: 'sd0'
			in: 'normalBayesianEvidence'
			shouldBe: FmlNumber].
	sd0 value > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd0' in: 'normalBayesianEvidence'].
	sd isNumber
		ifFalse: [^self
			argument: 'sd'
			in: 'normalBayesianEvidence'
			shouldBe: FmlNumber].
	sd value > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd' in: 'normalBayesianEvidence'].
	normal := NormalDistribution standard
		inverseDistribution: self value + 1.0 / 2.0.
	b := sd value / sd0 value.
	n := (normal / error value) squared - b squared max: 0.0.
	^n asFmlValue]

{ #category : #'logical operations' }
FmlValue >> not [
	^self cannotEvaluate: #not]

{ #category : #'logical operations' }
FmlValue >> or: dummy [
	^self cannotEvaluate: #or]

{ #category : #perform }
FmlValue >> performFunction: symbol with: arg [
	^self performFunction: symbol withArgs: {arg}]

{ #category : #perform }
FmlValue >> performFunction: symbol withArgs: argArray atColumn: index [
	| cs |
	^(self respondsTo: (cs := self columnSelectorFor: symbol))
		ifTrue: [self perform: cs withArguments: (argArray copyWith: index)]
		ifFalse: [
			((self valueFrom: 1 to: index) asFmlValue
				performFunction: symbol
				withArgs: argArray)
				valueAt: index]]

{ #category : #perform }
FmlValue >> performOperation: aSymbol receiverValue: anObject [
	^(anObject perform: aSymbol with: self value) asFmlValue]

{ #category : #services }
FmlValue >> periodRates [
	| periodicity n rates |
	periodicity := self periodicity.
	periodicity isYearly ifTrue: [^self].
	n := periodicity periods.
	rates := FloatArray new: n.
	1 to: n do: [:i | | rate factor |
		rate := self valueAt: i.
		factor := periodicity factorAtPeriod: i.
		rates at: i put: rate / factor].
	^rates]

{ #category : #functions }
FmlValue >> periodXNPV: anFmlArray dates: fmlDateArray [
	| answer |
	anFmlArray isFmlArray
		ifFalse: [^FmlArray new: self periodsSize withAll: FmlUndefinedValue new].
	fmlDateArray isFmlArray
		ifFalse: [^FmlArray new: self periodsSize withAll: FmlUndefinedValue new].
	fmlDateArray hasDates
		ifFalse: [^self
			argument: 'dates'
			in: 'periodXNPV'
			shouldBeArrayOf: FmlDate].
	answer := FloatArray new: anFmlArray size.
	1 to: anFmlArray size do: [:i | 
		answer
			at: i
			put: (self periodXNPV: anFmlArray dates: fmlDateArray atColumn: i)].
	^answer asFmlValue]

{ #category : #functions }
FmlValue >> periodXNPV: anFmlArray dates: fmlDateArray atColumn: index [
	^self
		runningNPV: anFmlArray value
		rate: (self valueAt: index)
		dates: fmlDateArray value
		atColumn: index]

{ #category : #functions }
FmlValue >> periodXNPV: array
dates: dates
startDate: startDate
endDate: endDate [
	| fmlArray fmlDates answer sd ed |
	fmlArray := array asFmlValue.
	(fmlArray isArrayValued and: [fmlArray isNumeric])
		ifFalse: [^self
			argument: 'array'
			in: 'periodXNPVLimit'
			shouldBeArrayOf: FmlNumber].
	fmlDates := dates asFmlValue.
	(fmlDates isArrayValued and: [fmlDates hasDates])
		ifFalse: [^self
			argument: 'dates'
			in: 'periodXNPVLimit'
			shouldBeArrayOf: FmlDate].
	startDate isDate
		ifFalse: [^self
			argument: 'startDate'
			in: 'periodXNPVLimit'
			shouldBe: FmlDate].
	endDate isDate
		ifFalse: [^self
			argument: 'endDate'
			in: 'periodXNPVLimit'
			shouldBe: FmlDate].
	answer := FloatArray new: array size.
	sd := startDate value.
	ed := endDate value.
	1 to: array size do: [:i | 
		answer
			at: i
			put: (self
				periodXNPV: fmlArray
				dates: fmlDates
				startDate: sd
				endDate: ed
				atColumn: i)].
	^answer asFmlValue]

{ #category : #functions }
FmlValue >> periodXNPV: anFmlArray
dates: fmlDateArray
startDate: startDate
endDate: endDate
atColumn: index [
	^self
		runningNPV: anFmlArray value
		rate: (self valueAt: index)
		dates: fmlDateArray value
		startDate: startDate
		endDate: endDate
		atColumn: index]

{ #category : #'array compatibility' }
FmlValue >> previousValue: first [
	^self cannotEvaluate: #previousValue]

{ #category : #evaluation }
FmlValue >> resultType [
	^self class]

{ #category : #functions }
FmlValue >> runningNPV: anArray rate: rate dates: dateArray [
	^self
		runningNPV: anArray value
		rate: rate
		dates: dateArray value
		atColumn: (anArray size min: dateArray size)]

{ #category : #functions }
FmlValue >> runningNPV: anArray
rate: rate
dates: dateArray
atColumn: index [
	| npv base d1 pi di |
	npv := 0.0.
	rate ~ -1.0 ifTrue: [^FmlUndefinedValue new].
	base := 1.0 + rate.
	d1 := dateArray first value.
	1 to: index do: [:i | 
		pi := (anArray at: i) ifNil: [0.0].
		di := dateArray at: i.
		npv := npv + (pi / (base raisedTo: (di value subtractDate: d1) / 365.0))].
	^npv]

{ #category : #functions }
FmlValue >> runningNPV: anArray
rate: rate
dates: dateArray
startDate: startDate
endDate: endDate [
	^self
		runningNPV: anArray
		rate: rate
		dates: dateArray
		startDate: startDate
		endDate: endDate
		atColumn: anArray size]

{ #category : #functions }
FmlValue >> runningNPV: anArray
rate: rate
dates: dateArray
startDate: startDate
endDate: endDate
atColumn: index [
	| npv start |
	npv := 0.0.
	start := dateArray value positionOf: startDate value.
	start := start max: 1.
	start to: index do: [:i | | di rho pi ei |
		di := dateArray at: i.
		di <= endDate ifTrue: [
			rho := 1.0 + (rate valueAt: i).
			rho = 0.0 ifTrue: [^nil asFmlValue].
			pi := (anArray at: i) ifNil: [0.0].
			ei := (di value subtractDate: startDate) / 365.0.
			npv := pi / (rho raisedTo: ei) + npv]].
	^npv]

{ #category : #validation }
FmlValue >> setLiteralUnitsFrom: aUnit [
]

{ #category : #'array compatibility' }
FmlValue >> shiftLeft: first [
	^self cannotEvaluate: #shiftLeft]

{ #category : #'array compatibility' }
FmlValue >> shiftLeftFillWith: element positions: positions [
	^self cannotEvaluate: #positionsLeft]

{ #category : #'array compatibility' }
FmlValue >> shiftRight: first [
	^self cannotEvaluate: #shiftRight]

{ #category : #'array compatibility' }
FmlValue >> shiftRightFillWith: element positions: positions [
	^self cannotEvaluate: #positionsRight]

{ #category : #arithmetic }
FmlValue >> signedDistanceTo: aFmlValue [
	^self - aFmlValue]

{ #category : #accessing }
FmlValue >> size [
	^1]

{ #category : #functions }
FmlValue >> sl: life [
	^self cannotEvaluate: 'sl']

{ #category : #testing }
FmlValue >> supportsLogicalOperations [
	^self class supportsLogicalOperations]

{ #category : #functions }
FmlValue >> syd: life [
	^self cannotEvaluate: 'syd']

{ #category : #errors }
FmlValue >> table: arg shouldBe: fmlValueClass [
	^InvalidArgumentType
		signal: 'Argument <' , arg , '> should contain entries of type '
			, fmlValueClass typeName]

{ #category : #functions }
FmlValue >> tableLookupTable: t searchColumn: s returnColumn: r [
	| table column key index |
	table := t value.
	column := table column: s value asInteger.
	column isEmpty ifTrue: [^FmlUndefinedValue new].
	key := self value.
	index := (((column conform: [:v | v isNumber]) and: [key isNumber])
		or: [(column conform: [:v | v isDate]) and: [key isDate]])
		ifTrue: [
			column isIncreasing
				ifTrue: [column findLast: [:v | v <~ key] ifAbsent: [1]]
				ifFalse: [column
					findFirst: [:v | v = key]
					ifAbsent: [^FmlUndefinedValue new]]]
		ifFalse: [column
			findFirst: [:v | v = key]
			ifAbsent: [^FmlUndefinedValue new]].
	^(r asFmlValue columnValueIn: table row: index) asFmlValue]

{ #category : #'translation to Excel' }
FmlValue >> translateUsing: anFmlTranslator [
	^anFmlTranslator translateValue: self value]

{ #category : #'translation to Excel' }
FmlValue >> translateUsing: anFmlExcelTranslator atColumn: index [
	| v |
	v := self valueAt: index.
	^anFmlExcelTranslator translateValue: v]

{ #category : #accessing }
FmlValue >> value [
	self subclassResponsibility]

{ #category : #accessing }
FmlValue >> value: anObject [
	self subclassResponsibility]

{ #category : #accessing }
FmlValue >> valueAt: index [
	^self value]

{ #category : #accessing }
FmlValue >> valueAt: index put: anObject [
	self value: anObject.
	^anObject]

{ #category : #'array compatibility' }
FmlValue >> valueAtIndex: aFmlValue [
	^self]

{ #category : #accessing }
FmlValue >> valueFrom: startIndex to: stopIndex [
	^self value]

{ #category : #functions }
FmlValue >> vLookupTable: fmlTable returnColumn: index [
	^self
		tableLookupTable: fmlTable
		searchColumn: 1 asFmlValue
		returnColumn: index]

{ #category : #functions }
FmlValue >> xIRR: dummy [
	^self cannotEvaluate: #xIRR]

{ #category : #functions }
FmlValue >> xNPV: fmlArray dates: dates [
	self cannotEvaluate: #xNPV]

{ #category : #'date functions' }
FmlValue >> year [
	self cannotEvaluate: #year]

{ #category : #functions }
FmlValue >> yearlyNPV: array [
	| fmlArray n answer npv exp rates |
	fmlArray := array asFmlValue.
	(fmlArray isArrayValued and: [fmlArray isNumeric])
		ifFalse: [^self
			argument: 'array'
			in: 'yearlyNPV'
			shouldBeArrayOf: FmlNumber].
	n := fmlArray size.
	answer := FloatArray new: n.
	npv := 0.0.
	exp := 1.0.
	rates := self periodRates.
	1 to: n do: [:i | | rate cashflow |
		rate := rates valueAt: i.
		exp := exp * (1 + rate).
		cashflow := fmlArray valueAt: i.
		npv := cashflow / exp + npv.
		answer at: i put: npv].
	^answer asFmlValue]

{ #category : #functions }
FmlValue >> yearlyNPV: anFmlArray atColumn: index [
	| npv exp rates |
	npv := 0.0.
	exp := 1.0.
	rates := self periodRates.
	1 to: index do: [:i | | rate cashflow |
		rate := rates valueAt: i.
		exp := exp * (1 + rate).
		cashflow := anFmlArray valueAt: i.
		npv := cashflow / exp + npv].
	^npv]

{ #category : #services }
FmlValue >> zero [
	^FmlUndefinedValue new]

{ #category : #services }
FmlValue >> zeroArray [
	^FloatArray new: self periodsSize]

