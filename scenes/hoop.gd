extends Sprite2D

@onready var you_win_screen = %you_win_screen

var ball_entered = false
# ball entering hoop
func _on_ball_entering_body_entered(body):
	if body.name == "basky":
		ball_entered = true
		print(body.name + " entered")

# ball leaving hoop
func _on_ball_leaving_body_exited(body):
	if ball_entered and body.name == "basky":
		you_win_screen.text = "You Win"
		print(body.name + " exited")
		ball_entered = false
