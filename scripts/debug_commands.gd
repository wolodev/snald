extends Node

func _ready():
	Console.connect_node(self)
	if Engine.editor_hint:
		EventMan.circuit_on("cheater")

const win_help = "wins the game"
func win_cmd():
	if not EventMan.circuit("cheater"):
		Console.print("bruh")
		return
	EventMan.completed()

const quick_reset_help = "Resets the game's state without reloading the map."
func quick_reset_cmd():
	EventMan.quick_reset()

const cheater_cheater_pumpkin_eater_help = "With great power comes great responsibility... (Enables cheats.)"
func cheater_cheater_pumpkin_eater_cmd():
	PersistMan.set_flag("cheater", true)
	EventMan.circuit_on("cheater")

const set_power_help = "Sets the power."
func set_power_cmd(power: float):
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can break the laws of thermodynamics")
		return
	if power < 0 or 100 < power:
		Console.print("New power should be within [0,100].")
		return
	EventMan.power = power;
	Console.print("Ok")

const set_temperature_help = "Sets the temperature."
func set_temperature_cmd(temperature: float):
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can break the laws of thermodynamics")
		return
	EventMan.temperature = temperature;
	Console.print("Ok")

const reset_help = "Creates a new universe where everything repeats itself, according to 「Fate」. (Resets the game's state.)"
func reset_cmd():
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can accelerate the universe to the 「Vanishing Point」")
		return
	EventMan.reset()
	Console.print("Ok")

const set_difficulty_help = "Makes a friend or foe ANGRY. Costs 5 JUICE. (Sets a character's anger level.)"
func set_difficulty_cmd(name: String, diff: int):
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use mind control")
		return
	EventMan.register(name, diff)
	for character in get_tree().get_nodes_in_group("animatronics"):
		if character.id == name:
			character.difficulty = diff
	Console.print("Ok")

const push_state_help = "Teleports a character to the specified position."
func push_state_cmd(name: String, state: int):
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use mind control")
		return
	if name == "tanner":
		Console.print("This character doesn't use the state system in the typical way, so it isn't likely to work correctly.")
		
	for character in get_tree().get_nodes_in_group("animatronics"):
		if character.id == name:
			character.assume_state(state)
	Console.print("Ok")

const set_circuit_help = "Sets the value of a circuit."
func set_circuit_cmd(name: String, value: bool):
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use electrokinesis")
		return
	if name == "cheater":
		Console.print(";)")
	if value:
		EventMan.circuit_on(name)
	else:
		EventMan.circuit_off(name)
	Console.print("Ok")

const circuit_help = "Gets the value of a circuit."
func circuit_cmd(name: String):
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use electrokinesis")
		return
	if not name in EventMan.circuit_states:
		Console.print("Doesn't exist yet.")
	else:
		Console.print(EventMan.circuit_states[name])

const circuits_help = "Gets the value of all circuits."
func circuits_cmd():
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use electrokinesis")
		return
	for circuit in EventMan.circuit_states:
		if circuit.ends_with("_not"):
			continue
		Console.print(circuit + ": " + str(EventMan.circuit_states[circuit]))

const set_saved_bool_help = "Sets a save file flag."
func set_saved_bool_cmd(name: String, value: bool):
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can change the past")
		return
	if name == "cheater":
		Console.print(";)")
	PersistMan.set_flag(name, value)

const saved_help = "Gets the save file."
func saved_cmd():
	Console.print(str(PersistMan.persistent_dict))

const free_help = "♪ You can scramble my molecules, 'Cause I'm just passin' through! ♪ (Enables noclip.)"
func free_cmd():
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can ♪ scramble them molecules. ♪")
		return
	for player in get_tree().get_nodes_in_group("player"):
		player.enable_debug()
	for camera in get_tree().get_nodes_in_group("camera"):
		camera.enable_debug()

const reload_help = "Travels between dimensions by being closed between two objects. (Reloads the map.)"
func reload_cmd():
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can perform filthy acts at a reasonable price.")
		return
	var map = get_tree().get_nodes_in_group("map")[0]
	if map:
		EventMan.pause = true
		map.verify_and_build()
		yield(map, "build_complete")
		EventMan.pause = false

const pause_help = "The ultimate stand. (Pauses and unpauses power, temperature, and character movements.)"
func pause_cmd():
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can move during stopped time.")
		return
	EventMan.pause = not EventMan.pause

const maps_help = "Shows all maps included with the game."
func maps_cmd():
	var dir = Directory.new()
	var result = dir.open("maps");
	if result == OK:
		dir.list_dir_begin()
		var name = dir.get_next()
		while name != "":
			if not dir.current_is_dir() and not name.ends_with("import"):
				Console.print(name)
			name = dir.get_next()
	else:
		Console.print("heck")
		Console.print(result)

const mods_help = "Shows all mods that are currently loaded."
func mods_cmd():
	for mod in Modloader.mods:
		Console.print(mod)

const jumpscare_help = "Triggers a jumpscare!"
func jumpscare_cmd(character, animation):
	EventMan.jumpscare(character, animation)
	Console.hide()

const cvar_help = "Manipulates a cvar. Pass \"get\" as the value to read."
func cvar_cmd(cvar: String, type: String, value):
	var getting = str(value) == "get"
	if (not EventMan.circuit("cheater")) and not getting:
		Console.print("Configuring the game is a cheat")
		return
	if getting:
		var val = CVars.call(("get" if getting else "set") + "_" + type, cvar)
		Console.print(val)
	else:
		var expr = Expression.new()
		var _e = expr.parse(type + "(v)", ["v"])
		var correct_type = expr.execute([value])
		print(correct_type)
		CVars.call(("get" if getting else "set") + "_" + type, cvar, correct_type)

const put_txt_help = "Puts text on the screen"
func put_txt_cmd(content: String):
	if !CutsceneMan.cutscene_is_running():
		CutsceneMan.start_cutscene(PackedScene.new())
	CutsceneMan.put_text(content)

const del_txt_help = "Deletes the default text."
func del_txt_cmd():
	CutsceneMan.remove_text()

const overpowered_help = "Don't bother with power and temperature when debugging!"
func overpowered_cmd():
	EventMan.passive_power = -20
	EventMan.passive_temperature = -1

const jojo_a_go_go_help = "make jojo go"
func jojo_a_go_go_cmd():
	var jojo: Jojo
	for a in get_tree().get_nodes_in_group('animatronic'):
		if a is Jojo:
			jojo = a
	if not jojo:
		return
	jojo.get_node("MovementTimer").emit_signal("timeout")

