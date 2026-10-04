extends CanvasLayer
class_name StrikeUI

@onready var timer_label = $HUD/TopBar/Timer
@onready var blue_score_label = $HUD/TopBar/BlueScore
@onready var red_score_label = $HUD/TopBar/RedScore
@onready var objective_label = $HUD/ObjectiveState
@onready var announcement_label = $HUD/Announcement
@onready var end_panel = $HUD/EndPanel
@onready var end_label = $HUD/EndPanel/Result
var match_manager: MatchManager
var player: StrikeCharacter

func _ready():
    await get_tree().process_frame
    var players = get_tree().get_nodes_in_group("human_player")
    if players.size() > 0:
        player = players[0]
    _connect_mobile()

func setup(manager):
    match_manager = manager
    manager.hud_changed.connect(refresh)
    manager.announcement.connect(show_announcement)
    manager.match_finished.connect(show_result)
    refresh()

func refresh():
    if not match_manager:
        return
    timer_label.text = match_manager.get_time_text()
    blue_score_label.text = "BLUE  %02d" % match_manager.blue_score
    red_score_label.text = "RED  %02d" % match_manager.red_score
    objective_label.text = "BLUE: %d/2    MAIN %s        RED: %d/2    MAIN %s" % [
        match_manager.blue_targets_destroyed,
        "OPEN" if match_manager.blue_main_unlocked else "LOCKED",
        match_manager.red_targets_destroyed,
        "OPEN" if match_manager.red_main_unlocked else "LOCKED"
    ]

func show_announcement(text):
    announcement_label.text = text
    announcement_label.visible = true
    await get_tree().create_timer(2.0).timeout
    if is_instance_valid(announcement_label):
        announcement_label.visible = false

func show_result(winner):
    end_panel.visible = true
    if winner == "DRAW":
        end_label.text = "DRAW"
    else:
        end_label.text = winner + " TEAM\nVICTORY"

func _connect_mobile():
    $HUD/Mobile/Up.button_down.connect(func(): _set_move(Vector2(0, -1)))
    $HUD/Mobile/Up.button_up.connect(func(): _clear_vertical())
    $HUD/Mobile/Down.button_down.connect(func(): _set_move(Vector2(0, 1)))
    $HUD/Mobile/Down.button_up.connect(func(): _clear_vertical())
    $HUD/Mobile/Left.button_down.connect(func(): _set_move(Vector2(-1, 0)))
    $HUD/Mobile/Left.button_up.connect(func(): _clear_horizontal())
    $HUD/Mobile/Right.button_down.connect(func(): _set_move(Vector2(1, 0)))
    $HUD/Mobile/Right.button_up.connect(func(): _clear_horizontal())
    $HUD/Mobile/Attack.pressed.connect(func(): _attack())
    $HUD/Mobile/A1.pressed.connect(func(): _ability(0))
    $HUD/Mobile/A2.pressed.connect(func(): _ability(1))
    $HUD/Mobile/A3.pressed.connect(func(): _ability(2))

func _set_move(v):
    if is_instance_valid(player):
        player.virtual_move = v

func _clear_vertical():
    if is_instance_valid(player):
        player.virtual_move.y = 0

func _clear_horizontal():
    if is_instance_valid(player):
        player.virtual_move.x = 0

func _attack():
    if is_instance_valid(player):
        player.virtual_attack = true

func _ability(i):
    if is_instance_valid(player):
        player.use_ability(i)
