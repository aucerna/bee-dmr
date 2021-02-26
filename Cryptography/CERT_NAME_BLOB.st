"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CERT_NAME_BLOB,
	#superclass : #CRYPTOAPI_BLOB,
	#category : #Cryptography
}

{ #category : #inspecting }
CERT_NAME_BLOB class >> aspects [
	^CRYPTOAPI_BLOB aspects]

{ #category : #accessing }
CERT_NAME_BLOB class >> def [
	^<def>
typedef CRYPT_INTEGER_BLOB CERT_NAME_BLOB;
	
	</def>]

