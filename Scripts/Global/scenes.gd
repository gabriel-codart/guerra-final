class_name Scenes

enum SceneID {
	CUTSCENE_1,
	LEVEL_1_AREA_1,
	LEVEL_1_AREA_2,
	LEVEL_1_BOSS,
	CUTSCENE_2,
	CUTSCENE_3,
	LEVEL_2_AREA_1,
	LEVEL_2_AREA_2,
	LEVEL_2_BOSS,
	CUTSCENE_4,
	LEVEL_3_AREA_1,
	LEVEL_3_AREA_2,
	LEVEL_3_BOSS,
	CUTSCENE_5,
	LEVEL_4_AREA_1,
	LEVEL_4_AREA_2,
	CUTSCENE_6,
	CUTSCENE_7,
	CREDITS,
}

const SCENE_PATHS := {
	SceneID.CUTSCENE_1: preload("res://Scenes/Cutscenes/cutscene_1.tscn"),
	SceneID.LEVEL_1_AREA_1: preload("res://Scenes/Areas/level_1_area_1.tscn"),
	SceneID.LEVEL_1_AREA_2: preload("res://Scenes/Areas/level_1_area_2.tscn"),
	SceneID.LEVEL_1_BOSS: preload("res://Scenes/Areas/level_1_boss.tscn"),
	SceneID.CUTSCENE_2: preload("res://Scenes/Cutscenes/cutscene_2.tscn"),
	SceneID.CUTSCENE_3: preload("res://Scenes/Cutscenes/cutscene_3.tscn"),
	SceneID.LEVEL_2_AREA_1: preload("res://Scenes/Areas/level_2_area_1.tscn"),
	SceneID.LEVEL_2_AREA_2: preload("res://Scenes/Areas/level_2_area_2.tscn"),
	SceneID.LEVEL_2_BOSS: preload("res://Scenes/Areas/level_2_boss.tscn"),
	SceneID.CUTSCENE_4: preload("res://Scenes/Cutscenes/cutscene_4.tscn"),
	SceneID.LEVEL_3_AREA_1: preload("res://Scenes/Areas/level_3_area_1.tscn"),
	SceneID.LEVEL_3_AREA_2: preload("res://Scenes/Areas/level_3_area_2.tscn"),
	SceneID.LEVEL_3_BOSS: preload("res://Scenes/Areas/level_3_boss.tscn"),
	SceneID.CUTSCENE_5: preload("res://Scenes/Cutscenes/cutscene_5.tscn"),
	SceneID.LEVEL_4_AREA_1: preload("res://Scenes/Areas/level_4_area_1.tscn"),
	SceneID.LEVEL_4_AREA_2: preload("res://Scenes/Areas/level_4_area_2.tscn"),
	SceneID.CUTSCENE_6: preload("res://Scenes/Cutscenes/cutscene_6.tscn"),
	SceneID.CUTSCENE_7: preload("res://Scenes/Cutscenes/cutscene_7.tscn"),
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
	6: SceneID.CUTSCENE_3,
	7: SceneID.LEVEL_2_AREA_1,
	8: SceneID.LEVEL_2_AREA_2,
	9: SceneID.LEVEL_2_BOSS,
	10: SceneID.CUTSCENE_4,
	11: SceneID.LEVEL_3_AREA_1,
	12: SceneID.LEVEL_3_AREA_2,
	13: SceneID.LEVEL_3_BOSS,
	14: SceneID.CUTSCENE_5,
	15: SceneID.LEVEL_4_AREA_1,
	16: SceneID.LEVEL_4_AREA_2,
	17: SceneID.CUTSCENE_6,
	18: SceneID.CUTSCENE_7,
	19: SceneID.CREDITS,
}

static func get_scene(scene_id: SceneID) -> PackedScene:
	return SCENE_PATHS.get(scene_id, null)
