class_name Scenes

enum SceneID {
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
}

const SCENE_PATHS := {
	SceneID.LEVEL_1: preload("res://Scenes/Areas/level_1.tscn"),
	SceneID.LEVEL_2: preload("res://Scenes/Areas/level_2.tscn"),
	SceneID.LEVEL_3: preload("res://Scenes/Areas/level_3.tscn"),
	SceneID.LEVEL_4: preload("res://Scenes/Areas/level_4.tscn"),
	SceneID.LEVEL_5: preload("res://Scenes/Areas/level_5.tscn"),
}

static func get_scene(scene_id: SceneID) -> PackedScene:
	return SCENE_PATHS.get(scene_id, null)
