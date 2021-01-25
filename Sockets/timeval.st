"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #timeval,
	#superclass : #SocketStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
timeval class >> def [
	^<def>
	typedef struct timeval {
		long tv_sec;
		long tv_usec;
	} timeval;
	</def>]

{ #category : #'instance creation' }
timeval class >> fromDuration: aDuration [
	^self new milliseconds: aDuration milliseconds]

{ #category : #accessing }
timeval class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
timeval >> asDuration [
	^Duration milliseconds: self milliseconds]

{ #category : #output }
timeval >> microseconds [
	^self tv_sec * 1000000 + self tv_usec]

{ #category : #input }
timeval >> microseconds: anInteger [
	self tv_sec: anInteger // 1000000; tv_usec: anInteger \\ 1000000]

{ #category : #output }
timeval >> milliseconds [
	^self microseconds // 1000]

{ #category : #input }
timeval >> milliseconds: anInteger [
	self microseconds: anInteger * 1000]

{ #category : #accessing }
timeval >> tv_sec [
	^self longAtOffset: tv_sec]

{ #category : #accessing }
timeval >> tv_sec: anInteger [
	self longAtOffset: tv_sec put: anInteger]

{ #category : #accessing }
timeval >> tv_usec [
	^self longAtOffset: tv_usec]

{ #category : #accessing }
timeval >> tv_usec: anInteger [
	self longAtOffset: tv_usec put: anInteger]

