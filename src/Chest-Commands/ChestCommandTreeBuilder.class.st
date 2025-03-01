"
Class that builds the group of Chest commands for the `SpCodePresenter` context menu.
"
Class {
	#name : #ChestCommandTreeBuilder,
	#superclass : #Object,
	#instVars : [
		'rootCommandGroup',
		'codePresenter'
	],
	#category : #'Chest-Commands'
}

{ #category : #accessing }
ChestCommandTreeBuilder class >> buildCommandsGroupWith: aCodePresenter forRoot: aRootCommandGroup [

	self new
		buildCommandsGroupWith: aCodePresenter
		forRoot: aRootCommandGroup
]

{ #category : #accessing }
ChestCommandTreeBuilder class >> displayStrategy [

	^ CmUIDisplayAsSubMenu
]

{ #category : #accessing }
ChestCommandTreeBuilder class >> groupDescription [

	^ 'Actions interacting with Chest'
]

{ #category : #accessing }
ChestCommandTreeBuilder class >> groupName [

	^ 'Chest'
]

{ #category : #building }
ChestCommandTreeBuilder >> buildAndRegisterGroup [

	"builds the group that will register under the provided root command group"

	| group |
	group := (CmCommandGroup named: self groupName) asSpecGroup.
	group description: self groupDescription.
	group displayStrategy: self displayStrategy.
	rootCommandGroup register: group.
	^ group
]

{ #category : #building }
ChestCommandTreeBuilder >> buildChestCommandGroup [

	self chestCommandClasses do: [ :commandClass |
		self group register:
			(self buildSpecCommand: commandClass forContext: codePresenter) ].
	self group register: self buildPasteLoadCodeGroup.
	self group beDisplayedAsGroup
]

{ #category : #building }
ChestCommandTreeBuilder >> buildCommandsGroupWith: aCodePresenter forRoot: aRootCommandGroup [

	codePresenter := aCodePresenter.
	rootCommandGroup := aRootCommandGroup.
	self buildChestCommandGroup
]

{ #category : #building }
ChestCommandTreeBuilder >> buildPasteLoadCodeGroup [

	| specGroup allChests subSpecGroup |
	specGroup := (CmCommandGroup forSpecNamed:
			              'Paste object from chest > ')
		             beDisplayedAsSubMenu;
		             yourself.
	allChests := Chest allChests.
	allChests do: [ :chest |
		subSpecGroup := CmCommandGroup forSpecNamed: chest name.
		specGroup register: subSpecGroup.
		chest contents keysDo: [ :key |
			subSpecGroup register: (ChestPasteLoadCodeCommand
					 forSpecContext: codePresenter
					 withChestName: chest name
					 withObjectName: key) ] ].

	^ specGroup
]

{ #category : #building }
ChestCommandTreeBuilder >> buildSpecCommand: commandClass forContext: aContext [

	^ commandClass forSpecContext: aContext
]

{ #category : #building }
ChestCommandTreeBuilder >> chestCommandClasses [

	^ {
		  ChestLoadObjectIntoCodeCommand.
		  ChestPasteLastObjectLoadCodeCommand } select: [ :each |
		  each isVisibleForContext: codePresenter ]
]

{ #category : #accessing }
ChestCommandTreeBuilder >> displayStrategy [

	^ self class displayStrategy new
]

{ #category : #accessing }
ChestCommandTreeBuilder >> group [

	^ rootCommandGroup
		  commandOrGroupNamed: self groupName
		  ifNone: [ self buildAndRegisterGroup ]
]

{ #category : #accessing }
ChestCommandTreeBuilder >> groupDescription [

	^ self class groupDescription
]

{ #category : #accessing }
ChestCommandTreeBuilder >> groupName [

	^ self class groupName
]
