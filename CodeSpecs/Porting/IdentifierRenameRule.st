"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #IdentifierRenameRule, 
	#superclass : #ConversionRule, 
	#category : #Porting
}

{#category : #actions}
IdentifierRenameRule >> applyToMethod: aMethodSpec [
	| ast var code |
	ast := aMethodSpec ast ifNil: [^self].
	var := ast variableNamed: original.
	var isNil ifTrue: [^self].
	code := aMethodSpec sourceCode.
	var sourceIntervals
		reverseDo: [:s | code := code replace: original at: s start with: new].
	aMethodSpec source: code]

{#category : #private}
IdentifierRenameRule >> basicApplyTo: aModuleSpec [
	| class |
	class := aModuleSpec resolveClass: original.
	class ifNotNil: [
		class subclasses do: [:s | s supername: new].
		class name: new].
	aModuleSpec allMethodsDo: [:m | self applyToMethod: m].
	aModuleSpec allClassesDo: [:c | | cvars |
		c instVarNames replace: original with: new.
		cvars := c classVariables.
		cvars at: original ifPresent: [:v | 
			cvars
				removeKey: original;
				at: new put: v].
		c sharedPools replace: original asSymbol with: new asSymbol]]

