"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BoxCoxTest,
	#superclass : #TestCase,
	#instVars : [
		'boxcox'
	],
	#category : #'Distributions\Tests'
}

{ #category : #setup }
BoxCoxTest >> setUp [
	super setUp.
	boxcox := BoxCoxTransformation new]

{ #category : #all }
BoxCoxTest >> testBookSample [
	| data results |
	data := '
		.15	 .09	 .18	 .10	 .05	 .12	 .08
		.05	 .08	 .10	 .07	 .02	 .01	 .10
		.10	 .10	 .02	 .10	 .01	 .40	 .10
		.05	 .03	 .05	 .15	 .10	 .15	 .09
		.08	 .18	 .10	 .20	 .11	 .30	 .02
		.20	 .20	 .30	 .30	 .40	 .30	 .05' substrings
		collect: [:s | ('0' , s) asFloat].
	boxcox on: data.
	results := '
		-2.0	 7.1146	 -0.6	 89.0587	 0.7	 103.0322
		-1.9	 14.1877	 -0.5	 92.7855	 0.8	 101.3254
		-1.8	 21.1356	 -0.4	 96.0974	 0.9	 99.3403
		-1.7	 27.9468	 -0.3	 98.9722	 1.0	 97.1030
		-1.6	 34.6082	 -0.2	 101.3923	 1.1	 94.6372
		-1.5	 41.1054	 -0.1	 103.3457	 1.2	 91.9643
		-1.4	 47.4229	 0.0	 104.8276	 1.3	 89.1034
		-1.3	 53.5432	 0.1	 105.8406	 1.4	 86.0714
		-1.2	 59.4474	 0.2	 106.3947	 1.5	 82.8832
		-1.1	 65.1147	 0.3	 106.5069	 1.6	 79.5521
		-0.9	 75.6471	 0.4	 106.1994	 1.7	 76.0896
		-0.8	 80.4625	 0.5	 105.4985	 1.8	 72.5061
		-0.7	 84.9421	 0.6	 104.4330	 1.9	 68.8106' substrings
		collect: #asFloat.
	boxcox compute. 
	results
		pairsDo: [:a :b | self
			assert: ((boxcox logLikelihoodAt: a) - b) abs < 0.0001].
	self assert: (boxcox power roundTo: 0.01) = 0.28]

