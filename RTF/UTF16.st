"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #UTF16 }

{ #category : '*RTF' }
UTF16 >> cpFrom: charset [
	| info cs success |
	info := CHARSETINFO external.
	cs := (charset = SYMBOL_CHARSET or: [charset = DEFAULT_CHARSET])
		ifTrue: [ANSI_CHARSET]
		ifFalse: [charset].
	success := GDIDLL current
		TranslateCharsetInfo: cs asParameter
		lpCs: info asParameter
		dwFlags: TCI_SRCCHARSET.
	success ifFalse: [self winError].
	^info makeLocal codePage]

