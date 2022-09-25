extends CanvasLayer

onready var mushroom_orange_count = $Collectibles/MushroomOrange/Count
onready var mushroom_brown_count = $Collectibles/MushroomBrown/Count
onready var stone_yellow_count = $Collectibles/StoneYellow/Count
onready var stone_red_count = $Collectibles/StoneRed/Count

func _ready() -> void:
	pass

func _on_Player_on_pickup_collectible(type) -> void:
	get(type + '_count').text = String(int(get(type + '_count').text) + 1)
