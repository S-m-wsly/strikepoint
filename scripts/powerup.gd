extends Area3D
class_name StrikePowerup

enum Kind { HEALTH, SPEED, DAMAGE, ARMOR, ABILITY }
var kind := Kind.HEALTH
var active := true
var respawn_time := 20.0

func setup(k: int):
    kind = k
    monitoring = true
    var mesh = MeshInstance3D.new()
    var sphere = SphereMesh.new()
    sphere.radius = 0.45
    sphere.height = 0.9
    mesh.mesh = sphere
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color("#b52dff")
    mat.emission_enabled = true
    mat.emission = Color("#d05cff")
    mat.emission_energy_multiplier = 3.0
    mesh.material_override = mat
    add_child(mesh)
    var shape = CollisionShape3D.new()
    var sphere_shape = SphereShape3D.new()
    sphere_shape.radius = 1.0
    shape.shape = sphere_shape
    add_child(shape)
    body_entered.connect(_on_body_entered)

func _on_body_entered(body):
    if not active or not body is StrikeCharacter:
        return
    active = false
    if kind == Kind.HEALTH:
        body.heal(body.stats.health * 0.30)
    elif kind == Kind.SPEED:
        body.stats.speed *= 1.2
        await get_tree().create_timer(8.0).timeout
        if is_instance_valid(body):
            body.stats.speed /= 1.2
    elif kind == Kind.DAMAGE:
        body.stats.damage *= 1.2
        await get_tree().create_timer(8.0).timeout
        if is_instance_valid(body):
            body.stats.damage /= 1.2
    elif kind == Kind.ABILITY:
        body.cooldowns = [0.0, 0.0, 0.0]
    visible = false
    await get_tree().create_timer(respawn_time).timeout
    active = true
    visible = true
