"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Extension { #name : #NativizationEnvironment }

{ #category : '*Nativization\\OCompiler' }
NativizationEnvironment >> optimizingNativizer [
	^OptimizingNativizer new environment: self
]

{ #category : '*Nativization\\OCompiler' }
NativizationEnvironment >> shouldOptimize: method [
	| selector species |
	method isDebuggable ifTrue: [^false].
	method isCallback ifTrue: [^false].
	selector := method selector.
	species := method classBinding.
	^optimizedMethods
		anySatisfy: [:m | m classBinding == species and: [m selector == selector]]
]

