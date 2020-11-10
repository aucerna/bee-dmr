"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Unit,
	#superclass : #ModelObject,
	#instVars : [
		'name',
		'conversion'
	],
	#category : #Units
}

{ #category : #arithmetic }
Unit class >> * unitType [
	^Unit multiply: self by: unitType]

{ #category : #arithmetic }
Unit class >> / unitType [
	^Unit divide: self by: unitType]

{ #category : #'PM support' }
Unit class >> aboutToSaveLibrary [
	super aboutToSaveLibrary.
	normalization := nil]

{ #category : #private }
Unit class >> adaptToBase: aUnit [
	"nothing by default"]

{ #category : #accessing }
Unit class >> add: aUnit [
	self ASSERT: aUnit class == self.
	Unit registerUnit: aUnit.
	^units markDirtyAt: aUnit name put: aUnit]

{ #category : #accessing }
Unit class >> addUnit: aUnit [
	^self add: aUnit]

{ #category : #accessing }
Unit class >> allDenominators [
	^self denominators]

{ #category : #accessing }
Unit class >> allNumerators [
	^self numerators]

{ #category : #accessing }
Unit class >> allUnits [
	| answer |
	answer := OrderedCollection new.
	self allUnitsDo: [:u | answer add: u].
	^answer]

{ #category : #accessing }
Unit class >> allUnitsDo: aBlock [
	self allUnitTypesDo: [:t | t units do: aBlock]]

{ #category : #private }
Unit class >> allUnitTypes [
	^Array
		streamContents: [:strm | self allUnitTypesDo: [:type | strm nextPut: type]]]

{ #category : #'gui support' }
Unit class >> allUnitTypesDo: aBlock [
	| ordered |
	ordered := Unit allSubclasses
		reject: [:t | t isAbstract or: [t componentTypes notEmpty]].
	ordered := OrderedSet withAll: ordered.
	Unit allSubclasses
		do: [:t | t isAbstract ifFalse: [t componentTypesOn: ordered]].
	CompositeUnitType types do: [:t | t componentTypesOn: ordered].
	ordered do: aBlock]

{ #category : #accessing }
Unit class >> areaUnit [
	^AreaUnit currentClass]

{ #category : #converting }
Unit class >> asJson [
	^JsonObject new
		at: 'Type' put: self typeName;
		at: 'ValueType' put: self baseClass name;
		at: 'DefaultValue' put: self defaultValue;
		yourself]

{ #category : #accessing }
Unit class >> baseClass [
	^Number]

{ #category : #accessing }
Unit class >> baseClassName [
	^self isNumeric ifTrue: ['Numeric'] ifFalse: [self typeName]]

{ #category : #accessing }
Unit class >> baseUnit [
	self ASSERT: [
		baseUnit isNil
			or: [(self units includes: baseUnit) and: [baseUnit conversion = 1.0]]].
	^baseUnit]

{ #category : #services }
Unit class >> baseUnit: aUnit [
	baseUnit := aUnit]

{ #category : #accessing }
Unit class >> baseUnitName [
	^self baseUnit ifNotNil: [:u | u name]]

{ #category : #'instance accessing' }
Unit class >> bbl [
	^LiquidVolumeUnit bbl]

{ #category : #'instance accessing' }
Unit class >> bpd [
	^LiquidRateUnit bpd]

{ #category : #'instance accessing' }
Unit class >> btu [
	^EnergyUnit btu]

{ #category : #testing }
Unit class >> canAddUnit [
	^self hasLinearConversion]

{ #category : #testing }
Unit class >> canChangeUnit [
	^units size > 1 or: [units anyone isPercent]]

{ #category : #services }
Unit class >> changeBaseTo: aUnit [
	| save |
	self ASSERT: self hasLinearConversion.
	save := aUnit conversion.
	units do: [:u | u conversion: u conversion / save].
	self invalidateNormalization.
	self baseUnit: aUnit]

{ #category : #private }
Unit class >> componentTypes [
	^#()]

{ #category : #'gui support' }
Unit class >> componentTypesOn: aSet [
	self componentTypes do: [:t | t componentTypesOn: aSet].
	aSet add: self]

{ #category : #accessing }
Unit class >> constantsUnit [
	^self baseUnit]

{ #category : #accessing }
Unit class >> conversionRange [
	^Range from: 0.1e-100 to: 0.1e100]

{ #category : #accessing }
Unit class >> costPerLengthUnit [
	^CostPerLengthUnit currentClass]

{ #category : #accessing }
Unit class >> currentClass [
	^self]

{ #category : #'instance accessing' }
Unit class >> days [
	^TimeUnit days]

{ #category : #defaults }
Unit class >> defaultArrayClass [
	^self isNumeric ifTrue: [FloatArray] ifFalse: [Array]]

{ #category : #defaults }
Unit class >> defaultDecimalPlaces [
	^self isNumeric ifTrue: [2] ifFalse: [0]]

{ #category : #defaults }
Unit class >> defaultFormat [
	^self defaultUnitFormat format]

{ #category : #defaults }
Unit class >> defaultMetricUnitName [
	^self constantsUnit name]

{ #category : #defaults }
Unit class >> defaultRange [
	^nil]

{ #category : #defaults }
Unit class >> defaultUnit [
	^self defaultUnitFormat unit]

{ #category : #defaults }
Unit class >> defaultUnitFormat [
	| u |
	^self publishesDefaultUnit
		ifTrue: [DefaultUnits at: self typeName]
		ifFalse: [
			u := self defaultInstance.
			u asUnitFormat]]

{ #category : #accessing }
Unit class >> defaultUnits [
	^DefaultUnits]

{ #category : #defaults }
Unit class >> defaultValue [
	^0.0]

{ #category : #services }
Unit class >> defineUnit: aString conversion: anObject [
	| u c |
	u := self named: aString.
	c := (anObject isKindOf: Unit)
		ifTrue: [anObject conversion]
		ifFalse: [anObject].
	u isNil
		ifTrue: [u := self newNamed: aString conversion: c]
		ifFalse: [(c notNil and: [u canOverrideConversion])
			ifTrue: [u conversion: c]].
	^u]

{ #category : #services }
Unit class >> deleteUserUnit: aUnit withReplacementsDo: aBlock [
	| replacements dependents |
	replacements := Dictionary new.
	dependents := OrderedCollection new.
	aUnit withDependentsDo: [:u | 
		replacements at: u put: nil.
		dependents add: u].
	dependents do: [:u | u type removeUnit: u].
	replacements keysDo: [:u | | replacement |
		replacement := u activeReplacement.
		replacements at: u put: replacement.
		(u type publishesDefaultUnit and: [u isDefaultUnit])
			ifTrue: [replacement beDefault]].
	aBlock value: replacements]

{ #category : #accessing }
Unit class >> denominators [
	^#()]

{ #category : #accessing }
Unit class >> denominatorUnitType [
	^NumberUnit]

{ #category : #accessing }
Unit class >> densityUnit [
	^DensityUnit currentClass]

{ #category : #testing }
Unit class >> dependsOn: unitType [
	^self = unitType]

{ #category : #'gui support' }
Unit class >> displayGroupName [
	^self typeName, ' Variables']

{ #category : #arithmetic }
Unit class >> divide: unitType by: otherUnitType [
	| n d type fluid |
	otherUnitType == InvalidUnit ifTrue: [^otherUnitType].
	type := Unit typeForLeft: unitType right: otherUnitType operator: #'/'.
	type notNil ifTrue: [^type].
	n := otherUnitType denominators && unitType.
	d := otherUnitType numerators.
	type := Unit findTypeWithNumerators: n denominators: d.
	type notNil ifTrue: [^type].
	n := unitType numerators.
	d := unitType denominators && otherUnitType.
	type := Unit findTypeWithNumerators: n denominators: d.
	type notNil ifTrue: [^type].
	n := unitType numerators & otherUnitType denominators.
	d := unitType denominators & otherUnitType numerators.
	type := Unit findTypeWithNumerators: n denominators: d.
	type notNil ifTrue: [^type].
	n := unitType allNumerators & otherUnitType allDenominators.
	d := unitType allDenominators & otherUnitType allNumerators.
	fluid := self relatedFluidFrom: unitType and: otherUnitType.
	type := Unit
		findTypeWithNumerators: n
		denominators: d
		preferredFluid: fluid.
	type notNil ifTrue: [^type].
	^CompositeUnitType left: unitType operator: #'/' right: otherUnitType]

{ #category : #'instance accessing' }
Unit class >> dollarDay [
	^Unit moneyPerTimeUnit dollarDay]

{ #category : #'instance accessing' }
Unit class >> dollars [
	^MoneyUnit dollars]

{ #category : #'instance accessing' }
Unit class >> existingUnitForLeft: lUnit right: rUnit [
	^units detect: [:u | u matchesLeft: lUnit right: rUnit] ifNone: nil]

{ #category : #services }
Unit class >> findTypeWithNumerators: numUnits denominators: denUnits [
	| num den type |
	num := numUnits asOrderedCollection.
	den := denUnits asOrderedCollection.
	self simplify: num with: den.
	(den isEmpty and: [num size = 1]) ifTrue: [^num first].
	type := Unit typeWithNumerators: num denominators: den.
	type notNil ifTrue: [^type].
	(den isEmpty and: [num size = 2] and: [num noneSatisfy: #isCompositeUnit])
		ifTrue: [^CompositeUnitType left: num first operator: #'*' right: num last].
	(den size = 1
		and: [num size = 1]
		and: [num & den noneSatisfy: #isCompositeUnit])
		ifTrue: [^CompositeUnitType
			left: num first
			operator: #'/'
			right: den first].
	^nil]

{ #category : #services }
Unit class >> findTypeWithNumerators: numUnits denominators: denUnits preferredFluid: aFluid [
	| num den type |
	num := numUnits asOrderedCollection.
	den := denUnits asOrderedCollection.
	self simplify: num with: den.
	(den isEmpty and: [num size = 1]) ifTrue: [^num first].
	type := Unit
		typeWithNumerators: num
		denominators: den
		preferredFluid: aFluid.
	type notNil ifTrue: [^type].
	(den isEmpty and: [num size = 2] and: [num noneSatisfy: #isCompositeUnit])
		ifTrue: [^CompositeUnitType left: num first operator: #'*' right: num last].
	(den size = 1
		and: [num size = 1]
		and: [num & den noneSatisfy: #isCompositeUnit])
		ifTrue: [^CompositeUnitType
			left: num first
			operator: #'/'
			right: den first].
	^nil]

{ #category : #'instance creation' }
Unit class >> fromJson: aJsonObject [
	| t type n unit c |
	self == Unit ifTrue: [
		t := aJsonObject at: 'Type'.
		type := t isString
			ifTrue: [self resolveUnitType: t]
			ifFalse: [CompositeUnitType fromJson: t].
		^type fromJson: aJsonObject].
	n := aJsonObject at: 'Name'.
	unit := self named: n.
	c := aJsonObject valueAt: 'Conversion'.
	c isNil ifTrue: [^unit].
	unit isNil ifTrue: [^self newNamed: n conversion: c].
	(unit conversion relativeDistanceTo: c) > 1.0e-6
		ifTrue: [self error: 'Conversion factor mismatch'].
	^unit]

{ #category : #'instance creation' }
Unit class >> fromString: aString [
	"
	(Unit fromString: 'm3d')
	"
	| classes c |
	classes := self allSubclasses select: [:cls | 
		(cls isAbstract | cls isObsolete) not
			and: [(cls named: aString ifAbsent: nil) notNil]].
	classes isEmpty ifTrue: [
		classes := self allSubclasses select: [:cls | 
			cls isAbstract not
				and: [cls isObsolete]
				and: [(cls named: aString ifAbsent: nil) notNil]]].
	^classes notEmpty ifTrue: [
		aString = self percent displayName ifTrue: [^self percent].
		self ASSERT: classes size = 1.
		c := classes anyone.
		c := c currentClass.
		c named: aString]]

{ #category : #accessing }
Unit class >> gasCalorificValueUnit [
	^GasCalorificValueUnit currentClass]

{ #category : #accessing }
Unit class >> gorUnit [
	^GORUnit currentClass]

{ #category : #testing }
Unit class >> hasConsistentBaseUnit [
	^true]

{ #category : #testing }
Unit class >> hasCurrency [
	^(self numerators includes: MoneyUnit)
		or: [self denominators includes: MoneyUnit]]

{ #category : #testing }
Unit class >> hasLinearConversion [
	^self isNumeric]

{ #category : #initialization }
Unit class >> initialize [
	self initializeUnits]

{ #category : #'gui support' }
Unit class >> initializeAll [
	DefaultUnits removeAll.
	units := Dictionary new.
	self allUnitTypesDo: [:type | type invalidateUnits].
	CompositeUnitType initialize.
	self allUnitTypesDo: [:type | type initializeUnits]]

{ #category : #initialization }
Unit class >> initializeUnits [
	self initializeUnitsFrom: self conversions]

{ #category : #initialization }
Unit class >> initializeUnitsFrom: aDictionary [
	units := Dictionary new.
	baseUnit := nil.
	aDictionary keysAndValuesDo: [:k :c | | unit |
		unit := self new.
		unit name: k; conversion: c.
		(c = 1.0 and: [baseUnit isNil]) ifTrue: [self baseUnit: unit].
		self add: unit]]

{ #category : #'instance accessing' }
Unit class >> integer [
	^NumberUnit integer]

{ #category : #services }
Unit class >> invalidate [
	"
	Unit invalidate
	"
	Unit allSubclasses
		do: [:class | class invalidateNormalization];
		reject: [:class | class isAbstract]
		thenDo: [:class | class initializeUnits]]

{ #category : #services }
Unit class >> invalidateNormalization [
	normalization := nil]

{ #category : #services }
Unit class >> invalidateNormalizations [
	"
	Unit invalidateNormalizations
	"
	Unit allUnitTypesDo: [:t | t invalidateNormalization]]

{ #category : #initialization }
Unit class >> invalidateUnits [
	units := baseUnit := nil]

{ #category : #accessing }
Unit class >> invalidUnit: aString type: aClass [
	^InvalidUnit defaultUnit]

{ #category : #testing }
Unit class >> isAbstract [
	^self == Unit]

{ #category : #testing }
Unit class >> isCompatibleWith: unitType [
	| n1 d1 n2 d2 |
	^self == unitType
		or: [
			n1 := self allNumerators asOrderedCollection.
			d1 := self allDenominators asOrderedCollection.
			n2 := unitType allNumerators asOrderedCollection.
			d2 := unitType allDenominators asOrderedCollection.
			(n1 equalsTo: n2) and: [d1 equalsTo: d2]]
		or: [
			self simplify: n1 with: d1.
			self simplify: n2 with: d2.
			(n1 equalsTo: n2) and: [d1 equalsTo: d2]]]

{ #category : #testing }
Unit class >> isCompositeUnit [
	^false]

{ #category : #testing }
Unit class >> isDimensionless [
	^false]

{ #category : #testing }
Unit class >> isNumeric [
	^self baseClass == Number]

{ #category : #testing }
Unit class >> isObsolete [
	^false]

{ #category : #testing }
Unit class >> isPercentUnit [
	^false]

{ #category : #testing }
Unit class >> isPrivate [
	^false]

{ #category : #testing }
Unit class >> isPublic [
	self isAbstract ifTrue: [^false].
	self isPrivate ifTrue: [^false].
	^self currentClass == self]

{ #category : #testing }
Unit class >> isQualifier [
	^false]

{ #category : #testing }
Unit class >> isQuantifier [
	^false]

{ #category : #testing }
Unit class >> isRateUnit [
	^false]

{ #category : #testing }
Unit class >> isTimeUnit [
	^false]

{ #category : #testing }
Unit class >> isVolumeUnit [
	^false]

{ #category : #accessing }
Unit class >> leftUnitType [
	^self]

{ #category : #accessing }
Unit class >> liquidYieldUnit [
	^LiquidYieldUnit currentClass]

{ #category : #'instance creation' }
Unit class >> metricUnit [
	^self units at: self defaultMetricUnitName ifAbsent: [self constantsUnit]]

{ #category : #accessing }
Unit class >> moneyPerTimeUnit [
	^MoneyPerTimeUnit currentClass]

{ #category : #arithmetic }
Unit class >> multiply: unitType by: otherUnitType [
	| n d type |
	otherUnitType == InvalidUnit ifTrue: [^otherUnitType].
	type := Unit typeForLeft: unitType right: otherUnitType operator: #'*'.
	type notNil ifTrue: [^type].
	n := unitType numerators & otherUnitType numerators.
	d := unitType denominators & otherUnitType denominators.
	type := Unit findTypeWithNumerators: n denominators: d.
	type notNil ifTrue: [^type].
	n := unitType allNumerators & otherUnitType allNumerators.
	d := unitType allDenominators & otherUnitType allDenominators.
	type := Unit findTypeWithNumerators: n denominators: d.
	type notNil ifTrue: [^type].
	^CompositeUnitType left: unitType operator: #'*' right: otherUnitType]

{ #category : #accessing }
Unit class >> named: aString [
	^self named: aString ifAbsent: nil]

{ #category : #'instance creation' }
Unit class >> namedOrNew: aString [
	^(self named: aString) ifNil: [self newNamed: aString conversion: 1]]

{ #category : #services }
Unit class >> newCurrency: currency [
	| default |
	default := MoneyUnit defaultCurrency.
	self allUnitTypes
		select: [:cls | 
			cls numeratorUnitType == MoneyUnit
				and: [cls units noneSatisfy: [:u | u currency = currency]]]
		thenDo: [:cls | 
			cls publicUnits
				select: [:u | u currency = default]
				thenDo: [:unit | unit inCurrency: currency]]]

{ #category : #'instance creation' }
Unit class >> newNamed: aString conversion: aNumber [
	| new |
	new := self new name: aString; conversion: aNumber.
	new canOverrideConversion ifFalse: [new updateConversion].
	new validate hasPassed ifFalse: [^nil].
	self add: new.
	^new]

{ #category : #accessing }
Unit class >> normalization [
	^1.0]

{ #category : #services }
Unit class >> normalize [
	"
	nothing to do by default
	"
	]

{ #category : #services }
Unit class >> normalizeAll [
	self allUnitTypesDo: [:t | t normalize]]

{ #category : #accessing }
Unit class >> number [
	^NumberUnit defaultInstance]

{ #category : #accessing }
Unit class >> numerator: aUnit denominator: anotherUnit [
	self ASSERT: self isRateUnit.
	^self unitForLeft: aUnit right: anotherUnit]

{ #category : #accessing }
Unit class >> numerators [
	^OrderedCollection with: self numeratorUnitType]

{ #category : #accessing }
Unit class >> numeratorUnitType [
	^self]

{ #category : #accessing }
Unit class >> objects [
	^units]

{ #category : #accessing }
Unit class >> operator [
	^#/]

{ #category : #'instance accessing' }
Unit class >> percent [
	^PercentUnit defaultInstance]

{ #category : #accessing }
Unit class >> publicUnits [
	^self units select: [:u | u isPrivate not] in: OrderedCollection new]

{ #category : #accessing }
Unit class >> publicUnitTypes [
	^(Unit unitTypes select: [:t | t isPublic] in: OrderedCollection new)
		sortBy: #typeName]

{ #category : #testing }
Unit class >> publishesDefaultUnit [
	^self isPublic]

{ #category : #accessing }
Unit class >> quadAFactorUnit [
	^QuadAFactorUnit currentClass]

{ #category : #accessing }
Unit class >> quadFactorUnit [
	^QuadFactorUnit currentClass]

{ #category : #private }
Unit class >> readBaseUnitFrom: aDictionary [
	| base unit |
	base := aDictionary keyAtValue: 1.0 ifAbsent: [
		self ASSERT: false.
		^nil].
	unit := self named: base ifAbsent: nil.
	unit isNil ifTrue: [
		self ASSERT: false.
		^nil].
	^unit]

{ #category : #services }
Unit class >> readDefaultUnits [
	| file |
	file := FileDialog new
		title: 'Open an Json File';
		fileSpec: '*.json';
		defExtension: 'json';
		fileMustExist;
		open;
		file.
	file isNil ifTrue: [^self].
	self readDefaultUnitsFrom: file asFilename]

{ #category : #services }
Unit class >> readDefaultUnitsFrom: aFilename [
	| file d |
	file := aFilename asFilename asFile readStream.
	[d := (JsonParser on: file) next] ensure: [file close].
	d keysAndValuesDo: [:k :u | 
		(DefaultUnits at: k)
			unit: (Unit fromJson: (u at: 'unit'));
			decimals: ((u at: 'format') at: 'decimals')]]

{ #category : #services }
Unit class >> readUnitsFrom: aDictionary [
	| base answer |
	self hasLinearConversion ifFalse: [^#()].
	aDictionary isEmpty ifTrue: [^#()].
	base := self readBaseUnitFrom: aDictionary.
	base isNil ifTrue: [^#()].
	answer := OrderedCollection new: aDictionary size.
	aDictionary keysAndValuesDo: [:k :v | | c u |
		c := base convert: v.
		u := self defineUnit: k conversion: c.
		answer add: u].
	^answer]

{ #category : #services }
Unit class >> registerUnit: aUnit [
	| key existing |
	key := aUnit name asLowercase.
	existing := units at: key ifAbsent: nil.
	existing isNil ifTrue: [
		units at: key put: aUnit.
		^self].
	existing isCollection
		ifTrue: [
			self ASSERT: (existing conform: [:u | u type != aUnit type]).
			existing add: aUnit]
		ifFalse: [
			self ASSERT: existing type != aUnit type.
			units at: key put: (OrderedCollection with: existing with: aUnit)]]

{ #category : #arithmetic }
Unit class >> relatedFluidFrom: leftUnitType and: rightUnitType [
	| f1 f2 |
	f1 := leftUnitType relatedFluid.
	f2 := rightUnitType relatedFluid.
	f2 = f1 ifTrue: [^f1].
	f1 isNil ifTrue: [^f2].
	f2 isNil ifTrue: [^f1].
	^nil]

{ #category : #services }
Unit class >> removeMigrationProperties [
	Unit
		allUnitsDo: [:u | u
			removeProperty: #oldConversion;
			removeProperty: #newUnit]]

{ #category : #accessing }
Unit class >> removeUnit: aUnit [
	self haltWhen: aUnit name = 'acre'.
	aUnit name = 'acre' ifTrue: [^self].
	Unit unregisterUnit: aUnit.
	self units removeKey: aUnit name ifAbsent: nil; markDirty]

{ #category : #services }
Unit class >> resetAllToSystemUnits [
	units := Dictionary new.
	self traceUnitConversionChangesWhile: [
		self allUnitTypesDo: [:type | 
			type resetToSystemUnits.
			type units do: [:u | Unit registerUnit: u]]]]

{ #category : #services }
Unit class >> resetToSystemUnits [
	self readUnitsFrom: self conversions.
	units copy do: [:u | u isSystemUnit ifFalse: [self removeUnit: u]]]

{ #category : #services }
Unit class >> resolveUnit: aUnit [
	| stream type u uname |
	aUnit isString ifFalse: [^aUnit].
	stream := aUnit readStream.
	(aUnit includes: $:) ifTrue: [
		type := stream upTo: $:.
		type := self resolveUnitType: type].
	type isNil ifTrue: [type := self].
	uname := stream upToEnd trimBlanks.
	u := type named: uname.
	u isNil ifTrue: [u := Unit named: uname].
	u isCollection ifTrue: [^u anyone].
	^u]

{ #category : #services }
Unit class >> resolveUnitType: aClass [
	| type |
	aClass isString ifFalse: [^aClass].
	type := Unit unitTypeNamed: aClass.
	type isNil ifTrue: [self unresolvedUnitType: aClass].
	^type]

{ #category : #accessing }
Unit class >> rightUnitType [
	^NumberUnit]

{ #category : #arithmetic }
Unit class >> simplify: num with: den [
	num removeAllSuchThat: [:t | t == NumberUnit].
	den removeAllSuchThat: [:t | t == NumberUnit].
	num copy do: [:u | 
		(den includes: u) ifTrue: [
			num remove: u.
			den remove: u]].
	num isEmpty ifTrue: [num add: NumberUnit]]

{ #category : #accessing }
Unit class >> squared [
	^CompositeUnitType left: self operator: #'*' right: self]

{ #category : #accessing }
Unit class >> timePerLengthUnit [
	^TimePerLengthUnit currentClass]

{ #category : #accessing }
Unit class >> typeForLeft: lUnitType right: rUnitType operator: symbol [
	^Unit unitTypes
		detect: [:c | 
			c operator == symbol
				and: [c rightUnitType == rUnitType]
				and: [c leftUnitType == lUnitType]]
		ifNone: nil]

{ #category : #arithmetic }
Unit class >> typeWithNumerators: num denominators: den [
	^self typeWithNumerators: num denominators: den preferredFluid: nil]

{ #category : #arithmetic }
Unit class >> typeWithNumerators: num denominators: den preferredFluid: aFluid [
	| candidate |
	Unit allUnitTypesDo: [:type | | n d f |
		n := type allNumerators asOrderedCollection.
		d := type allDenominators asOrderedCollection.
		self simplify: n with: d.
		((n equalsTo: num) and: [d equalsTo: den]) ifTrue: [
			f := type relatedFluid.
			f = aFluid ifTrue: [^type].
			f isNil ifTrue: [candidate := type]]].
	^candidate]

{ #category : #services }
Unit class >> undefinedValue [
	^FmlUndefinedValue new]

{ #category : #accessing }
Unit class >> unitConversions [
	"
	MoneyUnit unitConversions
	"
	^self units collect: [:u | u conversion]]

{ #category : #'instance accessing' }
Unit class >> unitForLeft: lUnit right: rUnit [
	^self existingUnitForLeft: lUnit right: rUnit]

{ #category : #accessing }
Unit class >> units [
	units isNil ifTrue: [self initializeUnits].
	^units]

{ #category : #accessing }
Unit class >> units: aCollection [
	self ASSERT: false.
	units := aCollection]

{ #category : #accessing }
Unit class >> unitTypeNamed: aString [
	self
		withAllSubclassesDo: [:type | (type isAbstract not
			and: [type typeName = aString])
			ifTrue: [^type]].
	^CompositeUnitType types
		detect: [:type | type typeName = aString]
		ifNone: nil]

{ #category : #accessing }
Unit class >> unitTypes [
	| types |
	types := Dictionary new.
	self
		withAllSubclassesDo: [:class | class isAbstract
			ifFalse: [types at: class typeName put: class]].
	^types]

{ #category : #services }
Unit class >> unitWithNumerators: numUnits denominators: denUnits [
	| n d |
	n := numUnits reject: #isNumberUnit.
	n isEmpty ifTrue: [n := {NumberUnit defaultInstance}].
	d := denUnits reject: #isNumberUnit.
	^self units
		detect: [:unit | (unit allNumerators equalsTo: n)
			and: [unit allDenominators equalsTo: d]]
		ifNone: nil]

{ #category : #services }
Unit class >> unregister: aString [
	self halt.
	^units removeKey: aString ifAbsent: nil]

{ #category : #services }
Unit class >> unregisterUnit: aUnit [
	| key existing |
	key := aUnit name asLowercase.
	existing := units at: key ifAbsent: [^nil].
	(existing isCollection and: [existing size > 1])
		ifTrue: [existing remove: aUnit]
		ifFalse: [units removeKey: key]]

{ #category : #services }
Unit class >> unresolvedUnitType: aString [
	UnresolvedName
		signal: 'Could not find the unit type ' , aString printString]

{ #category : #services }
Unit class >> updateDependentsOf: aUnit [
	self units do: [:u | (u dependsOn: aUnit) ifTrue: [u update]]]

{ #category : #services }
Unit class >> updateUnitsFrom: aDictionary [
	| all |
	all := self allUnits.
	self traceUnitConversionChangesWhile: [
		self allUnitTypesDo: [:type | | read d |
			d := aDictionary at: type ifAbsent: nil.
			d notNil ifTrue: [
				read := type readUnitsFrom: d.
				all removeAll: read ifAbsent: nil]].
		self allUnitsDo: [:u | u updateConversion].
		all do: [:u | u isSystemUnit ifFalse: [u type removeUnit: u]]]]

{ #category : #validation }
Unit class >> validateNewName: aString [
	^self validatorClass validate: self selector: #validateName: with: aString]

{ #category : #validation }
Unit class >> validatorClass [
	^UnitValidator]

{ #category : #private }
Unit class >> validCode: aString [
	^self == Unit ifTrue: [aString asLowercase] ifFalse: [
		aString
			collect: [:ch | ch isNumeric ifTrue: [ch regularDigit] ifFalse: [ch]]]]

{ #category : #accessing }
Unit class >> volumeRatioUnit [
	^VolumeRatioUnit currentClass]

{ #category : #accessing }
Unit class >> volumeUnit [
	^LiquidVolumeUnit currentClass]

{ #category : #services }
Unit class >> withId: aString [
	| stream type u uname |
	aString isString ifFalse: [^aString].
	stream := aString readStream.
	(aString includes: $:) ifTrue: [
		type := stream upTo: $:.
		type := self unitTypeNamed: type.
		type isNil ifTrue: [^nil]].
	type isNil ifTrue: [type := self].
	uname := stream upToEnd trimBlanks.
	u := type named: uname.
	u isNil ifTrue: [u := Unit named: uname].
	u isCollection ifTrue: [^u size = 1 ifTrue: [u anyone]].
	^u]

{ #category : #accessing }
Unit class >> withName: aString [
	^self named: aString ifAbsent: [self invalidUnit: aString type: self]]

{ #category : #arithmetic }
Unit >> - aUnit [
	^self + aUnit]

{ #category : #arithmetic }
Unit >> & aUnit [
	^self + aUnit]

{ #category : #arithmetic }
Unit >> * aUnit [
	| n d u t |
	aUnit isInvalidUnit ifTrue: [^aUnit].
	t := self class typeForLeft: self type right: aUnit type operator: #'*'.
	t notNil ifTrue: [
		u := t unitForLeft: self right: aUnit.
		u notNil ifTrue: [^u]].
	(self isDecomposable or: [aUnit isDecomposable]) ifTrue: [
		n := self numerators & aUnit numerators.
		d := self denominators & aUnit denominators.
		u := self simplify: n with: d.
		u notNil ifTrue: [^u].
		n := self allNumerators & aUnit allNumerators.
		d := self allDenominators & aUnit allDenominators.
		u := self simplify: n with: d.
		u notNil ifTrue: [^u]].
	self isMultiplicativeIdentity ifTrue: [^aUnit].
	^self resultUnitFor: #'*' with: aUnit]

{ #category : #arithmetic }
Unit >> / aUnit [
	| n d u t |
	aUnit isInvalidUnit ifTrue: [^aUnit].
	aUnit == self ifTrue: [^NumberUnit defaultInstance].
	t := self class typeForLeft: self type right: aUnit type operator: #'/'.
	t notNil ifTrue: [^(t unitForLeft: self right: aUnit) ifNil: [t defaultUnit]].
	(self isDecomposable or: [aUnit isDecomposable]) ifTrue: [
		n := self numerators & aUnit denominators.
		d := self denominators & aUnit numerators.
		u := self simplify: n with: d.
		u notNil ifTrue: [^u].
		n := self allNumerators & aUnit allDenominators.
		d := self allDenominators & aUnit allNumerators.
		u := self simplify: n with: d.
		u notNil ifTrue: [^u]].
	^self resultUnitFor: #'/' with: aUnit]

{ #category : #arithmetic }
Unit >> // aUnit [
	^self / aUnit]

{ #category : #arithmetic }
Unit >> \\ aUnit [
	^self]

{ #category : #arithmetic }
Unit >> | aUnit [
	^self + aUnit]

{ #category : #arithmetic }
Unit >> + aUnit [
	aUnit type = self type ifTrue: [^self].
	((self type isCompatibleWith: aUnit type)
		and: [self hasConsistentBaseUnit]
		and: [aUnit hasConsistentBaseUnit])
		ifTrue: [^self].
	^InvalidUnit defaultInstance]

{ #category : #comparing }
Unit >> <= aUnit [
	^self name <= aUnit name]

{ #category : #comparing }
Unit >> = aUnit [
	^self class == aUnit class
		and: [name = aUnit name and: [conversion = aUnit conversion]]]

{ #category : #private }
Unit >> aboutToRenameWith: aString [
	"
	do nothing here
	"
	]

{ #category : #'file in/out' }
Unit >> activated [
	| u |
	u := self type named: name.
	u isNil
		ifTrue: [self validate hasPassed ifTrue: [u := self type add: self]]
		ifFalse: [u].
	^u]

{ #category : #private }
Unit >> activeReplacement [
	| u |
	u := self defaultUnit.
	u isActive ifTrue: [^u].
	u := self type constantsUnit.
	u isActive ifTrue: [^u].
	^self type baseUnit]

{ #category : #converting }
Unit >> adaptType: value [
	self isNumeric ifFalse: [^value].
	value isNumber ifTrue: [^value].
	value isUndefinedValue ifTrue: [^value].
	value isString ifTrue: [^self undefinedValue].
	value isBoolean ifTrue: [^self undefinedValue].
	value isDate ifTrue: [^self undefinedValue].
	value isArrayValued ifTrue: [
		(value conform: [:each | each isNumber]) ifTrue: [^value asFloatArray].
		^(value collect: [:each | (self adaptType: each) asFloat]) asFloatArray].
	self ASSERT: false.
	^value]

{ #category : #services }
Unit >> addConversionTo: aString [
	self isBaseUnit ifTrue: [^aString].
	^aString , ' * ' , self conversion storeString]

{ #category : #accessing }
Unit >> allDenominators [
	^#()]

{ #category : #accessing }
Unit >> allNumerators [
	^{self}]

{ #category : #testing }
Unit >> allowsMagicConstants [
	^false]

{ #category : #converting }
Unit >> asJson [
	| json |
	json := JsonObject new.
	json
		at: 'Type' put: self type typeName;
		at: 'Name' put: self name;
		at: 'Conversion' put: conversion.
	^json]

{ #category : #converting }
Unit >> asUnitFormat [
	^UnitFormat unit: self decimals: self defaultDecimalPlaces]

{ #category : #accessing }
Unit >> baseClass [
	^self type baseClass]

{ #category : #accessing }
Unit >> baseClassName [
	^self type baseClassName]

{ #category : #converting }
Unit >> baseValueOf: quantity [
	quantity isUndefinedValue ifTrue: [^quantity].
	quantity isNumber ifTrue: [^quantity asFloat / self conversion].
	quantity isString ifTrue: [^self fromNLString: quantity].
	(quantity isDate or: [quantity isTimestamp]) ifTrue: [^quantity asDate].
	quantity isCsrVariable ifTrue: [^self baseValueOf: quantity basicValue].
	quantity isArrayValued
		ifTrue: [^quantity collect: [:v | self baseValueOf: v]].
	^0.0]

{ #category : #converting }
Unit >> baseValueOfMomentum: quantity [
	^(self baseValueOf: quantity) - (self baseValueOf: 0.0)]

{ #category : #converting }
Unit >> baseValueOfSd: quantity [
	^self baseValueOfMomentum: quantity]

{ #category : #converting }
Unit >> baseValueOfSquare: quantity [
	^self baseValueOf: (self baseValueOf: quantity)]

{ #category : #converting }
Unit >> beBaseUnit [
	self isBaseUnit ifTrue: [^self].
	self type changeBaseTo: self]

{ #category : #converting }
Unit >> beBaseUnitAndNormalize [
	| type |
	self beBaseUnit.
	type := self type.
	Unit allUnitTypesDo: [:t | t == type ifFalse: [t adaptToBase: self]]]

{ #category : #services }
Unit >> beDefault [
	self beDefaultFor: self type typeName]

{ #category : #testing }
Unit >> canBeConverted [
	^self hasLinearConversion or: [self isBaseUnit]]

{ #category : #testing }
Unit >> canBeDeleted [
	^self isUserDefined]

{ #category : #testing }
Unit >> canBeEdited [
	^self hasLinearConversion and: [self canOverrideConversion]]

{ #category : #testing }
Unit >> canChangeFormat [
	^true]

{ #category : #testing }
Unit >> canChangeUnit [
	^self type canChangeUnit]

{ #category : #testing }
Unit >> canOverrideConversion [
	^self isUserDefined]

{ #category : #copying }
Unit >> clone [
	^self shallowCopyTo: self class new]

{ #category : #converting }
Unit >> conversion [
	^conversion]

{ #category : #converting }
Unit >> conversion: aNumberOrNil [
	conversion = aNumberOrNil ifTrue: [^self].
	conversion := aNumberOrNil notNil ifTrue: [aNumberOrNil asFloat]]

{ #category : #converting }
Unit >> conversionString [
	^self conversion asString]

{ #category : #converting }
Unit >> convert: aNumber [
	| number |
	number := aNumber value.
	number isNumber ifFalse: [^number].
	^number * conversion]

{ #category : #converting }
Unit >> convertDensity: aNumber [
	| converted |
	aNumber ~ 0.0 ifTrue: [^0.0].
	converted := self convert: aNumber value reciprocal.
	converted ~ 0.0 ifTrue: [^0.0].
	^converted reciprocal]

{ #category : #converting }
Unit >> convertMomentum: aNumber [
	| v |
	v := self convert: aNumber.
	(self isNumeric andNot: [self hasLinearConversion])
		ifTrue: [v := v - (self convert: 0.0)].
	^v]

{ #category : #converting }
Unit >> convertRange: aRange [
	| lower upper range parent |
	lower := aRange lowerBound ifNotNil: [:b | self safeConvert: b].
	upper := aRange upperBound ifNotNil: [:b | self safeConvert: b].
	range := aRange copy.
	range isSubrange ifTrue: [
		parent := range parentRange.
		parent notNil ifTrue: [
			parent := self convertRange: parent.
			range setRange: parent]].
	range lowerBound: lower; upperBound: upper.
	(lower notNil and: [upper notNil] and: [lower > upper]) ifTrue: [range swap].
	^range]

{ #category : #converting }
Unit >> convertSd: aNumber [
	^self convertMomentum: aNumber]

{ #category : #converting }
Unit >> convertSquare: aNumber [
	| once |
	once := self convert: aNumber.
	^self convert: once]

{ #category : #converting }
Unit >> convertValue: aNumber toUnit: aUnit in: context [
	self ASSERT: [aUnit type isCompatibleWith: self type].
	^self convert: aNumber]

{ #category : #defaults }
Unit >> defaultArrayClass [
	^self type defaultArrayClass]

{ #category : #accessing }
Unit >> defaultDecimalPlaces [
	^self type defaultDecimalPlaces]

{ #category : #defaults }
Unit >> defaultUnit [
	^self type defaultUnit]

{ #category : #defaults }
Unit >> defaultValue [
	^self type defaultValue]

{ #category : #accessing }
Unit >> denominator [
	^self isRateUnit
		ifTrue: [self rightUnit]
		ifFalse: [NumberUnit defaultInstance]]

{ #category : #accessing }
Unit >> denominators [
	^#()]

{ #category : #accessing }
Unit >> denominatorUnitType [
	^self type denominatorUnitType]

{ #category : #accessing }
Unit >> dependentsDo: aBlock [
	Unit allUnitsDo: [:u | (u dependsOn: self) ifTrue: [aBlock value: u]]]

{ #category : #inquiries }
Unit >> dependentUnits [
	| dependents |
	dependents := OrderedCollection new.
	self dependentsDo: [:u | dependents add: u].
	^dependents]

{ #category : #testing }
Unit >> dependsOn: aUnit [
	^false]

{ #category : #'gui support' }
Unit >> display [
	^name ifNil: ['']]

{ #category : #'gui support' }
Unit >> displayName [
	| read alpha ch string |
	string := self name replaceAll: ' /' with: '/'.
	string := string replaceAll: '/ ' with: '/'.
	self type hasCurrency ifTrue: [string := MoneyUnit displayNameFor: string].
	read := string readStream.
	alpha := false.
	^String streamContents: [:write | 
		[read atEnd] whileFalse: [
			ch := read next.
			ch = $^ ifTrue: [alpha := true] ifFalse: [
				ch = $3 & alpha ifTrue: [ch := $³].
				ch = $2 & alpha ifTrue: [ch := $²].
				write nextPut: ch.
				alpha := ch isLetter]]]]

{ #category : #'gui support' }
Unit >> displayString: aNumber [
	^(self convert: aNumber) printNLString]

{ #category : #converting }
Unit >> displayValue: aNumber withUnit: aUnit in: context [
	^aUnit convert: aNumber]

{ #category : #services }
Unit >> dumpConversionOf: aString on: rtf [
	| converted |
	converted := self addConversionTo: aString.
	rtf append: converted]

{ #category : #'gui support' }
Unit >> format [
	^nil]

{ #category : #accessing }
Unit >> fromNLString: aString [
	^self baseValueOf: (Float fromNLString: aString)]

{ #category : #converting }
Unit >> fromString: aString [
	| float |
	float := self valueFromString: aString.
	^float notNil ifTrue: [self baseValueOf: float]]

{ #category : #testing }
Unit >> hasConsistentBaseUnit [
	^self type hasConsistentBaseUnit]

{ #category : #comparing }
Unit >> hash [
	^self type hashWith: name with: conversion]

{ #category : #testing }
Unit >> hasLinearConversion [
	^self class hasLinearConversion]

{ #category : #testing }
Unit >> hasSystemUnitType [
	^true]

{ #category : #accessing }
Unit >> id [
	| u |
	u := Unit named: self name.
	^(u isCollection and: [u size > 1])
		ifTrue: [self modelName]
		ifFalse: [self name]]

{ #category : #'excel translation' }
Unit >> inferredUnit [
	^self]

{ #category : #initialization }
Unit >> initialize [
	name := 'unnamed'.
	self initializeConversion]

{ #category : #initialization }
Unit >> initializeConversion [
	conversion := 0.0]

{ #category : #testing }
Unit >> isActive [
	^self type units includesIdentical: self]

{ #category : #testing }
Unit >> isAreaUnit [
	^false]

{ #category : #testing }
Unit >> isBaseUnit [
	^self type baseUnit == self]

{ #category : #testing }
Unit >> isBooleanUnit [
	^false]

{ #category : #testing }
Unit >> isComparableWith: aUnit [
	^(self isCompatibleWith: aUnit)
		and: [(conversion log: 10.0) rounded = (aUnit conversion log: 10.0) rounded]]

{ #category : #testing }
Unit >> isCompatibleWith: aUnit [
	^self type isCompatibleWith: aUnit type]

{ #category : #testing }
Unit >> isCompositeUnit [
	^self type isCompositeUnit]

{ #category : #testing }
Unit >> isConstantsUnit [
	^self == self type constantsUnit]

{ #category : #testing }
Unit >> isCostUnit [
	^false]

{ #category : #testing }
Unit >> isDateUnit [
	^false]

{ #category : #testing }
Unit >> isDecomposable [
	^false]

{ #category : #testing }
Unit >> isDefaultUnit [
	^self == self defaultUnit]

{ #category : #testing }
Unit >> isDimensionless [
	^self type isDimensionless]

{ #category : #testing }
Unit >> isGasRateUnit [
	^false]

{ #category : #testing }
Unit >> isGasVolumeUnit [
	^false]

{ #category : #testing }
Unit >> isIntegerUnit [
	^false]

{ #category : #testing }
Unit >> isInvalidUnit [
	^false]

{ #category : #testing }
Unit >> isLengthUnit [
	^false]

{ #category : #testing }
Unit >> isLiquidUnit [
	^false]

{ #category : #testing }
Unit >> isMoneyUnit [
	^false]

{ #category : #testing }
Unit >> isMultiplicativeIdentity [
	^false]

{ #category : #testing }
Unit >> isNumberUnit [
	^self type number == self]

{ #category : #testing }
Unit >> isNumeric [
	^self type isNumeric]

{ #category : #testing }
Unit >> isObsolete [
	^self type isObsolete]

{ #category : #testing }
Unit >> isOilRateUnit [
	^false]

{ #category : #testing }
Unit >> isPercent [
	^false]

{ #category : #testing }
Unit >> isPercentUnit [
	^self type isPercentUnit]

{ #category : #testing }
Unit >> isPrivate [
	^false]

{ #category : #testing }
Unit >> isRateUnit [
	^self type isRateUnit]

{ #category : #testing }
Unit >> isStringUnit [
	^false]

{ #category : #testing }
Unit >> isSystemUnit [
	^self type conversions includesKey: name]

{ #category : #testing }
Unit >> isTimeUnit [
	^self type isTimeUnit]

{ #category : #testing }
Unit >> isUnnamed [
	^name isNil or: [name = 'unnamed']]

{ #category : #testing }
Unit >> isUserDefined [
	^self isSystemUnit not]

{ #category : #accessing }
Unit >> leftUnit [
	^self]

{ #category : #testing }
Unit >> matchesLeft: aUnit right: anotherUnit [
	^self leftUnit = aUnit and: [self rightUnit = anotherUnit]]

{ #category : #services }
Unit >> maxRepresentableRange [
	^Range open: self minRepresentableValue open: self maxRepresentableValue]

{ #category : #converting }
Unit >> maxRepresentableValue [
	| max |
	max := Float maxValue / 10.0.
	^max * (1.0 min: conversion)]

{ #category : #converting }
Unit >> minRepresentableValue [
	| min |
	min := Float minValue / 10.0.
	^min * (1.0 min: conversion)]

{ #category : #accessing }
Unit >> modelName [
	^self typeName , ': ' , name]

{ #category : #accessing }
Unit >> name [
	^name ifNil: ['']]

{ #category : #accessing }
Unit >> name: aString [
	| active |
	name = aString ifTrue: [^self].
	self ASSERT: aString isString.
	active := self isActive.
	active ifTrue: [
		self aboutToRenameWith: aString.
		self type removeUnit: self].
	name := aString.
	active ifTrue: [self type addUnit: self]]

{ #category : #'file in/out' }
Unit >> needsConversionMigrationTo: u [
	^conversion notNil
		and: [(u conversion relativeDistanceTo: conversion) > 0.0001]]

{ #category : #converting }
Unit >> normalization [
	^self type normalization]

{ #category : #accessing }
Unit >> numerator [
	^self]

{ #category : #accessing }
Unit >> numerators [
	^OrderedCollection with: self numerator]

{ #category : #accessing }
Unit >> numeratorUnitType [
	^self type numeratorUnitType]

{ #category : #services }
Unit >> oldConversionFrom: aDictionary [
	| valid |
	^self isActive ifTrue: [aDictionary at: self ifAbsent: nil] ifFalse: [
		valid := self validUnit.
		(self name = valid name andNot: [self conversion = valid conversion])
			ifTrue: [self conversion]]]

{ #category : #printing }
Unit >> printOn: aStream [
	aStream nextPutAll: self display asString]

{ #category : #printing }
Unit >> printTextOn: rtf [
	| string read mapping |
	string := self displayName.
	read := string readStream.
	mapping := Dictionary new.
	mapping
		at: $² put: #squared;
		at: $³ put: #cubic;
		at: $º put: #degree.
	self isBaseUnit ifTrue: [rtf bold].
	self isConstantsUnit ifTrue: [rtf underline].
	[read atEnd] whileFalse: [| ch cmd |
		ch := read next.
		cmd := mapping at: ch ifAbsent: nil.
		cmd isNil ifTrue: [rtf nextPut: ch] ifFalse: [rtf perform: cmd]].
	self isBaseUnit ifTrue: [rtf boldOff].
	self isConstantsUnit ifTrue: [rtf underlineOff].]

{ #category : #arithmetic }
Unit >> raisedTo: aUnit [
	^nil]

{ #category : #testing }
Unit >> refersTo: aUnit [
	^name includesString: aUnit display]

{ #category : #removing }
Unit >> remove [
	self ASSERT: self canBeDeleted.
	self type deleteUserUnit: self]

{ #category : #copying }
Unit >> resistsCopying [
	^true]

{ #category : #private }
Unit >> resultUnitFor: operation with: aUnit [
	| type u |
	aUnit isMultiplicativeIdentity ifTrue: [^self].
	type := self type perform: operation with: aUnit type.
	type isNil ifTrue: [^InvalidUnit defaultInstance].
	type = self numeratorUnitType ifTrue: [^self numerator].
	type = aUnit numeratorUnitType ifTrue: [^aUnit numerator].
	type = aUnit denominatorUnitType ifTrue: [^aUnit denominator].
	u := (type leftUnitType = self type and: [type rightUnitType = aUnit type])
		ifTrue: [type unitForLeft: self right: aUnit].
	^u ifNil: [type defaultUnit]]

{ #category : #accessing }
Unit >> rightUnit [
	^Unit number]

{ #category : #converting }
Unit >> safeConvert: aNumber [
	^[self convert: aNumber] on: ArithmeticError do: [:e | 
		(aNumber > 0.0 and: [conversion > 1.0])
			ifTrue: [e return: self maxRepresentableValue].
		(aNumber < 0.0 and: [conversion > 1.0])
			ifTrue: [e return: self minRepresentableValue].
		self ASSERT: false.
		e return: nil]]

{ #category : #'gui support' }
Unit >> sameTypeUnits [
	| units |
	units := self type publicUnits
		sortBy: [:u1 :u2 | u1 visibleDisplayName asLowercase
			< u2 visibleDisplayName asLowercase].
	(units includes: self) ifFalse: [units add: self].
	^units]

{ #category : #copying }
Unit >> shallowCopy [
	self ASSERT: false.
	^self]

{ #category : #private }
Unit >> simplify: numUnits with: denUnits [
	| num den numTypes denTypes type |
	(numUnits isEmpty or: [denUnits isEmpty]) ifTrue: [^nil].
	num := numUnits reject: [:t | t type == NumberUnit].
	den := denUnits reject: [:t | t type == NumberUnit].
	num copy do: [:n | 
		(den includes: n) ifTrue: [
			num remove: n.
			den remove: n]]. 
	num copy do: [:n | | t d |
		t := n type.
		d := den detect: [:one | one type == t] ifNone: nil.
		d notNil ifTrue: [
			num remove: n.
			den remove: d]].
	num isEmpty ifTrue: [num add: NumberUnit defaultInstance].
	(den size = 1 and: [num size = 1]) ifTrue: [^num first / den first].
	(den isEmpty and: [num size = 1]) ifTrue: [^num first].
	numTypes := num collect: #type.
	denTypes := den collect: #type.
	type := Unit typeWithNumerators: numTypes denominators: denTypes.
	^type notNil ifTrue: [type unitWithNumerators: num denominators: den]]

{ #category : #arithmetic }
Unit >> sqrt [
	^nil]

{ #category : #arithmetic }
Unit >> squared [
	^self * self]

{ #category : #accessing }
Unit >> type [
	^self class]

{ #category : #accessing }
Unit >> typeName [
	^self type typeName]

{ #category : #services }
Unit >> undefinedValue [
	^self class undefinedValue]

{ #category : #accessing }
Unit >> unit [
	^self]

{ #category : #services }
Unit >> unitFormatAdjustedFor: aNumber [
	| value |
	value := self convert: aNumber.
	^UnitFormat unit: self decimals: value log floor abs]

{ #category : #private }
Unit >> update [
	"
	nothing by default
	"
	]

{ #category : #private }
Unit >> updateConversion [
	"
	nothing here
	"
	]

{ #category : #private }
Unit >> updateDependents [
	| t |
	t := self type.
	Unit
		allUnitTypesDo: [:type | (type dependsOn: t)
			ifTrue: [type updateDependentsOf: self]]]

{ #category : #accessing }
Unit >> updateFrom: aUnit [
	self ASSERT: self class == aUnit class.
	self name: aUnit name; conversion: aUnit conversion; updateDependents]

{ #category : #services }
Unit >> validUnit [
	self isActive ifTrue: [^self].
	^self activated ifNil: [self type defaultInstance]]

{ #category : #accessing }
Unit >> validUnitTypes [
	^{self unit type}]

{ #category : #'gui support' }
Unit >> valueFromDisplay: aString [
	^Float fromNLString: aString]

{ #category : #converting }
Unit >> valueFromString: aString [
	| string |
	string := aString trimBlanks replaceAll: 'E' with: 'e'.
	(string anySatisfy: [:c | c isAsciiLetter and: [c ~~ $e]]) ifTrue: [^nil].
	^Float fromNLString: string]

{ #category : #'gui support' }
Unit >> visibleDisplayName [
	| text |
	text := self displayName.
	^text isEmpty ifTrue: [self name] ifFalse: [text]]

{ #category : #accessing }
Unit >> withDependentsDo: aBlock [
	self dependentsDo: aBlock.
	aBlock value: self]

