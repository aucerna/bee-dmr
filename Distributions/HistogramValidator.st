"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HistogramValidator,
	#superclass : #DomainValidator,
	#category : #Distributions
}

{ #category : #'general validations' }
HistogramValidator >> validateBinWidth [
	| limit |
	object isDiscreteHistogram ifTrue: [^self].
	self aspect: #binWidth.
	(self value isUndefinedValue andNot: [object numberOfBins isNil])
		ifTrue: [^self].
	self valueIsPositive.
	object sample isNil ifTrue: [^self].
	limit := object max - object min.
	self value <= limit ifFalse: [
		self
			failBecause: self prettyPrint
				, ' must be lower than or equal the sample interval width: '
				, limit printString]]

{ #category : #'general validations' }
HistogramValidator >> validateNumberOfBins [
	| k size |
	object isDiscreteHistogram ifTrue: [^self].
	self aspect: #numberOfBins.
	(self value isNil andNot: [object binWidth isNil]) ifTrue: [^self].
	self valueIsPositiveInteger.
	object sample isNil ifTrue: [^self].
	object isIntegerHistogram ifFalse: [^self].
	k := self value.
	size := object max - object min max: 1.
	k <= size ifFalse: [
		self
			failBecause: self prettyPrint
				, ' must be lower than or equal the sample interval size: '
				, size printString]]

{ #category : #'general validations' }
HistogramValidator >> validateSample [
	self aspect: #sample; valueIsDefined.
	self value max ~ self value min
		ifTrue: [self warnBecause: self prettyPrint , ' has only one value']]

