extends Node2D

const NUM_STRINGS = 6 # Standard # of guitar string
const NUM_FRETS = 22 # Standard # of frets

const STRING_SPACING = 30  # Adjust for vertical spacing
const NUT_WIDTH = 0.125  # Adjust as needed for better proportions

var scale_length  # Will be updated dynamically
var fretboard_container

var tunings = {
	"Standard": ["E", "A", "D", "G", "B", "E"],
	"Drop D": ["D", "A", "D", "G", "B", "E"],
	"Open G": ["D", "G", "D", "G", "B", "D"],
	"DADGAD-CelticTuning": ["D","A","D","G","A","D",]
}
var chromatic_scale = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
var current_tuning
var display_mode = "numbers"  # "numbers" or "notes"


func _ready():
	current_tuning = tunings["Standard"].duplicate() # Default to standard tuning
	reverse_tuning(current_tuning)
	update_scale_length()

	# Initialize the container for the fretboard
	fretboard_container = VBoxContainer.new()
	add_child(fretboard_container)
	
	var tuning_menu = OptionButton.new()
	add_child(tuning_menu)
	for tuning in tunings.keys():
		tuning_menu.add_item(tuning)
	tuning_menu.position = Vector2(10, 250)
	tuning_menu.connect("item_selected", _on_tuning_selected)
	
	var toggle_button = Button.new()
	toggle_button.text = "Switch Labels"
	toggle_button.position = Vector2(300 ,250)
	add_child(toggle_button)
	
	toggle_button.connect("pressed", _on_toggle_labels)
	
	draw_fretboard()
	get_viewport().connect("size_changed", _on_resize)  # Detect window resizing

func update_scale_length():
	var screen_width = get_viewport_rect().size.x
	scale_length = screen_width * 1.25# * 0.7225  # Adjust scale factor dynamically

func draw_fretboard():
	# Remove old fretboard contents
	for child in fretboard_container.get_children():
		child.queue_free()

	for string_index in range(NUM_STRINGS):
		var string_row = HBoxContainer.new()
		fretboard_container.add_child(string_row)
		
		var previous_fret_x = 0  # Track the previous fret position

		for fret_index in range(NUM_FRETS+1):
			var fret_button = Button.new()
			fret_button.name = "String%d_Fret%d" % [string_index, fret_index]
			
			# Get the correct label based on the display mode
			var label = get_fret_label(string_index, fret_index)
			fret_button.text = label  # Assign correct label
			
			# Use the real-world fret spacing formula:
			var fret_x = scale_length - (scale_length / (2 ** (fret_index / 12.0)))
			var fret_width = fret_x - previous_fret_x
			previous_fret_x = fret_x  # Update the last fret position

			# Lock the size of the button
			fret_button.custom_minimum_size = Vector2(fret_width, STRING_SPACING - 5)
			fret_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			fret_button.size_flags_vertical = Control.SIZE_EXPAND_FILL

			# Store metadata for debugging
			fret_button.set_meta("string", string_index+1)
			fret_button.set_meta("fret", fret_index)

			string_row.add_child(fret_button)
			fret_button.connect("pressed", _fret_pressed.bind(fret_button))

func _fret_pressed(fret_button):
	var string = fret_button.get_meta("string")
	var fret = fret_button.get_meta("fret")
	print("You pressed string %d, fret %d" % [string, fret])
	
	# Change color to indicate it was pressed
	fret_button.modulate = Color(1, 0, 0)  # Change to red color

	# Optionally, reset the color after some time
	await get_tree().create_timer(0.5).timeout
	fret_button.modulate = Color(1, 1, 1)  # Reset to default color
		
func _on_resize():
	update_scale_length()
	draw_fretboard()
	
# Function to determine what to display (fret number or note)
func get_fret_label(string_index, fret_index):
	if display_mode == "numbers":
		return str(fret_index) # Display fret numbers
	else:
		return calculate_note_name(string_index, fret_index)	# Display note names

func calculate_note_name(string_index, fret_index):
	var open_note = current_tuning[string_index]  # Get open string note
	var open_note_index = chromatic_scale.find(open_note)  # Find in scale
	var note_index = (open_note_index + fret_index) % chromatic_scale.size()  # Wrap around scale
	return chromatic_scale[note_index]  # Return note name

func _on_tuning_selected(index):
	var tuning_name = tunings.keys()[index]
#	current_tuning = reverse_tuning(tunings[tuning_name])
	
	current_tuning = tunings[tuning_name].duplicate() # Default to standard tuning
	reverse_tuning(current_tuning)
	
	draw_fretboard()  # Redraw with new tuning
	
func _on_toggle_labels():
	if display_mode == "numbers":
		display_mode = "notes"
	else:
		display_mode = "numbers"
	
	draw_fretboard()  # Redraw with new mode
	
func reverse_tuning(tuning):
	tuning.reverse()
	return tuning

func _input(event):
	#if Input.is_action_just_pressed("fret_pressed"):
	if Input.is_key_pressed(KEY_Q):
			var string_pressed = fretboard_container.get_child(4)
			var fretted_note_pressed = string_pressed.get_child(0)
			#fret_button.name = "String%d_Fret%d" % [string_index, fret_index]
			_fret_pressed(fretted_note_pressed)
	
			
#	if event is InputEventKey:
		#OS.get_keycode_string(event.key_label)
		#OS.get_keycode_string(event.keycode)
		#var key = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		
		#var key = OS.get_keycode_string(event.key_label)
		#if key == 'a':
			#var fretted_note = fretboard_container[4][0]
			#_fret_pressed(fretted_note)

func play_note():
	pass
	
func calculate_note_freq():
	pass
