class_name Scenes

enum SceneID {
	CUTSCENE_1,
	LEVEL_1_AREA_1,
	LEVEL_1_AREA_2,
	LEVEL_1_BOSS,
	CUTSCENE_2,
	LEVEL_2_AREA_1,
	LEVEL_2_AREA_2,
	LEVEL_2_BOSS,
	LEVEL_3_AREA_1,
	LEVEL_3_AREA_2,
	LEVEL_3_BOSS,
	CREDITS,
}

const SCENE_PATHS := {
	SceneID.CUTSCENE_1: preload("res://Scenes/Cutscenes/cutscene_1.tscn"),
	SceneID.LEVEL_1_AREA_1: preload("res://Scenes/Areas/level_1_area_1.tscn"),
	SceneID.LEVEL_1_AREA_2: preload("res://Scenes/Areas/level_1_area_2.tscn"),
	SceneID.LEVEL_1_BOSS: preload("res://Scenes/Areas/level_1_boss.tscn"),
	SceneID.CUTSCENE_2: preload("res://Scenes/Cutscenes/cutscene_2.tscn"),
	SceneID.LEVEL_2_AREA_1: preload("res://Scenes/Areas/level_2_area_1.tscn"),
	SceneID.LEVEL_2_AREA_2: preload("res://Scenes/Areas/level_2_area_2.tscn"),
	SceneID.LEVEL_2_BOSS: preload("res://Scenes/Areas/level_2_boss.tscn"),
	SceneID.LEVEL_3_AREA_1: preload("res://Scenes/Areas/level_3_area_1.tscn"),
	SceneID.LEVEL_3_AREA_2: preload("res://Scenes/Areas/level_3_area_2.tscn"),
	SceneID.LEVEL_3_BOSS: preload("res://Scenes/Areas/level_3_boss.tscn"),
	SceneID.CREDITS: preload("res://Scenes/Cutscenes/credits.tscn"),
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
	6: SceneID.LEVEL_2_AREA_1,
	7: SceneID.LEVEL_2_AREA_2,
	8: SceneID.LEVEL_2_BOSS,
	9: SceneID.LEVEL_3_AREA_1,
	10: SceneID.LEVEL_3_AREA_2,
	11: SceneID.LEVEL_3_BOSS,
	12: SceneID.CREDITS,
}

static func get_scene(scene_id: SceneID) -> PackedScene:
	return SCENE_PATHS.get(scene_id, null)
