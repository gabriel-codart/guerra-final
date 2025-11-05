class_name Scenes

enum SceneID {
	CUTSCENE_1,
	LEVEL_1_AREA_1,
	LEVEL_1_AREA_2,
	LEVEL_1_BOSS,
	CUTSCENE_2,
}

const SCENE_PATHS := {
	SceneID.CUTSCENE_1: preload("res://Scenes/Cutscenes/cutscene_1.tscn"),
	SceneID.LEVEL_1_AREA_1: preload("res://Scenes/Areas/level_1_area_1.tscn"),
	SceneID.LEVEL_1_AREA_2: preload("res://Scenes/Areas/level_1_area_2.tscn"),
	SceneID.LEVEL_1_BOSS: preload("res://Scenes/Areas/level_1_boss.tscn"),
	SceneID.CUTSCENE_2: preload("res://Scenes/Cutscenes/cutscene_2.tscn"),
}

enum Type {
	LevelCommon, LevelBoss
}

static var PROGRESS_SCENE_MAP := {
	1: SceneID.CUTSCENE_1,
	2: SceneID.LEVEL_1_AREA_1,
	3: SceneID.LEVEL_1_AREA_2,
	4: SceneID.LEVEL_1_BOSS,
	5: SceneID.CUTSCENE_2,
	#6: SceneID.LEVEL_5,
	#7: SceneID.CUTSCENE_2,
}

static func get_scene(scene_id: SceneID) -> PackedScene:
	return SCENE_PATHS.get(scene_id, null)
