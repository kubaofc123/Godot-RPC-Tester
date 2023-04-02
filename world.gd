extends Node

var enet_peer = ENetMultiplayerPeer.new()
const PORT = 9999
var player_entity


func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func host_game():
	# Create server
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	# Add player entity
	add_player(multiplayer.get_unique_id())
	player_entity = find_owning_player_entity()
	if not player_entity:
		print("SERVER: host_game(): Failed to find owning player_entity")
	
	$MainMenu.visible = false
	$Match.visible = true

func join_game():
	multiplayer.connected_to_server.connect(_connected_to_server)
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	$MainMenu.visible = false
	$Match.visible = true

func add_player(peer_id):
	if multiplayer.is_server():		
		print("SERVER: add_player(): peer_id: ", peer_id)
	else:
		print("CLIENT: add_player(): peer_id: ", peer_id)
		
	# Add player entity
	var player_class = load("res://player_entity.tscn")
	var a = player_class.instantiate()
	a.name = "player_entity_" + str(peer_id)
	$Players.add_child(a)

func _connected_to_server():
	print("Connected to server, my ID: ", multiplayer.get_unique_id())

func _on_player_entity_spawned(node):
	if multiplayer.is_server():		
		print("SERVER: _on_player_entity_spawned(): ", node, " | Authority: ", node.get_multiplayer_authority())
	else:
		print("CLIENT: _on_player_entity_spawned(): ", node, " | Authority: ", node.get_multiplayer_authority())
	
	if not player_entity:
		var a = find_owning_player_entity()
		if a:
			player_entity = a
			if multiplayer.is_server():		
				print("SERVER: _on_player_entity_spawned(): Found owning node ", a)
			else:
				print("CLIENT: _on_player_entity_spawned(): Found owning node ", a)
			return

func find_owning_player_entity():
	for a in $Players.get_children():
		if a.is_multiplayer_authority() and a is PlayerEntity:
			return a
	return null

func find_other_player_entity():
	for a in $Players.get_children():
		if not a.is_multiplayer_authority() and a is PlayerEntity:
			return a
	return null

func _on_any_peer_local_reliable_pressed():
	if not player_entity:
		if multiplayer.is_server():		
			print("SERVER: _on_any_peer_local_reliable_pressed(): player_entity is not valid")
		else:
			print("CLIENT: _on_any_peer_local_reliable_pressed(): player_entity is not valid")
		return
	player_entity.any_peer_local_reliable.rpc("Test data 1")
	
func _on_authority_local_reliable_pressed():
	if not player_entity:
		if multiplayer.is_server():		
			print("SERVER: _on_authority_local_reliable_pressed(): player_entity is not valid")
		else:
			print("CLIENT: _on_authority_local_reliable_pressed(): player_entity is not valid")
		return
	player_entity.authority_local_reliable.rpc("Test data 2")

func _on_any_peer_remote_reliable_pressed():
	if not player_entity:
		if multiplayer.is_server():		
			print("SERVER: _on_any_peer_remote_reliable_pressed(): player_entity is not valid")
		else:
			print("CLIENT: _on_any_peer_remote_reliable_pressed(): player_entity is not valid")
		return
	player_entity.any_peer_remote_reliable.rpc("Test data 3")

func _on_authority_remote_reliable_pressed():
	if not player_entity:
		if multiplayer.is_server():		
			print("SERVER: _on_authority_remote_reliable_pressed(): player_entity is not valid")
		else:
			print("CLIENT: _on_authority_remote_reliable_pressed(): player_entity is not valid")
		return
	player_entity.authority_remote_reliable.rpc("Test data 4")



func _on_other_any_peer_local_reliable_pressed():
	var a = find_other_player_entity()
	if not a:
		if multiplayer.is_server():		
			print("SERVER: _on_other_any_peer_local_reliable_pressed(): other player_entity is not valid")
		else:
			print("CLIENT: _on_other_any_peer_local_reliable_pressed(): other player_entity is not valid")
		return
	a.any_peer_local_reliable.rpc("Test data 1")

func _on_other_authority_local_reliable_pressed():
	var a = find_other_player_entity()
	if not a:
		if multiplayer.is_server():		
			print("SERVER: _on_other_authority_local_reliable_pressed(): other player_entity is not valid")
		else:
			print("CLIENT: _on_other_authority_local_reliable_pressed(): other player_entity is not valid")
		return
	a.authority_local_reliable.rpc("Test data 2")
	
func _on_other_any_peer_remote_reliable_pressed():
	var a = find_other_player_entity()
	if not a:
		if multiplayer.is_server():		
			print("SERVER: _on_other_any_peer_remote_reliable_pressed(): other player_entity is not valid")
		else:
			print("CLIENT: _on_other_any_peer_remote_reliable_pressed(): other player_entity is not valid")
		return
	a.any_peer_remote_reliable.rpc("Test data 3")
	
func _on_other_authority_remote_reliable_pressed():
	var a = find_other_player_entity()
	if not a:
		if multiplayer.is_server():		
			print("SERVER: _on_other_authority_remote_reliable_pressed(): other player_entity is not valid")
		else:
			print("CLIENT: _on_other_authority_remote_reliable_pressed(): other player_entity is not valid")
		return
	a.authority_remote_reliable.rpc("Test data 4")
