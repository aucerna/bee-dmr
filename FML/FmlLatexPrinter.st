"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlLatexPrinter,
	#superclass : #FmlPlainPrinter,
	#category : #FML
}

{ #category : #visiting }
FmlLatexPrinter >> visitFunctionCall: aFmlFunctionCall [
	| first |
	first := true.
	writer
		nextPutAll: '{\rm ';
		nextPutAll: aFmlFunctionCall name;
		nextPutAll: '}('.
	aFmlFunctionCall arguments do: [:each | 
		first
			ifTrue: [first := false]
			ifFalse: [writer nextPutAll: self dataSeparator].
		self visit: each].
	writer nextPut: $)]

{ #category : #visiting }
FmlLatexPrinter >> visitVariableName: anFmlVariableName [
	self
		print: anFmlVariableName fullName
		color: anFmlVariableName color
		from: anFmlVariableName]

