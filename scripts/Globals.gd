extends Node

var PATH = "user://data.save"
var DEBUG = false

var bio_questions : Array = [
	#["TUTORIAL MODE", "TUTORIAL MODE"],
	["res://assets/images/sperm-head.png", "HEAD"],
	["res://assets/images/sperm-neck.png", "NECK"],
	["res://assets/images/sperm-tail.png", "TAIL"],
	["res://assets/images/sperm-mito.png", "MITOCHONDRIA"],
	["res://assets/images/sperm-mid.png", "MIDDLE PIECE"],
	["res://assets/images/sperm-membrane.png", "PLASMA MEMBRANE"],
	["res://assets/images/sperm-nucleus.png", "NUCLEUS"],
	["res://assets/images/sperm-acrosome.png", "ACROSOME"],
	["____ contains two important structures which are acrosome and nucleus.", "HEAD"],
	["Head contains two important structures which are ____ and nucleus.", "ACROSOME"],
	["Head contains two important structures which are acrosome and ____.", "NUCLEUS"],
	["Acrosome contains hydrolytic enzyme to help the sperm to penetrate the ____ of the secondary oocyte.", "ZONA PELLUCIDA"],
	["Acrosome contains hydrolytic enzyme to help the sperm to penetrate the zona pellucida of the ____.", "SECONDARY OOCYTE"],
	["____ contains hydrolytic enzyme to help the sperm to penetrate the zona pellucida of the secondary oocyte.", "ACROSOME"],
	["Acrosome contains ____ enzyme to help the sperm to penetrate the zona pellucida of the secondary oocyte.", "HYDROLYTIC"],
	["Nucleus contains ____.", "PATERNAL DNA"],
	["____ contains paternal DNA.", "NUCLEUS"],
	["Midpiece contains high number of ____ that provide energy in the form of ATP for the tail to move.", "MITOCHONDRIA"],
	["____ contains high number of mitochondria that provide energy in the form of ATP for the tail to move.", "MIDPIECE"],
	["Midpiece contains high number of mitochondria that provide energy in the form of ____ for the tail to move.", "ATP"],
	["Midpiece contains high number of mitochondria that provide energy in the form of ATP for the ____ to move.", "TAIL"],
	["____ composed of 9+2 microtubule arrangement to facilitate the movement of the sperm.", "TAIL"],
	["Tail composed of 9+2 ____ arrangement to facilitate the movement of the sperm.", "MICROTUBULE"],
	["res://assets/images/ovum-membrane.png", "PLASMA MEMBRANE"],
	["res://assets/images/ovum-follicular.png", "FOLLICULAR CELLS"],
	["res://assets/images/ovum-cytoplasm.png", "CYTOPLASM"],
	["res://assets/images/ovum-nucleus.png", "NUCLEUS"],
	["res://assets/images/ovum-zona.png", "ZONA PELLUCIDA"],
	["res://assets/images/ovum-cortical.png", "CORTICAL GRANULE"]
]

var phys_questions : Array = [
	["What is the direction of the electric field produced by a positive point charge?", "OUTWARDS"],
	["What will the negative charge experience nearby a positive charge?", "ATTRACTIVE FORCE"],
	["res://assets/images/two-points.png", "NEGATIVE", "The electrostatic force experienced by the ___ charge is to the left."],
	["res://assets/images/two-points.png", "POSITIVE", "The electrostatic force experienced by the ___ charge is to the right."],
	["res://assets/images/two-points.png", "LEFT", "The electrostatic force experienced by the negative charge is to the ___."],
	["res://assets/images/two-points.png", "RIGHT", "The electrostatic force experienced by the positive charge is to the ___."],
	["Based on ___'s law, electrostatic force and separation distance between these two charges are inversely proportional.", "COULOMB"],
	["Based on coulomb's law, electrostatic force and separation distance between these two charges are ___ proportional.", "INVERSELY"],
	["Magnitude of electrostatic force will ___ if a negative charge was moved away from a positive charge.", "DECREASE"],
	["Magnitude of electrostatic force will ___ if a negative charge was moved towards a positive charge.", "INCREASE"],
]

