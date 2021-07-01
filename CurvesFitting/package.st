"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #CurvesFitting,
	#requires : [
		'Kernel',
		'Utilities'
	],
	#classes : [
		'LeastSquares',
		'PerpendicularLeastSquares',
		'RayleighQuotientLeastSquares',
		'VerticalLeastSquares'
	]
}

