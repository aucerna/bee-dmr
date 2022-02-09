"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*IR' }
Object >> isBinaryConstantOperation [
	^false
]

{ #category : '*IR' }
Object >> isBinaryVariableOperation [
	^false
]

{ #category : '*IR' }
Object >> isTernaryOperation [
	^false
]

{ #category : '*IR' }
Object >> isUnaryOperation [
	^false
]

{ #category : '*IR' }
Object >> primitivePrintString [
	^self printString
]

