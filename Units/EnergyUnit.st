"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EnergyUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #'instance accessing' }
EnergyUnit class >> btu [
	^self named: 'BTU']

{ #category : #accessing }
EnergyUnit class >> constantsUnit [
	^self named: 'kW.day']

{ #category : #accessing }
EnergyUnit class >> conversions [
	^#('g.(ft/day2)' 'ft'
		'N' 'm'
		'kN' 'm'
		'MN' 'm'
		'kg.(m/day2)' 'm')]

{ #category : #defaults }
EnergyUnit class >> defaultMetricUnitName [
	^'kW.h']

{ #category : #'instance accessing' }
EnergyUnit class >> e9Btu [
	^self named: 'E9 BTU']

{ #category : #'instance accessing' }
EnergyUnit class >> gwh [
	^self named: 'gW.h']

{ #category : #initialization }
EnergyUnit class >> initializeUnits [
	| wh kwh mwh gwh kwd btu mbtu mmbtu cmmbtu e9btu tbtu hph tJ mmJ gJ pJ |
	super initializeUnits.
	wh := self new
		name: 'W.h';
		conversion: (3600 unitsOf: self joule) reciprocal.
	self add: wh.
	kwh := self new
		name: 'kW.h';
		conversion: (1000 unitsOf: wh) reciprocal.
	self add: kwh.
	mwh := self new
		name: 'mW.h';
		conversion: (1000 unitsOf: kwh) reciprocal.
	self add: mwh.
	gwh := self new
		name: 'gW.h';
		conversion: (1000 unitsOf: mwh) reciprocal.
	self add: gwh.
	kwd := self new
		name: 'kW.day';
		conversion: (24 unitsOf: kwh) reciprocal.
	self add: kwd.
	btu := self new
		name: 'BTU';
		conversion: (1055.0559 unitsOf: self joule) reciprocal.
	self add: btu.
	mbtu := self new
		name: 'M BTU';
		conversion: (1.0e3 unitsOf: btu) reciprocal.
	self add: mbtu.
	mmbtu := self new
		name: 'MM BTU';
		conversion: (1.0e6 unitsOf: btu) reciprocal.
	self add: mmbtu.
	cmmbtu := self new
		name: '100MM BTU';
		conversion: (100 unitsOf: mmbtu) reciprocal.
	self add: cmmbtu.
	e9btu := self new
		name: 'E9 BTU';
		conversion: (1.0e9 unitsOf: btu) reciprocal.
	self add: e9btu.
	tbtu := self new
		name: 'T BTU';
		conversion: (1.0e12 unitsOf: btu) reciprocal.
	self add: tbtu.
	hph := self new
		name: 'hp.h';
		conversion: (2684519.5 unitsOf: self joule) reciprocal.
	self add: hph.
	mmJ := self new
		name: 'MM J';
		conversion: (1.0e6 unitsOf: self joule) reciprocal.
	self add: mmJ.
	gJ := self new
		name: 'GJ';
		conversion: (1.0e9 unitsOf: self joule) reciprocal.
	self add: gJ.
	tJ := self new
		name: 'TJ';
		conversion: (1.0e12 unitsOf: self joule) reciprocal.
	self add: tJ.
	pJ := self new
		name: 'PJ';
		conversion: (1.0e15 unitsOf: self joule) reciprocal.
	self add: pJ]

{ #category : #testing }
EnergyUnit class >> isQuantifier [
	^true]

{ #category : #'instance accessing' }
EnergyUnit class >> joule [
	^self named: 'J']

{ #category : #'instance accessing' }
EnergyUnit class >> kJ [
	^self named: 'kJ']

{ #category : #'instance accessing' }
EnergyUnit class >> kwd [
	^self named: 'kW.day']

{ #category : #'instance accessing' }
EnergyUnit class >> kwh [
	^self named: 'kW.h']

{ #category : #accessing }
EnergyUnit class >> leftUnitType [
	^ForceUnit]

{ #category : #'instance accessing' }
EnergyUnit class >> mbtu [
	^self named: 'M BTU']

{ #category : #'instance accessing' }
EnergyUnit class >> mmbtu [
	^self named: 'MM BTU']

{ #category : #'instance accessing' }
EnergyUnit class >> mmJ [
	^self named: 'MM J']

{ #category : #'instance accessing' }
EnergyUnit class >> mwh [
	^self named: 'mW.h']

{ #category : #accessing }
EnergyUnit class >> operator [
	^#*]

{ #category : #accessing }
EnergyUnit class >> rightUnitType [
	^LengthUnit]

{ #category : #'instance accessing' }
EnergyUnit class >> tbtu [
	^self named: 'T BTU']

{ #category : #'instance accessing' }
EnergyUnit class >> tJ [
	^self named: 'TJ']

{ #category : #accessing }
EnergyUnit class >> typeName [
	^'Energy']

{ #category : #private }
EnergyUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'joule' with: 'J'.
	code := code replaceAll: 'Day' with: 'day'.
	code := code replaceAll: 'wh' with: 'W.h'.
	code := code replaceAll: 'Wh' with: 'W.h'.
	code := code replaceAll: 'hph' with: 'hp.h'.
	^code]

{ #category : #arithmetic }
EnergyUnit >> / aUnit [
	| string |
	(aUnit isTimeUnit and: [
		string := '.' , aUnit name asLowercase.
		name asLowercase endsWith: string])
		ifTrue: [^ElectricalPowerUnit named: (name allButLast: string size)].
	^super / aUnit]

{ #category : #private }
EnergyUnit >> defaultName [
	(left isNil or: [right isNil]) ifTrue: [^super defaultName].
	(left name = 'N' and: [right name = 'm']) ifTrue: [^'J'].
	(left name = 'kN' and: [right name = 'm']) ifTrue: [^'kJ'].
	(left name = 'MN' and: [right name = 'm']) ifTrue: [^'MJ'].
	^super defaultName]

{ #category : #inquiries }
EnergyUnit >> explicitTime [
	| stream string |
	stream := name readStream.
	string := stream upTo: $.; upToEnd.
	^TimeUnit named: string]

{ #category : #testing }
EnergyUnit >> isSystemUnit [
	^super isSystemUnit
		or: [self type class >> #initializeUnits includes: name]]

{ #category : #inquiries }
EnergyUnit >> powerUnit [
	^ElectricalPowerUnit named: (name upTo: $.)]

