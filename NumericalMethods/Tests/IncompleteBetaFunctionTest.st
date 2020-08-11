"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IncompleteBetaFunctionTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #all }
IncompleteBetaFunctionTest >> test [
	self
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 0.5) valueAt: 0) ~ 0;
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 0.5) valueAt: 1) ~ 1;
		assert: ((NormalizedIncompleteBetaFunction a: 1 b: 1) valueAt: 0.3) ~ 0.3;
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 0.5) valueAt: 0.8)
			~ 0.70483276469913;
		assert: ((NormalizedIncompleteBetaFunction a: 1 b: 0.5) valueAt: 0.2)
			~ 0.10557280900008;
		assert: ((NormalizedIncompleteBetaFunction a: 1 b: 0.5) valueAt: 0.8)
			~ 0.55278640450004;
		assert: ((NormalizedIncompleteBetaFunction a: 31 b: 30) valueAt: 0.3)
			~ 0.36402563242403e-3;
		assert: ((NormalizedIncompleteBetaFunction a: 0.2 b: 0.3) valueAt: 0.3)
			~ 0.52800355495078;
		assert: ((NormalizedIncompleteBetaFunction a: 0.2 b: 0.3) valueAt: 0.8)
			~ 0.72360679774998;
		assert: ((NormalizedIncompleteBetaFunction a: 0.114 b: 0.3)
			epsilon: 1.0e-14;
			valueAt: 0.4) ~ 0.70600018534085;
		assert: ((NormalizedIncompleteBetaFunction a: 0.05 b: 0.3) valueAt: 0.2)
			~ 0.81258610665163;
		assert: ((NormalizedIncompleteBetaFunction a: 0.3 b: 0.06) valueAt: 0.8)
			~ 0.2185518518099;
		assert: ((NormalizedIncompleteBetaFunction a: 0.3 b: 1) valueAt: 0.3)
			~ 0.69684530193595;
		assert: ((NormalizedIncompleteBetaFunction a: 0.3 b: 1) valueAt: 0.7)
			~ 0.89852344179064;
		assert: ((NormalizedIncompleteBetaFunction a: 30 b: 50) valueAt: 0.3)
			~ 0.79279223823672e-1;
		assert: ((NormalizedIncompleteBetaFunction a: 30 b: 20.5) valueAt: 0.3)
			~ 0.79630229741674e-5;
		assert: ((NormalizedIncompleteBetaFunction a: 30 b: 20.5) valueAt: 0.4)
			~ 0.2709237657196e-2;
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 2) valueAt: 0.2)
			~ 0.62609903369994;
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 2)
			epsilon: 10.0e-14;
			valueAt: 0.4) ~ 0.82219219164378;
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 15) valueAt: 0.2)
			~ 0.9897201794708;
		assert: ((NormalizedIncompleteBetaFunction a: 15 b: 0.5) valueAt: 0.8)
			~ 0.0102798205292;
		assert: ((NormalizedIncompleteBetaFunction a: 2 b: 10.1) valueAt: 0.4)
			~ 0.97104269334266;
		assert: ((NormalizedIncompleteBetaFunction a: 2 b: 1.1)
			epsilon: 10.0e-14;
			valueAt: 0.4) ~ 0.1790270129391;
		assert: ((NormalizedIncompleteBetaFunction a: 2 b: 0.5) valueAt: 0.8)
			~ 0.37390096630006;
		assert: ((NormalizedIncompleteBetaFunction a: 2 b: 0.5)
			epsilon: 10.0e-14;
			valueAt: 0.4) ~ 0.7048399691022e-1;
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 2) valueAt: 0.05)
			~ 0.32982002668122]

