"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #BytecodeToOptimizingIRVisitor,
	#superclass : #BytecodeVisitor,
	#instVars : [
		'method',
		'parser',
		'blocks',
		'initialStates',
		'blockPhis',
		'firstBlock',
		'currentBlock',
		'pc',
		'activation',
		'regS',
		'regR',
		'regA',
		'regT',
		'stack'
	],
	#category : #OCompiler
}

