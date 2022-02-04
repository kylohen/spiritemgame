extends Node

var rng

func randSeedNum():
	randomize()
	var seedNum = round(rand_range(0,999999999999))
	return seedNum

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash(randSeedNum())
	print ("Seed Key State = ",rng.get_state())