{ #category : #all }
IncompleteBetaFunctionTest >> testComplementary [
	self
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 0.5) complementaryAt: 0)
			~ 1;
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 0.5) complementaryAt: 1)
			~ 0;
		assert: ((NormalizedIncompleteBetaFunction a: 1 b: 1) complementaryAt: 0.3)
			~ 0.7;
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 0.5)
			complementaryAt: 0.8)
			~ 0.29516723530087;
		assert: ((NormalizedIncompleteBetaFunction a: 1 b: 0.5) complementaryAt: 0.2)
			~ 0.89442719099992;
		assert: ((NormalizedIncompleteBetaFunction a: 1 b: 0.5) complementaryAt: 0.8)
			~ (1 - 0.55278640450004);
		assert: ((NormalizedIncompleteBetaFunction a: 31 b: 30) complementaryAt: 0.3)
			~ (1 - 0.36402563242403e-3);
		assert: ((NormalizedIncompleteBetaFunction a: 0.2 b: 0.3)
			complementaryAt: 0.3)
			~ (1 - 0.52800355495078);
		assert: ((NormalizedIncompleteBetaFunction a: 0.2 b: 0.3)
			complementaryAt: 0.8)
			~ (1 - 0.72360679774998);
		assert: ((NormalizedIncompleteBetaFunction a: 0.114 b: 0.3)
			epsilon: 10.0e-14;
			complementaryAt: 0.4) ~ (1 - 0.70600018534085);
		assert: ((NormalizedIncompleteBetaFunction a: 0.05 b: 0.3)
			complementaryAt: 0.2)
			~ (1 - 0.81258610665163);
		assert: ((NormalizedIncompleteBetaFunction a: 0.3 b: 0.06)
			complementaryAt: 0.8)
			~ (1 - 0.2185518518099);
		assert: ((NormalizedIncompleteBetaFunction a: 0.3 b: 1) complementaryAt: 0.3)
			~ (1 - 0.69684530193595);
		assert: ((NormalizedIncompleteBetaFunction a: 0.3 b: 1) complementaryAt: 0.7)
			~ (1 - 0.89852344179064);
		assert: ((NormalizedIncompleteBetaFunction a: 30 b: 50) complementaryAt: 0.3)
			~ (1 - 0.79279223823672e-1);
		assert: ((NormalizedIncompleteBetaFunction a: 30 b: 20.5)
			complementaryAt: 0.3)
			~ (1 - 0.79630229741674e-5);
		assert: ((NormalizedIncompleteBetaFunction a: 30 b: 20.5)
			complementaryAt: 0.4)
			~ (1 - 0.2709237657196e-2);
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 2) complementaryAt: 0.2)
			~ (1 - 0.62609903369994);
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 2)
			epsilon: 10.0e-14;
			complementaryAt: 0.4) ~ (1 - 0.82219219164378);
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 15)
			complementaryAt: 0.2)
			~ (1 - 0.9897201794708);
		assert: ((NormalizedIncompleteBetaFunction a: 15 b: 0.5)
			complementaryAt: 0.8)
			~ (1 - 0.0102798205292);
		assert: ((NormalizedIncompleteBetaFunction a: 2 b: 10.1)
			complementaryAt: 0.4)
			~ (1 - 0.97104269334266);
		assert: ((NormalizedIncompleteBetaFunction a: 2 b: 1.1) complementaryAt: 0.4)
			~ (1 - 0.1790270129391);
		assert: ((NormalizedIncompleteBetaFunction a: 2 b: 0.5) complementaryAt: 0.8)
			~ (1 - 0.37390096630006);
		assert: ((NormalizedIncompleteBetaFunction a: 2 b: 0.5) complementaryAt: 0.4)
			~ (1 - 0.7048399691022e-1);
		assert: ((NormalizedIncompleteBetaFunction a: 0.5 b: 2)
			complementaryAt: 0.05)
			~ (1 - 0.32982002668122)]

{ #category : #all }
IncompleteBetaFunctionTest >> testInvertedSeries [
	self
		assert: ((NormalizedIncompleteBetaFunction a: 0.114 b: 0.3)
			epsilon: 10.0e-14;
			valueAt: 0.4) ~ 0.70600018534085]

