extends StaticBody2D
class_name StaticElement

@onready var collision_shape: CollisionShape2D = $TileCollision
@onready var sprite: Sprite2D = $TileSprite

func set_coords(coordinates: Vector2):
	self.position = (coordinates + Vector2(1, 1)) * CONSTANTS.TILE_SIZE

# object can't be eaten if in movement
func try_eat() -> bool:
	eat()
	return true

func eat():
	self.collision_shape.disabled = true

func has_been_eaten():
	self.queue_free()
