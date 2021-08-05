"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Package {
	#name : #Porting, 
	#requires : [
		'BeeProjects', 
		'CodeSpecs', 
		'Kernel', 
		'ProjectChanges', 
		'STON', 
		'Tonel'
	], 
	#classes : [
		'BeeModuleBuilder', 
		'ClassRemoveRule', 
		'ConversionRule', 
		'IdentifierRenameRule', 
		'MethodFilterRule', 
		'ModuleExporter', 
		'ModuleImporter', 
		'ModuleImporterTest', 
		'ModuleTransliterator', 
		'ModuleTransliteratorTest', 
		'PackageRemoveRule', 
		'PackageRenameRule', 
		'RefactoringRule', 
		'RejectMethodRule', 
		'RemoveInstVarRule', 
		'SelectorRenameRule', 
		'TransliterationRule', 
		'TransliterationScope'
	]
}