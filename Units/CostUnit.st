"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CostUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #testing }
CostUnit class >> isAbstract [
	^self == CostUnit]

{ #category : #accessing }
CostUnit class >> numeratorUnitType [
	^MoneyUnit]

{ #category : #accessing }
CostUnit >> currency [
	^left currency]

{ #category : #conversion }
CostUnit >> inDefaultCurrency [
	^left inDefaultCurrency / right]

{ #category : #testing }
CostUnit >> isCostUnit [
	^true]

