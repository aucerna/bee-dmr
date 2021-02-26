"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CERT_CONTEXT,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #inspecting }
CERT_CONTEXT class >> aspects [
	^super aspects , #(#encodingType #certificate #certInfo)]

{ #category : #accessing }
CERT_CONTEXT class >> def [
	^<def>
		typedef struct _CERT_CONTEXT {
			DWORD dwCertEncodingType; // 0
			BYTE* pbCertEncoded; // 4
			DWORD cbCertEncoded; // 8
			PCERT_INFO pCertInfo; // 12
			HCERTSTORE hCertStore; // 16
		} CERT_CONTEXT, *PCERT_CONTEXT, *PCCERT_CONTEXT; // sizeInBytes = 20
	</def>]

{ #category : #accessing }
CERT_CONTEXT class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 40;
		at: 'dwCertEncodingType' put: 0;
		at: 'pbCertEncoded' put: 8;
		at: 'cbCertEncoded' put: 16;
		at: 'pCertInfo' put: 24;
		at: 'hCertStore' put: 32;
		yourself]

{ #category : #accessing }
CERT_CONTEXT class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
CERT_CONTEXT class >> typedefTable [
	^Crypt32DLL typedefTable]

{ #category : #accessing }
CERT_CONTEXT >> cbCertEncoded [
	^self uLongAtOffset: cbCertEncoded]

{ #category : #output }
CERT_CONTEXT >> certificate [
	| data |
	data := ByteArray new: self cbCertEncoded.
	^data
		replaceFrom: 1
		to: data size
		with: self pbCertEncoded
		startingAt: 1]

{ #category : #output }
CERT_CONTEXT >> certInfo [
	^CERT_INFO fromMemory: self pCertInfo]

{ #category : #accessing }
CERT_CONTEXT >> dwCertEncodingType [
	^self uLongAtOffset: dwCertEncodingType]

{ #category : #output }
CERT_CONTEXT >> encodingType [
	| type |
	type := self dwCertEncodingType.
	type = X509_ASN_ENCODING ifTrue: [^'X509_ASN_ENCODING'].
	type = PKCS_7_ASN_ENCODING ifTrue: [^'PKCS_7_ASN_ENCODING']]

{ #category : #accessing }
CERT_CONTEXT >> hCertStore [
	^self pointerAtOffset: hCertStore]

{ #category : #output }
CERT_CONTEXT >> issuerName [
	^Crypt32DLL current
		certificateName: self dwCertEncodingType
		pName: self certInfo Issuer]

{ #category : #accessing }
CERT_CONTEXT >> pbCertEncoded [
	^self addressAtOffset: pbCertEncoded]

{ #category : #accessing }
CERT_CONTEXT >> pCertInfo [
	^self addressAtOffset: pCertInfo]

{ #category : #output }
CERT_CONTEXT >> subjectName [
	| subject ulong |
	subject := self certInfo Subject externalCopy.
	ulong := Crypt32DLL current
		certificateName: self dwCertEncodingType
		pName: subject asParameter.
	subject free.
	^ulong]

