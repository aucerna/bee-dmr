"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleImporterTest, 
	#superclass : #TestCase, 
	#category : #Porting
}

{#category : #all}
ModuleImporterTest >> testBasicImport [
	| path builder module exporter directory importer imported |
	path := Directory scratchDir.
	builder := BeeModuleBuilder new.
	builder addClass: Point.
	module := builder module.
	module name: 'MyModule'.
	exporter := ModuleExporter new.
	directory := (path \ 'MyModule') asDirectory.
	directory exists ifTrue: [directory asFilename removeDirectory].
	exporter path: path; module: module; exportPseudoTonel.
	self
		assert: directory exists;
		assert: (directory entityNamed: 'Point.st') notNil;
		assert: (directory entityNamed: 'package.st') notNil.
	importer := ModuleImporter new.
	importer path: directory; import.
	imported := importer module.
	self assert: imported name = module name]

{#category : #all}
ModuleImporterTest >> testImportExtension [
	| path builder module exporter directory importer imported classes class |
	path := Directory scratchDir.
	builder := BeeModuleBuilder new.
	builder addMethod: ModuleImporterTest >> #testImportExtension.
	module := builder module.
	module name: 'MyModule'.
	exporter := ModuleExporter new.
	directory := (path \ 'MyModule') asDirectory.
	directory exists ifTrue: [directory asFilename removeDirectory].
	exporter path: path; module: module; exportPseudoTonel.
	self
		assert: directory exists;
		assert: (directory entityNamed: 'ModuleImporterTest.st') notNil;
		assert: (directory entityNamed: 'package.st') notNil.
	importer := ModuleImporter new.
	importer path: directory; import.
	imported := importer module.
	classes := imported extendedClasses.
	self assert: classes size = 1.
	class := classes anyone.
	self
		assert: class name asString = 'ModuleImporterTest';
		assert: class methods size = 1;
		assert: class methods anyone selector == #testImportExtension]

