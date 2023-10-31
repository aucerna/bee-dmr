"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Integer}

{ #category : '*Nativization/OCompiler/IR' }
Integer >> powerOfTwo [
	^(self bitAnd: self - 1) = 0 ifTrue: [self highBit - 1]
]

