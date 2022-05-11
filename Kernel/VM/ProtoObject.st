"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #ProtoObject }

{ #category : '*Primitives' }
ProtoObject >> _size [
	<primitive: UnderSize>
]

{ #category : '*Primitives' }
ProtoObject >> behavior [
	<primitive: Behavior>
]

{ #category : #'*Primitives' }
ProtoObject >> behavior: aBehavior [
	<primitive: SetBehavior>
]

{ #category : '*Primitives' }
ProtoObject >> class [
	<primitive: Class>
]

{ #category : '*Primitives' }
ProtoObject >> == anObject [
	<primitive: Equal>
]

{ #category : '*Primitives' }
ProtoObject >> primitiveSize [
	<primitive: Size>
]

{ #category : '*Primitives' }
ProtoObject >> primitiveAt: index [
	<primitive: At>
]

{ #category : '*Primitives' }
ProtoObject >> primitiveAt: anInteger put: anObject [
	<primitive: AtPut>
]

{ #category : '*Primitives' }
ProtoObject >> basicHash [
	<primitive: Hash>
]

