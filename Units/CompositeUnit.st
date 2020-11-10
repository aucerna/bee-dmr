"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CompositeUnit,
	#superclass : #Unit,
	#instVars : [
		'left',
		'right'
	],
	#category : #Units
}

{ #category : #private }
CompositeUnit class >> adapt: unitType toBase: aUnit [
	| u right left |
	unitType leftUnitType = aUnit type
		ifTrue: [
			left := aUnit.
			right := unitType rightUnitType baseUnit]
		ifFalse: [
			unitType rightUnitType = aUnit type
				ifTrue: [
					right := aUnit.
					left := unitType leftUnitType baseUnit]
				ifFalse: [^self]].
	u := unitType unitForLeft: left right: right.
	u isNil ifTrue: [
		u := unitType newForLeft: left right: right.
		unitType add: u].
	u beBaseUnitAndNormalize]

{ #category : #private }
CompositeUnit class >> adaptToBase: aUnit [
	self adapt: self toBase: aUnit]

{ #category : #accessing }
CompositeUnit class >> allDenominators [
	| denominators op |
	denominators := self leftUnitType allDenominators.
	op := self operator.
	op == #'*' ifTrue: [^denominators & self rightUnitType allDenominators].
	op == #'/' ifTrue: [^denominators & self rightUnitType allNumerators].
	self ASSERT: false.
	^#()]

{ #category : #accessing }
CompositeUnit class >> allNumerators [
	| numerators op |
	numerators := self leftUnitType allNumerators.
	op := self operator.
	op == #'*' ifTrue: [^numerators & self rightUnitType allNumerators].
	op == #'/' ifTrue: [^numerators & self rightUnitType allDenominators].
	self ASSERT: false.
	^#()]

{ #category : #private }
CompositeUnit class >> componentTypes [
	^{self leftUnitType. self rightUnitType}]

{ #category : #services }
CompositeUnit class >> consistentBaseUnit [
	^self
		unitForLeft: self leftUnitType baseUnit
		right: self rightUnitType baseUnit]

{ #category : #accessing }
CompositeUnit class >> defaultMetricUnitName [
	| u |
	u := self
		unitForLeft: self leftUnitType metricUnit
		right: self rightUnitType metricUnit.
	^u notNil ifTrue: [u name] ifFalse: [super defaultMetricUnitName]]

{ #category : #accessing }
CompositeUnit class >> denominators [
	self operator == #'*' ifTrue: [^#()].
	self operator == #'/' ifTrue: [^{self rightUnitType}].
	self ASSERT: false.
	^super denominators]

{ #category : #testing }
CompositeUnit class >> dependsOn: unitType [
	^(super dependsOn: unitType)
		or: [self leftUnitType dependsOn: unitType]
		or: [self rightUnitType dependsOn: unitType]]

{ #category : #'instance creation' }
CompositeUnit class >> fromJson: aJsonObject [
	| n unit op1 left op2 right |
	n := aJsonObject at: 'Name'.
	unit := self named: n.
	unit notNil ifTrue: [^unit].
	op1 := aJsonObject valueAt: 'Left'.
	op1 isNil ifTrue: [^nil].
	left := Unit fromJson: op1.
	op2 := aJsonObject valueAt: 'Right'.
	right := Unit fromJson: op2.
	^unit notNil ifTrue: [unit] ifFalse: [self newForLeft: left right: right]]

{ #category : #testing }
CompositeUnit class >> hasConsistentBaseUnit [
	| base |
	base := self baseUnit.
	^base leftUnit = self leftUnitType baseUnit
		and: [base rightUnit = self rightUnitType baseUnit]]

{ #category : #initialization }
CompositeUnit class >> initializeUnitsFrom: anArray [
	| numType denType base |
	units := Dictionary new.
	numType := self leftUnitType.
	denType := self rightUnitType.
	base := self newBaseUnitLeft: numType baseUnit right: denType baseUnit.
	self add: base.
	anArray pairsDo: [:n :d | | new num den |
		num := numType named: n.
		den := denType named: d.
		self ASSERT: num notNil & den notNil.
		(base leftUnit = num and: [base rightUnit = den]) ifFalse: [
			new := self newForLeft: num right: den.
			self add: new]]]

{ #category : #testing }
CompositeUnit class >> isAbstract [
	^self == CompositeUnit]

{ #category : #testing }
CompositeUnit class >> isCompositeUnit [
	^true]

{ #category : #testing }
CompositeUnit class >> isRateUnit [
	^self operator = #/]

{ #category : #testing }
CompositeUnit class >> isSquaredUnit [
	^self leftUnitType = self rightUnitType and: [self operator = #'*']]

{ #category : #accessing }
CompositeUnit class >> leftUnitType [
	^self numeratorUnitType]

{ #category : #'instance creation' }
CompositeUnit class >> newBaseUnitLeft: lUnit right: rUnit [
	| base |
	base := self new
		leftUnit: lUnit;
		rightUnit: rUnit;
		conversion: 1.0;
		updateName.
	self baseUnit: base.
	^baseUnit]

{ #category : #'instance creation' }
CompositeUnit class >> newForLeft: lUnit right: rUnit [
	^self new
		leftUnit: lUnit;
		rightUnit: rUnit;
		update]

{ #category : #'instance creation' }
CompositeUnit class >> newNamed: aString conversion: aNumber [
	| new stream n d |
	stream := aString readStream.
	n := stream upToAll: self operator.
	d := stream upToEnd.
	n := self leftUnitType named: n.
	d := self rightUnitType named: d.
	(n notNil and: [d notNil])
		ifTrue: [
			new := self newForLeft: n right: d.
			self ASSERT: aNumber = new conversion.
			new name: aString; conversion: aNumber.
			self add: new]
		ifFalse: [self ASSERT: false].
	^new]

{ #category : #accessing }
CompositeUnit class >> normalization [
	| base u |
	normalization isNil ifTrue: [
		u := self
			unitForLeft: self leftUnitType baseUnit
			right: self rightUnitType baseUnit.
		u notNil ifTrue: [normalization := u conversion] ifFalse: [
			base := self baseUnit.
			base rightUnit conversion
				perform: self operator
				with: base leftUnit conversion]].
	^normalization]

{ #category : #services }
CompositeUnit class >> normalize [
	self normalize: self]

{ #category : #services }
CompositeUnit class >> normalize: unitType [
	| left right u |
	left := unitType leftUnitType baseUnit.
	right := unitType rightUnitType baseUnit.
	(unitType baseUnit leftUnit = left
		and: [unitType baseUnit rightUnit = right])
		ifTrue: [^self].
	u := unitType unitForLeft: left right: right.
	u isNil ifTrue: [
		u := unitType newForLeft: left right: right.
		unitType add: u].
	u beBaseUnit]

{ #category : #accessing }
CompositeUnit class >> numerators [
	self operator == #'*' ifTrue: [^{self leftUnitType. self rightUnitType}].
	self operator == #'/' ifTrue: [^{self leftUnitType}].
	self ASSERT: false.
	^super numerators]

{ #category : #services }
CompositeUnit class >> readUnitsFrom: aDictionary [
	| answer |
	self hasLinearConversion ifFalse: [^#()].
	(aDictionary conform: [:v | v isArray])
		ifFalse: [^super readUnitsFrom: aDictionary].
	answer := OrderedCollection new: aDictionary size.
	aDictionary keysAndValuesDo: [:k :v | | left right current u |
		current := self named: k.
		current notNil ifTrue: [answer add: current].
		(current isNil orNot: [current isSystemUnit]) ifTrue: [
			left := v first notNil
				ifTrue: [self leftUnitType named: v first ifAbsent: nil].
			right := v first notNil
				ifTrue: [self rightUnitType named: v last ifAbsent: nil].
			(left notNil and: [right notNil]) ifTrue: [
				current isNil
					ifTrue: [
						u := self newForLeft: left right: right.
						u name: k.
						answer add: u.
						self add: u]
					ifFalse: [current leftUnit: left; rightUnit: right; updateConversion]]]].
	^answer]

{ #category : #services }
CompositeUnit class >> resetToSystemUnits [
	units do: [:u | u updateConversion].
	units copy do: [:u | u isSystemUnit ifFalse: [self removeUnit: u]]]

{ #category : #accessing }
CompositeUnit class >> rightUnitType [
	^self denominatorUnitType]

{ #category : #accessing }
CompositeUnit class >> unitConversions [
	^self units collect: [:unit | | left right |
		left := unit leftUnit ifNotNil: [:u | u name].
		right := unit rightUnit ifNotNil: [:u | u name].
		{left. right}]]

{ #category : #private }
CompositeUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: ' / ' with: '/'.
	code := self leftUnitType validCode: code.
	code := self rightUnitType validCode: code.
	^code]

{ #category : #'file in/out' }
CompositeUnit >> activated [
	| u |
	u := self type named: name.
	u isNil ifFalse: [^u].
	left notNil ifTrue: [left := left activated].
	right notNil ifTrue: [right := right activated].
	^(left notNil and: [right notNil]) ifTrue: [super activated]]

{ #category : #private }
CompositeUnit >> activeReplacement [
	| lu ru u |
	lu := left notNil
		ifTrue: [left isActive ifTrue: [left] ifFalse: [left activeReplacement]].
	ru := right notNil
		ifTrue: [right isActive ifTrue: [right] ifFalse: [right activeReplacement]].
	u := (lu notNil and: [ru notNil])
		ifTrue: [self type existingUnitForLeft: lu right: ru].
	^u ifNil: [super activeReplacement]]

{ #category : #validation }
CompositeUnit >> addValidationSelectorsTo: aCollection [
	aCollection add: #compositeUnitValidation]

{ #category : #accessing }
CompositeUnit >> allDenominators [
	self isDecomposable ifFalse: [^#()].
	^left allDenominators
		& (self operator == #'/'
			ifTrue: [right allNumerators]
			ifFalse: [right allDenominators])]

{ #category : #accessing }
CompositeUnit >> allNumerators [
	self isDecomposable ifFalse: [^{self}].
	^left allNumerators
		& (self operator == #'/'
			ifTrue: [right allDenominators]
			ifFalse: [right allNumerators])]

{ #category : #converting }
CompositeUnit >> asJson [
	| json |
	json := JsonObject new.
	json
		at: 'Type' put: self type typeName;
		at: 'Name' put: self name.
	self isUserDefined ifTrue: [
		json
			at: 'Left' put: left asJson;
			at: 'Right' put: right asJson].
	^json]

{ #category : #testing }
CompositeUnit >> canBeConverted [
	(self hasLinearConversion or: [self isBaseUnit]) ifTrue: [^true].
	(left isNil or: [right isNil]) ifTrue: [^false].
	^left canBeConverted and: [right canBeConverted]]

{ #category : #testing }
CompositeUnit >> canBeEdited [
	^self hasLinearConversion and: [self isUserDefined]]

{ #category : #testing }
CompositeUnit >> canOverrideConversion [
	^false]

{ #category : #private }
CompositeUnit >> defaultName [
	| base l r op |
	^self isSquaredUnit
		ifTrue: [
			base := left isNil ifTrue: ['?'] ifFalse: [left name].
			(base includesAny: ' 23/*')
				ifTrue: ['(' , base , ')^2']
				ifFalse: [base , '2']]
		ifFalse: [
			l := left isNil ifTrue: ['?'] ifFalse: [left name].
			(l includes: $/) ifTrue: [l := '(' , l , ')'].
			r := right isNil ifTrue: ['?'] ifFalse: [right name].
			(r includes: $/) ifTrue: [r := '(' , r , ')'].
			op := self operator.
			op = #'*' ifTrue: [op := '.'].
			(left notNil and: [left isNumberUnit] and: [op = #'/']) ifTrue: [l := '1'].
			l , op , r]]

{ #category : #accessing }
CompositeUnit >> denominators [
	self isDecomposable ifFalse: [^#()].
	^self operator == #'/' ifTrue: [{right}] ifFalse: [#()]]

{ #category : #testing }
CompositeUnit >> dependsOn: aUnit [
	^(super dependsOn: aUnit)
		or: [left notNil and: [left = aUnit or: [left dependsOn: aUnit]]]
		or: [right notNil and: [right = aUnit or: [right dependsOn: aUnit]]]]

{ #category : #conversion }
CompositeUnit >> inCurrency: aMoneyUnit [
	| lUnit rUnit u |
	lUnit := left isMoneyUnit
		ifTrue: [(left convertToCurrency: aMoneyUnit) ifNil: [aMoneyUnit]]
		ifFalse: [left].
	rUnit := right isMoneyUnit
		ifTrue: [(right convertToCurrency: aMoneyUnit) ifNil: [aMoneyUnit]]
		ifFalse: [right].
	u := self type unitForLeft: lUnit right: rUnit.
	u notNil ifTrue: [^u].
	u := self type newForLeft: lUnit right: rUnit.
	self type add: u.
	^u]

{ #category : #testing }
CompositeUnit >> isDecomposable [
	^left notNil and: [right notNil]]

{ #category : #testing }
CompositeUnit >> isNumberUnit [
	^false]

{ #category : #testing }
CompositeUnit >> isPrivate [
	super isPrivate ifTrue: [^true].
	self isUserDefined ifTrue: [^false].
	self isDefaultUnit ifTrue: [^false].
	^(name occurrencesOf: $.) + (name occurrencesOf: $/) > 2]

{ #category : #testing }
CompositeUnit >> isSquaredUnit [
	^left = right and: [self operator = #*]]

{ #category : #testing }
CompositeUnit >> isSystemUnit [
	| ln rn |
	left isNil | right isNil ifTrue: [^false].
	self isBaseUnit ifTrue: [^true].
	name = self defaultName ifFalse: [^false].
	ln := left name.
	rn := right name.
	self type conversions
		pairsDo: [:n :d | (ln = n and: [rn = d]) ifTrue: [^true]].
	^false]

{ #category : #accessing }
CompositeUnit >> leftUnit [
	^left]

{ #category : #accessing }
CompositeUnit >> leftUnit: aUnit [
	| type |
	type := aUnit type.
	self
		ASSERT: type = self type leftUnitType;
		ASSERT: aUnit canBeConverted.
	left := aUnit canBeConverted ifTrue: [aUnit]]

{ #category : #accessing }
CompositeUnit >> numerator [
	^(self operator == #'/' and: [self isDecomposable])
		ifTrue: [left]
		ifFalse: [self]]

{ #category : #accessing }
CompositeUnit >> numerators [
	self isDecomposable ifFalse: [^{self}].
	^self operator == #'/' ifTrue: [{left}] ifFalse: [{left. right}]]

{ #category : #accessing }
CompositeUnit >> operator [
	^self type operator]

{ #category : #accessing }
CompositeUnit >> rightUnit [
	^right]

{ #category : #accessing }
CompositeUnit >> rightUnit: aUnit [
	| type |
	type := aUnit type.
	self
		ASSERT: type = self type rightUnitType;
		ASSERT: aUnit canBeConverted.
	right := aUnit canBeConverted ifTrue: [aUnit]]

{ #category : #arithmetic }
CompositeUnit >> sqrt [
	^self type isSquaredUnit
		ifTrue: [left ifNil: [self class leftUnitType defaultUnit]]]

{ #category : #private }
CompositeUnit >> update [
	self updateConversion; updateName ]

{ #category : #private }
CompositeUnit >> updateConversion [
	| base l r |
	left isNil | right isNil ifTrue: [^self].
	base := self type baseUnit.
	conversion := (base isNil orNot: [base isDecomposable])
		ifTrue: [(left conversion perform: self operator with: right conversion)
			* self type consistentBaseUnit conversion]
		ifFalse: [
			l := 1.0 unitOf: base leftUnit in: left unit.
			r := 1.0 unitOf: base rightUnit in: right unit.
			l perform: self operator with: r]]

{ #category : #accessing }
CompositeUnit >> updateFrom: aUnit [
	super updateFrom: aUnit.
	self leftUnit: aUnit leftUnit; rightUnit: aUnit rightUnit]

{ #category : #private }
CompositeUnit >> updateName [
	self name: self defaultName]

