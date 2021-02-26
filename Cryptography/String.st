"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #String }

{ #category : '*Cryptography' }
String >> base64Encoding [
	^Crypt32DLL current encodeBase64: self utf8]

{ #category : '*Cryptography' }
String >> sha256 [
	"
	'Alicia le vendió cinco bitcoins a Carmen' sha256
	"
	^self utf8 sha256]

