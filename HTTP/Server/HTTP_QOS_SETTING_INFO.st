"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_QOS_SETTING_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_QOS_SETTING_INFO class >> aspects [
	^#(#QosType
		#QosSetting)]

{ #category : #private }
HTTP_QOS_SETTING_INFO class >> def [
	^<def>
	typedef struct _HTTP_QOS_SETTING_INFO {
		HTTP_QOS_SETTING_TYPE  QosType;
		PVOID                 QosSetting;
	} HTTP_QOS_SETTING_INFO, *PHTTP_QOS_SETTING_INFO;
	</def>]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forBandwidth [
	^self new forBandwidth]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forBandwidth: anInteger [
	^self new forBandwidth: anInteger]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forConnectionLimit [
	^self new forConnectionLimit]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forConnectionLimit: anInteger [
	^self new forConnectionLimit: anInteger]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forFlowRate [
	^self new forFlowRate]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forFlowRate: anInteger [
	^self new forFlowRate: anInteger]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forFlowRateBurstSize: anInteger [
	^self new forFlowRateBurstSize: anInteger]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forFlowRateMaxBandwidth: anInteger [
	^self new forFlowRateMaxBandwidth: anInteger]

{ #category : #'instance creation' }
HTTP_QOS_SETTING_INFO class >> forFlowRateMaxPeakBandwidth: anInteger [
	^self new forFlowRateMaxPeakBandwidth: anInteger]

{ #category : #initialization }
HTTP_QOS_SETTING_INFO class >> initializeConstants [
	self initializeQosTypeConstants]

{ #category : #initialization }
HTTP_QOS_SETTING_INFO class >> initializeQosTypeConstants [
	WinConstants
		at: 'HttpQosSettingTypeBandwidth' put: 0;
		at: 'HttpQosSettingTypeConnectionLimit' put: 1;
		at: 'HttpQosSettingTypeFlowRate' put: 2]

{ #category : #private }
HTTP_QOS_SETTING_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'QosType' put: 0;
		at: 'QosSetting' put: 8;
		yourself]

{ #category : #accessing }
HTTP_QOS_SETTING_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_QOS_SETTING_INFO class >> typedefTable [
	^HttpApiDLL typedefTable]

{ #category : #input }
HTTP_QOS_SETTING_INFO >> forBandwidth [
	self
		QosType: HttpQosSettingTypeBandwidth;
		QosSetting: HTTP_BANDWIDTH_LIMIT_INFO external]

{ #category : #input }
HTTP_QOS_SETTING_INFO >> forBandwidth: anInteger [
	| info |
	info := HTTP_BANDWIDTH_LIMIT_INFO external MaxBandwidth: anInteger.
	self QosType: HttpQosSettingTypeBandwidth; QosSetting: info]

{ #category : #input }
HTTP_QOS_SETTING_INFO >> forConnectionLimit [
	self
		QosType: HttpQosSettingTypeConnectionLimit;
		QosSetting: HTTP_CONNECTION_LIMIT_INFO external]

{ #category : #input }
HTTP_QOS_SETTING_INFO >> forConnectionLimit: anInteger [
	| info |
	info := HTTP_CONNECTION_LIMIT_INFO external MaxConnections: anInteger.
	self QosType: HttpQosSettingTypeConnectionLimit; QosSetting: info]

{ #category : #input }
HTTP_QOS_SETTING_INFO >> forFlowRate [
	self
		QosType: HttpQosSettingTypeFlowRate;
		QosSetting: HTTP_FLOWRATE_INFO external]

{ #category : #input }
HTTP_QOS_SETTING_INFO >> forFlowRateBurstSize: anInteger [
	| info |
	info := HTTP_FLOWRATE_INFO external BurstSize: anInteger.
	self QosType: HttpQosSettingTypeFlowRate; QosSetting: info]

{ #category : #input }
HTTP_QOS_SETTING_INFO >> forFlowRateMaxBandwidth: anInteger [
	| info |
	info := HTTP_FLOWRATE_INFO external MaxBandwidth: anInteger.
	self QosType: HttpQosSettingTypeFlowRate; QosSetting: info]

{ #category : #input }
HTTP_QOS_SETTING_INFO >> forFlowRateMaxPeakBandwidth: anInteger [
	| info |
	info := HTTP_FLOWRATE_INFO external MaxPeakBandwidth: anInteger.
	self QosType: HttpQosSettingTypeFlowRate; QosSetting: info]

{ #category : #accessing }
HTTP_QOS_SETTING_INFO >> QosSetting [
	^self pointerAtOffset: QosSetting]

{ #category : #output }
HTTP_QOS_SETTING_INFO >> qosSetting [
	| memory type |
	memory := self QosSetting.
	memory isValid ifFalse: [^nil].
	type := self QosType.
	type = HttpQosSettingTypeBandwidth
		ifTrue: [^HTTP_BANDWIDTH_LIMIT_INFO fromMemory: memory].
	type = HttpQosSettingTypeConnectionLimit
		ifTrue: [^HTTP_CONNECTION_LIMIT_INFO fromMemory: memory].
	type = HttpQosSettingTypeFlowRate
		ifTrue: [^HTTP_FLOWRATE_INFO fromMemory: memory].
	^nil]

{ #category : #accessing }
HTTP_QOS_SETTING_INFO >> QosSetting: anInteger [
	self pointerAtOffset: QosSetting put: anInteger]

{ #category : #accessing }
HTTP_QOS_SETTING_INFO >> QosType [
	^self uLongAtOffset: QosType]

{ #category : #accessing }
HTTP_QOS_SETTING_INFO >> QosType: anInteger [
	self uLongAtOffset: QosType put: anInteger]

