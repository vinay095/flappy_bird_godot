extends CharacterBody2D


class_name Player


const H_SPEED: float = 100.0
const V_SPEED: float = 350.0
const GRAVITY: float = 1000.0
const TILT_ANGLE: float = 0.05
const START_POS: Vector2 = Vector2(70.0, 205.0)


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var fly_sound: AudioStreamPlayer
var die_sound: AudioStreamPlayer
var hit_sound: AudioStreamPlayer

var has_hit_pipe: bool = false
var has_hit_ground: bool = false

signal died


var dead: bool = false
var active: bool = false


func _ready() -> void:
	fly_sound = AudioStreamPlayer.new()
	fly_sound.stream = preload("res://audio/flappy-bird-fly.mp3")
	add_child(fly_sound)
	
	die_sound = AudioStreamPlayer.new()
	die_sound.stream = preload("res://audio/sfx_die.mp3")
	add_child(die_sound)
	
	hit_sound = AudioStreamPlayer.new()
	hit_sound.stream = preload("res://audio/sfx_hit.wav")
	add_child(hit_sound)

	velocity.x = H_SPEED
	position = START_POS


func _physics_process(delta: float) -> void:
	if active:
		if not is_on_floor():
			velocity.y += GRAVITY * delta
		
		if is_on_floor() or is_on_ceiling():
			if not has_hit_ground:
				has_hit_ground = true
				if is_on_floor():
					die_sound.play()
			die()
		
		if Input.is_action_just_pressed("action") and not dead:
			velocity.y = -V_SPEED
			fly_sound.play()
		
		sprite.rotation_degrees = velocity.y * TILT_ANGLE
	
	move_and_slide()


func hit_pipe() -> void:
	if not has_hit_pipe:
		has_hit_pipe = true
		hit_sound.play()
	die()


func die() -> void:
	if dead:
		return
	
	dead = true
	velocity.x = 0
	velocity.y = 0
	sprite.stop()
	died.emit()


func activate() -> void:
	active = true
	velocity.y = -V_SPEED


func reset() -> void:
	position = START_POS
	active = false
	dead = false
	has_hit_pipe = false
	has_hit_ground = false
	velocity.x = H_SPEED
	sprite.play("fly")
