"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Package { #name : #IR,
	#classes : [
		'BMNullaryOperation',
		'OActivationContext',
		'OBasicBlock',
		'OBeginInstruction',
		'OBinaryConstantOperation',
		'OBinaryOperation',
		'OBinaryVariableOperation',
		'OBlockClosure',
		'OComposedLiveRange',
		'OConstant',
		'ODominatorTree',
		'OEndInstruction',
		'OInstruction',
		'OJump',
		'OJumpConditional',
		'OJumpFalse',
		'OJumpTrue',
		'OLiveRange',
		'OLoadConstant',
		'OLoadImplicit',
		'OLoadOperation',
		'OMemoryOperation',
		'OMessageSend',
		'OOperand',
		'OPhi',
		'OPrimitiveOperation',
		'OReturn',
		'OSimpleLiveRange',
		'OStoreOperation',
		'OTernaryOperation',
		'OTiling',
		'OUnaryOperation',
		'OValue'
	]
}