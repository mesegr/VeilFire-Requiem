extends CanvasLayer

var coins = 00

func _process(delta):
	UpdateCoins()

func _ready():
	
	$Coins.text = String(coins)
	
func handleCoinCollected():
	coins += 1
	$Coins.text = String(coins)
	
func UpdateCoins():
	$Coins.text = String(coins)
