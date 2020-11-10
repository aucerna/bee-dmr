"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CompiledTableFunction,
	#superclass : #FmlFunctionCall,
	#instVars : [
		'table',
		'search',
		'return'
	],
	#category : #FML
}

{ #category : #'instance creation' }
CompiledTableFunction class >> canOptimize: aFmlFunctionCall [
	^aFmlFunctionCall functionDefinition isTableFunction
		and: [subclasses anySatisfy: [:cls | cls canOptimize: aFmlFunctionCall]]]

{ #category : #'instance creation' }
CompiledTableFunction class >> from: anFmlFunctionCall [
	^self new from: anFmlFunctionCall]

{ #category : #'instance creation' }
CompiledTableFunction class >> optimize: aFmlFunctionCall [
	| cls |
	cls := subclasses detect: [:c | c canOptimize: aFmlFunctionCall].
	^cls from: aFmlFunctionCall]

{ #category : #accessing }
CompiledTableFunction >> from: anFmlFunctionCall [
	name := anFmlFunctionCall name.
	arguments := anFmlFunctionCall arguments.
	definition := anFmlFunctionCall functionDefinition.
	table := anFmlFunctionCall arguments first]

{ #category : #testig }
CompiledTableFunction >> isArrayValued [
	^false]

