extends Node

#ui stuff
signal settingsExit

signal weapon_entered(weaponBody, player_id)
signal picked_up(weaponBody)
signal c4detonated()
signal tilespawn(pos_x, pos_y, id)
signal tilegun_reset()
signal fired
signal weapon_swap(weaponName)
signal hurt
signal reload()

signal serverBrowserJoin(ip) # indicates a user trying to join a server at IP

# called anywhere in the game, received by the server node, to properly
# end a host session.
signal cancel_host()
signal game_over(name)
