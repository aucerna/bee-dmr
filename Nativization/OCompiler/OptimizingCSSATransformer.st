"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingCSSATransformer,
	#superclass : #Object,
	#instVars : [
		'firstBlock',
		'liveness'
	],
	#category : #OCompiler
}

{ #category : #accessing }
OptimizingCSSATransformer >> applyTransformation [
	self splitPhis; coalescePhis
]

{ #category : #accessing }
OptimizingCSSATransformer >> coalescePhis [
	"
	to do
	"
	
]

{ #category : #accessing }
OptimizingCSSATransformer >> firstBlock: block [
	firstBlock := block
]

{ #category : #accessing }
OptimizingCSSATransformer >> liftPhi: phi [
	phi variablesWithBlocksDo: [:var :pred | | copy |
		copy := var insertCopyBefore: pred lastInstruction.
		phi atOperand: pred put: copy.
		var removeUse: phi at: pred; dissolveIfUseless.
		copy addUse: phi at: pred]
]

{ #category : #accessing }
OptimizingCSSATransformer >> liftPhisIn: block [
	block
		phisDo: [:phi | phi isUsed
			ifTrue: [self liftPhi: phi]
			ifFalse: [phi dissolve]]
]

{ #category : #accessing }
OptimizingCSSATransformer >> splitPhis [
	firstBlock withSuccessorsPostOrder do: [:block | self liftPhisIn: block]
]

