"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #OCompiler}

{ #category : '*Nativization/OCompiler' }
OCompiler >> inlineMessagesIn: anOMethod [
	OptimizingMethodInliner new
		methods: environment inlinedMethods;
		method: anOMethod;
		inlineAllMessages
]

