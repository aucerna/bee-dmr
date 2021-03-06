"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #ProjectChanges,
	#requires : [
		'bdev',
		'bdevgui',
		'CodeLibraryBuilder',
		'CommonControls',
		'Compiler',
		'SKernel',
		'Smalltalk Browsers',
		'SourceCodeQA',
		'WindowsSystem'
	],
	#classes : [
		'ActionDefinition',
		'BeeProjectDefinition',
		'BindActionDefinition',
		'BrokenChange',
		'CategoryAddition',
		'CategoryChange',
		'CategoryMove',
		'CategoryRemoval',
		'CategoryRename',
		'CategoryReorganization',
		'ChangeHeaderSpec',
		'ChangeLogPreamble',
		'ChangeRecord',
		'Changeset',
		'ClassAddition',
		'ClassChange',
		'ClassCommentDefinition',
		'ClassDefinition',
		'ClassDuplicate',
		'ClassForget',
		'ClassRedefinition',
		'ClassReinstall',
		'ClassRemoval',
		'ClassRename',
		'ClassVariableAddition',
		'ClassVariableChange',
		'ClassVariableMoveDown',
		'ClassVariableMoveUp',
		'ClassVariableRemoval',
		'ClassVariableRename',
		'ClusterChange',
		'ClusterDefinition',
		'CommentRecord',
		'ExpressionEvaluation',
		'GlobalAddition',
		'GlobalChange',
		'GlobalForget',
		'GlobalRename',
		'InstanceVariableAddition',
		'InstanceVariableChange',
		'InstanceVariableInsertion',
		'InstanceVariableMoveDown',
		'InstanceVariableMoveUp',
		'InstanceVariableRemoval',
		'InstanceVariableRename',
		'MethodAddition',
		'MethodChange',
		'MethodDefinition',
		'MethodForget',
		'MethodInstallation',
		'MethodRecompilation',
		'MethodRemoval',
		'ModuleAlreadyExistsException',
		'OverriddenMethodDefinition',
		'PoolDictionaryAddition',
		'PoolVariableAddition',
		'PrerequisitesDefinition',
		'ProjectAddition',
		'ProjectChange',
		'ProjectChanges',
		'ProjectDefinition',
		'ProjectDescriptionDefinition',
		'ProjectForget',
		'ProjectRename',
		'ProjectRenamed',
		'ProjectSettingDefinition',
		'SelectorClassification',
		'SelectorRename',
		'SharedPoolAddition',
		'SharedPoolRemoval',
		'SuperclassDefinition',
		'TestCollector',
		'UnbindActionDefinition',
		'VariableChange'
	]
}

