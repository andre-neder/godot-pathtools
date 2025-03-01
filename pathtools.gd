@tool
extends EditorPlugin


func _enter_tree() -> void:
  # Initialization of the plugin goes here.
  add_custom_type("PathMultiMeshInstance3D", "Path3D", preload("nodes/PathMultiMeshInstance3D.gd"), preload("res://addons/pathtools/assets/PathMultiMeshInstance3D.svg"))
  if Engine.is_editor_hint():
    print("PathTools Addon loaded.")


func _exit_tree() -> void:
  # Clean-up of the plugin goes here.
  remove_custom_type("PathMultiMeshInstance3D")
