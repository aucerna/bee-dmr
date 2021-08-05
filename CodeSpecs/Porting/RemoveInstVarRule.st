"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #RemoveInstVarRule, 
	#superclass : #RefactoringRule, 
	#instVars : [
		'ivar', 
		'classname'
	], 
	#category : #Porting
}

{#category : #private}
RemoveInstVarRule class >> named: aString in: classname [
	^self new ivar: aString; classname: classname]

{#category : #private}
RemoveInstVarRule >> basicApplyTo: aModuleSpec [
	| class all |
	class := aModuleSpec resolveClass: classname.
	class ifNil: [^self].
	class instVarNames remove: ivar ifAbsent: nil.
	all := aModuleSpec withAllSubclasses: class.
	all do: [:c | 
		c methods
			select: [:m | m usesInstanceVariableNamed: ivar]
			thenDo: [:m | aModuleSpec removeMethod: m]]]

{#category : #accessing}
RemoveInstVarRule >> classname [
	^classname]

{#category : #accessing}
RemoveInstVarRule >> classname: aString [
	classname := aString]

{#category : #accessing}
RemoveInstVarRule >> ivar [
	^ivar]

{#category : #accessing}
RemoveInstVarRule >> ivar: aString [
	ivar := aString]

