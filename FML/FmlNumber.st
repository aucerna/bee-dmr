"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlNumber,
	#superclass : #FmlValue,
	#instVars : [
		'number',
		'unit'
	],
	#category : #FML
}

{ #category : #testing }
FmlNumber class >> isSummable [
	^true]

{ #category : #'instance creation' }
FmlNumber class >> on: aNumber [
	"
	123 asValue
	"
	^aNumber asFloat isNaN
		ifTrue: [FmlUndefinedValue new]
		ifFalse: [self new number: aNumber]]

{ #category : #'instance creation' }
FmlNumber class >> percent: aNumber [
	^self on: aNumber * 100]

{ #category : #testing }
FmlNumber class >> supportsLogicalOperations [
	^true]

{ #category : #constants }
FmlNumber class >> typeName [
	^'Number']

{ #category : #arithmetic }
FmlNumber >> - anFmlValue [
	anFmlValue isNumeric ifFalse: [^self argumentIn: '-' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'-' receiverValue: self value]

{ #category : #arithmetic }
FmlNumber >> * anFmlValue [
	anFmlValue isNumeric ifFalse: [^self argumentIn: '*' shouldBe: FmlNumber].
	^(anFmlValue isKindOf: FmlValue)
		ifTrue: [anFmlValue performOperation: #'*' receiverValue: self value]
		ifFalse: [self value * anFmlValue]]

{ #category : #arithmetic }
FmlNumber >> / anFmlValue [
	anFmlValue isNumeric ifFalse: [^self argumentIn: '-' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'/' receiverValue: self value]

{ #category : #arithmetic }
FmlNumber >> // anFmlValue [
	anFmlValue isNumeric ifFalse: [^self argumentIn: '//' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'//' receiverValue: self value]

{ #category : #functions }
FmlNumber >> @ anFmlValue [
	^self value @ anFmlValue value]

{ #category : #arithmetic }
FmlNumber >> \\ anFmlValue [
	anFmlValue isNumeric ifFalse: [^self argumentIn: '\\' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'\\' receiverValue: self value]

{ #category : #arithmetic }
FmlNumber >> + anFmlValue [
	anFmlValue isSummable ifFalse: [^self argumentIn: '+' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'+' receiverValue: self value]

{ #category : #comparing }
FmlNumber >> < anFmlValue [
	"
	1 asFmlValue < 3 asFmlValue
	1 asFmlValue < 3.0 asFmlValue
	1 asFmlValue < #(1 2 3) asFmlValue
	1 asFmlValue < Date today asFmlValue
	"
	anFmlValue isNumeric ifFalse: [^self argumentIn: #'<' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'<' receiverValue: self value]

{ #category : #comparing }
FmlNumber >> <= anFmlValue [
	"
	1 asFmlValue <= 3 asFmlValue
	1 asFmlValue <= 3.0 asFmlValue
	1 asFmlValue <=#(1 2 3) asFmlValue
	"
	anFmlValue isNumeric ifFalse: [^self argumentIn: #'<=' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'<=' receiverValue: self value]

{ #category : #comparing }
FmlNumber >> = anObject [
	^super = anObject and: [self unit = anObject unit]]

{ #category : #comparing }
FmlNumber >> > anFmlValue [
	"
	1 asFmlValue > 3 asFmlValue
	1 asFmlValue > 3.0 asFmlValue
	1 asFmlValue > #(1 2 3) asFmlValue
	"
	anFmlValue isNumeric ifFalse: [^self argumentIn: #'>' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'>' receiverValue: self value]

{ #category : #comparing }
FmlNumber >> >= anFmlValue [
	"
	1 asFmlValue >= 3 asFmlValue
	1 asFmlValue >= 3.0 asFmlValue 
	1 asFmlValue >=#(1 	2 3) asFmlValue
	"
	anFmlValue isNumeric ifFalse: [^self argumentIn: #'>=' shouldBe: FmlNumber].
	^anFmlValue performOperation: #'>=' receiverValue: self value]

{ #category : #arithmetic }
FmlNumber >> abs [
	^self value abs asFmlValue]

{ #category : #visiting }
FmlNumber >> acceptVisitor: fmlVisitor [
	fmlVisitor visitFmlNumber: self]

{ #category : #validation }
FmlNumber >> addMagicConstantsTo: aCollection [
	self isMagicConstant ifFalse: [^self].
	(self unit notNil and: [self unit allowsMagicConstants]) ifTrue: [^self].
	aCollection add: self]

{ #category : #validation }
FmlNumber >> addNumericLiteralsTo: aCollection [
	aCollection add: self]

{ #category : #'logical operations' }
FmlNumber >> and: fmlValue [
	^self asBoolean and: fmlValue]

{ #category : #converting }
FmlNumber >> asBoolean [
	^FmlBoolean on: number != 0]

{ #category : #converting }
FmlNumber >> asFloat [
	^self value asFloat]

{ #category : #converting }
FmlNumber >> asInteger [
	^self value asInteger]

{ #category : #converting }
FmlNumber >> asNumber [
	^self asFloat]

{ #category : #functions }
FmlNumber >> average: anArray [
	| array arg invalid sum |
	array := anArray isArray ifTrue: [anArray] ifFalse: [{anArray}].
	array isEmpty ifTrue: [^self].
	arg := array detect: [:x | x class == FmlArray] ifNone: nil.
	arg notNil ifTrue: [| rcvr |
		rcvr := Array new: arg size.
		rcvr atAllPut: self value.
		^rcvr asFmlValue average: array].
	invalid := array
		findFirst: [:x | x isNumber not andNot: [x isUndefinedValue]]
		ifAbsent: nil.
	invalid isNil ifFalse: [
		^self
			argument: 'value' , (invalid + 1) printString
			in: 'average'
			shouldBe: FmlNumber].
	sum := array sum: #value.
	^(self value + sum / (array size + 1)) asFmlValue]

{ #category : #accessing }
FmlNumber >> basicUnit [
	^unit]

{ #category : #accessing }
FmlNumber >> basicValue [
	^number]

{ #category : #evaluation }
FmlNumber >> bindContext: aModelObject [
	unit isString ifTrue: [self unitName: unit]]

{ #category : #testing }
FmlNumber >> canBeConsideredPercent [
	^(number between: 0.0 and: 1.0)]

{ #category : #arithmetic }
FmlNumber >> ceiling [
	^self value ceiling asFmlValue]

{ #category : #functions }
FmlNumber >> columnIndexInTable: anFmlTable [
	^number]

{ #category : #functions }
FmlNumber >> date: month day: day [
	month isNumeric
		ifFalse: [^self argument: 'month' in: 'date' shouldBe: FmlNumber].
	day isNumeric
		ifFalse: [^self argument: 'day' in: 'date' shouldBe: FmlNumber].
	^month day: day year: self]

{ #category : #functions }
FmlNumber >> day: day year: year [
	^day month: self year: year]

{ #category : #'date functions' }
FmlNumber >> daysInYear [
	self ASSERT: false.
	^(Date newDay: 1 monthIndex: 1 year: self value) daysInYear asFmlValue]

{ #category : #functions }
FmlNumber >> discountFactors [
	| answer base factor |
	answer := FloatArray new: self periodsSize.
	base := 1.0 + self value.
	factor := 1.0.
	1 to: self periodsSize do: [:i | 
		answer at: i put: factor.
		factor := factor / base].
	^answer asFmlValue]

{ #category : #printing }
FmlNumber >> displayString [
	^number displayString]

{ #category : #accessing }
FmlNumber >> displayValue [
	^number]

{ #category : #private }
FmlNumber >> distribution: aProbabilityDistribution cumulative: aBoolean [
	^aBoolean value
		ifTrue: [aProbabilityDistribution distribution: self value]
		ifFalse: [aProbabilityDistribution density: self value]]

{ #category : #comparing }
FmlNumber >> equals: anFmlValue [
	"
	1 asFmlValue equals: 1 asFmlValue 1 asFmlValue equals: #( 1 2 3 ) asFmlValue
	1 asFmlValue equals: #( 1 2 ) asFmlValue 1 asFmlValue equals: #( 1 2 3 4 )asFmlValue
	1 asFmlValue equals: #( 1 2 ) asFmlValue 1 asFmlValue equals: #( 1 2 0 0 )asFmlValue
	"
	^anFmlValue performOperation: #'=' receiverValue: self value]

{ #category : #functions }
FmlNumber >> escalate: rate [
	| periodicity n array v s |
	rate isNumeric
		ifFalse: [^self argument: 'rate' in: 'escalate' shouldBe: FmlNumber].
	rate isTableValued
		ifTrue: [^self argument: 'rate' in: 'escalate' shouldNotBe: FmlTable].
	periodicity := self periodicity.
	n := periodicity periods.
	array := FloatArray new: n.
	v := self value.
	array atValid: 1 put: v.
	s := 1.0.
	2 to: n do: [:i | | f ri si |
		f := periodicity factorAtPeriod: i - 1.
		ri := rate valueAt: i.
		si := ri + 1.0 raisedTo: f reciprocal.
		s := s * si.
		array atValid: i put: s * v].
	^array asFmlValue]

{ #category : #functions }
FmlNumber >> escalateReference: rate logic: bit [
	| periodicity n answer k b |
	periodicity := self periodicity.
	n := periodicity periods.
	b := bit value.
	b = 0 ifTrue: [b := false].
	b = 1 ifTrue: [b := true].
	b isBoolean ifFalse: [^FmlArray new: n withAll: FmlUndefinedValue new].
	rate isNumeric
		ifFalse: [^self argument: 'rate' in: 'escalate' shouldBe: FmlNumber].
	answer := FloatArray new: n.
	k := self value asInteger.
	1 to: n do: [:i | 
		answer at: i put: ((b or: [i >= k])
			ifTrue: [
				((rate valueAt: i) / (periodicity factorAtPeriod: i) + 1.0) value
					raisedToInteger: i - k]
			ifFalse: [1.0])].
	^answer asFmlValue]

{ #category : #accessing }
FmlNumber >> evaluated [
	number := number value]

{ #category : #arithmetic }
FmlNumber >> floor [
	^self value floor asFmlValue]

{ #category : #functions }
FmlNumber >> geometricMean: anArray [
	| value array invalid mu |
	value := self value.
	array := anArray isArray ifTrue: [anArray] ifFalse: [{anArray}].
	invalid := array findFirst: [:x | x isNumber not] ifAbsent: nil.
	invalid isNil ifFalse: [
		^self
			argument: 'value' , (invalid + 1) printString
			in: 'geometricMean'
			shouldBe: FmlNumber].
	value < 0 ifTrue: [^self nonPositiveArgument: 'value1' in: 'geometricMean'].
	invalid := array findFirst: [:x | x value < 0] ifAbsent: nil.
	invalid isNil ifFalse: [
		^self
			nonPositiveArgument: 'value' , (invalid + 1) printString
			in: 'geometricMean'].
	(value = 0 or: [array anySatisfy: [:x | x value = 0]])
		ifTrue: [^0 asFmlValue].
	array := anArray collect: [:x | x value ln asFmlValue].
	mu := value ln asFmlValue average: array.
	^mu value exp asFmlValue]

{ #category : #comparing }
FmlNumber >> hash [
	^number hashWith: unit]

{ #category : #testing }
FmlNumber >> hasNumericLiterals [
	^true]

{ #category : #testing }
FmlNumber >> hasValidUnit [
	^unit notNil and: [unit isString not] and: [unit isActive]]

{ #category : #accessing }
FmlNumber >> inferredUnit [
	^unit isString ifFalse: [unit]]

{ #category : #accessing }
FmlNumber >> invalidateUnit [
	unit := nil]

{ #category : #functions }
FmlNumber >> inverseAt: fmlArray [
	^(self value < 1
		ifTrue: [0]
		ifFalse: [fmlArray valueAt: self value asInteger])
		asFmlValue]

{ #category : #private }
FmlNumber >> inverseLognormal: aLognormalDistribution mean: mean sd: sd [
	(number between: 0.0 and: 1.0) ifFalse: [^nil].
	mean isNumber ifFalse: [^nil].
	sd isNumber ifFalse: [^nil].
	sd > 0.0 ifFalse: [^nil].
	aLognormalDistribution mean: mean deviation: sd.
	^aLognormalDistribution inverseDistribution: number]

{ #category : #functions }
FmlNumber >> inverseLognormal: mean sd: sd [
	| n inverse |
	mean isArrayValued ifTrue: [n := mean size].
	sd isArrayValued ifTrue: [n := sd size].
	inverse := n isNil
		ifTrue: [self singleInverseLognormal: mean sd: sd]
		ifFalse: [| rcvr |
			rcvr := FmlArray new: n withAll: self value.
			rcvr inverseLognormal: mean sd: sd].
	^inverse asFmlValue]

{ #category : #private }
FmlNumber >> inverseNormal: aNormalDistribution mean: mean sd: sd [
	mean isNumber ifFalse: [^nil].
	sd isNumber ifFalse: [^nil].
	sd > 0.0 ifFalse: [^nil].
	aNormalDistribution mean: mean deviation: sd.
	^aNormalDistribution inverseDistribution: number]

{ #category : #functions }
FmlNumber >> inverseNormal: mean sd: sd [
	| n inverse |
	mean isArrayValued ifTrue: [n := mean size].
	sd isArrayValued ifTrue: [n := sd size].
	inverse := n isNil
		ifTrue: [self singleInverseNormal: mean sd: sd]
		ifFalse: [| rcvr |
			rcvr := FmlArray new: n withAll: self value.
			rcvr inverseNormal: mean sd: sd].
	^inverse asFmlValue]

{ #category : #private }
FmlNumber >> inverseTriangular: aTriangularDistribution
left: a
mid: c
right: b [
	(number between: 0.0 and: 1.0) ifFalse: [^nil].
	a isNumber ifFalse: [^nil].
	c isNumber ifFalse: [^nil].
	b isNumber ifFalse: [^nil].
	a < c ifFalse: [^nil].
	c < b ifFalse: [^nil].
	aTriangularDistribution left: a mid: c right: b.
	^aTriangularDistribution inverseDistribution: number]

{ #category : #functions }
FmlNumber >> inverseTriangular: a mid: c max: b [
	| n inverse |
	a isArrayValued ifTrue: [n := a size].
	c isArrayValued ifTrue: [n := c size].
	b isArrayValued ifTrue: [n := b size].
	inverse := n isNil
		ifTrue: [self singleInverseTriangular: a mid: c max: b]
		ifFalse: [| rcvr |
			rcvr := FmlArray new: n withAll: self value.
			rcvr inverseTriangular: a mid: c max: b].
	^inverse asFmlValue]

{ #category : #testing }
FmlNumber >> isInfinite [
	^number isInfinite]

{ #category : #testing }
FmlNumber >> isInfinity [
	^number isInfinity]

{ #category : #comparing }
FmlNumber >> isLike: anObject [
	| u1 u2 |
	(super isLike: anObject) ifFalse: [^false].
	u1 := self unit.
	u2 := anObject unit.
	u1 = u2 ifTrue: [^true].
	u1 isNil ifTrue: [^u2 isMultiplicativeIdentity].
	u2 isNil ifTrue: [^u1 isMultiplicativeIdentity].
	^u1 isMultiplicativeIdentity and: [u2 isMultiplicativeIdentity]]

{ #category : #testing }
FmlNumber >> isMagicConstant [
	^unit isNil and: [number ~= 0.0]]

{ #category : #testing }
FmlNumber >> isNaN [
	^number isNaN]

{ #category : #testing }
FmlNumber >> isNumber [
	^true]

{ #category : #testing }
FmlNumber >> isNumeric [
	^true]

{ #category : #testing }
FmlNumber >> isSummable [
	^true]

{ #category : #testing }
FmlNumber >> isZero [
	^self value = Float zero]

{ #category : #functions }
FmlNumber >> log: anFmlValue [
	anFmlValue isNumeric ifFalse: [^self argumentIn: 'log' shouldBe: FmlNumber].
	anFmlValue value > 0.0
		ifFalse: [^self nonPositiveArgument: 'base' in: 'log'].
	self value > 0.0 ifFalse: [^self nonPositiveArgument: 'value' in: 'log'].
	^(self value log: anFmlValue value) asFmlValue]

{ #category : #functions }
FmlNumber >> lognormal: aLogNormalDistribution
mean: mean
sd: sd
cumulative: aBoolean [
	mean isNumber ifFalse: [^nil].
	mean value > 0.0 ifFalse: [^nil].
	sd isNumber ifFalse: [^nil].
	sd > 0.0 ifFalse: [^nil].
	aBoolean isBoolean ifFalse: [^nil].
	aLogNormalDistribution mean: mean deviation: sd.
	^self distribution: aLogNormalDistribution cumulative: aBoolean]

{ #category : #functions }
FmlNumber >> lognormal: mean sd: sd cumulative: aBoolean [
	| n lognormal |
	mean isArrayValued ifTrue: [n := mean size].
	sd isArrayValued ifTrue: [n := sd size].
	aBoolean isArrayValued ifTrue: [n := aBoolean size].
	lognormal := n isNil
		ifTrue: [self singleLognormal: mean sd: sd cumulative: aBoolean]
		ifFalse: [| rcvr |
			rcvr := FmlArray new: n withAll: self value.
			rcvr lognormal: mean sd: sd cumulative: aBoolean].
	^lognormal asFmlValue]

{ #category : #functions }
FmlNumber >> lognormalMeanOfNormalSd: sd [
	| mu sigma data |
	mu := self value.
	mu isNumber
		ifFalse: [^self
			argument: 'mean'
			in: 'lognormalMeanOfNormal'
			shouldBe: FmlNumber].
	sd isNumber
		ifFalse: [^self
			argument: 'sd'
			in: 'lognormalMeanOfNormal'
			shouldBe: FmlNumber].
	sigma := sd value.
	sigma > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd' in: 'lognormalMeanOfNormal'].
	data := LogNormalDistribution normalToLogMu: mu sigma: sigma.
	^data first]

{ #category : #functions }
FmlNumber >> lognormalSdOfNormalSd: sd [
	| mu sigma data |
	mu := self value.
	mu isNumber
		ifFalse: [^self
			argument: 'mean'
			in: 'lognormalSdOfNormal'
			shouldBe: FmlNumber].
	sd isNumber
		ifFalse: [^self
			argument: 'sd'
			in: 'lognormalSdOfNormal'
			shouldBe: FmlNumber].
	sigma := sd value.
	sigma > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd' in: 'lognormalSdOfNormal'].
	data := LogNormalDistribution normalToLogMu: mu sigma: sigma.
	^data second]

{ #category : #comparing }
FmlNumber >> max: anFmlValue [
	anFmlValue isNumeric ifFalse: [^self argumentIn: #max shouldBe: FmlNumber].
	^super max: anFmlValue]

{ #category : #comparing }
FmlNumber >> min: anFmlValue [
	anFmlValue isNumeric ifFalse: [^self argumentIn: #min shouldBe: FmlNumber].
	^super min: anFmlValue]

{ #category : #functions }
FmlNumber >> month: month year: year [
	| answer m d y last |
	d := self asInteger.
	m := month asInteger.
	y := year asInteger.
	(m between: 1 and: 12) ifFalse: [
		^self
			argument: 'month'
			in: 'date'
			notBetween: 1
			and: 12].
	last := Date daysInMonth: m forYear: y.
	(d between: 1 and: last) ifFalse: [
		^self
			argument: 'day'
			in: 'date'
			notBetween: 1
			and: last].
	answer := [Date newDay: d monthIndex: m year: year asInteger]
		on: Error
		do: [:e | e return: FmlUndefinedValue new].
	^answer asFmlValue]

{ #category : #arithmetic }
FmlNumber >> negate [
	number := -1 * number]

{ #category : #arithmetic }
FmlNumber >> negated [
	^self value negated asFmlValue]

{ #category : #private }
FmlNumber >> normal: aNormalDistribution
mean: mean
sd: sd
cumulative: aBoolean [
	mean isNumber ifFalse: [^nil].
	sd isNumber ifFalse: [^nil].
	sd > 0.0 ifFalse: [^nil].
	aBoolean isBoolean ifFalse: [^nil].
	aNormalDistribution mean: mean deviation: sd.
	^self distribution: aNormalDistribution cumulative: aBoolean]

{ #category : #functions }
FmlNumber >> normal: mean sd: sd cumulative: aBoolean [
	| n normal |
	mean isArrayValued ifTrue: [n := mean size].
	sd isArrayValued ifTrue: [n := sd size].
	aBoolean isArrayValued ifTrue: [n := aBoolean size].
	normal := n isNil
		ifTrue: [self singleNormal: mean sd: sd cumulative: aBoolean]
		ifFalse: [| rcvr |
			rcvr := FmlArray new: n withAll: self value.
			rcvr normal: mean sd: sd cumulative: aBoolean].
	^normal asFmlValue]

{ #category : #functions }
FmlNumber >> normalMeanOfLognormalSd: sd [
	| mu sigma data |
	mu := self value.
	mu isNumber
		ifFalse: [^self
			argument: 'mean'
			in: 'normalMeanOfLognormal'
			shouldBe: FmlNumber].
	mu > 0.0
		ifFalse: [^self nonPositiveArgument: 'mean' in: 'normalMeanOfLognormal'].
	sd isNumber
		ifFalse: [^self
			argument: 'sd'
			in: 'normalMeanOfLognormal'
			shouldBe: FmlNumber].
	sigma := sd value.
	sigma > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd' in: 'normalMeanOfLognormal'].
	data := LogNormalDistribution logToNormalMu: mu sigma: sigma.
	^data first]

{ #category : #functions }
FmlNumber >> normalSdOfLognormalSd: sd [
	| mu sigma data |
	mu := self value.
	mu isNumber
		ifFalse: [^self
			argument: 'mean'
			in: 'normalSdOfLognormal'
			shouldBe: FmlNumber].
	mu > 0.0
		ifFalse: [^self nonPositiveArgument: 'mean' in: 'normalSdOfLognormal'].
	sd isNumber
		ifFalse: [^self
			argument: 'sd'
			in: 'normalSdOfLognormal'
			shouldBe: FmlNumber].
	sigma := sd value.
	sigma > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd' in: 'normalSdOfLognormal'].
	data := LogNormalDistribution logToNormalMu: mu sigma: sigma.
	^data second]

{ #category : #'logical operations' }
FmlNumber >> not [
	^self asBoolean not]

{ #category : #functions }
FmlNumber >> npv: array [
	| fml |
	fml := array asFmlValue.
	(fml isArrayValued and: [fml isNumeric])
		ifFalse: [^self argument: 'array' in: 'npv' shouldBeArrayOf: FmlNumber].
	^fml npvRate: self]

{ #category : #accessing }
FmlNumber >> number: aNumber [
	number := aNumber]

{ #category : #'logical operations' }
FmlNumber >> or: fmlValue [
	^self asBoolean or: fmlValue]

{ #category : #functions }
FmlNumber >> payment: n
pv: presentValue
fv: futureValue
type: type [
	| power t value |
	t := type value.
	value := self value.
	(t = 1.0 or: [t = 0.0]) ifFalse: [^FmlUndefinedValue new].
	presentValue isNumber
		ifFalse: [^self
			argument: 'present value'
			in: 'payment'
			shouldBe: FmlNumber].
	futureValue isNumber
		ifFalse: [^self
			argument: 'present value'
			in: 'payment'
			shouldBe: FmlNumber].
	value = 0.0 ifTrue: [^(futureValue + presentValue / n) negated asFmlValue].
	power := 1.0 + value raisedTo: n value.
	^(futureValue + (presentValue * power)
		/ (power - 1.0 / value * (1.0 + (value * t))))
		negated
		asFmlValue]

{ #category : #functions }
FmlNumber >> paymentCF: n
pv: presentValue
fv: futureValue
type: type
firstPeriod: firstPeriod [
	| pmt answer period |
	(type value = 1.0 or: [type value = 0.0]) ifFalse: [^FmlUndefinedValue new].
	period := firstPeriod value.
	period + n value > self periodsSize ifTrue: [
		^FmlEvaluationError
			signal: 'periods + firstPeriod exceeds the number of project years'].
	presentValue isNumber
		ifFalse: [^self
			argument: 'present value'
			in: 'paymentCF'
			shouldBe: FmlNumber].
	futureValue isNumber
		ifFalse: [^self
			argument: 'present value'
			in: 'paymentCF'
			shouldBe: FmlNumber].
	pmt := (self
		payment: n
		pv: presentValue
		fv: futureValue
		type: type) value.
	answer := self zeroArray.
	period + 1 to: period + n value do: [:i | answer at: i asInteger put: pmt].
	answer
		at: period asInteger sum: presentValue value;
		at: (period + n value) asInteger sum: futureValue value.
	^answer asFmlValue]

{ #category : #perform }
FmlNumber >> performFunction: function withArgs: argsArray [
	(self respondsTo: function)
		ifTrue: [^self perform: function withArguments: argsArray].
	argsArray isEmpty
		ifTrue: [^(self value performFunction: function withArgs: argsArray) asFmlValue].
	argsArray size = 1 ifTrue: [
		^argsArray first asFmlValue
			performOperation: function
			receiverValue: self value].
	InvalidArgumentType
		signal: 'Function ' , function , ' cannot operate on Numbers']

{ #category : #arithmetic }
FmlNumber >> raisedTo: anFmlValue [
	^anFmlValue performOperation: #raisedTo: receiverValue: self value]

{ #category : #arithmetic }
FmlNumber >> reciprocal [
	"
	10 asFmlValue reciprocal
	"
	^self value reciprocal asFmlValue]

{ #category : #comparing }
FmlNumber >> relativeDistanceTo: anFmlValue [
	"
	1.0 asFmlValue relativeDistanceTo: 3.0 asFmlValue
	1.0 asFmlValue relativeDistanceTo: #(1 2 3) asFmlValue
	"
	^anFmlValue
		performOperation: #relativeDistanceTo:
		receiverValue: self value]

{ #category : #comparing }
FmlNumber >> relativeIncrementFrom: anFmlValue [
	"
	1.0 asFmlValue relativeIncrementFrom: 3.0 asFmlValue
	1.0 asFmlValue relativeIncrementFrom: #(1 2 3) asFmlValue
	"
	^anFmlValue
		performOperation: #relativeIncrementFrom:
		receiverValue: self value]

{ #category : #'units support' }
FmlNumber >> replaceReferencedUnitsUsing: aDictionary [
	| u |
	u := aDictionary at: unit ifAbsent: [^self].
	number := u convert: self value.
	unit := u]

{ #category : #arithmetic }
FmlNumber >> roundDigits: anInteger [
	anInteger value >= 0.0
		ifFalse: [self nonPositiveArgument: 'digits' in: 'round'].
	^(self value roundDigits: anInteger) asFmlValue]

{ #category : #functions }
FmlNumber >> runningCum [
	^self asArray runningCum]

{ #category : #validation }
FmlNumber >> setLiteralUnitsFrom: aUnit [
	unit notNil ifTrue: [^self].
	unit := (aUnit notNil and: [aUnit isNumeric])
		ifTrue: [aUnit type constantsUnit]]

{ #category : #printing }
FmlNumber >> showsUnitOn: aStream [
	unit isNil ifTrue: [^false].
	unit isString ifTrue: [^true].
	^(unit isNumberUnit or: [unit displayName isEmpty])
		ifTrue: [aStream isKindOf: Stream]
		ifFalse: [true]]

{ #category : #accessing }
FmlNumber >> sign [
	^number sign]

{ #category : #functions }
FmlNumber >> singleInverseLognormal: mean sd: sd [
	(self value between: 0.0 and: 1.0) ifFalse: [
		^self
			argument: 'value'
			in: 'inverseLognormal'
			notBetween: 0
			and: 1].
	mean isNumber
		ifFalse: [^self
			argument: 'mean'
			in: 'inverseLognormal'
			shouldBe: FmlNumber].
	mean value > 0.0
		ifFalse: [^self nonPositiveArgument: 'mean' in: 'inverseLognormal'].
	sd isNumber
		ifFalse: [^self argument: 'sd' in: 'inverseLognormal' shouldBe: FmlNumber].
	sd value > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd' in: 'inverseLognormal'].
	^self
		inverseLognormal: LogNormalDistribution new
		mean: mean value
		sd: sd value]

{ #category : #functions }
FmlNumber >> singleInverseNormal: mean sd: sd [
	(self value between: 0.0 and: 1.0) ifFalse: [
		^self
			argument: 'probability'
			in: 'inverseNormal'
			notBetween: 0
			and: 1].
	mean isNumber
		ifFalse: [^self argument: 'mean' in: 'inverseNormal' shouldBe: FmlNumber].
	sd isNumber
		ifFalse: [^self argument: 'sd' in: 'inverseNormal' shouldBe: FmlNumber].
	sd value > 0.0
		ifFalse: [^self nonPositiveArgument: 'sd' in: 'inverseNormal'].
	^self inverseNormal: NormalDistribution new mean: mean value sd: sd value]

{ #category : #functions }
FmlNumber >> singleInverseTriangular: a mid: c max: b [
	(self value between: 0.0 and: 1.0) ifFalse: [
		^self
			argument: 'value'
			in: 'inverseTriangular'
			notBetween: 0
			and: 1].
	a isNumber
		ifFalse: [^self
			argument: 'min'
			in: 'inverseTriangular'
			shouldBe: FmlNumber].
	c isNumber
		ifFalse: [^self
			argument: 'mid'
			in: 'inverseTriangular'
			shouldBe: FmlNumber].
	b isNumber
		ifFalse: [^self
			argument: 'max'
			in: 'inverseTriangular'
			shouldBe: FmlNumber].
	(a value < c value and: [c value < b value]) ifFalse: [
		^self
			argument: 'mid'
			in: 'inverseTriangular'
			notBetween: a
			and: b].
	^self
		inverseTriangular: TriangularDistribution new
		left: a value
		mid: c value
		right: b value]

{ #category : #functions }
FmlNumber >> singleLognormal: mean sd: sd cumulative: aBoolean [
	mean isNumber
		ifFalse: [^self argument: 'mean' in: 'lognormal' shouldBe: FmlNumber].
	mean value > 0.0
		ifFalse: [^self nonPositiveArgument: 'mean' in: 'lognormal'].
	sd isNumber
		ifFalse: [^self argument: 'sd' in: 'lognormal' shouldBe: FmlNumber].
	sd value > 0.0 ifFalse: [^self nonPositiveArgument: 'sd' in: 'lognormal'].
	aBoolean isLogical
		ifFalse: [^self
			argument: 'cumulative'
			in: 'lognormal'
			shouldBe: FmlBoolean].
	^self
		lognormal: LogNormalDistribution new
		mean: mean value
		sd: sd value
		cumulative: aBoolean value]

{ #category : #functions }
FmlNumber >> singleNormal: mean sd: sd cumulative: aBoolean [
	mean isNumber
		ifFalse: [^self argument: 'mean' in: 'normal' shouldBe: FmlNumber].
	sd isNumber
		ifFalse: [^self argument: 'sd' in: 'normal' shouldBe: FmlNumber].
	sd value > 0.0 ifFalse: [^self nonPositiveArgument: 'sd' in: 'normal'].
	aBoolean isLogical
		ifFalse: [^self argument: 'cumulative' in: 'normal' shouldBe: FmlBoolean].
	^self
		normal: NormalDistribution new
		mean: mean value
		sd: sd value
		cumulative: aBoolean value]

{ #category : #arithmetic }
FmlNumber >> sqrt [
	^self value sqrt asFmlValue]

{ #category : #arithmetic }
FmlNumber >> squared [
	^self value squared asFmlValue]

{ #category : #arithmetic }
FmlNumber >> squaredDifference: anObject [
	^(self value squaredDifference: anObject asFloat) asFmlValue]

{ #category : #functions }
FmlNumber >> tableRollupTable: fmlTable searchColumn: searchColumn factorColumn: factorColumn [
	^(fmlTable
		basicTableRollup: self value
		searchColumn: searchColumn value asInteger
		factorColumn: factorColumn value asInteger) asFmlValue]

{ #category : #'translation to Excel' }
FmlNumber >> translateUsing: anFmlTranslator [
	^anFmlTranslator translateValue: number]

{ #category : #arithmetic }
FmlNumber >> truncated [
	^self value truncated asFmlValue]

{ #category : #accessing }
FmlNumber >> unit: aUnit [
	self ASSERT: aUnit isNumeric.
	unit := aUnit]

{ #category : #accessing }
FmlNumber >> unitName [
	^unit notNil ifTrue: [unit isString ifTrue: [unit] ifFalse: [unit name]]]

{ #category : #'units support' }
FmlNumber >> usedUnitsDo: aBlock [
	unit notNil ifTrue: [aBlock value: unit]]

{ #category : #accessing }
FmlNumber >> value [
	| u |
	u := self unit.
	^u isNil ifTrue: [number] ifFalse: [number unitsOf: u]]

{ #category : #accessing }
FmlNumber >> value: anObject [
	self number: anObject]

{ #category : #functions }
FmlNumber >> xNPV: array dates: dates [
	| fmlArray fmlDates |
	fmlArray := array asFmlValue.
	(fmlArray isArrayValued and: [fmlArray isNumeric])
		ifFalse: [^self argument: 'array' in: 'xNPV' shouldBeArrayOf: FmlNumber].
	fmlDates := dates asFmlValue.
	(fmlDates isArrayValued and: [fmlDates hasDates])
		ifFalse: [^self argument: 'dates' in: 'xNPV' shouldBeArrayOf: FmlDate].
	^(fmlArray xNPVRate: self value dates: fmlDates value) asFmlValue]

{ #category : #functions }
FmlNumber >> xNPV: array
dates: dates
startDate: startDate
endDate: endDate [
	| fmlArray fmlDates |
	fmlArray := array asFmlValue.
	(fmlArray isArrayValued and: [fmlArray isNumeric])
		ifFalse: [^self
			argument: 'array'
			in: 'xNPVLimit'
			shouldBeArrayOf: FmlNumber].
	fmlDates := dates asFmlValue.
	(fmlDates isArrayValued and: [fmlDates hasDates])
		ifFalse: [^self argument: 'dates' in: 'xNPVLimit' shouldBeArrayOf: FmlDate].
	startDate isDate
		ifFalse: [^self argument: 'startDate' in: 'xNPVLimit' shouldBe: FmlDate].
	endDate isDate
		ifFalse: [^self argument: 'endDate' in: 'xNPVLimit' shouldBe: FmlDate].
	^(fmlArray
		xNPVRate: self value
		dates: fmlDates value
		startDate: startDate value
		endDate: endDate value) asFmlValue]

{ #category : #services }
FmlNumber >> zero [
	^0.0 asFmlValue]

