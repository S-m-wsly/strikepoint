extends CharacterBody3D
class_name StrikeCharacter

var character_id := "kael"
var team := "BLUE"
var stats: Dictionary
var hp := 100.0
var level := 1
var xp := 0.0
var spawn_invulnerable := 0.0
var cooldowns := [0.0, 0.0, 0.0]
var attack_cooldown := 0.0
var target: Node3D
var is_ai := true
var display_name := "KAEL"
var virtual_move := Vector2.ZERO
var virtual_attack := false

func setup(id: String, team_id: String, ai := true):
    character_id = id
    team = team_id
    is_ai = ai
    display_name = id.to_upper()
    stats = GameBalance.character_stats(character_id)
    hp = stats.health
    _build_body()

func _build_body():
    var body_mesh = MeshInstance3D.new()
    var capsule = CapsuleMesh.new()
    capsule.height = 1.8
    capsule.radius = 0.45
    body_mesh.mesh = capsule
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color("#2d8cff") if team == "BLUE" else Color("#ef3340")
    mat.emission_enabled = true
    mat.emission = mat.albedo_color * 0.18
    body_mesh.material_override = mat
    add_child(body_mesh)
    var collider = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()
    shape.height = 1.8
    shape.radius = 0.45
    collider.shape = shape
    add_child(collider)

func _physics_process(delta):
    if spawn_invulnerable > 0.0:
        spawn_invulnerable -= delta
    attack_cooldown = max(0.0, attack_cooldown - delta)
    for i in 3:
        cooldowns[i] = max(0.0, cooldowns[i] - delta)

    if is_ai:
        _ai_tick(delta)
    else:
        _player_tick()

    velocity.y = 0.0
    if velocity.length() > 0.01:
        move_and_slide()

func _player_tick():
    var keyboard_move := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var input_move := keyboard_move if keyboard_move.length() > 0.05 else virtual_move
    if input_move.length() > 0.05:
        velocity = Vector3(input_move.x, 0, input_move.y).normalized() * stats.speed
        target = _find_target()
    else:
        velocity = Vector3.ZERO
    if Input.is_action_just_pressed("attack") or virtual_attack:
        virtual_attack = false
        basic_attack(target)
    if Input.is_action_just_pressed("ability_1"):
        use_ability(0)
    if Input.is_action_just_pressed("ability_2"):
        use_ability(1)
    if Input.is_action_just_pressed("ability_3"):
        use_ability(2)

func _ai_tick(_delta):
    if not is_instance_valid(target):
        target = _find_target()
    if not is_instance_valid(target):
        velocity = Vector3.ZERO
        return

    var dist = global_position.distance_to(target.global_position)
    var direction = (target.global_position - global_position)
    direction.y = 0
    direction = direction.normalized()

    if dist > 5.5:
        velocity = direction * stats.speed
    else:
        velocity = Vector3.ZERO
        if attack_cooldown <= 0:
            basic_attack(target)

func _find_target():
    var best = null
    var best_dist = INF
    for node in get_tree().get_nodes_in_group("combat_targets"):
        if node == self:
            continue
        if "team" in node and node.team == team:
            continue
        if node is Node3D:
            var d = global_position.distance_to(node.global_position)
            if d < best_dist:
                best = node
                best_dist = d
    return best

func basic_attack(victim: Node):
    if attack_cooldown > 0:
        return
    attack_cooldown = 0.65
    if is_instance_valid(victim) and victim.has_method("take_damage"):
        victim.take_damage(stats.damage, self)

func use_ability(index: int):
    if index < 0 or index > 2 or cooldowns[index] > 0:
        return
    cooldowns[index] = [7.0, 10.0, 14.0][index]
    var radius = [4.0, 5.0, 6.0][index]
    var multiplier = [1.4, 1.0, 1.8][index]
    for node in get_tree().get_nodes_in_group("combat_targets"):
        if node == self:
            continue
        if "team" in node and node.team != team and global_position.distance_to(node.global_position) <= radius:
            if node.has_method("take_damage"):
                node.take_damage(stats.damage * multiplier, self)

func take_damage(amount: float, source: Node = null):
    if spawn_invulnerable > 0.0:
        return
    hp -= amount
    if hp <= 0:
        _die(source)

func heal(amount: float):
    hp = min(stats.health, hp + amount)

func add_xp(amount: float):
    xp += amount
    if xp >= 100 and level < 3:
        xp -= 100
        level += 1
        stats.health *= 1.05
        stats.damage *= 1.05
        hp = stats.health

func _die(killer):
    var match = get_tree().get_first_node_in_group("match_manager")
    if match:
        match.register_kill(killer, self)
    visible = false
    set_physics_process(false)
    await get_tree().create_timer(GameBalance.RESPAWN_TIME).timeout
    if is_inside_tree():
        var spawn = get_tree().get_first_node_in_group("spawn_" + team.to_lower())
        if spawn:
            global_position = spawn.global_position
        hp = stats.health
        visible = true
        set_physics_process(true)
        spawn_invulnerable = GameBalance.SPAWN_PROTECTION
