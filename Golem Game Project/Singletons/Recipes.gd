extends Node

#golemRecipes = {
	##String of Golem's Name : {
		##String of ItemID : ##Int of Qty needed
#		}
#	}
var golemRecipes= {
	"StrawBoy" : {
		"Straw" : 4
	},
	"Lead Zepplin":{
		"Stone" : 3
	},
	"Twisted Whisker":{
		"Wood" : 1
	},
}

#ItemRecipeDict = {
#	##Int that is a unique ID : {
#		String of ItemID: {
#			##String of ItemID : ##Int of Qty needed
#			}
#		}
#	}
var ItemRecipeDict = {
	0:{
		"Straw Bundle":{
			"Straw":9,
			},
		},
	1:{
		"Golem Core" : {
			"Aspect Crystal": 1,
			"Runic Matrix" : 1,
			},
		},
	2:{
		"Command Seal" :{
			"Wax" : 2,
			"Glimmerdust" : 1,
			},
		},
	}
