"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #KernelDensityEstimator,
	#superclass : #Object,
	#instVars : [
		'kernel',
		'bandwidth',
		'sample'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
KernelDensityEstimator class >> cosine [
	"
	KernelDensityEstimator cosine
	"
	^self new cosine]

{ #category : #'instance creation' }
KernelDensityEstimator class >> epanechnikov [
	"
	KernelDensityEstimator epanechnikov
	"
	^self new epanechnikov]

{ #category : #'instance creation' }
KernelDensityEstimator class >> gaussian [
	"
	KernelDensityEstimator gaussian
	"
	^self new gaussian]

{ #category : #'instance creation' }
KernelDensityEstimator class >> kernels [
	^#(#gaussian #cosine #epanechnikov #quartic #triangular #triweight #uniform)]

{ #category : #'instance creation' }
KernelDensityEstimator class >> new [
	^super new initialize]

{ #category : #'instance creation' }
KernelDensityEstimator class >> on: aSampleStatistic [
	^self new sample: aSampleStatistic]

{ #category : #'instance creation' }
KernelDensityEstimator class >> quartic [
	"
	KernelDensityEstimator quartic
	"
	^self new quartic]

{ #category : #bibliography }
KernelDensityEstimator class >> references [
	ShellDLL current
		openWebPage: 'http://en.wikipedia.org/wiki/Kernel_density_estimation']

{ #category : #'instance creation' }
KernelDensityEstimator class >> triangular [
	"
	KernelDensityEstimator triangular
	"
	^self new triangular]

{ #category : #'instance creation' }
KernelDensityEstimator class >> triweight [
	"
	KernelDensityEstimator triweight
	"
	^self new triweight]

{ #category : #'instance creation' }
KernelDensityEstimator class >> uniform [
	"
	KernelDensityEstimator uniform
	"
	^self new uniform]

{ #category : #accessing }
KernelDensityEstimator >> bandwidth [
	^bandwidth]

{ #category : #accessing }
KernelDensityEstimator >> bandwidth: aNumber [
	self ASSERT: aNumber > 0.0.
	bandwidth := aNumber]

{ #category : #kernel }
KernelDensityEstimator >> cosine [
	kernel := [:x | | pi |
		x abs <= 1
			ifTrue: [
				pi := Number pi.
				pi / 4 * (pi / 2 * x) cos]
			ifFalse: [0.0]]]

{ #category : #inquiries }
KernelDensityEstimator >> domain [
	^(sample data collect: [:x | x value]) sort]

{ #category : #kernel }
KernelDensityEstimator >> epanechnikov [
	kernel := [:x | x abs <= 1 ifTrue: [3 / 4 * (1 - x squared)] ifFalse: [0.0]]]

{ #category : #inquiries }
KernelDensityEstimator >> estimatedBandwidth [
	| sd5 |
	sd5 := sample sd raisedTo: 5.
	^4.0 * sd5 / 3.0 / sample size raisedTo: 0.2]

{ #category : #kernel }
KernelDensityEstimator >> gaussian [
	kernel := NormalDistribution standard]

{ #category : #initialization }
KernelDensityEstimator >> initialize [
	super initialize.
	bandwidth := 0.
	self gaussian]

{ #category : #accessing }
KernelDensityEstimator >> kernel [
	^kernel]

{ #category : #accessing }
KernelDensityEstimator >> kernel: evaluable [
	kernel := evaluable]

{ #category : #private }
KernelDensityEstimator >> kernelAt: u [
	(kernel isKindOf: ProbabilityDistribution) ifTrue: [^kernel density: u].
	^kernel evaluateWith: u]

{ #category : #kernel }
KernelDensityEstimator >> quartic [
	kernel := [:x | x abs <= 1
		ifTrue: [15 / 16 * (1 - x squared) squared]
		ifFalse: [0.0]]]

{ #category : #accessing }
KernelDensityEstimator >> sample: aSampleStatistic [
	sample := aSampleStatistic.
	bandwidth := self estimatedBandwidth]

{ #category : #inquiries }
KernelDensityEstimator >> silvermanBandwidth [
	| n sd percentiles q25 q75 snd z25 z75 |
	n := sample size.
	sd := sample sd.
	percentiles := sample percentiles: 4.
	q25 := percentiles second.
	q75 := percentiles fourth.
	snd := NormalDistribution standard.
	z25 := snd percentile: 0.25.
	z75 := snd percentile: 0.75.
	^0.9 * (sd min: q75 - q25 / (z75 - z25)) * (n raisedTo: -1 / 5)]

{ #category : #kernel }
KernelDensityEstimator >> triangular [
	kernel := TriangularDistribution left: -1 mid: 0 right: 1]

{ #category : #kernel }
KernelDensityEstimator >> triweight [
	kernel := [:x | x abs <= 1
		ifTrue: [35 / 32 * (1 - x squared raisedTo: 3)]
		ifFalse: [0.0]]]

{ #category : #kernel }
KernelDensityEstimator >> uniform [
	kernel := UniformDistribution from: -1 to: 1]

{ #category : #evaluation }
KernelDensityEstimator >> valueAt: x [
	| sum |
	sum := sample data sum: [:xi | self kernelAt: x - xi value / bandwidth].
	^sum / (sample size * bandwidth)]

{ #category : #inquiries }
KernelDensityEstimator >> values [
	^self domain collect: [:x | self valueAt: x]]

