"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GORUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
GORUnit class >> constantsUnit [
	^self named: 'scf/bbl']

{ #category : #accessing }
GORUnit class >> conversions [
	^#(
		'M scf' 'bbl' 
		'MM scf' 'bbl' 
		'scf' 'bbl' 
		'm3' 'm3'
		'M scf' 'acre.ft'
		'MM scf' 'acre.ft'
		'B scf' 'acre.ft'
		'scf' 'ft3'
		'scf' 'gal US')]

{ #category : #defaults }
GORUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
GORUnit class >> defaultMetricUnitName [
	^'m3/m3']

{ #category : #accessing }
GORUnit class >> denominatorUnitType [
	^LiquidVolumeUnit]

{ #category : #accessing }
GORUnit class >> numeratorUnitType [
	^GasVolumeUnit]

{ #category : #accessing }
GORUnit class >> typeName [
	^'GOR']

{ #category : #private }
GORUnit class >> validCode: aString [
	| first last |
	first := aString upTo: $/.
	first := self leftUnitType validCode: first trimBlanks.
	last := aString readStream upTo: $/; upToEnd.
	last := self rightUnitType validCode: last trimBlanks.
	^first , '/' , last]

