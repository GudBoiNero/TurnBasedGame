extends Obj
class_name InteractableObj

func destroy():
	print("destroyed")
	queue_free()
