"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CompositeUnitType,
	#superclass : #ModelObject,
	#instVars : [
		'left',
		'operator',
		'right',
		'name',
		'units',
		'baseUnit',
		'normalization'
	],
	#category : #Units
}

{ #category : #accessing }
CompositeUnitType class >> addType: aCompositeUnitType [
	^types markDirtyAdd: aCompositeUnitType]

{ #category : #'instance creation' }
CompositeUnitType class >> fromJson: aJsonObject [
	| op1 left operator op2 right |
	op1 := (aJsonObject at: 'Left') at: 'Type'.
	left := op1 isString
		ifTrue: [Unit resolveUnitType: op1]
		ifFalse: [self fromJson: op1].
	operator := aJsonObject at: 'Operator'.
	op2 := (aJsonObject at: 'Right') at: 'Type'.
	right := op2 isString
		ifTrue: [Unit resolveUnitType: op2]
		ifFalse: [self fromJson: op2].
	^self left: left operator: operator asSymbol right: right]

{ #category : #initialization }
CompositeUnitType class >> initialize [
	"
	CompositeUnitType initialize
	"
	super initialize.
	types := OrderedCollection new]

{ #category : #'instance creation' }
CompositeUnitType class >> left: lUnit operator: aSymbol right: rUnit [
	| new |
	(lUnit isNumeric and: [rUnit isNumeric]) ifFalse: [^nil].
	^types
		detect: [:t | t leftUnitType == lUnit
			and: [t rightUnitType == rUnit]
			and: [t operator == aSymbol]]
		ifNone: [
			new := self new
				leftUnit: lUnit;
				operator: aSymbol;
				rightUnit: rUnit;
				updateName.
			self addType: new]]

{ #category : #accessing }
CompositeUnitType class >> removeType: aCompositeUnitType [
	^types markDirtyRemove: aCompositeUnitType]

{ #category : #accessing }
CompositeUnitType class >> types [
	^types]

{ #category : #arithmetic }
CompositeUnitType >> * unitType [
	^Unit multiply: self by: unitType]

{ #category : #arithmetic }
CompositeUnitType >> / unitType [
	^Unit divide: self by: unitType]

{ #category : #comparing }
CompositeUnitType >> = unitType [
	^self == unitType]

{ #category : #private }
CompositeUnitType >> adaptToBase: aUnit [
	CompositeUnit adapt: self toBase: aUnit]

{ #category : #accessing }
CompositeUnitType >> add: aUnit [
	Unit registerUnit: aUnit.
	^units markDirtyAt: aUnit name put: aUnit]

{ #category : #services }
CompositeUnitType >> addDefaultBaseUnit [
	baseUnit := VirtualTypeUnit new
		type: self;
		leftUnit: left baseUnit;
		rightUnit: right baseUnit;
		conversion: 1.0;
		updateName.
	self add: baseUnit.
	^baseUnit]

{ #category : #accessing }
CompositeUnitType >> addUnit: aUnit [
	^self add: aUnit]

{ #category : #accessing }
CompositeUnitType >> allDenominators [
	| denominators op |
	denominators := self leftUnitType allDenominators.
	op := self operator.
	op == #'*' ifTrue: [^denominators & self rightUnitType allDenominators].
	op == #'/' ifTrue: [^denominators & self rightUnitType allNumerators].
	self ASSERT: false.
	^#()]

{ #category : #accessing }
CompositeUnitType >> allNumerators [
	| numerators op |
	numerators := self leftUnitType allNumerators.
	op := self operator.
	op == #'*' ifTrue: [^numerators & self rightUnitType allNumerators].
	op == #'/' ifTrue: [^numerators & self rightUnitType allDenominators].
	self ASSERT: false.
	^#()]

{ #category : #converting }
CompositeUnitType >> asJson [
	^JsonObject new
		at: 'Type' put: self typeName;
		at: 'Left' put: left asJson;
		at: 'Operator' put: operator;
		at: 'Right' put: right asJson;
		yourself]

{ #category : #accessing }
CompositeUnitType >> baseClass [
	^Number]

{ #category : #accessing }
CompositeUnitType >> baseClassName [
	^'Numeric']

{ #category : #accessing }
CompositeUnitType >> baseUnit [
	(baseUnit isNil and: [self units isEmpty]) ifTrue: [self addDefaultBaseUnit].
	^baseUnit]

{ #category : #services }
CompositeUnitType >> baseUnit: aUnit [
	baseUnit := aUnit]

{ #category : #accessing }
CompositeUnitType >> baseUnitName [
	^self baseUnit name]

{ #category : #testing }
CompositeUnitType >> canChangeUnit [
	^true]

{ #category : #services }
CompositeUnitType >> changeBaseTo: aUnit [
	| save |
	self ASSERT: self hasLinearConversion.
	save := aUnit conversion.
	units do: [:u | u conversion: u conversion / save].
	self invalidateNormalization.
	self baseUnit: aUnit]

{ #category : #private }
CompositeUnitType >> componentTypes [
	^{left. right}]

{ #category : #private }
CompositeUnitType >> componentTypesOn: aCollection [
	self componentTypes do: [:t | t componentTypesOn: aCollection].
	(aCollection includes: self) ifFalse: [aCollection add: self]]

{ #category : #accessing }
CompositeUnitType >> constantsUnit [
	^left constantsUnit perform: operator with: right constantsUnit]

{ #category : #accessing }
CompositeUnitType >> conversionRange [
	^Range from: 0.1e-100 to: 0.1e100]

{ #category : #accessing }
CompositeUnitType >> defaultArrayClass [
	^FloatArray]

{ #category : #accessing }
CompositeUnitType >> defaultDecimalPlaces [
	^2]

{ #category : #accessing }
CompositeUnitType >> defaultFormat [
	^self defaultUnitFormat format]

{ #category : #accessing }
CompositeUnitType >> defaultInstance [
	^self unitForLeft: left defaultInstance right: right defaultInstance]

{ #category : #accessing }
CompositeUnitType >> defaultRange [
	^nil]

{ #category : #accessing }
CompositeUnitType >> defaultUnit [
	^self unitForLeft: left defaultUnit right: right defaultUnit]

{ #category : #accessing }
CompositeUnitType >> defaultUnitFormat [
	^UnitFormat unit: self defaultUnit decimals: left defaultDecimalPlaces]

{ #category : #accessing }
CompositeUnitType >> defaultValue [
	^0.0]

{ #category : #accessing }
CompositeUnitType >> denominators [
	self operator == #'*' ifTrue: [^#()].
	self operator == #'/' ifTrue: [^{self rightUnitType}].
	self ASSERT: false.
	^nil]

{ #category : #accessing }
CompositeUnitType >> denominatorUnitType [
	operator = #'/' ifTrue: [^right].
	operator = #'*' ifTrue: [^NumberUnit].
	self ASSERT: false.
	^nil]

{ #category : #testing }
CompositeUnitType >> dependsOn: unitType [
	^self = unitType
		or: [self leftUnitType dependsOn: unitType]
		or: [self rightUnitType dependsOn: unitType]]

{ #category : #printing }
CompositeUnitType >> displayName [
	| display |
	display := name replaceAll: '^2' with: '²'.
	^display replaceAll: '^3' with: '³']

{ #category : #accessing }
CompositeUnitType >> existingUnitForLeft: lUnit right: rUnit [
	(lUnit type == left and: [rUnit type == right]) ifFalse: [^nil].
	^self units
		detect: [:u | u leftUnit = lUnit and: [u rightUnit = rUnit]]
		ifNone: nil]

{ #category : #initialization }
CompositeUnitType >> fromJson: aJsonObject [
	| n unit op1 lu op2 ru |
	n := aJsonObject at: 'Name'.
	unit := self named: n.
	unit notNil ifTrue: [^unit].
	op1 := aJsonObject valueAt: 'Left'.
	op1 isNil ifTrue: [^nil].
	lu := Unit fromJson: op1.
	op2 := aJsonObject valueAt: 'Right'.
	ru := Unit fromJson: op2.
	^self unitForLeft: lu right: ru]

{ #category : #testing }
CompositeUnitType >> hasConsistentBaseUnit [
	| base |
	base := self baseUnit.
	^base leftUnit = self leftUnitType baseUnit
		and: [base rightUnit = self rightUnitType baseUnit]]

{ #category : #testing }
CompositeUnitType >> hasCurrency [
	^(self numerators includes: MoneyUnit)
		or: [self denominators includes: MoneyUnit]]

{ #category : #testing }
CompositeUnitType >> hasLinearConversion [
	^left hasLinearConversion and: [right hasLinearConversion]]

{ #category : #initialization }
CompositeUnitType >> initializeUnits [
	units := Dictionary new.
	self addDefaultBaseUnit]

{ #category : #private }
CompositeUnitType >> invalidateNormalization [
	normalization := nil]

{ #category : #initialization }
CompositeUnitType >> invalidateUnits [
	units := nil.
	baseUnit := nil]

{ #category : #testing }
CompositeUnitType >> isAbstract [
	^false]

{ #category : #testing }
CompositeUnitType >> isCompatibleWith: unitType [
	^self == unitType or: [
		(self allNumerators equalsTo: unitType allNumerators)
			and: [self allDenominators equalsTo: unitType allDenominators]]]

{ #category : #testing }
CompositeUnitType >> isCompositeUnit [
	^true]

{ #category : #testing }
CompositeUnitType >> isDimensionless [
	^false]

{ #category : #testing }
CompositeUnitType >> isNumeric [
	^true]

{ #category : #testing }
CompositeUnitType >> isObsolete [
	^false]

{ #category : #testing }
CompositeUnitType >> isPrivate [
	^true]

{ #category : #testing }
CompositeUnitType >> isPublic [
	^false]

{ #category : #testing }
CompositeUnitType >> isRateUnit [
	^operator = #'/' or: [left isRateUnit] or: [right isRateUnit]]

{ #category : #testing }
CompositeUnitType >> isSquared [
	^left = right and: [operator = #*]]

{ #category : #testing }
CompositeUnitType >> isSquaredUnit [
	^left = right and: [self operator =#*]]

{ #category : #testing }
CompositeUnitType >> isTimeUnit [
	^false]

{ #category : #accessing }
CompositeUnitType >> leftUnit: aUnit [
	left := aUnit]

{ #category : #accessing }
CompositeUnitType >> leftUnitType [
	^left]

{ #category : #accessing }
CompositeUnitType >> metricUnit [
	^left metricUnit perform: operator with: right metricUnit]

{ #category : #accessing }
CompositeUnitType >> named: aString [
	| u l r id separator |
	u := self named: aString ifAbsent: nil.
	u notNil ifTrue: [^u].
	self isSquared ifTrue: [
		id := (aString readStream upToAny: #($^ $2)) trimOutermostParens.
		u := left named: id ifAbsent: nil.
		^u notNil ifTrue: [self unitForLeft: u right: u]].
	separator := operator = #'*' ifTrue: [$.] ifFalse: [operator first].
	l := left
		named: (aString upTo: separator) trimOutermostParens
		ifAbsent: nil.
	r := right
		named: (aString readStream upTo: separator; upToEnd) trimOutermostParens
		ifAbsent: nil.
	^(l notNil and: [r notNil]) ifTrue: [self unitForLeft: l right: r]]

{ #category : #accessing }
CompositeUnitType >> named: aString ifAbsent: block [
	| code u |
	code := self validCode: aString.
	code isNil ifTrue: [^block value].
	u := self units at: code ifAbsent: #notFound.
	u == #notFound ifTrue: [^block value].
	^u]

{ #category : #accessing }
CompositeUnitType >> normalization [
	| base |
	normalization isNil ifTrue: [
		base := self baseUnit.
		normalization := base denominator conversion / base numerator conversion].
	^normalization]

{ #category : #services }
CompositeUnitType >> normalize [
	CompositeUnit normalize: self]

{ #category : #accessing }
CompositeUnitType >> numerator: nUnit denominator: dUnit [
	^self unitForLeft: nUnit right: dUnit]

{ #category : #accessing }
CompositeUnitType >> numerators [
	self operator == #'*' ifTrue: [^{self leftUnitType. self rightUnitType}].
	self operator == #'/' ifTrue: [^{self leftUnitType}].
	self ASSERT: false.
	^#()]

{ #category : #accessing }
CompositeUnitType >> numeratorUnitType [
	operator = #'/' ifTrue: [^left].
	operator = #'*' ifTrue: [^self].
	self ASSERT: false.
	^nil]

{ #category : #accessing }
CompositeUnitType >> operator [
	^operator]

{ #category : #accessing }
CompositeUnitType >> operator: aSymbol [
	operator := aSymbol]

{ #category : #printing }
CompositeUnitType >> printOn: aStream [
	aStream nextPutAll: self displayName]

{ #category : #accessing }
CompositeUnitType >> publicUnits [
	^self units select: [:u | u isPrivate not] in: OrderedCollection new]

{ #category : #testing }
CompositeUnitType >> publishesDefaultUnit [
	^false]

{ #category : #accessing }
CompositeUnitType >> removeUnit: aUnit [
	Unit unregisterUnit: aUnit.
	self units removeKey: aUnit name ifAbsent: nil; markDirty]

{ #category : #services }
CompositeUnitType >> resetToSystemUnits [
	units do: [:u | u updateConversion].
	units do: [:u | u isSystemUnit ifFalse: [self removeUnit: u]]]

{ #category : #accessing }
CompositeUnitType >> rightUnit: aUnit [
	right := aUnit]

{ #category : #accessing }
CompositeUnitType >> rightUnitType [
	^right]

{ #category : #accessing }
CompositeUnitType >> typeName [
	^left typeName , operator , right typeName]

{ #category : #accessing }
CompositeUnitType >> unitForLeft: lUnit right: rUnit [
	| u new |
	u := self existingUnitForLeft: lUnit right: rUnit.
	u notNil ifTrue: [^u].
	(lUnit type == left and: [rUnit type == right]) ifFalse: [^nil].
	new := VirtualTypeUnit newForLeft: lUnit right: rUnit type: self.
	self add: new.
	^new]

{ #category : #accessing }
CompositeUnitType >> units [
	units isNil ifTrue: [self initializeUnits].
	^units]

{ #category : #services }
CompositeUnitType >> unitWithNumerators: numUnits denominators: denUnits [
	| n d |
	n := numUnits reject: #isNumberUnit.
	n isEmpty ifTrue: [n := {NumberUnit defaultInstance}].
	d := denUnits reject: #isNumberUnit.
	^self units
		detect: [:unit | (unit allNumerators equalsTo: n)
			and: [unit allDenominators equalsTo: d]]
		ifNone: [| all |
			all := n & d.
			all size = 2 ifTrue: [self unitForLeft: all first right: all last]]]

{ #category : #services }
CompositeUnitType >> updateDependentsOf: aUnit [
	self units do: [:u | (u dependsOn: aUnit) ifTrue: [u update]]]

{ #category : #private }
CompositeUnitType >> updateName [
	| base l r op |
	name := self isSquaredUnit
		ifTrue: [
			base := left typeName.
			(base includesAny: '23 /*.')
				ifTrue: ['(' , base , ')^2']
				ifFalse: [base , '2']]
		ifFalse: [
			l := left typeName.
			(l includes: $/) ifTrue: [l := '(' , l , ')'].
			r := right typeName.
			(r includes: $/) ifTrue: [r := '(' , r , ')'].
			op := self operator.
			op = #'*' ifTrue: [op := '.'].
			l , op , r]]

{ #category : #private }
CompositeUnitType >> validCode: aString [
	^aString]

