"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Number }

{ #category : '*FML' }
Number class >> fmlValueClass [
	^FmlNumber]

{ #category : '*FML' }
Number >> asFmlValue [
	^self class fmlValueClass on: self]

{ #category : '*FML' }
Number >> ceiling: significance [
	^self roundUpTo: significance]

{ #category : '*FML' }
Number >> date: month day: day [
	^Date day: day asInteger month: month asInteger year: self asInteger]

{ #category : '*FML' }
Number >> floor: significance [
	"
	16.9 floor: 0.1
	"
	| q |
	q := significance ~ 0.0
		ifTrue: [0.0]
		ifFalse: [self truncateTo: significance].
	^self - q ~ significance
		ifTrue: [q + significance truncateTo: significance]
		ifFalse: [q]]

{ #category : '*FML' }
Number >> isNumeric [
	^true]

{ #category : '*FML' }
Number >> isSingleValued [
	^true]

{ #category : '*FML' }
Number >> isSummable [
	^true]

{ #category : '*FML' }
Number >> performOperation: aSymbol receiverValue: aNumber [
	^(aNumber perform: aSymbol with: self) asFmlValue]

{ #category : '*FML' }
Number >> roundUpTo: significance [
	"
	9.01 roundUpTo: 0.011
	"
	significance ~ 0.0 ifTrue: [^0.0].
	^(self quo: significance) * significance >= self
		ifTrue: [self]
		ifFalse: [(self + significance quo: significance) * significance]]

{ #category : '*FML' }
Number >> valueAt: index [
	^self]

{ #category : '*FML' }
Number >> zero [
	^self class zero]

