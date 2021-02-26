"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CredentialVault,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #Cryptography
}

{ #category : #services }
CredentialVault class >> credentialsFor: aString [
	| vault |
	vault := self named: aString.
	^vault notNil ifTrue: [vault credentials]]

{ #category : #'instance creation' }
CredentialVault class >> named: aString [
	^self new name: aString]

{ #category : #inquiries }
CredentialVault >> credentials [
	| struct credentials |
	struct := self struct ifNil: [^nil].
	credentials := struct credentials.
	struct credFree.
	(credentials username size > 0 and: [credentials password isNil])
		ifTrue: [credentials password: ''].
	^credentials]

{ #category : #actions }
CredentialVault >> delete [
	| buffer success |
	buffer := name externalCopy.
	success := Advapi32DLL current
		CredDelete: buffer asParameter
		Type: CRED_TYPE_GENERIC
		Flags: 0.
	success ifFalse: [self winError]]

{ #category : #actions }
CredentialVault >> duplicateWithName: aString [
	| vault |
	vault := self class named: aString.
	vault exists ifTrue: [^nil].
	vault username: self username password: self password.
	^vault]

{ #category : #testing }
CredentialVault >> exists [
	^self struct ifNil: [false] ifNotNil: [:c | 
		c credFree.
		true]]

{ #category : #accessing }
CredentialVault >> name [
	^name]

{ #category : #accessing }
CredentialVault >> name: aString [
	name := aString]

{ #category : #inquiries }
CredentialVault >> password [
	^self credentials ifNotNil: [:c | c password]]

{ #category : #services }
CredentialVault >> password: password [
	self username: self username password: password]

{ #category : #printing }
CredentialVault >> printOn: aStream [
	aStream nextPutAll: self class name; space.
	name printOn: aStream]

{ #category : #actions }
CredentialVault >> renameTo: aString [
	| vault |
	vault := self duplicateWithName: aString.
	vault notNil ifTrue: [self delete].
	name := aString]

{ #category : #inquiries }
CredentialVault >> struct [
	| pointer buffer success code |
	pointer := ExternalPointer external.
	buffer := name externalCopy.
	success := Advapi32DLL current
		CredRead: buffer asParameter
		Type: CRED_TYPE_GENERIC
		Flags: 0
		Credential: pointer asParameter.
	success ifFalse: [
		code := self lastWinError.
		code = ERROR_NOT_FOUND ifTrue: [^nil].
		self winError: code].
	buffer free.
	^CREDENTIAL atMemory: pointer makeExternalMemory]

{ #category : #inquiries }
CredentialVault >> username [
	^self credentials ifNotNil: [:c | c username]]

{ #category : #services }
CredentialVault >> username: username [
	self username: username password: self password]

{ #category : #services }
CredentialVault >> username: username password: password [
	self username: username password: password persistent: true]

{ #category : #services }
CredentialVault >> username: username password: password persistent: aBoolean [
	| credentials success pwd |
	credentials := CREDENTIAL external.
	pwd := password isNil ifTrue: [''] ifFalse: [password].
	credentials
		persistent: aBoolean;
		username: username;
		password: pwd;
		targetName: name.
	success := Advapi32DLL current CredWrite: credentials asParameter Flags: 0.
	success ifFalse: [self winError].
	credentials free]

