"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #NumericalMethods,
	#requires : [
		'Extensions',
		'Distributions',
		'SKernel',
		'SUnit',
		'SUnitvalidation',
		'Utilities'
	]
	#classes : [
		'AnnealingAlgorithm',
		'AnnealingCorrelationSolver',
		'AnnealingHistogramFittingSolver',
		'AnnealingRankCorrelationSolver',
		'CholeskyDecompositionAlgorithm',
		'CombinatorialProblem',
		'ContinuedFraction',
		'ContinuedFractionA',
		'ContinuedFractionB',
		'ConvergentSeries',
		'CoolingDevice',
		'CorrelationProblem',
		'FloatPrecision',
		'Function',
		'FunctionRootInterval',
		'GammaFunction',
		'GoldenRatioContinuedFraction',
		'HeatingDevice',
		'HistogramFitting',
		'HistogramFittingProblem',
		'HistogramFittingValidator',
		'IncompleteBetaArguments',
		'IncompleteBetaContinuedFraction',
		'IncompleteBetaSeries',
		'IncompleteBetaSeriesSmallB',
		'IncompleteGammaFunction',
		'IncompleteGammaPrefix',
		'IncompleteUpperGammaContinuedFraction',
		'IntervalHalving',
		'InverseFunctionInterval',
		'LargeIncompleteBetaArguments',
		'LinearFunction',
		'LowerIncompleteGammaSeries',
		'LowerTriangularInversionAlgorithm',
		'MetalogDistribution',
		'NormalizedIncompleteBetaFunction',
		'OptimizationMethod',
		'PiContinuedFraction',
		'PointTriangulation',
		'PolynomialCoolingDevice',
		'PolynomialEuclideanAlgorithm',
		'PolynomialRootFinder',
		'RadixSort',
		'RadixStringSort',
		'RealPolynomial',
		'RealPolynomialDivisionAlgorithm',
		'SimpleCoolingDevice',
		'SimpsonMethod',
		'SmallIncompleteBetaArguments',
		'TemperatureController',
		'UpperIncompleteGammaSeries'
	]
}

