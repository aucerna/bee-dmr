"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IntegerHistogram,
	#superclass : #ContinuousHistogram,
	#category : #Distributions
}

{ #category : #private }
IntegerHistogram >> calculateH [
	h := max - min // k]

{ #category : #testing }
IntegerHistogram >> isIntegerHistogram [
	^true]

{ #category : #accessing }
IntegerHistogram >> max: aMagnitude [
	max := aMagnitude isNumber
		ifTrue: [aMagnitude ceiling]
		ifFalse: [aMagnitude]]

{ #category : #accessing }
IntegerHistogram >> min: aMagnitude [
	min := aMagnitude isNumber ifTrue: [aMagnitude floor] ifFalse: [aMagnitude]]

{ #category : #accessing }
IntegerHistogram >> numberOfBins: anInteger [
	| b count |
	b := anInteger.
	(min notNil and: [max notNil]) ifTrue: [
		count := max - min.
		count isUndefinedValue ifTrue: [count := 1].
		b := b min: count max: 1].
	super numberOfBins: b asInteger]

