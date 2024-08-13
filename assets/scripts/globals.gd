extends Node

var bio_questions : Array = [
	["___ of a sperm contains acrosome and nucleus.", "HEAD"],
	["Head of a sperm contains ___ and nucleus.", "ACROSOME"],
	["Head of a sperm contains acrosome and ___.", "NUCLEUS"],
	["Hydrolytic enzyme in acrosome helps the sperm penetrate the ___ of the secondary oocyte.", "ZONA PELLUCIDA"],
	["Hydrolytic enzyme in acrosome helps the sperm penetrate the zona pellucida of the ___.", "SECONDARY OOCYTE"],
	["Hydrolytic enzyme in ___ helps the sperm penetrate the zona pellucida of the secondary oocyte.", "ACROSOME"],
	["___ enzyme in acrosome helps the sperm penetrate the zona pellucida of the secondary oocyte.", "HYDROLYTIC"],
	["Nucleus contains ___ DNA.", "PATERNAL"],
	["Midpiece contains high number of ___ that provide energy for the tail.", "MITOCHONDRIA"],
	["___ contains high number of mitochondria that provide energy for the tail.", "MIDPIECE"],
	["Midpiece contains high number of mitochondria that provide energy in the form of ATP for the ___ to move.", "TAIL"],
	["Tail composed of 9+2 ___ arrangement to facilitate the movement of the sperm.", "MICROTUBULE"],
]

var phys_questions : Array = [
	["___ force is the force between two electrically charged objects.", "ELECTROSTATIC"],
	["What is the direction of the electric field produced by a positive point charge?", "OUTWARDS"],
	["What is the direction of the electric field produced by a negative point charge?", "INWARDS"],
	["Negative charge experiences ___ force nearby a positive charge.", "ATTRACTIVE"],
	["Negative charge experiences ___ force nearby a negative charge.", "REPULSIVE"],
	["___'s law states that electrostatic force and separation distance between these two charges are inversely proportional.", "COULOMB"],
	["Coulomb's law states that electrostatic force and separation distance between these two charges are ___ proportional.", "INVERSELY"],
	["Magnitude of electrostatic force will ___ if a negative charge was moved away from a positive charge.", "DECREASE"],
	["Magnitude of electrostatic force will ___ if a negative charge was moved towards a positive charge.", "INCREASE"],
]

var cs_questions : Array = [
	["Java is an ___ language.", "OBJECT ORIENTED"],
	["Data required to obtain the required output is an ___.", "INPUT"],
	["The steps involved in obtaining the output from the input.", "PROCESS"],
	["The result obtained from a program is an ___", "OUTPUT"],
	["Problem analysis is a process of ___ a problem into a solution.", "TRANSFORMING"],
	["___ are continuous block of memory that can be used to store data.", "ARRAYS"],
	["Arrays are ___ blocks of memory that can be used to store data.", "CONTINUOUS"],
	["___ are used to store data.", "VARIABLES"],
	["Text are represented as a ___ type.", "STRING"],
	["A ___ consists of 8 bits.", "BYTE"],
	["RAM is a type of ___ memory.", "VOLATILE"],
	["___ value can only be true or false.", "BOOLEAN"]
]

var questions: Array
var cur_level: int = 0
var stage: int = 1
var cur_question: int = 0
var answer: String
var answer_pos: int = 0
var diff: int = 0
var max_diff: int = 50
var lives: int = 3
var persist: Array = []
var time: float = 99
var time_default: float = 99
var score: int = 0
var running: bool = false

func _ready():
	questions = bio_questions + phys_questions + cs_questions
	questions.sort_custom(self, "diff_order")

func diff_order(a: Array, b: Array) -> bool:
	return len(a[1]) < len(b[1])
	
func diff_up():
	diff += 1
	
	if diff > max_diff:
		diff = max_diff

func reset_game():
	diff = 0
	answer_pos = 0
	cur_question = 0
	lives = 3
	persist = []
	score = 0
	stage = 1

func get_question() -> Array:
	var question: Array = questions[cur_question]
	cur_level = cur_question
	
	cur_question += 1
	
	if cur_question >= len(questions):
		cur_question = 0
	
	answer = question[1]
	return question

func check_letter(letter: String) -> bool:
	if letter.to_lower() == answer[answer_pos].to_lower():
		answer_pos += 1
		
		if answer_pos < len(answer) and answer[answer_pos] == ' ':
			answer_pos += 1
		
		return true
	else:
		return false

func check_win() -> bool:
	return answer_pos >= len(answer)
