"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #GDIDLL }

{ #category : '*RTF' }
GDIDLL >> TranslateCharsetInfo: lpSrc lpCs: aCHARSETINFO dwFlags: anIntger [
	<boolean: TranslateCharsetInfo>
	^self invalidArgument

" 
BOOL TranslateCharsetInfo(
  _Inout_ DWORD FAR     *lpSrc,
  _Out_   LPCHARSETINFO lpCs,
  _In_    DWORD         dwFlags
);
"]

