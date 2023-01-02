tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("Complex", "res://addons/complex/singleton.gd")

func _exit_tree():
	remove_autoload_singleton("Complex")
