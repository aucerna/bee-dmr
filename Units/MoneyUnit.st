"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MoneyUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #accessing }
MoneyUnit class >> addCurrency: aUnit [
	| m mm |
	aUnit isActive ifFalse: [self add: aUnit].
	m := self namedOrNew: aUnit name , 'M'.
	m updateConversion.
	mm := self namedOrNew: aUnit name , 'MM'.
	mm updateConversion.
	Unit newCurrency: aUnit.
	^aUnit]

{ #category : #services }
MoneyUnit class >> baseUnit: aUnit [
	aUnit name = '$' ifFalse: [self error: 'Invalid base unit'].
	super baseUnit: aUnit]

{ #category : #accessing }
MoneyUnit class >> constantsUnit [
	^self named: '$']

{ #category : #accessing }
MoneyUnit class >> conversionRange [
	^Range from: 0.1e-30 to: 0.1e30]

{ #category : #accessing }
MoneyUnit class >> conversions [
	"
	MoneyUnit initializeUnits
	"
	| euro |
	euro := 0.68.
	^Dictionary new
		at: '$' put: 1.0;
		at: '$M' put: 0.001;
		at: '$MM' put: 0.000001;
		at: 'eu' put: euro;
		at: 'euM' put: euro / 1000.0;
		at: 'euMM' put: euro / 1000000.0;
		yourself]

{ #category : #accessing }
MoneyUnit class >> currencies [
	^units select: #isCurrency]

{ #category : #accessing }
MoneyUnit class >> defaultCurrency [
	^self defaultUnit currency]

{ #category : #defaults }
MoneyUnit class >> defaultMetricUnitName [
	^'$MM']

{ #category : #services }
MoneyUnit class >> displayNameFor: aString [
	| string |
	string := aString replaceAll: 'eu' with: '€'.
	string := string replaceAll: 'yen' with: '¥'.
	string := string replaceAll: 'Yen' with: '¥'.
	string := string replaceAll: 'YEN' with: '¥'.
	^string]

{ #category : #'instance accessing' }
MoneyUnit class >> dollar [
	^self dollars]

{ #category : #'instance accessing' }
MoneyUnit class >> dollars [
	^self units at: '$']

{ #category : #'instance accessing' }
MoneyUnit class >> eu [
	"
	MoneyUnit eu
	"
	^self named: 'eu']

{ #category : #'instance accessing' }
MoneyUnit class >> euro [
	"
	CsrUMoney euro
	"
	^self eu]

{ #category : #testing }
MoneyUnit class >> isQuantifier [
	^true]

{ #category : #'instance accessing' }
MoneyUnit class >> m [
	^self named: '$M']

{ #category : #'instance accessing' }
MoneyUnit class >> mEu [
	"
	MoneyUnit mEu
	"
	^self named: 'euM']

{ #category : #'instance accessing' }
MoneyUnit class >> mm [
	^self named: '$MM']

{ #category : #'instance accessing' }
MoneyUnit class >> mmEu [
	"
	MoneyUnit mmEu
	"
	^self named: 'euMM']

{ #category : #'instance accessing' }
MoneyUnit class >> named: aString ifAbsent: block [
	| answer code codes |
	aString isEmptyOrNil ifTrue: [^block value].
	answer := super named: aString ifAbsent: #notFound.
	answer == #notFound ifFalse: [^answer].
	code := self validCode: aString.
	code trimBlanks isEmpty ifTrue: [^block value].
	(code endsWith: 'MM')
		ifTrue: [(code endsWith: ' MM')
			ifFalse: [code := (code allButLast: 2) , ' MM']]
		ifFalse: [
			((code endsWith: 'M') andNot: [code endsWith: ' M'])
				ifTrue: [code := code allButLast , ' M']].
	codes := code substrings.
	answer := super named: codes first ifAbsent: #notFound.
	answer == #notFound ifTrue: [^block value].
	codes from: 2 to: codes size do: [:c | 
		[answer := answer perform: c asSymbol]
			on: MessageNotUnderstood
			do: [answer := nil].
		answer isNil ifTrue: [^block value]].
	^answer]

{ #category : #private }
MoneyUnit class >> readBaseUnitFrom: aDictionary [
	| base |
	base := super readBaseUnitFrom: aDictionary.
	base isNil ifTrue: [^nil].
	self readCurrenciesFrom: aDictionary basedOn: base.
	^base]

{ #category : #private }
MoneyUnit class >> readCurrenciesFrom: aDictionary basedOn: base [
	aDictionary keysAndValuesDo: [:k :v | | c |
		(k endsWith: 'M') ifFalse: [
			c := base convert: v.
			self defineUnit: k conversion: c]]]

{ #category : #services }
MoneyUnit class >> resetToSystemUnits [
	super resetToSystemUnits.
	units do: [:u | u updateConversion]]

{ #category : #accessing }
MoneyUnit class >> typeName [
	^'Money']

{ #category : #private }
MoneyUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: '€' with: 'eu'.
	(aString beginsWith: '$ M')
		ifTrue: [code := code replaceAll: '$ M' with: '$M'].
	(aString beginsWith: 'EU') ifTrue: [code := code
		replaceAll: 'EU'
		with: 'eu'].
	(code beginsWith: 'eu M')
		ifTrue: [code := code replaceAll: 'eu M' with: 'euM'].
	^code]

{ #category : #private }
MoneyUnit >> aboutToRename: aUnit with: aString [
	| n |
	aUnit = self currency ifFalse: [^self].
	n := self hasThousands
		ifTrue: [n := aString , 'M']
		ifFalse: [self hasMillions ifTrue: [aString , 'MM']].
	n notNil ifTrue: [self name: n]]

{ #category : #private }
MoneyUnit >> aboutToRenameWith: aString [
	self type units
		select: [:u | u dependsOn: self]
		thenDo: [:u | u aboutToRename: self with: aString]]

{ #category : #'filein/out' }
MoneyUnit >> activated [
	| f |
	self currency isNil ifTrue: [
		f := self multiplier.
		f notNil
			ifTrue: [self type newNamed: self currencyName conversion: conversion * f]].
	^super activated]

{ #category : #validation }
MoneyUnit >> addValidationSelectorsTo: aCollection [
	aCollection add: #moneyValidation]

{ #category : #testing }
MoneyUnit >> canOverrideConversion [
	^(self currency isNil andNot: [self name endsWith: 'M'])
		or: [self isCurrency and: [self ~~ self type dollar]]]

{ #category : #converting }
MoneyUnit >> convertToCurrency: aUnit [
	self isCurrency ifTrue: [^aUnit currency].
	self hasMillions ifTrue: [^aUnit millions].
	self hasThousands ifTrue: [^aUnit thousands].
	self ASSERT: false]

{ #category : #converting }
MoneyUnit >> convertValue: aNumber toUnit: aUnit in: context [
	| n u |
	aUnit type = MoneyPerTimeUnit
		ifTrue: [
			n := aNumber / context duration value.
			u := MoneyPerTimeUnit numerator: self denominator: TimeUnit days]
		ifFalse: [
			n := aNumber.
			u := self].
	^aUnit convert: (u baseValueOf: n)]

{ #category : #accessing }
MoneyUnit >> currency [
	^self type named: self currencyName]

{ #category : #accessing }
MoneyUnit >> currencyName [
	^self hasThousands
		ifTrue: [name allButLast]
		ifFalse: [self hasMillions
			ifTrue: [name allButLast: 2]
			ifFalse: [name trimBlanks]]]

{ #category : #accessing }
MoneyUnit >> defaultCurrency [
	^self type defaultCurrency]

{ #category : #testing }
MoneyUnit >> dependsOn: aUnit [
	^(super dependsOn: aUnit) or: [aUnit != self and: [aUnit = self currency]]]

{ #category : #converting }
MoneyUnit >> displayValue: aNumber withUnit: aUnit in: context [
	| n d |
	n := aUnit type = MoneyPerTimeUnit
		ifTrue: [
			d := context duration value.
			d = 0 ifTrue: [^nil].
			aNumber / d]
		ifFalse: [aNumber].
	^aUnit convert: n]

{ #category : #testing }
MoneyUnit >> hasMillions [
	^name endsWith: 'MM']

{ #category : #testing }
MoneyUnit >> hasThousands [
	self hasMillions ifTrue: [^false].
	^name endsWith: 'M']

{ #category : #converting }
MoneyUnit >> inDefaultCurrency [
	| default |
	default := self defaultCurrency.
	default isNil ifTrue: [^self].
	^(self convertToCurrency: default) ifNil: [self]]

{ #category : #testing }
MoneyUnit >> isCurrency [
	^self currency = self]

{ #category : #testing }
MoneyUnit >> isMoneyUnit [
	^true]

{ #category : #testing }
MoneyUnit >> isUserDefined [
	^self canOverrideConversion and: [super isUserDefined]]

{ #category : #accessing }
MoneyUnit >> millions [
	| c |
	c := self currency.
	c = self ifTrue: [^self type named: name , 'MM'].
	^c millions]

{ #category : #private }
MoneyUnit >> multiplier [
	self hasThousands ifTrue: [^1000.0].
	self hasMillions ifTrue: [^1000000.0].
	self isCurrency ifTrue: [^1.0].
	^nil]

{ #category : #accessing }
MoneyUnit >> thousands [
	| c |
	c := self currency.
	c = self ifTrue: [^self type named: name , 'M'].
	^c thousands]

{ #category : #converting }
MoneyUnit >> update [
	self updateConversion]

{ #category : #private }
MoneyUnit >> updateConversion [
	| currency |
	self isCurrency ifTrue: [^self].
	currency := self currency.
	currency isNil ifTrue: [^self].
	conversion := currency conversion / self multiplier]

