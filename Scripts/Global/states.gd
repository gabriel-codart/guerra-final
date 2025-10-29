class_name States

enum Protagonist {
	Idle, Run, Jump, Fall, Shot, Fall_Shot, Attack, Dead, Hurt
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
	Protagonist.Hurt: "hurt",
}

enum Enemy {
	Idle, Walk, Fall, Attack, Shot, Dead, Hurt, Special
}

const ENEMY_NAMES = {
	Enemy.Idle: "idle",
	Enemy.Walk: "walk",
	Enemy.Fall: "fall",
	Enemy.Attack: "attack",
	Enemy.Shot: "shot",
	Enemy.Dead: "dead",
	Enemy.Hurt: "hurt",
	Enemy.Special: "special",
}
