"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Crypt32Test,
	#superclass : #TestCase,
	#category : #sockets
}

{ #category : #all }
Crypt32Test >> testCertOpenStore [
	| para store success context |
	para := 'Root' externalCopy.
	store := Crypt32DLL current
		CertOpenStore: CERT_STORE_PROV_SYSTEM_W
		dwMsgAndCertEncodingType: X509_ASN_ENCODING
		hCryptProv: 0
		dwFlags: CERT_SYSTEM_STORE_CURRENT_USER
		pvPara: para asParameter.
	self assert: store != 0.
	para free.
	[
		context := Crypt32DLL current
			CertFindCertificateInStore: store
			dwCertEncodingType: X509_ASN_ENCODING
			dwFindFlags: 0
			dwFindType: CERT_FIND_ANY
			pvFindPara: 0
			pPrevCertContext: 0.
		context = 0 ifTrue: [self winError]]
		ensure: [
			context ~= 0
				ifTrue: [Crypt32DLL current CertFreeCertificateContext: context].
			success := Crypt32DLL current CertCloseStore: store dwFlags: 0].
	self assert: success.
	self assert: context ~= 0]

{ #category : #all }
Crypt32Test >> testProtectUnpotect [
	| dll blob plaintext |
	dll := Crypt32DLL current.
	blob := dll protect: 'our secret'.
	plaintext := dll unprotect: blob.
	self assert: plaintext makeString = 'our secret']