var cs_questions : Array = [
	["Java is an ___ language.", "OBJECT ORIENTED"],
	["Data which is required in order to obtain the required output.", "INPUT"],
	["The steps involved in obtaining the output from the input.", "PROCESS"],
	["The result obtained from a program.", "OUTPUT"],
	["Problem analysis is a process of ___ a problem into a solution.", "TRANSFORMING"],
	["___ are continuous block of memory that can be used to store data.", "ARRAYS"],
	["Arrays are ___ blocks of memory that can be used to store data.", "CONTINUOUS"],
	["___ are used to store data.", "VARIABLES"],
	["Text are represented as a ___ type.", "STRING"],
	["A ___ consists of 8 bits.", "BYTE"],
	["A byte consists of 8 ___.", "BITS"],
	["RAM is a type of ___ memory.", "VOLATILE"],
	["___ value can only be true or false.", "BOOLEAN"],
	["Boolean value can only be ___ or false.", "TRUE"],
	["Boolean value can only be true or ___.", "FALSE"],
	["start:\n\tx = 1\n\toutput x\nend", "1", "2", "3", "4"],
	["start:\n\tx = 1\n\ty = 1\n\toutput x + y\nend", "2", "1", "3", "4"],
	["start:\n\tx = 1\n\ty = 0\n\toutput x / y\nend", "Error", "1", "2", "3"],
	["start:\n\tx = 1\n\ty = 2\n\tx = x + y\n\ty = x\nend", "x=3, y=3", "x=1, y=3", "x=3, y=1", "x=1, y=1"],
	["start:\n\tx = 0\n\tif x == 0\n\t\toutput \"x is 0\"\n\telse\n\t\toutput \"x is not 0\"\n\tendif\nend", "x is 0", "x is not 0"],
	["start:\n\tage = 18\n\tif age >= 18\n\t\toutput \"You can vote.\"\n\telse\n\t\toutput \"You cannot vote.\"\n\tendif\nend", "You can vote.", "You cannot vote."],
	["start:\n\tmark = 75\n\tif mark >= 90\n\t\toutput \"A+\"\n\telse if mark >= 80\n\t\toutput \"A\"\n\telse if mark >= 70\n\t\toutput \"B\"\n\telse\n\t\toutput \"Lower than B.\"\n\tendif\nend", "B", "A+", "A", "Lower than B."],
	["start:\n\tx = 0\n\ti = 0\n\twhile i < 5\n\t\tx = x + i\n\t\ti = i + 1\n\tendwhile\n\toutput x\nend", "10", "5", "3", "7"],
	["start:\n\tx = 0\n\ti = 0\n\twhile i < 10\n\t\tx = x + 1\n\t\ti = i + 2\n\tendwhile\n\toutput x\nend", "5", "1", "7", "10"],
	["start:\n\tx = 0\n\ti = 0\n\twhile i < 5\n\t\tif i == 1\n\t\t\tx = 1\n\t\tendif\n\t\ti = i + 1\n\tendwhile\n\toutput x\nend", "1", "2", "3", "4"],
]

var mode = 0

var cur_question: int = 0
var questions : Array = bio_questions
var lvl_list = []
var progress = [0, 0, 0, 0]
var cur_seed = 0

func _ready():
	load_score()
	save_score()

func congrats_msg():
	pass

func save_score():
	var file = File.new()
	
	file.open(PATH, File.WRITE)
	file.store_8(progress[0])
	file.store_8(progress[1])
	file.store_8(progress[2])
	file.store_8(progress[3])
	file.store_8(cur_seed)
	
	file.close()
	
func load_score():
	var file = File.new()
	var exist = file.file_exists(PATH)
	
	if exist:
		file.open(PATH, File.READ)
		
		progress[0] = file.get_8()
		progress[1] = file.get_8()
		progress[2] = file.get_8()
		progress[3] = file.get_8()
		cur_seed = file.get_8()
	
	file.close()
