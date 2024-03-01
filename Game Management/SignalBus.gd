extends Node

#ui stuff
signal settingsExit

signal weapon_entered(weaponBody, player_id)
signal picked_up(weaponBody)
signal fired
signal weapon_swap(weaponName)
signal hurt

signal serverBrowserJoin(ip) # indicates a user trying to join a server at IP
