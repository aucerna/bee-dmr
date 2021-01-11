"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FTPConnection,
	#superclass : #InternetConnection,
	#instVars : [
		'user',
		'password'
	],
	#category : #'HTTP\Client'
}

{ #category : #'os messages' }
FTPConnection >> command: aString response: aBoolean transferType: anInteger [
	| memory pointer success |
	memory := aString externalCopy.
	pointer := ExternalPointer external.
	success := self dll
		FtpCommand: handle
		fExpectResponse: aBoolean asParameter
		dwFlags: anInteger asParameter
		lpszCommand: memory asParameter
		dwContext: token asParameter
		phFtpCommand: pointer asParameter.
	success ifFalse: [self winError].
	pointer := pointer makeLocal asInteger.
	memory free]

{ #category : #'os messages' }
FTPConnection >> createDirectory: aFilename [
	| success memory |
	memory := aFilename asString externalCopy.
	success := self dll
		FtpCreateDirectory: handle
		lpszDirectory: memory asParameter.
	success ifFalse: [self winError].
	memory free]

{ #category : #'os messages' }
FTPConnection >> currentDirectory [
	| memory size success |
	memory := (MAX_PATH + 1 * 2) externalBytes.
	size := ExternalInt32 external fromInteger: MAX_PATH.
	success := self dll
		FtpGetCurrentDirectory: handle
		lpszCurrentDirectory: memory asParameter
		lpdwCurrentDirectory: size asParameter.
	success ifFalse: [self winError].
	size free.
	^memory makeUnicode]

{ #category : #'os messages' }
FTPConnection >> currentDirectory: aFilename [
	| memory success |
	memory := aFilename asString externalCopy.
	success := self dll
		FtpSetCurrentDirectory: handle
		lpszDirectory: memory asParameter.
	success ifFalse: [self winError].
	memory free]

{ #category : #'os messages' }
FTPConnection >> deleteFile: aFilename [
	| success memory |
	memory := aFilename asString externalCopy.
	success := self dll FtpDeleteFile: handle lpszFileName: memory asParameter.
	success ifFalse: [self winError].
	memory free]

{ #category : #download }
FTPConnection >> download: remoteFileName
to: localFileName
failIfExists: aBoolean
attributes: attributes [
	^self
		getFile: remoteFileName
		newFile: localFileName
		failIfExists: aBoolean
		attributes: attributes
		transferType: FTP_TRANSFER_TYPE_BINARY]

{ #category : #download }
FTPConnection >> downloadFile: remoteFilename to: localFilename [
	^self downloadFile: remoteFilename to: localFilename failIfExists: false]

{ #category : #download }
FTPConnection >> downloadFile: remoteFilename to: localFilename failIfExists: aBoolean [
	^self
		download: remoteFilename
		to: localFilename
		failIfExists: aBoolean
		attributes: FILE_ATTRIBUTE_NORMAL]

{ #category : #'os messages' }
FTPConnection >> getFile: aFilename
newFile: localFilename
failIfExists: aBoolean
attributes: attributes
transferType: transferType [
	| remote local success |
	remote := aFilename asString externalCopy.
	local := localFilename asString externalCopy.
	success := self dll
		FtpGetFile: handle
		lpszRemoteFile: remote asParameter
		lpszNewFile: local asParameter
		fFailIfExists: aBoolean asParameter
		dwFlagsAndAttributes: attributes asParameter
		dwFlags: transferType asParameter
		dwContext: token asParameter.
	success ifFalse: [self winError].
	remote free.
	local free.
	^success]

{ #category : #commands }
FTPConnection >> help [
	^self command: '?' response: false transferType: FTP_TRANSFER_TYPE_BINARY]

{ #category : #initialization }
FTPConnection >> initializePort [
	port := INTERNET_DEFAULT_FTP_PORT]

{ #category : #initialization }
FTPConnection >> initializeService [
	self ftp]

{ #category : #'opening files' }
FTPConnection >> openFile: aFilename [
	^self openFile: aFilename access: GENERIC_WRITE]

{ #category : #'opening files' }
FTPConnection >> openFile: aFilename access: access [
	^self
		openFile: aFilename
		access: access
		transferType: FTP_TRANSFER_TYPE_BINARY]

{ #category : #'os messages' }
FTPConnection >> openFile: aFilename access: access transferType: transferType [
	| ulong memory |
	memory := aFilename asString externalCopy.
	ulong := self dll
		FtpOpenFile: handle
		lpszFileName: memory asParameter
		dwAccess: access asParameter
		dwFlags: transferType asParameter
		dwContext: token asParameter.
	ulong = 0 ifTrue: [self winError].
	memory free.
	^InternetFile on: self handle: ulong address: aFilename]

{ #category : #'opening files' }
FTPConnection >> openFileReadOnly: aFilename [
	^self openFile: aFilename access: GENERIC_READ]

{ #category : #accessing }
FTPConnection >> password [
	^password]

{ #category : #accessing }
FTPConnection >> password: aString [
	password := aString]

{ #category : #'os messages' }
FTPConnection >> putFile: localFilename into: remoteFilename transferType: transferType [
	| success local remote |
	local := localFilename asString externalCopy.
	remote := remoteFilename asString externalCopy.
	success := self dll
		FtpPutFile: handle
		lpszLocalFile: local asParameter
		lpszNewRemoteFile: remote asParameter
		dwFlags: transferType asParameter
		dwContext: token asParameter.
	success ifFalse: [self winError].
	local free.
	remote free]

{ #category : #'os messages' }
FTPConnection >> removeDirectory: aFilename [
	| success memory |
	memory := aFilename externalCopy.
	success := self dll
		FtpRemoveDirectory: handle
		lpszDirectory: memory asParameter.
	success ifFalse: [self winError].
	memory free]

{ #category : #'os messages' }
FTPConnection >> renameFile: aFilename to: anotherFilename [
	| success address1 address2 |
	address1 := aFilename asString externalCopy.
	address2 := anotherFilename asString externalCopy.
	success := self dll
		FtpRenameFile: handle
		lpszExisting: address1 asParameter
		lpszNew: address2 asParameter.
	success ifFalse: [self winError].
	address1 free.
	address2 free]

{ #category : #upload }
FTPConnection >> uploadFile: localFilename to: remoteFilename [
	self
		putFile: localFilename
		into: remoteFilename
		transferType: FTP_TRANSFER_TYPE_BINARY]

{ #category : #accessing }
FTPConnection >> user [
	^user]

{ #category : #accessing }
FTPConnection >> user: aString [
	user := aString]

{ #category : #commands }
FTPConnection >> verbose [
	^self
		command: 'verbose?'
		response: false
		transferType: FTP_TRANSFER_TYPE_BINARY]

