"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CompiledTableLookup,
	#superclass : #CompiledTableFunction,
	#instVars : [
		'equal'
	],
	#category : #FML
}

{ #category : #'instance creation' }
CompiledTableLookup class >> canOptimize: aFmlFunctionCall [
	| args |
	^(aFmlFunctionCall name includesString: 'Lookup')
		and: [
			args := aFmlFunctionCall arguments.
			(args at: 3) isNumber]
		and: [args size > 3 and: [(args at: 4) isNumber]]]

{ #category : #private }
CompiledTableLookup >> evaluateWith: anFmlEvaluator [
	| key index |
	key := (anFmlEvaluator evaluate: arguments second) value.
	index := equal
		ifTrue: [
			table value
				column: search
				findFirst: [:v | v = key]
				ifAbsent: [^FmlUndefinedValue new]]
		ifFalse: [table value column: search findLast: [:v | v <~ key] ifAbsent: 1].
	^(table atRow: index column: return) asFmlValue]

{ #category : #accessing }
CompiledTableLookup >> from: anFmlFunctionCall [
	| column |
	super from: anFmlFunctionCall.
	return := arguments last value asInteger.
	search := arguments size > 3
		ifTrue: [(arguments at: 3) value asInteger]
		ifFalse: [1].
	column := table value column: search.
	equal := (((column conform: [:v | v isNumber])
		or: [column conform: [:v | v isDate]])
		and: [column isIncreasing]) not]

