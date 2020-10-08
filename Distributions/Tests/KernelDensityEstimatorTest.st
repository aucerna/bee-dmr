"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #KernelDensityEstimatorTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #'basic behavior' }
KernelDensityEstimatorTest >> testBasicBehavior [
	| nsd data sample estimator domain estimated f integral |
	nsd := NormalDistribution standard.
	data := nsd sample: 100.
	sample := SampleStatistic on: data.
	estimator := KernelDensityEstimator on: sample.
	estimator gaussian.
	domain := estimator domain.
	estimated := estimator values.
	self
		assert: (domain equalsTo: data);
		assert: estimated size = data size.
	f := LinearInterpolatedFunction abscissas: domain ordinates: estimated.
	integral := f integralFrom: domain min to: domain last.
	self assert: (integral relativeDistanceTo: 1.0) < 0.1]

