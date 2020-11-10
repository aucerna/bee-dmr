"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Date }

{ #category : '*FML' }
Date class >> fmlBase [
	^Date newDay: 1 monthIndex: 1 year: 2000]

{ #category : '*FML' }
Date class >> fmlValueClass [
	^FmlDate]

{ #category : '*FML' }
Date >> asFmlString [
	^'date(' , self year printString , ', ' , self month printString , ', '
		, self dayOfMonth printString
		, ')']

{ #category : '*FML' }
Date >> asFmlValue [
	"
	Date today asFmlValue
	"
	^self class fmlValueClass on: self]

{ #category : '*FML' }
Date >> isNumeric [
	^false]

{ #category : '*FML' }
Date >> isSingleValued [
	^true]

{ #category : '*FML' }
Date >> isSummable [
	^true]

{ #category : '*FML' }
Date >> month [
	^self monthIndex]

{ #category : '*FML' }
Date >> performOperation: aSymbol receiverValue: aDate [
	^(aDate perform: aSymbol with: self) asFmlValue]

{ #category : '*FML' }
Date >> resultType [
	^FmlDate]

{ #category : '*FML' }
Date >> valueAt: index [
	^self]

