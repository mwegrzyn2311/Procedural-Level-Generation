extends RigidBody2D
class_name MovableElement

@onready var sprite: Sprite2D = $Sprite2d

@onready var ray: RayCast2D = $MoveDirRayCast
@onready var gravity_ray: RayCast2D = $GravityRayCast
@onready var gravity_ray_right: RayCast2D = $GravityRayCastRight
@onready var gravity_ray_left: RayCast2D = $GravityRayCastLeft

@onready var slide_left_horiz_ray: RayCast2D = $SlideLeftRayCastHoriz
@onready var slide_left_vert_ray: RayCast2D = $SlideLeftRayCastVert
@onready var slide_right_horiz_ray: RayCast2D = $SlideRightRayCastHoriz
@onready var slide_right_vert_ray: RayCast2D = $SlideRightRayCastVert

@onready var explode_below_rays: Array = [$ExplodeEleBelowRayCastDown,
 $ExplodeEleBelowRayCastRight, $ExplodeEleBelowRayCastLeft]

@onready var collision_shape: CollisionShape2D = $TileCollision

var direction: Vector2 = Vector2.ZERO

var _pixels_per_second: float = CONSTANTS.ELE_SPEED_MULT * CONSTANTS.TILE_SIZE
var _step_size: float = 1 / _pixels_per_second

var _step: float = 0
var _pixels_moved: int = 0

func set_coords(coordinates: Vector2):
	self.position = (coordinates + Vector2(1, 1)) * CONSTANTS.TILE_SIZE

# FIXME: Find out why setting Gravity Scale in editor doesn't work
func _ready():
	self.gravity_scale = 0.0

func _physics_process(delta):
	if not is_moving():
		if !try_for_movement():
			return
	
	self._step += delta
	
	var steps: int = floor(self._step / self._step_size)
	if steps:
		self._step -= steps * self._step_size
		while steps > 0 and self._pixels_moved < CONSTANTS.TILE_SIZE:
			self._pixels_moved += 1
			steps -= 1
			move_and_collide(self.direction, false, 0.0)
			if self.direction == Vector2.DOWN:
				for explode_below_ray in explode_below_rays:
					if explode_below_ray.is_colliding():
						var collider = explode_below_ray.get_collider()
						if collider.is_in_group("explosive"):
							collider.explode()
		if self._pixels_moved == CONSTANTS.TILE_SIZE:
			self.direction = Vector2.ZERO
			self._pixels_moved = 0
			self._step = 0

func is_moving() -> bool:
	return self.direction != Vector2.ZERO

# Returns true if can move afterwards
func push(direction: Vector2) -> bool:
	# If is already in move, disallow pushing
	if self.direction != Vector2.ZERO:
		return false
		
	if self.is_moving() or self.try_for_gravity():
		return false
	
	ray.target_position = direction * CONSTANTS.TILE_SIZE
	ray.force_raycast_update()
	if ray.is_colliding():
		self.direction = Vector2.ZERO
		return false
	else:
		self.direction = direction
		return true
		
func try_for_movement() -> bool:
	if try_for_gravity():
		return true
	if try_for_slide():
		return true
	return false

# TODO: Because of smalled collision shapes, while something is pushed underneath, we need to make sure objects above don't start falling
func try_for_gravity() -> bool:
	if !gravity_ray.is_colliding() and !gravity_ray_left.is_colliding() and !gravity_ray_right.is_colliding():
		self.direction = Vector2.DOWN
		return true
	return false

func try_for_slide() -> bool:
	# It's needed because of smaller collision shapes and objects being pushed underneath
	if !gravity_ray.is_colliding():
		return false
	var ele_below = gravity_ray.get_collider()
	if !ele_below.is_in_group("movable"):
		return false
	
	if !slide_right_horiz_ray.is_colliding() and !slide_right_vert_ray.is_colliding():
		self.direction = Vector2.RIGHT
		return true
	elif !slide_left_horiz_ray.is_colliding() and !slide_left_vert_ray.is_colliding():
		self.direction = Vector2.LEFT
		return true
	else:
		return false
		
# object can't be eaten if in movement
func try_eat() -> bool:
	if self.is_moving() or self.try_for_gravity():
		return false
	else:
		eat()
		return true

func eat():
	self.collision_shape.disabled = true

func has_been_eaten():
	self.queue_free()
