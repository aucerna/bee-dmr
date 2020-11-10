"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Float }

{ #category : '*FML' }
Float >> asFmlValue [
	^self isNaN ifTrue: [FmlUndefinedValue new] ifFalse: [super asFmlValue]]

{ #category : '*FML' }
Float >> printOn: aStream dataSeparator: dataSep decimalSeparator: decimalSep [
	self printOn: aStream separatedBy: decimalSep]

