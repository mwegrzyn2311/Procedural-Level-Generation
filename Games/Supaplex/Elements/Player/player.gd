extends CharacterBody2D
class_name Player

@onready var ray: RayCast2D = $MoveDirRayCast
@onready var falling_objects_ray: RayCast2D = $FallingObjectsRayCast

var direction: Vector2 = Vector2.ZERO

var _pixels_per_second: float = CONSTANTS.ELE_SPEED_MULT * CONSTANTS.TILE_SIZE
var _step_size: float = 1 / _pixels_per_second

var _step: float = 0
var _pixels_moved: int = 0

func set_coords(coordinates: Vector2):
	self.position = (coordinates + Vector2(1, 1)) * CONSTANTS.TILE_SIZE

func _physics_process(delta):
	if not is_moving():
		if not self.move():
			return

	self._step += delta
	
	var steps: int = floor(self._step / self._step_size)
	if steps:
		self._step -= steps * self._step_size
		while steps > 0 and _pixels_moved < CONSTANTS.TILE_SIZE:
			self._pixels_moved += 1
			steps -= 1
			move_and_collide(self.direction, false, 0.0)
		if self._pixels_moved == CONSTANTS.TILE_SIZE:
			self.direction = Vector2.ZERO
			self._pixels_moved = 0
			self._step = 0

func is_moving() -> bool:
	return self.direction != Vector2.ZERO

# Returns true if can move afterwards
func move() -> bool:
	self.set_move_dir_from_input()
	
	if self.direction == Vector2.ZERO:
		return false
	
	ray.target_position = self.direction * CONSTANTS.TILE_SIZE
	ray.force_raycast_update()
	falling_objects_ray.target_position.x = self.direction.x * CONSTANTS.TILE_SIZE
	falling_objects_ray.force_raycast_update()
	# FIXME: Something is wrong here
	if falling_objects_ray.is_colliding():
		var collider = falling_objects_ray.get_collider()
		if collider.is_in_group("movable") and (collider.is_moving()):
			self.direction = Vector2.ZERO
			return false
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("eatable"):
			if collider.eat():
				return true
		elif collider.is_in_group("movable"):
			if collider.push(self.direction):
				return true
			else:
				self.direction = Vector2.ZERO
				return false
		else:
			self.direction = Vector2.ZERO
			return false
	else:
		return true

func set_move_dir_from_input():
	self.direction.x = Input.get_axis("ui_left", "ui_right")
	if self.direction == Vector2.ZERO:
			self.direction.y = Input.get_axis("ui_up", "ui_down")
	
