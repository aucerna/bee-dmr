"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'Distributions\Tests',
	#requires : [
		'Distributions',
		'Extensions',
		'NumericalMethods',
		'ObjectDumper',
		'SCompiler',
		'SKernel',
		'SUnit',
		'Utilities'
	]
	#classes : [
		'BernoulliCalculatorTest',
		'BetaDistributionFinderTest',
		'BoxCoxTest',
		'DateDistributionTest',
		'DiscreteDistributionTest',
		'HistogramTest',
		'KernelDensityEstimatorTest',
		'MultivariateNormalDistributionTest',
		'ProbabilityDistributionTest',
		'RandomTest',
		'SampleStatisticTest'
	]
}

