"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Package {
	#name : #OCompiler,
	#requires : [
		'JIT',
		'Kernel',
		'Nativization\\Assembler\\Intel\\JIT',
		'Nativization\\OCompiler\\IR'
	],
	#classes : [
		'BMMultilevelDictionary',
		'ODispatchInliner',
		'OptimizingBlockInliner',
		'OptimizingBraunAllocator',
		'OptimizingBraunAssigner',
		'OptimizingCFGSimplifier',
		'OptimizingCodeEmitter',
		'OptimizingCSSATransformer',
		'OptimizingInstructionSelector',
		'OptimizingLivenessAnalysis',
		'OptimizingMethodInliner',
		'OptimizingNativizer',
		'OptimizingPhiSimplification',
		'OptimizingRegisterAllocator',
		'OptimizingSSAReconstructor',
		'OptimizingTwoAddressEnforcer',
		'OptimizingValueNumbering',
		'OptimizingVariableBinder',
		'OptimizingVisitor'
	]
}