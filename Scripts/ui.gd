extends CanvasLayer

var coins = 00

func _process(delta):
	UpdateCoins()

func _ready():
	
	$CoinsPanel/Coins.text = String(coins)
	
func handleCoinCollected():
	coins += 1
	$CoinsPanel/Coins.text = String(coins)
	
func UpdateCoins():
	$CoinsPanel/Coins.text = String(coins)
