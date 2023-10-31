"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #CompiledMethod}

{ #category : '*Nativization/OCompiler/IR' }
CompiledMethod >> hasSpecialABI [
	^(self includes: #specialABIBegin) or: [self includes: #savePreviousSelf]
]

