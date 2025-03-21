extends Node2D

const NUM_STRINGS = 6
const NUM_FRETS = 22
const STRING_SPACING = 30  # Adjust for vertical spacing
const NUT_WIDTH = 0.125  # Adjust as needed for better proportions

var scale_length  # Will be updated dynamically
var fretboard_container

func _ready():
	update_scale_length()

	# Initialize the container for the fretboard
	fretboard_container = VBoxContainer.new()
	add_child(fretboard_container)
	
	draw_fretboard()
	get_viewport().connect("size_changed", _on_resize)  # Detect window resizing

func update_scale_length():
	var screen_width = get_viewport_rect().size.x
	scale_length = screen_width * 1.25# * 0.7225  # Adjust scale factor dynamically

func draw_fretboard():
	# Remove old fretboard contents
	for child in fretboard_container.get_children():
		child.queue_free()

	var previous_fret_x = 0  # Track the previous fret position

	for string_index in range(NUM_STRINGS):
		var string_row = HBoxContainer.new()
		fretboard_container.add_child(string_row)

		for fret_index in range(NUM_FRETS+1):
			var fret_button = Button.new()
			fret_button.text = str(fret_index)
			fret_button.name = "String%d_Fret%d" % [string_index, fret_index]

			# Use the real-world fret spacing formula:
			var fret_x = scale_length - (scale_length / (2 ** (fret_index / 12.0)))
			var fret_width = fret_x - previous_fret_x
			previous_fret_x = fret_x  # Update the last fret position

			fret_button.custom_minimum_size = Vector2(fret_width, STRING_SPACING - 5)

			# Store metadata for debugging
			fret_button.set_meta("string", string_index)
			fret_button.set_meta("fret", fret_index)

			string_row.add_child(fret_button)
			fret_button.connect("pressed", _on_fret_pressed.bind(fret_button))

func _on_fret_pressed(fret_button):
	var string = fret_button.get_meta("string")
	var fret = fret_button.get_meta("fret")
	print("You pressed string %d, fret %d" % [string, fret])

func _on_resize():
	update_scale_length()
	draw_fretboard()
