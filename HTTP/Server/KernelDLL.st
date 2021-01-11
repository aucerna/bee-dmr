"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #KernelDLL }

{ #category : '*HTTP\Server' }
KernelDLL >> CancelThreadpoolIo: pio [
	<ulong: CancelThreadpoolIo>
	^self invalidArgument

"
VOID WINAPI CancelThreadpoolIo(
  _Inout_ PTP_IO pio
);
"]

{ #category : '*HTTP\Server' }
KernelDLL >> CloseThreadpoolIo: pio [
	<ulong: CloseThreadpoolIo>
	^self invalidArgument

"
VOID WINAPI CloseThreadpoolIo(
  _Inout_ PTP_IO pio
);
"]

{ #category : '*HTTP\Server' }
KernelDLL >> CreateThreadpoolIo: fl
pfnio: aCallbackMethod
pv: data
pcbe: env [
	<ulong: CreateThreadpoolIo>
	^self invalidArgument

"
PTP_IO WINAPI CreateThreadpoolIo(
  _In_        HANDLE                fl,
  _In_        PTP_WIN32_IO_CALLBACK pfnio,
  _Inout_opt_ PVOID                 pv,
  _In_opt_    PTP_CALLBACK_ENVIRON  pcbe
);
"]

{ #category : '*HTTP\Server' }
KernelDLL >> StartThreadpoolIo: pio [
	<ulong: StartThreadpoolIo>
	^self invalidArgument

"
VOID WINAPI StartThreadpoolIo(
  _Inout_ PTP_IO pio
);
"]

{ #category : '*HTTP\Server' }
KernelDLL >> WaitForThreadpoolIoCallbacks: pio fCancelPendingCallbacks: boolean [
	<ulong: WaitForThreadpoolIoCallbacks>
	^self invalidArgument

"
VOID WINAPI WaitForThreadpoolIoCallbacks(
  _Inout_ PTP_IO pio,
  _In_    BOOL   fCancelPendingCallbacks
);
"]

