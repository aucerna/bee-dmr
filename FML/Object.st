"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*FML' }
Object >> asFmlExpression [
	^self asFmlValue]

{ #category : '*FML' }
Object >> asFmlString [
	^self storeString]

{ #category : '*FML' }
Object >> asFmlValue [
	^self value asFmlValue]

{ #category : '*FML' }
Object >> equals: anObject [
	^self = anObject]

{ #category : '*FML' }
Object >> evaluated [
	^self]

{ #category : '*FML' }
Object >> fullValue [
	^self]

{ #category : '*FML' }
Object >> isFmlArray [
	^false]

{ #category : '*FML' }
Object >> isMagnitude [
	^false]

{ #category : '*FML' }
Object >> performFunction: symbol withArgs: argsArray [
	^(self respondsTo: symbol)
		ifTrue: [self perform: symbol withArguments: argsArray]
		ifFalse: [self asFmlValue cannotEvaluate: symbol]]

{ #category : '*FML' }
Object >> printOn: aStream dataSeparator: dataSep decimalSeparator: decSep [
	self printOn: aStream]

