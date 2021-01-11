"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #HttpRequestAuthenticator }

{ #category : '*HTTP\Server' }
HttpRequestAuthenticator >> validUserFrom: anHttpRequest using: aUsersRepository [
	| credentials user |
	credentials := self credentialsFrom: anHttpRequest.
	credentials isNil ifTrue: [^nil].
	user := aUsersRepository named: credentials key.
	user isNil ifTrue: [^nil].
	user isActive ifFalse: [^nil].
	^(user matchesPassword: credentials value) ifTrue: [user]]

