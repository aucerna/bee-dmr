"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PasswordTest,
	#superclass : #TestCase,
	#category : #'Cryptography\Tests'
}

{ #category : #passwords }
PasswordTest >> testBase64 [
	| vault secret password |
	vault := CredentialVault named: 'testProtect'.
	secret := 'slow train coming'.
	vault username: 'bob dylan' password: secret copy persistent: false.
	self
		assert: vault password base64Encoding makeUnicode = secret base64Encoding.
	vault delete.
	password := Password on: secret copy.
	self assert: password base64Encoding makeUnicode = secret base64Encoding]

{ #category : #credentials }
PasswordTest >> testCredentialsBase64 [
	| c1 c2 |
	c1 := UserCredentials new
		username: 'nobody@nowhere.com';
		password: 'nothing' copy.
	c2 := Crypt32DLL current credentialsBase64: c1 base64.
	self
		assert: c1 username equals: c2 username;
		assert: c1 password characters equals: c2 password characters]

{ #category : #credentials }
PasswordTest >> testCredentialsForm [
	| credentials string form |
	credentials := UserCredentials new
		username: 'user';
		password: 'mysecretpassword' copy.
	form := credentials formFor: 'tenant'.
	self assert: form isExternalMemory.
	string := form makeString.
	self
		assert: string
			= 'grant_type=password&username=user&password=mysecretpassword&scope=planningspace&client_id=tenant resource_owner&client_secret=']

{ #category : #credentials }
PasswordTest >> testCredentialsJson [
	| credentials json string |
	credentials := UserCredentials new
		username: 'user';
		password: 'mysecretpassword' copy.
	json := credentials json.
	string := json makeString.
	self
		assert: json isExternalMemory;
		assert: string = '{"userName":"user","password":"mysecretpassword"}']

{ #category : #all }
PasswordTest >> testProtect [
	| vault secret password |
	vault := CredentialVault named: 'testProtect'.
	secret := 'slow train coming'.
	vault username: 'bob dylan' password: secret copy persistent: false.
	self
		assert: vault password externalCopy length = (secret size + 1 * 2);
		assert: vault password cleartext = secret.
	vault delete.
	password := Password on: secret copy.
	self
		assert: password externalCopy length = (secret size + 1 * 2);
		assert: password cleartext = secret]

{ #category : #all }
PasswordTest >> testProtect2 [
	| secret password |
	secret := 'slow train coming' copy.
	password := Password on: secret.
	self
		assert: secret asSet asArray = {0 asCharacter};
		assert: password cleartext = 'slow train coming']

{ #category : #all }
PasswordTest >> testUTF8 [
	| vault secret password |
	vault := CredentialVault named: 'testProtect'.
	secret := 'slow train coming'.
	vault username: 'bob dylan' password: secret copy persistent: false.
	self assert: vault password utf8 makeBytes = secret utf8.
	vault delete.
	password := Password on: secret copy.
	self assert: password utf8 makeBytes = secret utf8]

