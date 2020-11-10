"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LiquidYieldUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
LiquidYieldUnit class >> bblMMscf [
	^self named: 'bbl/MM scf']

{ #category : #accessing }
LiquidYieldUnit class >> constantsUnit [
	^self bblMMscf]

{ #category : #accessing }
LiquidYieldUnit class >> conversions [
	^#(
		'bbl' 'M scf' 
		'm3' 'M m3'
		'M m3' 'M scf'
		'bbl' 'MM scf' 
		'm3' 'MM m3'
		'gal US' 'scf'
		'bbl' 'scf')]

{ #category : #defaults }
LiquidYieldUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
LiquidYieldUnit class >> defaultMetricUnitName [
	^'m3/MM m3']

{ #category : #accessing }
LiquidYieldUnit class >> denominatorUnitType [
	^GasVolumeUnit]

{ #category : #accessing }
LiquidYieldUnit class >> numeratorUnitType [
	^LiquidVolumeUnit]

{ #category : #accessing }
LiquidYieldUnit class >> typeName [
	^'Liquid Yield']

{ #category : #private }
LiquidYieldUnit class >> validCode: aString [
	| first last |
	first := aString upTo: $/.
	first := self leftUnitType validCode: first trimBlanks.
	last := aString readStream upTo: $/; upToEnd.
	last := self rightUnitType validCode: last trimBlanks.
	^first , '/' , last]

