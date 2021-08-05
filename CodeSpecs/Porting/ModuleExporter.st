"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleExporter, 
	#superclass : #Object, 
	#instVars : [
		'module', 
		'path', 
		'compatible'
	], 
	#category : #Porting
}

{#category : #'instance creation'}
ModuleExporter class >> new [
	^super new initialize]

{#category : #accessing}
ModuleExporter >> compatible: aBoolean [
	compatible := aBoolean]

{#category : #accessing}
ModuleExporter >> copyright [
	^'Copyright (c) ' , Date today year asString , ' Quorum Software.']

{#category : #private}
ModuleExporter >> createFolder [
	self moduleFolder createPath]

{#category : #private}
ModuleExporter >> definition [
	| names |
	names := (module classes collect: #name) sort.
	^OrderedDictionary new
		at: #name put: self moduleName asSymbol;
		at: #requires
		put: module dependencies keys asArray sort;
		at: #classes put: names asArray;
		yourself]

{#category : #export}
ModuleExporter >> export [
	self
		createFolder;
		exportMetadata;
		exportClasses;
		exportExtendedClasses]

{#category : #export}
ModuleExporter >> exportClass: aClassSpec [
	| filename |
	filename := self filenameForClass: aClassSpec.
	self withFileNamed: filename do: [:stream | | writer |
		stream truncate.
		writer := TonelWriter on: stream.
		writer
			category: self moduleName;
			class: aClassSpec;
			methods: (aClassSpec metaMethods sortBy: #selector)
				& (aClassSpec methods sortBy: #selector);
			write]]

{#category : #export}
ModuleExporter >> exportClasses [
	module classes do: [:class | self exportClass: class]]

{#category : #private}
ModuleExporter >> exportedName [
	^module name copy replace: Character space with: $\]

{#category : #export}
ModuleExporter >> exportEmptyClass: aClassSpec [
	| filename |
	filename := self filenameForClass: aClassSpec.
	self withFileNamed: filename do: [:stream | | writer |
		writer := TonelWriter on: stream.
		writer
			category: self moduleName;
			class: aClassSpec;
			methods: #();
			write]]

{#category : #export}
ModuleExporter >> exportEmptyClasses [
	module classes do: [:class | self exportEmptyClass: class]]

{#category : #export}
ModuleExporter >> exportExtendedClass: aClassSpec [
	| filename |
	filename := self filenameForExtension: aClassSpec.
	self withFileNamed: filename do: [:stream | 
		stream truncate.
		(TonelWriter on: stream)
			writeMethods: (aClassSpec metaMethods sortBy: #selector)
				& (aClassSpec methods sortBy: #selector)]]

{#category : #export}
ModuleExporter >> exportExtendedClasses [
	module extendedClasses do: [:class | self exportExtendedClass: class]]

{#category : #export}
ModuleExporter >> exportMetadata [
	| package |
	package := self moduleFolder \ 'package.st'.
	self withFileNamed: package do: [:stream | 
		stream nextPutAll: 'Package '.
		(STONWriter on: stream) writeMap: self definition]]

{#category : #services}
ModuleExporter >> exportPseudoTonel [
	compatible := false.
	self export]

{#category : #private}
ModuleExporter >> filenameForClass: aClassSpec [
	| name |
	name := aClassSpec name asFilename.
	compatible ifTrue: [name := name appendExtension: 'class'].
	^self moduleFolder \ name appendExtension: 'st']

{#category : #private}
ModuleExporter >> filenameForExtension: aClassSpec [
	| name |
	name := aClassSpec name asFilename.
	compatible ifTrue: [name := name appendExtension: 'extension'].
	^self moduleFolder \ name appendExtension: 'st']

{#category : #initialization}
ModuleExporter >> initialize [
	super initialize.
	path := Directory current asFilename.
	compatible := true]

{#category : #accessing}
ModuleExporter >> license [
	^'See (MIT) license in root directory.']

{#category : #accessing}
ModuleExporter >> module: aModuleSpec [
	module := aModuleSpec]

{#category : #private}
ModuleExporter >> moduleFolder [
	^path \ self exportedName]

{#category : #private}
ModuleExporter >> moduleName [
	^self exportedName asFilename entityName]

{#category : #accessing}
ModuleExporter >> path: aFilename [
	path := aFilename asFilename]

{#category : #private}
ModuleExporter >> withFileNamed: aFilename do: aBlock [
	| stream |
	stream := aFilename asFile writeStream.
	stream
		truncate;
		eol: String lf;
		nextPut: $";
		crtab;
		nextPutAll: self copyright;
		crtab;
		nextPutAll: self license;
		cr;
		nextPut: $";
		cr;
		cr.
	[aBlock evaluateWith: stream] ensure: [stream close]]

