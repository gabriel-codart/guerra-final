class_name States

enum Protagonist {
	Idle, Run, Jump, Fall, Shot, Fall_Shot, Attack, Dead
}

const PROTAGONIST_NAMES = {
	Protagonist.Idle: "idle",
	Protagonist.Run: "run",
	Protagonist.Jump: "jump",
	Protagonist.Fall: "fall",
	Protagonist.Shot: "shot",
	Protagonist.Fall_Shot: "fall_shot",
	Protagonist.Attack: "attack",
	Protagonist.Dead: "dead",
}

enum Enemy {
	Idle, Walk, Attack, Shot, Dead
}

const ENEMY_NAMES = {
	Enemy.Idle: "idle",
	Enemy.Walk: "walk",
	Enemy.Attack: "attack",
	Enemy.Shot: "shot",
	Enemy.Dead: "dead",
}
