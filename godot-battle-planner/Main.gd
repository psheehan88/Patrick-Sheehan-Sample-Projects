extends Node2D

# Main core logic: file save/load, image export, UI wiring, and grid snapping.

const STATIC_ROOT := "user://battle_planner"  # Godot user data dir (writable on all platforms)
const DEBUG := false                          # flip to true for verbose flow logging

@onready var topbar := $UI/TopBar
@onready var settings_menu := $UI/SettingsMenu
@onready var help_popup := $UI/HelpPopup
@onready var ui_layer := $UI
@onready var player_panel := $UI/PlayerPanel
@onready var map_container := $MapContainer
@onready var keep_factory := $MapContainer/KeepFactory
@onready var help_overlay_scene: PackedScene = preload("res://scenes/ui/HelpOverlay.tscn")


func _ready() -> void:
	_log("_ready at %s" % get_path())
	_wire_ui()
	_show_first_run_help()


func _log(msg: String) -> void:
	if DEBUG:
		print("[Main] ", msg)


func _data_path(subdir: String) -> String:
	var dir := "%s/%s" % [STATIC_ROOT, subdir]
	DirAccess.make_dir_recursive_absolute(dir)
	return dir


# ----------------------------
# UI wiring
# ----------------------------
func _wire_ui() -> void:
	if topbar == null:
		push_error("[Main] TopBar not found at UI/TopBar")
	else:
		topbar.request_settings.connect(_open_settings)
		topbar.request_help.connect(_open_help)
		topbar.request_save.connect(_request_save)
		topbar.request_load.connect(_request_load)
		topbar.request_export.connect(_request_export)

	if player_panel == null:
		push_error("[Main] PlayerPanel not found at UI/PlayerPanel")
	else:
		player_panel.create_player.connect(_on_create_player)


# ----------------------------
# Save / Load (layouts)
# ----------------------------
func _request_save() -> void:
	var keeps: Array = keep_factory.get_keep_dicts()
	_log("saving %d keeps" % keeps.size())

	var ts := Time.get_datetime_string_from_system().replace(":", "").replace(" ", "-")
	var path := "%s/layout-%s.json" % [_data_path("layouts"), ts]

	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("[Main] Could not open file for writing: %s" % path)
		return

	f.store_string(JSON.stringify({
		"version": "1.0",
		"created": Time.get_datetime_string_from_system(),
		"keeps": keeps
	}, "  "))
	f.close()
	_log("saved %s" % path)


func _request_load() -> void:
	var layouts_dir := _data_path("layouts")
	var da := DirAccess.open(layouts_dir)
	if da == null:
		_log("no layouts dir at %s" % layouts_dir)
		return

	# Find the newest layout file.
	var newest := ""
	var t_latest := -1
	for fname in da.get_files():
		if fname.ends_with(".json"):
			var full := "%s/%s" % [layouts_dir, fname]
			var t := FileAccess.get_modified_time(full)
			if t > t_latest:
				t_latest = t
				newest = full

	if newest == "":
		_log("no layout JSON found in %s" % layouts_dir)
		return

	# Clear current keeps before loading.
	for k in keep_factory.get_keep_nodes():
		k.queue_free()

	# Parse the saved layout.
	var content := FileAccess.get_file_as_string(newest)
	var parsed: Variant = JSON.parse_string(content)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("[Main] Bad JSON at %s" % newest)
		return

	var root: Dictionary = parsed
	var keeps_arr: Array = root.get("keeps", [])
	_log("spawning %d keeps" % keeps_arr.size())

	# Optional map bounds; <= 0 disables clamping.
	var map_rows := -1
	var map_cols := -1

	for d_raw in keeps_arr:
		var d: Dictionary = d_raw
		var size := int(d.get("size", 1))
		var anchor := str(d.get("anchor", "center"))  # legacy files had no anchor
		var grid_arr: Array = d.get("grid", [0, 0])
		var r := float(grid_arr[0])
		var c := float(grid_arr[1])

		# Normalize center-anchored coords to top-left, unless an exact pixel pos is already stored.
		var has_pos: bool = d.has("pos") and d.get("pos") is Array and (d.get("pos") as Array).size() == 2
		if not has_pos:
			if anchor != "topLeft":
				var tl := _top_left_from_center(r, c, size)
				d["grid"] = [tl.x, tl.y]
				d["anchor"] = "topLeft"
			else:
				d["grid"] = [int(r), int(c)]

		# Keep the full footprint on-map if bounds are known.
		if map_rows > 0 and map_cols > 0:
			var clamped := _clamp_top_left(int(d["grid"][0]), int(d["grid"][1]), size, map_rows, map_cols)
			d["grid"] = [clamped.x, clamped.y]

		keep_factory.spawn_keep_from_dict(d)

	_log("loaded %s" % newest)


# Convert a center grid coordinate to a top-left grid coordinate for a keep of a given size.
func _top_left_from_center(r_c: float, c_c: float, size: int) -> Vector2i:
	var off := (size - 1) / 2.0  # 3x3 -> 1.0, 2x2 -> 0.5
	return Vector2i(int(floor(r_c - off)), int(floor(c_c - off)))


# Clamp a top-left coordinate so the full footprint stays within map bounds.
func _clamp_top_left(r_tl: int, c_tl: int, size: int, map_rows: int, map_cols: int) -> Vector2i:
	var r := clampi(r_tl, 0, max(0, map_rows - size))
	var c := clampi(c_tl, 0, max(0, map_cols - size))
	return Vector2i(r, c)


# ----------------------------
# Screenshot / image export
# ----------------------------
func _request_export() -> void:
	await get_tree().process_frame
	var img := get_viewport().get_texture().get_image()
	if img == null:
		push_error("[Main] Export failed: no image")
		return

	var ts := Time.get_datetime_string_from_system().replace(":", "").replace(" ", "-")
	var path := "%s/shot-%s.png" % [_data_path("exports"), ts]
	var err := img.save_png(path)
	if err == OK:
		_log("exported %s" % path)
	else:
		push_error("[Main] Export failed, code %d" % err)


# ----------------------------
# UI plumbing
# ----------------------------
func _on_create_player(player: Dictionary) -> void:
	EventBus.emit_signal("toast", "Player created: %s" % player.get("name", ""))


func _open_settings() -> void:
	settings_menu.popup_centered()


func _open_help() -> void:
	help_popup.popup_centered()


func _show_first_run_help() -> void:
	# Only show the help overlay on the very first launch.
	if not Settings.first_run:
		return

	var overlay := help_overlay_scene.instantiate()
	ui_layer.add_child(overlay)

	if overlay is AcceptDialog:
		overlay.confirmed.connect(_on_help_overlay_done.bind(overlay))
		overlay.canceled.connect(_on_help_overlay_done.bind(overlay))
		overlay.popup_centered()
	elif overlay is Window:
		overlay.close_requested.connect(_on_help_overlay_done.bind(overlay))
		overlay.popup_centered()
	elif overlay.has_signal("finished"):
		overlay.finished.connect(_on_help_overlay_done.bind(overlay))
	else:
		overlay.tree_exited.connect(_on_help_overlay_done.bind(overlay))


func _on_help_overlay_done(overlay: Node) -> void:
	if is_instance_valid(overlay):
		overlay.queue_free()
	# Mark first run complete so the overlay doesn't show again.
	Settings.first_run = false
	Settings.save_settings()
