extends CanvasLayer

var coins = 0

func _process(delta):
	UpdateCoins()

func _ready():
	update_coin_display()

func handleCoinCollected():
	coins += 1
	update_coin_display()

func UpdateCoins():
	update_coin_display()

func update_coin_display():
	$CoinsPanel/Coins.bbcode_text = "[center]" + String(coins) + "[/center]"
