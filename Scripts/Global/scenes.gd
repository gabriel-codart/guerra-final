class_name Scenes

enum SceneID {
	CUTSCENE_1,
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
	CUTSCENE_2,
}

const SCENE_PATHS := {
	SceneID.CUTSCENE_1: preload("res://Scenes/Cutscenes/cutscene_1.tscn"),
	SceneID.LEVEL_1: preload("res://Scenes/Areas/level_1.tscn"),
	SceneID.LEVEL_2: preload("res://Scenes/Areas/level_2.tscn"),
	SceneID.LEVEL_3: preload("res://Scenes/Areas/level_3.tscn"),
	SceneID.LEVEL_4: preload("res://Scenes/Areas/level_4.tscn"),
	SceneID.LEVEL_5: preload("res://Scenes/Areas/level_5.tscn"),
	SceneID.CUTSCENE_2: preload("res://Scenes/Cutscenes/cutscene_2.tscn"),
}

enum Type {
	LevelCommon, LevelBoss
}

static var PROGRESS_SCENE_MAP := {
	1: SceneID.CUTSCENE_1,
	2: SceneID.LEVEL_1,
	3: SceneID.LEVEL_2,
	4: SceneID.LEVEL_3,
	5: SceneID.LEVEL_4,
	6: SceneID.LEVEL_5,
	7: SceneID.CUTSCENE_2,
}

static func get_scene(scene_id: SceneID) -> PackedScene:
	return SCENE_PATHS.get(scene_id, null)
