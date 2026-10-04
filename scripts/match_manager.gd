extends Node
class_name MatchManager

var time_left := GameBalance.MATCH_DURATION
var blue_score := 0
var red_score := 0
var blue_targets_destroyed := 0
var red_targets_destroyed := 0
var finished := false
var blue_main_unlocked := false
var red_main_unlocked := false

signal hud_changed
signal announcement(text)
signal match_finished(winner)

func _ready():
    add_to_group("match_manager")

func _process(delta):
    if finished:
        return
    time_left -= delta
    hud_changed.emit()
    if time_left <= 0:
        time_left = 0
        _finish_by_score()

func register_kill(killer, victim):
    if not is_instance_valid(killer):
        return
    if killer is StrikeCharacter:
        if killer.team == "BLUE":
            blue_score += GameBalance.KILL_POINTS
        else:
            red_score += GameBalance.KILL_POINTS
        killer.add_xp(35)
        hud_changed.emit()

func register_objective_damage(source, objective, amount):
    if source is StrikeCharacter:
        source.add_xp(amount * 0.04)

func objective_destroyed(objective):
    if objective.is_main:
        var winner = objective.team == "BLUE" and "RED" or "BLUE"
        _finish(winner)
        return

    if objective.team == "BLUE":
        blue_targets_destroyed += 1
        red_score += GameBalance.TARGET_POINTS
        announcement.emit("BLUE " + objective.objective_id + " DESTROYED")
        if blue_targets_destroyed >= 2:
            blue_main_unlocked = true
            _unlock_main("BLUE")
    else:
        red_targets_destroyed += 1
        blue_score += GameBalance.TARGET_POINTS
        announcement.emit("RED " + objective.objective_id + " DESTROYED")
        if red_targets_destroyed >= 2:
            red_main_unlocked = true
            _unlock_main("RED")
    hud_changed.emit()

func _unlock_main(team):
    for node in get_tree().get_nodes_in_group("main_" + team.to_lower()):
        node.unlocked = true
    announcement.emit(team + " MAIN TOWER UNLOCKED!")

func _finish_by_score():
    if blue_score > red_score:
        _finish("BLUE")
    elif red_score > blue_score:
        _finish("RED")
    else:
        _finish("DRAW")

func _finish(winner):
    if finished:
        return
    finished = true
    match_finished.emit(winner)

func get_time_text() -> String:
    var total := int(ceil(time_left))
    return "%02d:%02d" % [total / 60, total % 60]
