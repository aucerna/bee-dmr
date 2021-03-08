"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #WideString }

{ #category : '*RTF' }
WideString class >> fromMultiByte: aByteArray charset: anInteger [
	"
	WideString fromMultiByte: #[16rFA] charset: 204
	"
	| cp |
	cp := UTF16 current cpFrom: anInteger.
	^self fromMultiByte: aByteArray codePage: cp]

