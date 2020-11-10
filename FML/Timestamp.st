"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Timestamp }

{ #category : '*FML' }
Timestamp >> asFmlValue [
	"
	TimeStamp current asFmlValue
	"
	^self date asFmlValue]

{ #category : '*FML' }
Timestamp >> resultType [
	^FmlDate]

