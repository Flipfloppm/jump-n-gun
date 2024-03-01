extends Node

#ui stuff
signal settingsExit

signal weapon_entered(weaponBody, player_id)
signal picked_up(weaponBody)
signal fired
signal weapon_swap(weaponName)
signal hurt

signal server_closed()

@rpc("any_peer","call_local")
func broadcast_server_closed():
	SignalBus.server_closed.emit()

signal serverBrowserJoin(ip) # indicates a user trying to join a server at IP
