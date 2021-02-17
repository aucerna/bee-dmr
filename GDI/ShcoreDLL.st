"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ShcoreDLL,
	#superclass : #ExternalLibrary,
	#type : #bytes,
	#category : #GDI
}

{ #category : #initialization }
ShcoreDLL class >> initializeAwarenessConstants [
	WindowsConstants
		at: 'PROCESS_DPI_UNAWARE' put: 0;
		at: 'PROCESS_SYSTEM_DPI_AWARE' put: 1;
		at: 'PROCESS_PER_MONITOR_DPI_AWARE' put: 2]

{ #category : #initialization }
ShcoreDLL class >> initializeConstants [
	self initializeAwarenessConstants; initializeWMConstants]

{ #category : #unclassified }
ShcoreDLL class >> initializeWMConstants [
	WindowsConstants at: 'WM_DPICHANGED' put: 16r2E0]

{ #category : #accessing }
ShcoreDLL class >> moduleName [
	^'Shcore']

{ #category : #dpi }
ShcoreDLL >> dpiAwareness [
	"
	ShcoreDLL current dpiAwareness
	"
	| ulong hresult |
	ulong := ExternalInt32 external.
	hresult := self GetProcessDpiAwareness: 0 value: ulong asParameter.
	hresult = S_OK ifFalse: [self osError].
	^ulong makeInteger]

{ #category : #dpi }
ShcoreDLL >> dpiFromMonitor: hmonitor [
	"
	ShcoreDLL current dpiFromMonitor: 0 @ 0
	"
	| x y hresult |
	x := ExternalInt32 external.
	y := ExternalInt32 external.
	hresult := self
		GetDpiForMonitor: hmonitor
		dpiType: 0
		dpiX: x asParameter
		dpiY: y asParameter.
	hresult = S_OK ifFalse: [self winError].
	y free.
	^x makeInteger]

{ #category : #dpi }
ShcoreDLL >> dpiFromPoint: aPoint [
	"
	ShcoreDLL current dpiFromPoint: 0 @ 0
	"
	| hmonitor x y hresult |
	hmonitor := UserDLL current monitorFromPoint: aPoint.
	x := ExternalInt32 external.
	y := ExternalInt32 external.
	hresult := self
		GetDpiForMonitor: hmonitor
		dpiType: 0
		dpiX: x asParameter
		dpiY: y asParameter.
	hresult = S_OK ifFalse: [self winError].
	y free.
	^x makeInteger]

{ #category : #dpi }
ShcoreDLL >> GetDpiForMonitor: hmonitor
dpiType: type
dpiX: x
dpiY: y [
	<ulong: GetDpiForMonitor>
	^self invalidCall

"
HRESULT WINAPI GetDpiForMonitor(
  _In_  HMONITOR         hmonitor,
  _In_  MONITOR_DPI_TYPE dpiType,
  _Out_ UINT             *dpiX,
  _Out_ UINT             *dpiY
);
"]

{ #category : #private }
ShcoreDLL >> GetProcessDpiAwareness: hprocess value: awareness [
	<ulong: GetProcessDpiAwareness>
	^self invalidCall

"
HRESULT WINAPI GetProcessDpiAwareness(
  _In_  HANDLE                hprocess,
  _Out_ PROCESS_DPI_AWARENESS *value
);
"]

