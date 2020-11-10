"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Range }

{ #category : '*Units' }
Range >> beRepresentableInUnit: aUnit [
	lowerBound := lowerBound isNil
		ifTrue: [aUnit minRepresentableValue]
		ifFalse: [aUnit minRepresentableValue max: lowerBound].
	upperBound := upperBound isNil
		ifTrue: [aUnit maxRepresentableValue]
		ifFalse: [aUnit maxRepresentableValue min: upperBound]]

{ #category : '*Units' }
Range >> convertToFormat: aDisplayFormat [
	| bound |
	lowerBound isNumber ifTrue: [
		bound := aDisplayFormat displayString: lowerBound.
		lowerBound := Float fromNLString: bound].
	upperBound isNumber ifTrue: [
		bound := aDisplayFormat displayString: upperBound.
		upperBound := Float fromNLString: bound]]

{ #category : '*Units' }
Range >> convertToUnit: aUnit [
	^self hasBounds ifTrue: [aUnit convertRange: self] ifFalse: [self]]

{ #category : '*Units' }
Range >> inUnit: aUnit [
	| bound |
	self hasBounds ifFalse: [^self].
	bound := lowerBound ifNil: [upperBound].
	(bound isKindOf: aUnit baseClass) ifFalse: [^nil].
	^self convertToUnit: aUnit]

{ #category : '*Units' }
Range >> inUnit: aUnit format: aDisplayFormat [
	| range |
	range := self inUnit: aUnit.
	^range notNil ifTrue: [
		aUnit isIntegerUnit
			ifTrue: [range]
			ifFalse: [range withFormat: aDisplayFormat]]]

{ #category : '*Units' }
Range >> representableInUnit: aUnit [
	"
	Precondition: the receiver is expressed in base unit
	"
	| r |
	r := self inUnit: aUnit.
	^(r notNil and: [aUnit isNumeric])
		ifTrue: [r beRepresentableInUnit: aUnit]
		ifFalse: [r]]

{ #category : '*Units' }
Range >> withFormat: aDisplayFormat [
	^self shallowCopy convertToFormat: aDisplayFormat]

