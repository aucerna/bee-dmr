"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #UserDLL }

{ #category : '*GDI' }
UserDLL >> SystemParametersInfoForDpi: uiAction
uiParam: uiParam
pvParam: aWindowsStructure
fWinIni: anInteger
dpi: dpiInteger [
	<boolean: SystemParametersInfoForDpi>
	^self invalidCall

"
BOOL SystemParametersInfoForDpi(
  UINT  uiAction,
  UINT  uiParam,
  PVOID pvParam,
  UINT  fWinIni,
  UINT  dpi
);
"]

