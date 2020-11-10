"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CompiledTableInterpolate,
	#superclass : #CompiledTableFunction,
	#instVars : [
		'interpolator',
		'extrapolate'
	],
	#category : #FML
}

{ #category : #'instance creation' }
CompiledTableInterpolate class >> canOptimize: aFmlFunctionCall [
	| arguments |
	arguments := aFmlFunctionCall arguments.
	^aFmlFunctionCall name = 'interpolate'
		and: [(arguments at: 3) isNumber]
		and: [(arguments at: 4) isNumber]
		and: [arguments size = 4 or: [(arguments at: 5) isBoolean]]]

{ #category : #private }
CompiledTableInterpolate >> evaluateWith: anFmlEvaluator [
	| value |
	value := anFmlEvaluator evaluate: arguments second.
	interpolator isUndefinedValue ifTrue: [^interpolator].
	^value interpolateUsing: interpolator extrapolate: extrapolate]

{ #category : #accessing }
CompiledTableInterpolate >> from: anFmlFunctionCall [
	super from: anFmlFunctionCall.
	search := (arguments at: 3) value asInteger.
	return := (arguments at: 4) value asInteger.
	extrapolate := (arguments at: 5 ifAbsent: false) value.
	interpolator := table interpolatorAt: search @ return]

