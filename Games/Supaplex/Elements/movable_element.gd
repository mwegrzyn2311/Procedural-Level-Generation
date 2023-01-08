extends RigidBody2D
class_name MovableElement

@onready var sprite: Sprite2D = $TileSprite

@onready var ray: RayCast2D = $MoveDirRayCast
@onready var gravity_ray: RayCast2D = $GravityRayCast
@onready var gravity_ray_right: RayCast2D = $GravityRayCastRight
@onready var gravity_ray_left: RayCast2D = $GravityRayCastLeft

@onready var gravity_rays: Array = [gravity_ray, $GravityRayCastRight,
 $GravityRayCastLeft, $GravityRayCastEnsureSlowerFall,
 $GravityRayCastRightEnsureSlowerFall, $GravityRayCastLeftEnsureSlowerFall
]


@onready var slide_right_rays = [$SlideRightRayCastHoriz, 
$SlideRightRayCastHorizUp, $SlideRightRayCastVert]
@onready var slide_left_rays: Array = [$SlideLeftRayCastHoriz, 
$SlideLeftRayCastHorizUp, $SlideLeftRayCastVert]

@onready var explode_below_rays: Array = [$ExplodeEleBelowRayCastDown,
 $ExplodeEleBelowRayCastRight, $ExplodeEleBelowRayCastLeft]

@onready var collision_shape: CollisionShape2D = $TileCollision

var direction: Vector2 = Vector2.ZERO

var _pixels_per_second: float = SUPAPLEX_CONSTANTS.ELE_SPEED_MULT * SUPAPLEX_CONSTANTS.TILE_SIZE
var _step_size: float = 1 / _pixels_per_second

var _step: float = 0
var _pixels_moved: int = 0

func set_coords(coordinates: Vector2):
	self.position = (coordinates + Vector2(1, 1)) * SUPAPLEX_CONSTANTS.TILE_SIZE

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
		while steps > 0 and self._pixels_moved < SUPAPLEX_CONSTANTS.TILE_SIZE:
			self._pixels_moved += 1
			steps -= 1
			move_and_collide(self.direction, false, 0.0)
			if self.direction == Vector2.DOWN:
				for explode_below_ray in explode_below_rays:
					if explode_below_ray.is_colliding():
						var collider = explode_below_ray.get_collider()
						if collider.is_in_group("explosive"):
							collider.explode()
		if self._pixels_moved == SUPAPLEX_CONSTANTS.TILE_SIZE:
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
		
	# We cannot push something that is moving or when nothing is underneath
	if self.is_moving() or !gravity_ray.is_colliding():
		return false
	
	ray.target_position = direction * SUPAPLEX_CONSTANTS.TILE_SIZE
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
	if !are_rays_colliding(gravity_rays):
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
	
	if ele_below.is_moving() or ele_below.try_for_movement():
		return false
	
	if !are_rays_colliding(slide_right_rays):
		self.direction = Vector2.RIGHT
		return true
	elif !are_rays_colliding(slide_left_rays):
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

# Util part: Consider moving to an external file
func are_rays_colliding(rays: Array) -> bool:
	return rays.filter(is_ray_colliding).size() != 0

func is_ray_colliding(ray: RayCast2D) -> bool:
	return ray.is_colliding()
