"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*Nativization\\OCompiler\\IR' }
Object >> isBinaryConstantOperation [
	^false
]

{ #category : '*Nativization\\OCompiler\\IR' }
Object >> isBinaryVariableOperation [
	^false
]

{ #category : '*Nativization\\OCompiler\\IR' }
Object >> isTernaryOperation [
	^false
]

{ #category : '*Nativization\\OCompiler\\IR' }
Object >> isUnaryOperation [
	^false
]

{ #category : '*Nativization\\OCompiler\\IR' }
Object >> primitivePrintString [
	^self printString
]

