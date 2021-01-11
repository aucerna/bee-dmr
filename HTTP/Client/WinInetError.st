"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WinInetError,
	#superclass : #Win32Error,
	#category : #'HTTP\Client'
}

{ #category : #errors }
WinInetError >> errorMessage [
	^KernelDLL current formatMessage: code fromModule: WininetDLL]

{ #category : #testing }
WinInetError >> isDenied [
	^false]

{ #category : #testing }
WinInetError >> isTimeout [
	^code = 12002]

