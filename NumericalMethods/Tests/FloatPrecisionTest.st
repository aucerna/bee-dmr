"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FloatPrecisionTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #testing }
FloatPrecisionTest >> testArcTan2 [
	| pi excel |
	pi := Number pi.
	self
		assert: (1.0 arcTan2: 1.0) ~ (pi / 4);
		assert: (-1.0 arcTan2: -1.0) ~ (pi * 3 / 4 negated);
		assert: (-1.0 arcTan2: 1.0) ~ (pi * 3 / 4);
		assert: (1.0 arcTan2: -1.0) ~ (pi / 4 negated);
		assert: (1.0 arcTan2: 0.0) = 0.0;
		assert: (-1.0 arcTan2: 0.0) ~ pi;
		assert: (1.0 arcTan2: 3 sqrt / 2) ~ 0.71372437894477.
	excel := #(0.099669	 0.197396	0.291457 0.380506 0.463648 0.54042 0.610726 0.674741 0.732815).
	1
		to: 9
		do: [:i | self
			assert: ((1.0 arcTan2: i / 10.0) - (excel at: i)) abs < 0.00001].
	excel := #(1.471128 1.373401 1.27934 1.19029 1.107149 1.030377 0.96007 0.896055 0.837981).
	1
		to: 9
		do: [:i | self
			assert: ((i / 10.0 arcTan2: 1.0) - (excel at: i)) abs < 0.00001].
	excel := #(1.670465 1.768192 1.862253 1.951303 2.034444 2.111216 2.181522 2.245537 2.303611).
	1
		to: 9
		do: [:i | self
			assert: ((i / -10.0 arcTan2: 1.0) - (excel at: i)) abs < 0.00001]]

{ #category : #testing }
FloatPrecisionTest >> testLargest [
	| smallest largest |
	smallest := Float smallest.
	largest := Float largest.
	self assert: 1.0 / smallest < largest.
	self assert: 1.0 / smallest asFraction < largest asFraction]

{ #category : #testing }
FloatPrecisionTest >> testNegativePrecision [
	| p q epsilon r |
	p := Float negativePrecision.
	self assert: p > 0.0.
	self assert: 1.0 - p = 1.0.
	epsilon := Float smallest.
	r := Float radix.
	[
		q := p + epsilon.
		q > p]
		whileFalse: [epsilon := epsilon * r].
	self assert: 1.0 - q < 1.0]

{ #category : #testing }
FloatPrecisionTest >> testPositivePrecision [
	| p q epsilon r |
	p := Float positivePrecision.
	self assert: 0.0 < p.
	self assert: 1.0 + p = 1.0.
	epsilon := Float smallest.
	r := Float radix.
	[
		q := p + epsilon.
		p < q]
		whileFalse: [epsilon := epsilon * r].
	self assert: 1.0 + q > 1.0]

{ #category : #testing }
FloatPrecisionTest >> testRadix [
	self assert: FloatPrecision current radix == 2.
	self assert: Float radix = 2.0]

{ #category : #testing }
FloatPrecisionTest >> testRationalValues [
	| largest negativePrecision positivePrecision smallest power52 power969 |
	largest := Float largest asFraction.
	negativePrecision := Float negativePrecision asFraction.
	positivePrecision := Float positivePrecision asFraction.
	smallest := Float smallest asFraction.
	power52 := 2 raisedToInteger: 52.
	power969 := 2 raisedToInteger: 1024 - 55.
	self
		assert: power52 * 2 - 1 * power969 * 4 = largest;
		assert: 1 / (power52 * 4) = negativePrecision;
		assert: 1 / (power52 * 2) = positivePrecision]

{ #category : #testing }
FloatPrecisionTest >> testSingleFloat [
	| buffer x ole random u |
	buffer := MemoryBuffer new: 4.
	buffer singleFloatAtOffset: 0 put: 2.0.
	x := buffer singleFloatAtOffset: 0.
	self assert: x = 2.0.
	buffer singleFloatAtOffset: 0 put: 0.0.
	x := buffer singleFloatAtOffset: 0.
	self assert: x = 0.0.
	buffer singleFloatAtOffset: 0 put: -1.0.
	x := buffer singleFloatAtOffset: 0.
	self assert: x = -1.0.
	ole := Smalltalk at: #OLEStructure ifAbsent: [^self].
	ole := ole new: 4.
	random := self random.
	1000 timesRepeat: [
		u := random next.
		buffer singleFloatAtOffset: 0 put: u.
		ole singleFloatAtOffset: 0 put: u.
		self assert: buffer contents = ole contents]]

{ #category : #testing }
FloatPrecisionTest >> testSmall [
	| smallest small |
	smallest := Float smallest.
	small := Float small.
	self assert: smallest < small.
	self assert: smallest sqrt = small]

{ #category : #testing }
FloatPrecisionTest >> testSmallest [
	| smallest |
	smallest := Float smallest.
	self assert: 0.0 < smallest.
	self assert: smallest < Float negativePrecision.
	self assert: smallest < Float positivePrecision]

{ #category : #testing }
FloatPrecisionTest >> testSmallFloats [
	| smallest np pp |
	smallest := Float smallest.
	np := Float negativePrecision.
	pp := Float positivePrecision.
	self assert: smallest < np.
	self assert: np < pp]

