extends Node

signal weapon_entered(weaponBody, player_id)
signal picked_up(weaponBody)
signal c4detonated()
signal tilespawn(pos_x, pos_y)
signal fired
signal weapon_swap(weaponName)
signal hurt

signal server_closed()

@rpc("any_peer","call_local")
func broadcast_server_closed():
	SignalBus.server_closed.emit()
