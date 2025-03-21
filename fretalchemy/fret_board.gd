extends Node2D

const NUM_STRINGS = 6
const NUM_FRETS = 22  # Standard fretboard length
const STRING_SPACING = 20	# Adjust this for proper spacing
const FRET_SPACING = 50		# Adjust for fret width

func _ready():
	draw_fretboard()

func draw_fretboard():
	var fretboard_container = VBoxContainer.new()	# Holds all strings
	add_child(fretboard_container)
	
	for string_index in range(NUM_STRINGS):
		var string_row = HBoxContainer.new()	# Holds frets for this string
		fretboard_container.add_child(string_row)
		
		for fret_index in range(NUM_FRETS+1):
			var fret_button = Button.new()
			fret_button.text = str(fret_index+1)
			fret_button.name = "String%d_Fret%d" % [string_index+1, fret_index+1]

			# Store data for note mapping
			fret_button.set_meta("string", string_index+1)
			fret_button.set_meta("fret", fret_index+1)

			string_row.add_child(fret_button)

			# Optional: Connect to a function for handling visual feedback
			fret_button.connect("pressed", _on_fret_pressed.bind(fret_button))

func _on_fret_pressed(fret_button):
	var string = fret_button.get_meta("string")
	var fret = fret_button.get_meta("fret")
	print("You pressed string %d, fret %d" % [string, fret])
