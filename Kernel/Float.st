"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Float,
	#superclass : #Number,
	#type : #bytes,
	#classVars : [
		'E',
		'Infinity',
		'MinusInfinity',
		'Pi',
		'RadiansPerDegree',
		'Status'
	],
	#category : #Kernel
}

{ #category : #private }
Float class >> basicErrorOn: aSymbol status: status for: aNumber [
	self error: 'Float error ' , aSymbol
]

{ #category : #errors }
Float class >> clearStatusFlags [
	"
	We initialize MXCSR to clean all sticky bits (0-5), mask all exceptions (7-12),
	and to treat denormal arguments of operations as zero (bit 6).
	We don't flush denormal results to zero (bit 15), but should think about it.
	"
	self _floatStatus: self initialControlAndStatusFlags
]

{ #category : #constants }
Float class >> e [
	"
	Float e
	"
	^E
]

{ #category : #errors }
Float class >> errorOn: aSymbol status: status for: aNumber [
	| error |
	(self hasZeroDivisorFlag: status)
		ifTrue: [^ZeroDivide new dividend: aNumber; operation: aSymbol; signal].
	error := ArithmeticError on: aSymbol.
	(self hasOverflowFlag: status) ifTrue: [^error signalOverflow].
	(self hasUnderflowFlag: status) ifTrue: [^error signalUnderflow].
	(self hasDenormalizedOperandFlag: status) ifTrue: [^error signalDenormalized].
	(self hasInvalidOperationFlag: status)
		ifTrue: [^error signalInvalidOperation].
	(self hasCoprocessorMissingFlag: status)
		ifTrue: [^error signalCoprocessorMissing].
	(self hasInexactFlag: status) ifTrue: [^error signalInexactOperation].
	^error signalUndefined
]

{ #category : #'instance creation' }
Float class >> from: aNumber [
	^aNumber asFloat
]

{ #category : #'instance creation' }
Float class >> fromByteArray: aByteArray [
	^self new initializeWith: aByteArray
]

{ #category : #'instance creation' }
Float class >> fromBytes: anObject [
	| float |
	^anObject isByteArray ifTrue: [self fromByteArray: anObject] ifFalse: [
		float := self new.
		float replaceBytesFrom: 1 to: 8 with: anObject startingAt: 1.
		^float]
]

{ #category : #'instance creation' }
Float class >> fromInteger: anInteger [
	| result |
	result := Float new.
	anInteger _isSmallInteger ifTrue: [
		anInteger _asNative _asFloatInto: result.
		^result].
	anInteger isInteger
		ifTrue: [^(self fromInteger: (anInteger bitShift: -24)) * 16r1000000 asFloat
			+ (self fromInteger: (anInteger bitAnd: 16rFFFFFF))]
		ifFalse: [self error: 'number is not an integer']
]

{ #category : #'instance creation' }
Float class >> fromLocalString: aString [
	| thous dec string currency sign float |
	aString isEmpty ifTrue: [^0.0].
	thous := Locale current thousandsSeparator.
	dec := Locale current decimalSeparator.
	string := thous = dec
		ifTrue: [aString]
		ifFalse: [aString reject: [:c | thous includes: c]].
	currency := Locale current currency first.
	string := string reject: [:c | c = currency].
	string isEmpty ifTrue: [^0.0].
	sign := 1.0.
	(string first = $( and: [string last = $)]) ifTrue: [
		string := string copyFrom: 2 to: string size - 1.
		sign := -1.0].
	float := self fromString: string decimalSeparator: dec.
	^float * sign
]

{ #category : #'instance creation' }
Float class >> fromString: aString decimalSeparator: anotherString [
	^(super fromString: aString decimalSeparator: anotherString) asFloat
]

{ #category : #testing }
Float class >> hasCoprocessorMissingFlag [
	^self hasCoprocessorMissingFlag: self status
]

{ #category : #testing }
Float class >> hasCoprocessorMissingFlag: status [
	^(status bitAnd: 128) != 0
]

{ #category : #testing }
Float class >> hasDenormalizedOperandFlag [
	^self hasDenormalizedOperandFlag: self status
]

{ #category : #testing }
Float class >> hasDenormalizedOperandFlag: status [
	^(status bitAnd: 2) != 0
]

{ #category : #testing }
Float class >> hasErrorFlag: status [
	^(status bitAnd: 0x1F) != 0
]

{ #category : #testing }
Float class >> hasFixedSize [
	^self hasVariableSize not
]

{ #category : #testing }
Float class >> hasInexactFlag [
	^self hasInexactFlag: self status
]

{ #category : #testing }
Float class >> hasInexactFlag: status [
	^(status bitAnd: 32) != 0
]

{ #category : #testing }
Float class >> hasInvalidOperationFlag [
	^self hasInvalidOperationFlag: self status
]

{ #category : #testing }
Float class >> hasInvalidOperationFlag: status [
	^(status bitAnd: 1) != 0
]

{ #category : #testing }
Float class >> hasOverflowFlag [
	^self hasOverflowFlag: self status
]

{ #category : #testing }
Float class >> hasOverflowFlag: status [
	^(status bitAnd: 8) != 0
]

{ #category : #testing }
Float class >> hasUnderflowFlag [
	^self hasUnderflowFlag: self status
]

{ #category : #testing }
Float class >> hasUnderflowFlag: status [
	^(status bitAnd: 16) != 0
]

{ #category : #testing }
Float class >> hasVariableSize [
	^false
]

{ #category : #testing }
Float class >> hasZeroDivisorFlag [
	^self hasZeroDivisorFlag: self status
]

{ #category : #testing }
Float class >> hasZeroDivisorFlag: status [
	^(status bitAnd: 4) != 0
]

{ #category : #constants }
Float class >> infinity [
	"
	Float infinity
	"
	^Infinity
]

{ #category : #errors }
Float class >> initialControlAndStatusFlags [
	"
	We initialize MXCSR with all sticky bits clean (0-5), all exceptions masked (7-12),
	and denormal arguments of operations treated as zero (bit 6).
	We don't flush denormal results to zero (bit 15), but should think about it.
	"
	^0x1FC0
]

{ #category : #initialization }
Float class >> initializeConstants [
	"
	Float initializeConstants
	"
	self
		initializeInfinity;
		initializeMinusInfinity;
		initializeStatus;
		initializePi;
		initializeE;
		initializeRadiansPerDegree
]

{ #category : #initialization }
Float class >> initializeE [
	E := self fromByteArray: #[105 87 20 139 10 191 5 64]
]

{ #category : #initialization }
Float class >> initializeInfinity [
	Infinity := self fromByteArray: #[00 00 00 00 00 00 0xF0 0x7F]
]

{ #category : #initialization }
Float class >> initializeMinusInfinity [
	MinusInfinity := self fromByteArray: #[00 00 00 00 00 00 0xF0 0xFF]
]

{ #category : #initialization }
Float class >> initializePi [
	Pi := 3.14159265358979323846264338327950288
]

{ #category : #initialization }
Float class >> initializeRadiansPerDegree [
	RadiansPerDegree := Pi / 180.0
]

{ #category : #constants }
Float class >> maxExponent [
	^309
]

{ #category : #constants }
Float class >> maxForExp [
	self disableCode: [^(10.0 raisedTo: Float maxExponent - 1) ln].
	^self fromByteArray: #[16r5E 16r2A 16rD6 16rD5 16r91 16r29 16r86 16r40]
]

{ #category : #constants }
Float class >> maxNegativeValue [
	"
	Float maxNegativeValue
	"
	^self fromByteArray: #[0 0 0 0 0 0 16 128]
]

{ #category : #constants }
Float class >> maxValue [
	"
	Float maxValue
	"
	^self fromByteArray: #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rEF 16r7F]
]

{ #category : #constants }
Float class >> minPositiveValue [
	"
	Float minPositiveValue / 2
	"
	^self fromByteArray: #[0 0 0 0 0 0 16 0]
]

{ #category : #constants }
Float class >> minusInfinity [
	"
	Float minusInfinity
	"
	^MinusInfinity
]

{ #category : #constants }
Float class >> minValue [
	"
	Float minValue
	"
	^self fromByteArray: #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rEF 16rFF]
]

{ #category : #constants }
Float class >> multiplicativeIdentity [
	^1.0
]

{ #category : #constants }
Float class >> nan [
	"
	Float nan
	"
	^self new
		at: 7 put: 248;
		at: 8 put: 127;
		yourself
]

{ #category : #'instance creation' }
Float class >> new [
	| byteSize object headerSize totalSize buffer |
	byteSize := 8.
	headerSize := 8.
	totalSize := headerSize + byteSize.
	buffer := self memory allocate: totalSize.
	object := (buffer + headerSize _asPointer) _asObject.
	object
		_longSlotAt: _Behavior put: self instanceBehavior;
		initializeExtended: false contentSize: byteSize;
		_beArrayed;
		_beBytes;
		_longSlotAt: 1 put: 0 _asNative;
		_longSlotAt: 2 put: 0 _asNative.
	^object
]

{ #category : #constants }
Float class >> pi [
	"
	Number pi
	"
	^Pi
]

{ #category : #constants }
Float class >> plusInfinity [
	"
	Float plusInfinity
	"
	^Infinity
]

{ #category : #accessing }
Float class >> sizeInBytes [
	^8
]

{ #category : #accessing }
Float class >> status [
	^self _floatStatus
]

{ #category : #'instance creation' }
Float class >> usingBytes: aByteArray [
	^self new initializeWith: aByteArray
]

{ #category : #constants }
Float class >> zero [
	^0.0
]

{ #category : #arithmetic }
Float >> - aNumber [
	| new result |
	aNumber isFloat ifFalse: [^self - aNumber asFloat].
	new := Float new.
	result := self _floatMinus: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'-' status: result
]

{ #category : #arithmetic }
Float >> * aNumber [
	| new result |
	aNumber isFloat ifFalse: [^self * aNumber asFloat].
	new := Float new.
	result := self _floatMultiply: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'*' status: result
]

{ #category : #arithmetic }
Float >> / aNumber [
	| new result |
	aNumber isFloat ifFalse: [^self / aNumber asFloat].
	new := Float new.
	result := self _floatQuotient: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'/' status: result
]

{ #category : #arithmetic }
Float >> // aNumber [
	| quo q |
	q := self / aNumber.
	quo := q truncated.
	q positive ifTrue: [^quo].
	^quo = q ifTrue: [quo] ifFalse: [quo - 1]
]

{ #category : #comparing }
Float >> ~ aFloat [
	| delta distance |
	aFloat isFloat ifFalse: [^self isCloseTo: aFloat].
	self isSpecialValue ifTrue: [^self = aFloat].
	aFloat isSpecialValue ifTrue: [^false].
	delta := aFloat - self.
	(-0.1e-289 < delta and: [delta < 0.1e-289]) ifTrue: [^true].
	self = 0.0 ifTrue: [^false].
	delta = aFloat ifTrue: [^false].
	distance := delta / self.
	^-1.0e-10 < distance and: [distance < 1.0e-10]
]

{ #category : #arithmetic }
Float >> + aNumber [
	| new result |
	aNumber isFloat ifFalse: [^aNumber addTo: self].
	new := Float new.
	result := self _floatPlus: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'+' status: result
]

{ #category : #comparing }
Float >> < aNumber [
	| result |
	aNumber isFloat ifFalse: [^self < aNumber asFloat].
	result := self _floatLessThan: aNumber.
	result _isSmallInteger ifFalse: [^result].
	^self errorOn: #'<' status: result
]

{ #category : #comparing }
Float >> <~ aNumber [
	| float |
	float := aNumber asFloat.
	^(float < self) not or: [self ~ float]
]

{ #category : #comparing }
Float >> <= aNumber [
	^self < aNumber or: [self = aNumber]
]

{ #category : #comparing }
Float >> = aNumber [
	| result nan equal |
	aNumber isFloat
		ifFalse: [^aNumber isNumber
			ifTrue: [self = aNumber asFloat]
			ifFalse: [false]].
	result := self _floatEquals: aNumber.
	result _isSmallInteger ifFalse: [^result].
	nan := self isNaN.
	equal := nan == aNumber isNaN.
	equal ifFalse: [^false].
	nan ifTrue: [^true].
	^self errorOn: #'=' status: result
]

{ #category : #comparing }
Float >> > aNumber [
	^aNumber asFloat < self
]

{ #category : #comparing }
Float >> >~ aNumber [
	| float |
	float := aNumber asFloat.
	^(self < float) not or: [self ~ float]
]

{ #category : #comparing }
Float >> >= aNumber [
	^(self < aNumber asFloat) not
]

{ #category : #arithmetic }
Float >> abs [
	self isNaN ifTrue: [^self].
	^self < 0.0 ifTrue: [^0.0 - self] ifFalse: [self]
]

{ #category : #trigonometry }
Float >> arcTan [
	^OS libc atan: self
]

{ #category : #converting }
Float >> asByteArray [
	| array |
	array := ByteArray new: self size.
	array
		replaceBytesFrom: 1
		to: self size
		with: self
		startingAt: 1.
	^array
]

{ #category : #converting }
Float >> asFloat [
	^self
]

{ #category : #converting }
Float >> asFraction [
	^self asTrueFraction
]

{ #category : #converting }
Float >> asNormalized [
	^self isDenormalizedValue ifTrue: [0.0] ifFalse: [self]
]

{ #category : #converting }
Float >> asTrueFraction [
	| high exponent positive low significand fraction exp zeroes numerator denominator |
	self isSpecialValue
		ifTrue: [self
			error: 'cannot represent ' , self printString , ' as a fraction'].
	high := self uLongAtOffset: 4.
	exponent := high bitShift: -20.
	positive := (exponent bitAnd: 16r800) = 0.
	positive ifFalse: [exponent := exponent bitAnd: 16r7FF].
	low := self uLongAtOffset: 0.
	significand := ((high bitAnd: 16rFFFFF) bitShift: 32) + low.
	(exponent = 0 and: [significand = 0]) ifTrue: [^0].
	fraction := exponent = 0
		ifTrue: [significand bitShift: 1]
		ifFalse: [significand bitOr: 16r10000000000000].
	positive ifFalse: [fraction := fraction negated].
	exp := 1075 - exponent.
	exp < 0 ifTrue: [^fraction bitShift: exp negated].
	zeroes := fraction lowBit - 1.
	exp := exp - zeroes.
	exp <= 0 ifTrue: [^fraction bitShift: zeroes negated - exp].
	numerator := fraction bitShift: zeroes negated.
	exp = 0 ifTrue: [^numerator].
	denominator := 1 bitShift: exp.
	^numerator / denominator
]

{ #category : #testing }
Float >> at: index [
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	(1 <= index and: [index <= self _size])
		ifFalse: [self outOfBoundsIndex: index].
	^self _byteAt: index
]

{ #category : #testing }
Float >> basicAt: anInteger [
	^self basicByteAt: anInteger
]

{ #category : #arithmetic }
Float >> ceiling [
	^self isNaN ifTrue: [self] ifFalse: [super ceiling]
]

{ #category : #private }
Float >> coerce: aNumber [
	^aNumber asFloat
]

{ #category : #trigonometry }
Float >> cos [
	^OS libc cos: self
]

{ #category : #trigonometry }
Float >> degreesToRadians [
	^self * RadiansPerDegree
]

{ #category : #errors }
Float >> errorOn: aSymbol status: anInteger [
	^self class errorOn: aSymbol status: anInteger for: self
]

{ #category : #logarithms }
Float >> exp [
	| result float status |
	float := self class.
	float clearStatusFlags.
	result := OS libc exp: self.
	status := self _floatStatus.
	(float hasErrorFlag: status) ifTrue: [^self errorOn: #exp status: status].
	^result
]

{ #category : #accessing }
Float >> exponent [
	| bits |
	bits := (self at: 8) * 256 + (self at: 7).
	bits := bits // 16 bitAnd: 2r11111111111.
	^bits > 0
		ifTrue: [
			bits < 2047
				ifTrue: [bits - 1023]
				ifFalse: [self isMinusInfinity
					ifTrue: [self class plusInfinity]
					ifFalse: [self]]]
		ifFalse: [self asNormalized exponent]
]

{ #category : #copying }
Float >> externalCopy [
	^ExternalMemory fromByteArray: self
]

{ #category : #arithmetic }
Float >> floor [
	^self isNaN ifTrue: [self] ifFalse: [super floor]
]

{ #category : #random }
Float >> fractionPart [
	| new result |
	new := Float new.
	result := self _floatFractionPartInto: new.
	result == new ifTrue: [^result].
	^self errorOn: #fractionPart status: result
]

{ #category : #testing }
Float >> hasFixedSize [
	^true
]

{ #category : #comparing }
Float >> hash [
	| hash |
	self isSpecialValue ifFalse: [
		self fractionPart = 0.0 ifTrue: [
			((self
				between: -1073741824.0 "SmallInteger smallestNegative"
				and: 1073741823.0 "SmallInteger largestPositive")
				or: [9007199254740992.0 < self]
				or: [self < -9007199254740992.0 "53 bits of mantissa"])
				ifTrue: [^self truncated hash]]].
	hash := 8.
	1
		to: 8
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self at: i)].
	^hash
]

{ #category : #testing }
Float >> hasZeroExponent [
	^((self at: 8) bitAnd: 16r7F) = 0 and: [((self at: 7) bitAnd: 16rF0) = 0]
]

{ #category : #testing }
Float >> hasZeroMantissa [
	((self at: 7) bitAnd: 16rF) = 0 ifFalse: [^false].
	(self at: 6) = 0 ifFalse: [^false].
	(self at: 5) = 0 ifFalse: [^false].
	(self at: 4) = 0 ifFalse: [^false].
	(self at: 3) = 0 ifFalse: [^false].
	(self at: 2) = 0 ifFalse: [^false].
	^(self at: 1) = 0
]

{ #category : #testing }
Float >> initializeWith: bytes [
	bytes _primitiveULargeAtOffset: 0 into: self
]

{ #category : #testing }
Float >> initializeWith: bytes at: index [
	bytes _primitiveULargeAtOffset: index - 1 * 8 into: self
]

{ #category : #testing }
Float >> isDenormalizedValue [
	^self hasZeroExponent and: [self hasZeroMantissa not]
]

{ #category : #testing }
Float >> isFloat [
	^true
]

{ #category : #testing }
Float >> isInfinite [
	^self = Infinity or: [self = MinusInfinity]
]

{ #category : #testing }
Float >> isInfinity [
	^self = Infinity
]

{ #category : #testing }
Float >> isMinusInfinity [
	^self = MinusInfinity
]

{ #category : #testing }
Float >> isNaN [
	^self isSpecialValue and: [self hasZeroMantissa not]
]

{ #category : #testing }
Float >> isSpecialValue [
	^((self uShortAtOffset: 6) bitAnd: 16r7FF0) = 16r7FF0
]

{ #category : #logarithms }
Float >> ln [
	self <= 0 ifTrue: [
		self = 0.0
			ifTrue: [self zeroDivisorOn: #ln]
			ifFalse: [^(ArithmeticError on: self) signal]].
	^OS libc log: self
]

{ #category : #private }
Float >> loadFromFloat: aByteArray [
	^self _floatFromFloat: aByteArray
]

{ #category : #accessing }
Float >> mantissa [
	^self significand
]

{ #category : #private }
Float >> marshalOn: aStream [
	aStream _nextDoublePut: self
]

{ #category : #arithmetic }
Float >> negated [
	^-1.0 * self
]

{ #category : #printing }
Float >> printDecimals: decimals separatedBy: aString [
	| fraction digits |
	self isNaN ifTrue: [^'NAN'].
	(self = 0.0 or: [self exponent + decimals < self class maxExponent])
		ifFalse: [^self asString].
	digits := 10 raisedToInteger: decimals.
	fraction := (self * digits) rounded / digits.
	^fraction printDecimals: decimals separatedBy: aString
]

{ #category : #printing }
Float >> printOn: aStream [
	self printOn: aStream separatedBy: Locale current decimalSeparator
]

{ #category : #printing }
Float >> printOn: aStream separatedBy: separator [
	| number factor scientificThreshold maxDigits digits integer reverse exp |
	self isNaN ifTrue: [^aStream nextPutAll: 'NAN'].
	self = Infinity ifTrue: [^aStream nextPutAll: '+infinite'].
	self = MinusInfinity ifTrue: [^aStream nextPutAll: '-infinite'].
	self < 0.0 ifTrue: [
		aStream nextPut: $-.
		^self negated printOn: aStream separatedBy: separator].
	(self = 0.0 or: [self isDenormalizedValue]) ifTrue: [
		^aStream
			nextPut: $0;
			nextPutAll: separator;
			nextPut: $0].
	number := self.
	factor := 0.5e-14.
	scientificThreshold := 13.
	digits := (number log: 10) truncated.
	number := number / (digits asFloat * 10.0 ln) exp + factor.
	number >= 10.0 ifTrue: [
		number := number / 10.0.
		digits := digits + 1].
	digits = 0 ifFalse: [
		((digits between: scientificThreshold negated and: scientificThreshold)
			and: [
				digits >= 0 or: [| n |
					n := number * ((digits + scientificThreshold) asFloat * 10.0 ln) exp.
					(n fractionPart * (digits negated * 10.0 ln) exp) truncated = 0]])
			ifTrue: [
				number := number * (digits asFloat * 10.0 ln) exp.
				factor := factor * (digits * 10.0 ln) exp.
				digits := 0]].
	exp := digits.
	integer := number truncated.
	number := number fractionPart.
	reverse := String streamContents: [:strm | 
		[integer >= 10] whileTrue: [
			strm nextPut: (Character digitValue: integer \\ 10).
			integer := integer // 10].
		strm nextPut: (Character digitValue: integer)].
	aStream nextPutAll: reverse reversed.
	maxDigits := 15.
	digits := maxDigits - reverse size - 1.
	aStream nextPutAll: separator.
	factor := factor * 2.0.
	[
		number := number * 10.0.
		integer := number truncated.
		number := number fractionPart.
		aStream nextPut: (Character digitValue: integer).
		digits := digits - 1.
		digits positive and: [
			factor := factor * 10.0.
			factor <= number]] whileTrue.
	exp = 0 ifFalse: [
		aStream nextPut: $e.
		exp printOn: aStream]
]

{ #category : #trigonometry }
Float >> radiansToDegrees [
	^self / RadiansPerDegree
]

{ #category : #logarithms }
Float >> raisedTo: aNumber [
	| n base |
	aNumber \\ 1.0 = 0.0 ifTrue: [^self raisedToInteger: aNumber asInteger].
	(self = 0.0 and: [aNumber > 0.0]) ifTrue: [^0.0].
	self positive ifTrue: [
		base := aNumber * self abs ln.
		^base >= self class maxForExp
			ifTrue: [self class infinity]
			ifFalse: [base exp]].
	n := aNumber rounded.
	aNumber = n ifTrue: [^self raisedToInteger: n].
	^(ArithmeticError on: #raisedTo:) signalInvalidOperation
]

{ #category : #logarithms }
Float >> raisedToInteger: anInteger [
	^(super raisedToInteger: anInteger) asFloat
]

{ #category : #arithmetic }
Float >> reciprocal [
	^1.0 / self
]

{ #category : #replacing }
Float >> replaceFrom: start
to: stop
with: anObject
startingAt: position [
	self
		replaceBytesFrom: start
		to: stop
		with: anObject
		startingAt: position
]

{ #category : #arithmetic }
Float >> rounded [
	self isNaN ifTrue: [^self].
	self isInfinite ifTrue: [^self].
	^self fractionPart abs < 0.5
		ifTrue: [self truncated]
		ifFalse: [self truncated + self sign rounded]
]

{ #category : #accessing }
Float >> sign [
	self isNaN ifTrue: [^self].
	^super sign
]

{ #category : #accessing }
Float >> significand [
	| result new |
	new := Float new.
	result := self _floatSignificandInto: new.
	result == new ifTrue: [^result].
	^self errorOn: #significand status: result
]

{ #category : #trigonometry }
Float >> sin [
	^OS libc sin: self
]

{ #category : #accessing }
Float >> sizeInBytes [
	^8
]

{ #category : #functions }
Float >> sqrt [
	| sqrt result |
	sqrt := Float new.
	result := self _floatSqrtInto: sqrt.
	result == sqrt ifTrue: [^result].
	^self errorOn: #sqrt status: result
]

{ #category : #arithmetic }
Float >> storeAsFloatInto: aByteArray [
	^self _floatAsFloatInto: aByteArray
]

{ #category : #printing }
Float >> storeOn: aStream [
	self printOn: aStream separatedBy: '.'
]

{ #category : #trigonometry }
Float >> tan [
	^OS libc tan: self
]

{ #category : #arithmetic }
Float >> timesTwoPower: anInteger [
	| new result |
	new := self copy.
	result := new _timesTwoPower: anInteger asFloat.
	result == new ifTrue: [^result].
	^self errorOn: #timesTwoPower status: result
]

{ #category : #arithmetic }
Float >> truncated [
	| result |
	result := self _floatTruncated.
	(result notNil and: [result = 0 or: [result sign = self sign]])
		ifTrue: [^result].
	self isSpecialValue ifTrue: [^self].
	^self abs < 2.0e16
		ifTrue: [| q r |
			q := self quo: 536870912.0.
			"((SmallInteger largestPositive bitShift: -1) + 1) asFloat"
			r := self - (q asFloat * 536870912.0).
			q * 536870912 + r truncated]
		ifFalse: [self asTrueFraction]
]

{ #category : #private }
Float >> uLongAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 3 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self _primitiveULongAtOffset: offset
]

{ #category : #private }
Float >> uShortAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 1 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self _primitiveUShortAtOffset: offset
]

