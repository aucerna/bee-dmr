"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleImporter, 
	#superclass : #Object, 
	#instVars : [
		'module', 
		'path', 
		'metadata'
	], 
	#category : #Porting
}

{#category : #'instance creation'}
ModuleImporter class >> new [
	^super new initialize]

{#category : #import}
ModuleImporter >> import [
	self importMetadata; importClasses; importExtendedClasses]

{#category : #import}
ModuleImporter >> importClass: aString [
	| filename reader definition pointers variable class metasclass stream |
	filename := path \ aString withExtension: 'st'.
	filename exists ifFalse: [
		filename := path \ aString withFullExtension: 'class.st'.
		filename exists
			ifFalse: [self error: 'Cannot find file for class ' , aString]].
	stream := filename asFile readStream.
	reader := TonelReader on: stream.
	[reader read] ensure: [stream close].
	definition := reader definition.
	variable := pointers := true.
	definition at: #type ifPresent: [:type | 
		variable := true.
		type = #bytes ifTrue: [pointers := false]].
	class := ClassSpec new
		module: module;
		name: (definition at: #name) asString;
		supername: (definition at: #superclass ifAbsent: nil) asString;
		ivars: (definition at: #instVars ifAbsent: #());
		cvarNames: (definition at: #classVars ifAbsent: #());
		sharedPools: (definition at: #pools ifAbsent: #());
		isVariable: variable;
		isPointers: pointers.
	metasclass := MetaclassSpec new
		module: module;
		instanceClass: class;
		ivars: (definition at: #classInstVars ifAbsent: #()).
	class metaclass: metasclass.
	module addClass: class.
	reader methods do: [:m | self importMethod: m]]

{#category : #import}
ModuleImporter >> importClasses [
	(metadata at: #classes) do: [:name | self importClass: name]]

{#category : #import}
ModuleImporter >> importExtendedClass: aString [
	| filename stream reader definition class metaclass |
	filename := path \ aString withExtension: 'st'.
	filename exists ifFalse: [
		filename := path \ aString withFullExtension: 'extension.st'.
		filename exists
			ifFalse: [self error: 'Cannot find file for extended class ' , aString]].
	stream := filename asFile readStream.
	reader := TonelReader on: stream.
	[reader read] ensure: [stream close].
	definition := reader definition.
	class := ClassSpec new
		module: module;
		name: (definition at: #name) asString.
	metaclass := MetaclassSpec new module: module; instanceClass: class.
	class metaclass: metaclass.
	module addClassExtension: class.
	reader methods do: [:m | self importMethod: m]]

{#category : #import}
ModuleImporter >> importExtendedClasses [
	| classes filenames candidates |
	classes := metadata at: #classes.
	filenames := path asDirectory fileNamesWithExtension: 'st'.
	candidates := filenames collect: [:s | s asFilename fileNameOnly].
	candidates := candidates
		reject: [:n | n = 'package' or: [classes includes: n]].
	candidates do: [:n | self importExtendedClass: n]]

{#category : #import}
ModuleImporter >> importMetadata [
	| stream name |
	stream := (path \ 'package.st') asFile readStream.
	stream throughAll: 'Package '.
	metadata := (STONReader on: stream) parseMap.
	name := (metadata at: #name) replace: $- with: Character space.
	module name: name asString]

{#category : #import}
ModuleImporter >> importMethod: aDictionary [
	| classname selector category class signature body source method |
	classname := aDictionary at: #class.
	selector := aDictionary at: #selector.
	category := aDictionary at: #category.
	class := module resolveClass: classname.
	class isNil ifTrue: [
		self
			error: 'Cannot find class for method ' , classname , ' >> #'
				, selector asString].
	signature := aDictionary at: #signature.
	body := aDictionary at: #body.
	source := signature dosToUnix unixToMac , String cr
		, body dosToUnix unixToMac.
	method := MethodSpec new
		module: module;
		classBinding: class;
		selector: selector;
		category: category;
		source: source.
	class addMethod: method]

{#category : #initialization}
ModuleImporter >> initialize [
	super initialize.
	module := ModuleSpec new]

{#category : #accessing}
ModuleImporter >> module [
	^module]

{#category : #accessing}
ModuleImporter >> module: aModuleSpec [
	module := aModuleSpec]

{#category : #accessing}
ModuleImporter >> path: aFilename [
	path := aFilename]

