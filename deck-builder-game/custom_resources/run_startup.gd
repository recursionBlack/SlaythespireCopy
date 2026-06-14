extends Resource
class_name RunStartup

enum Type {NEW_RUN, CONTINUE_RUN}

@export var type: Type
@export var picked_character: CharacterStats
