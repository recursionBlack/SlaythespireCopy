# meta-name: Effect
# meta-description: Create a effect which can be applied to a target
extends Effect
class_name MyAwesomeEffect

var member_var := 0


func execute(targets: Array[Node]) -> void:
	print("My effect targets them: %s" % targets)
	print("It does %s something" % member_var)
