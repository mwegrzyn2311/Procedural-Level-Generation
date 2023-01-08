extends CharacterBody2D
class_name Player

@onready var ray: RayCast2D = $MoveDirRayCast
@onready var falling_objects_rays: Array = [$FallingObjectsRayCastUp, $FallingObjectsRayCastDown]

var direction: Vector2 = Vector2.ZERO

var _pixels_per_second: float = SUPAPLEX_CONSTANTS.ELE_SPEED_MULT * SUPAPLEX_CONSTANTS.TILE_SIZE
var _step_size: float = 1 / _pixels_per_second

var _step: float = 0
var _pixels_moved: int = 0

var eaten_ele: MovableElement = null

func set_coords(coordinates: Vector2):
	self.position = (coordinates + Vector2(1, 1)) * SUPAPLEX_CONSTANTS.TILE_SIZE

func _physics_process(delta):
	if not is_moving():
		if not self.move():
			return

	self._step += delta
	
	var steps: int = floor(self._step / self._step_size)
	if steps:
		self._step -= steps * self._step_size
		while steps > 0 and _pixels_moved < SUPAPLEX_CONSTANTS.TILE_SIZE:
			self._pixels_moved += 1
			steps -= 1
			move_and_collide(self.direction, false, 0.0)
			eat_one_pixel()
		if self._pixels_moved == SUPAPLEX_CONSTANTS.TILE_SIZE:
			if eaten_ele != null:
				eaten_ele.has_been_eaten()
				eaten_ele = null
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
	
	# Update ray casts
	ray.target_position = self.direction * SUPAPLEX_CONSTANTS.TILE_SIZE
	ray.force_raycast_update()
	for falling_objects_ray in falling_objects_rays:
		falling_objects_ray.target_position.x = self.direction.x * SUPAPLEX_CONSTANTS.TILE_SIZE
		falling_objects_ray.force_raycast_update()
	
	# Check if player is trying to move to a place which is gonna be or still is occupied by a falling object
	for falling_objects_ray in falling_objects_rays:
		if falling_objects_ray.is_colliding():
			var collider = falling_objects_ray.get_collider()
			if collider.is_in_group("movable") and (collider.is_moving() or collider.try_for_movement()):
				self.direction = Vector2.ZERO
				return false
	
	# Check if player is trying to move to an occupied field
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("exit"):
			collider.try_exit()
		
		if collider.is_in_group("eatable"):
			if collider.try_eat():
				eaten_ele = collider
				return true
			else:
				self.direction = Vector2.ZERO
				return false
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

#TODO: Implement
func explode():
	print(self._pixels_moved)
	print("player explodes")

func eat_one_pixel():
	if eaten_ele == null:
		return
	
	eaten_ele.sprite.position += self.direction/2
	eaten_ele.sprite.region_rect.size -= self.direction.abs()
	if self.direction.abs() == self.direction:
		eaten_ele.sprite.region_rect.position += self.direction
	
