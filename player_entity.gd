class_name PlayerEntity
extends Node


func _enter_tree():
	var arr = str(name).split("_")
	set_multiplayer_authority(str(arr[arr.size()-1]).to_int())

@rpc("any_peer", "call_local", "reliable")
func any_peer_local_reliable(data):
	if multiplayer.is_server():		
		print("SERVER: ", self, ": any_peer_local_reliable(): data: ", data)
	else:
		print("CLIENT: ", self, ": any_peer_local_reliable(): data: ", data)

@rpc("authority", "call_local", "reliable")
func authority_local_reliable(data):
	if multiplayer.is_server():
		print("SERVER: ", self, ": authority_local_reliable(): data: ", data)
	else:
		print("CLIENT: ", self, ": authority_local_reliable(): data: ", data)

@rpc("any_peer", "call_remote", "reliable")
func any_peer_remote_reliable(data):
	if multiplayer.is_server():		
		print("SERVER: ", self, ": any_peer_remote_reliable(): data: ", data)
	else:
		print("CLIENT: ", self, ": any_peer_remote_reliable(): data: ", data)
		
@rpc("authority", "call_remote", "reliable")
func authority_remote_reliable(data):
	if multiplayer.is_server():		
		print("SERVER: ", self, ": authority_remote_reliable(): data: ", data)
	else:
		print("CLIENT: ", self, ": authority_remote_reliable(): data: ", data)
