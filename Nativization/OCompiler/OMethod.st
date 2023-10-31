"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #OMethod}

{ #category : '*Nativization/OCompiler' }
OMethod >> allocate [
	| allocator |
	allocator := OptimizingRegisterAllocator new
		abi: compiler abi;
		method: self.
	^allocator doAllocation
]

{ #category : '*Nativization/OCompiler' }
OMethod >> assemble [
	| allocation |
	allocation := self splitCriticalEdges; transformToCSSA; allocate.
	^self
		enforceTwoAddressCodeUsing: allocation;
		simplifyCFG;
		assembleUsing: allocation
]

{ #category : '*Nativization/OCompiler' }
OMethod >> assembleUsing: allocation [
	^OptimizingCodeEmitter new
		method: self;
		allocation: allocation;
		assemble;
		nativeCode
]

{ #category : '*Nativization/OCompiler' }
OMethod >> enforceTwoAddressCodeUsing: allocation [
	| enforcer |
	enforcer := OptimizingTwoAddressEnforcer new
		allocation: allocation;
		firstBlock: start.
	^enforcer doEnforce
]

{ #category : '*Nativization/OCompiler' }
OMethod >> inlineMessages [
	compiler inlineMessagesIn: self.
	self validate
]

{ #category : '*Nativization/OCompiler' }
OMethod >> optimize [
	self removeRedundantCode; schedule; simplifyCFG
]

{ #category : '*Nativization/OCompiler' }
OMethod >> removeRedundantCode [
	OptimizingValueNumbering new workFrom: start
]

{ #category : '*Nativization/OCompiler' }
OMethod >> simplifyCFG [
	OptimizingCFGSimplifier new clean: self
]

{ #category : '*Nativization/OCompiler' }
OMethod >> splitCriticalEdges [
	start splitAllCriticalEdges
]

{ #category : '*Nativization/OCompiler' }
OMethod >> transformToCSSA [
	| transformer |
	transformer := OptimizingCSSATransformer new firstBlock: start.
	transformer applyTransformation
]

