"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InternetFileFinder,
	#superclass : #FileFinder,
	#category : #'HTTP\Client'
}

{ #category : #accessing }
InternetFileFinder >> connection [
	^directory]

{ #category : #private }
InternetFileFinder >> endSearch [
	| success local |
	local := data localCopy.
	success := WininetDLL current InternetCloseHandle: handle asParameter.
	success ifFalse: [self winNotification].
	data free.
	data := local.
	handle := nil]

{ #category : #queries }
InternetFileFinder >> findFirstFile [
	| connection copy error |
	connection := self connection.
	copy := pattern externalCopy.
	handle := WininetDLL current
		FtpFindFirstFile: connection asParameter
		lpszSearchFile: copy asParameter
		lpFindFileData: data asParameter
		dwFlags: INTERNET_NO_CALLBACK
		dwContext: 0.
	error := handle = 0 ifTrue: [self lastWinError].
	copy free.
	^error]

{ #category : #queries }
InternetFileFinder >> findNext [
	| success error |
	success := WininetDLL current
		InternetFindNextFile: handle asParameter
		lpvFindData: data asParameter.
	success ifTrue: [^true].
	error := self lastWinError.
	error = ERROR_NO_MORE_FILES ifFalse: [self winError: error].
	^false]

