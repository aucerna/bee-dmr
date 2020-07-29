"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ScaledGammaDistribution,
	#superclass : #GammaDistribution,
	#instVars : [
		'scale'
	],
	#category : #Distributions
}

{ #category : #examples }
ScaledGammaDistribution class >> sampleInstance [
	^super sampleInstance scale: 3]

{ #category : #'instance creation' }
ScaledGammaDistribution class >> shape: shape scale: scale [
	^(self shape: shape) scale: scale]

{ #category : #'probability functions' }
ScaledGammaDistribution >> density: x [
	^super density: x / scale]

{ #category : #'probability functions' }
ScaledGammaDistribution >> distribution: x [
	^super distribution: x / scale]

{ #category : #statistics }
ScaledGammaDistribution >> mean [
	^super mean * scale]

{ #category : #statistics }
ScaledGammaDistribution >> next [
	^super next * scale]

{ #category : #accessing }
ScaledGammaDistribution >> scale: aNumber [
	scale := aNumber asFloat]

{ #category : #statistics }
ScaledGammaDistribution >> variance [
	^super variance * scale squared]

