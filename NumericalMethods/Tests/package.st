"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'NumericalMethods\Tests',
	#requires : [
		'NumericalMethods',
		'Distributions',
		'Kernel',
		'SUnit',
		'Utilities'
	]
	#classes : [
		'CholeskyDecompositionTest',
		'ContinuedFractionTest',
		'FloatPrecisionTest',
		'IncompleteBetaFunctionTest',
		'IncompleteGammaTest',
		'LowerTriangularInversionAlgorithmTest',
		'MetalogDistributionTest',
		'OptimizationMethodTest',
		'RadixSortTest',
		'RealPolynomialTest',
		'SimpsonMethodTest',
		'TriangulationTest'
	]
}

