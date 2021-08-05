"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #SelectorRenameRule, 
	#superclass : #ConversionRule, 
	#category : #Porting
}

{#category : #private}
SelectorRenameRule >> applyToMethod: aMethodSpec [
	| ast found |
	ast := aMethodSpec ast.
	found := aMethodSpec selector == original.
	found ifTrue: [
		aMethodSpec selector: new.
		ast selectorNode symbol: new].
	ast
		messagesDo: [:m | m selector symbol == original ifTrue: [found := true]].
	found ifFalse: [^self].
	ast replaceSelector: original with: new.
	aMethodSpec source: ast format]

{#category : #private}
SelectorRenameRule >> basicApplyTo: aModuleSpec [
	aModuleSpec allMethodsDo: [:m | self applyToMethod: m]]

