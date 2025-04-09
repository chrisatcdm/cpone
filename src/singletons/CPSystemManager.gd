# CPSystemManager.gd
# Autoload Singleton to manage global CP system state.
extends Node

# Global flag to track if the protective current is interrupted.
var system_interrupted: bool = false

# Function to call when interrupting the system.
func interrupt_system():
	if not system_interrupted:
		print("--- CP System Interrupted ---")
		system_interrupted = true
		# Optional: Emit a signal here if other parts of the game need to react instantly.
		# emit_signal("system_interruption_changed", true)

# Function to call when restoring the system.
func restore_system():
	if system_interrupted:
		print("--- CP System Restored ---")
		system_interrupted = false
		# Optional: Emit a signal here.
		# emit_signal("system_interruption_changed", false)

# Optional: Define signals if needed elsewhere
# signal system_interruption_changed(is_interrupted: bool)
