"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTPSRequest,
	#superclass : #HTTPRequest,
	#category : #'HTTP\Client'
}

{ #category : #services }
HTTPSRequest >> securityCertificate [
	| data |
	data := self getOption: INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT.
	^INTERNET_CERTIFICATE_INFO usingBytes: data]

{ #category : #services }
HTTPSRequest >> securityCertificateString [
	| data |
	data := self getOption: INTERNET_OPTION_SECURITY_CERTIFICATE.
	^data asString]

