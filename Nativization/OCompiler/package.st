"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Package { #name : #OCompiler,
	#classes : [
		'BMMultilevelDictionary',
		'OptimizingBlockInliner',
		'OptimizingBraunAllocator',
		'OptimizingBraunAssigner',
		'OptimizingCFGSimplifier',
		'OptimizingCodeEmitter',
		'OptimizingCSSATransformer',
		'OptimizingInstructionFragmenter',
		'OptimizingInstructionSelector',
		'OptimizingLivenessAnalysis',
		'OptimizingMethodInliner',
		'OptimizingNativizer',
		'OptimizingPhiSimplification',
		'OptimizingRegisterAllocator',
		'OptimizingSSAReconstructor',
		'OptimizingTwoAddressEnforcer',
		'OptimizingUsesVerifier',
		'OptimizingValueNumbering',
		'OptimizingVariableBinder',
		'OptimizingVisitor'
	]
}

