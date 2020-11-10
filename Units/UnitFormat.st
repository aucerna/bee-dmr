"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #UnitFormat,
	#superclass : #ModelObject,
	#instVars : [
		'name',
		'unit',
		'format'
	],
	#category : #Units
}

{ #category : #constants }
UnitFormat class >> maxDecimals [
	^20]

{ #category : #'instance creation' }
UnitFormat class >> name: aString unit: aUnit [
	^aUnit asUnitFormat name: aString; yourself]

{ #category : #'instance creation' }
UnitFormat class >> name: aString unit: aUnit decimals: anInteger [
	^self new
		name: aString;
		unit: aUnit;
		decimals: anInteger]

{ #category : #'instance creation' }
UnitFormat class >> unit: aUnit [
	^self name: '' unit: aUnit]

{ #category : #'instance creation' }
UnitFormat class >> unit: aUnit decimals: anInteger [
	^self name: '' unit: aUnit decimals: anInteger]

{ #category : #'instance creation' }
UnitFormat class >> unit: aUnit format: aDisplayFormat [
	^self new unit: aUnit; format: aDisplayFormat]

{ #category : #comparing }
UnitFormat >> < aUnitFormat [
	self ASSERT: false.
	^name < aUnitFormat name]

{ #category : #comparing }
UnitFormat >> <= aUnitFormat [
	self ASSERT: false.
	^name <= aUnitFormat name]

{ #category : #comparing }
UnitFormat >> = aUnitFormat [
	aUnitFormat class == self class ifFalse: [^false].
	format = aUnitFormat format ifFalse: [^false].
	unit = aUnitFormat unit ifFalse: [^false].
	^name = aUnitFormat name]

{ #category : #converting }
UnitFormat >> baseValueOf: value [
	^self unit baseValueOf: value]

{ #category : #converting }
UnitFormat >> convert: value [
	^unit convert: value]

{ #category : #accessing }
UnitFormat >> decimals [
	^format isNil ifTrue: [1] ifFalse: [format decimals]]

{ #category : #accessing }
UnitFormat >> decimals: anInteger [
	format decimals: anInteger]

{ #category : #printing }
UnitFormat >> display: value [
	| v |
	v := unit isNil ifTrue: [value] ifFalse: [
		unit isDateUnit
			ifTrue: [(value respondsTo: #asDate) ifTrue: [value asDate]]
			ifFalse: [unit convert: value]].
	^format displayString: v]

{ #category : #printing }
UnitFormat >> displayValueWithUnit: value [
	| tail text |
	tail := unit displayName.
	text := self display: value.
	tail notEmpty ifTrue: [text := text , ' ' , tail].
	^text]

{ #category : #'excel support' }
UnitFormat >> excelFormat [
	^format excelFormat]

{ #category : #accessing }
UnitFormat >> format [
	^format]

{ #category : #accessing }
UnitFormat >> format: aDisplayFormat [
	format := aDisplayFormat]

{ #category : #printing }
UnitFormat >> formatDisplay [
	^self display: 0]

{ #category : #converting }
UnitFormat >> fromString: value [
	^unit fromString: value]

{ #category : #copying }
UnitFormat >> fullCopy [
	^self copy]

{ #category : #comparing }
UnitFormat >> hash [
	^unit hashWith: format with: name]

{ #category : #initialization }
UnitFormat >> initialize [
	unit := NumberUnit defaultInstance.
	format := DisplayFormat new]

{ #category : #testing }
UnitFormat >> isBooleanUnit [
	^unit isBooleanUnit]

{ #category : #testing }
UnitFormat >> isDateUnit [
	^unit isDateUnit]

{ #category : #comparing }
UnitFormat >> isLike: unitFormat [
	self class == unitFormat class ifFalse: [^false].
	unit = unitFormat unit ifFalse: [^false].
	^format isLike: unitFormat format]

{ #category : #testing }
UnitFormat >> isStringUnit [
	^unit isStringUnit]

{ #category : #accessing }
UnitFormat >> name [

^name]

{ #category : #accessing }
UnitFormat >> name: aString [
	name := aString]

{ #category : #copying }
UnitFormat >> postCopy [
	super postCopy.
	format := format copy]

{ #category : #accessing }
UnitFormat >> unit [
	^unit]

{ #category : #accessing }
UnitFormat >> unit: aUnit [
	unit := aUnit]

{ #category : #printing }
UnitFormat >> unitDisplay [
	^unit displayName]

{ #category : #accessing }
UnitFormat >> unitName [
	^unit name]

{ #category : #accessing }
UnitFormat >> validUnitTypes [
	^unit validUnitTypes]

{ #category : #printing }
UnitFormat >> visibleDisplayName [
	^unit visibleDisplayName]

