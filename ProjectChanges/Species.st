"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Species }

{ #category : '*ProjectChanges' }
Species >> definitionString [
	^String streamContents: [:strm | self fileOutOn: strm]]

{ #category : '*ProjectChanges' }
Species >> methodsFor: category stamp: stamp [
	| stream author |
	stream := stamp readStream.
	author := stream upTo: $ .
	^MethodDefinition new
		category: category;
		author: author;
		timestamp: (Timestamp mmddyyyyhhmmss: stream upToEnd);
		className: self name]

{ #category : '*ProjectChanges' }
Species >> parseTree [
	| result |
	result := Compiler parseExpression: self sourceCode in: self.
	^result ast]

{ #category : '*ProjectChanges' }
Species >> subclass: className
instanceVariableNames: instVars
classVariableNames: classVars
package: projectName [
	^self
		subclass: className
		instanceVariableNames: instVars
		classVariableNames: classVars
		poolDictionaries: ''
		category: projectName]

{ #category : '*ProjectChanges' }
Species >> subclass: classname
instanceVariableNames: ivars
classVariableNames: cvars
poolDictionaries: pools
category: module [
	| definition project index package change |
	definition := String streamContents: [:strm | 
		strm
			nextPutAll: self name;
			nextPutAll: ' subclass: #';
			nextPutAll: classname;
			crtab;
			nextPutAll: 'instanceVariableNames: ';
			nextPutAll: ivars storeString;
			crtab;
			nextPutAll: 'classVariableNames: ';
			nextPutAll: cvars storeString;
			crtab;
			nextPutAll: 'poolDictionaries: ';
			nextPutAll: pools storeString].
	project := BeeModule getProject: module.
	project isNil ifTrue: [
		index := module indexOfString: '-Tests'.
		index > 0 ifTrue: [
			package := module replace: '-Tests' at: index with: ''.
			project := BeeModule getProject: package]].
	project isNil ifTrue: [project := BeeModule newProject: module].
	change := ClassDefinition new
		className: classname;
		project: project;
		definition: definition.
	^change perform]

{ #category : '*ProjectChanges' }
Species >> subclass: className
instanceVariableNames: instVars
classVariableNames: classVars
poolDictionaries: pools
package: projectName [
	^self
		subclass: className
		instanceVariableNames: instVars
		classVariableNames: classVars
		poolDictionaries: pools
		category: projectName]

{ #category : '*ProjectChanges' }
Species >> variableSubclass: className
instanceVariableNames: instVars
classVariableNames: classVars
poolDictionaries: pools
category: projectName [
	| definition project change |
	definition := self name , ' variableSubclass: #' , className
		, '
	instanceVariableNames: '
		, instVars storeString
		, '
	classVariableNames: '
		, classVars storeString
		, '
	poolDictionaries: '
		, pools storeString.
	project := BeeModule withName: projectName.
	change := ClassDefinition new
		className: className;
		project: project;
		definition: definition.
	^change perform]

