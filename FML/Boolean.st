"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Boolean }

{ #category : '*FML' }
Boolean class >> fmlValueClass [
	^FmlBoolean]

{ #category : '*FML' }
Boolean >> asFmlValue [
	^self class fmlValueClass on: self]

{ #category : '*FML' }
Boolean >> isNumeric [
	^false]

{ #category : '*FML' }
Boolean >> isSingleValued [
	^true]

{ #category : '*FML' }
Boolean >> isSummable [
	^false]

{ #category : '*FML' }
Boolean >> resultType [
	^FmlBoolean]

{ #category : '*FML' }
Boolean >> valueAt: index [
	^self]

