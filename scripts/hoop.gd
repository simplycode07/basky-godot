extends Sprite2D

@onready var you_win_screen = %you_win_screen

var ball_entered = false
var counter = 0

func _on_ball_entering_body_entered(body):
	ball_entered = true

func _on_ball_leaving_body_entered(body):
	if ball_entered:
		counter += 1
		you_win_screen.text = "You Win " + str(counter)
		ball_entered = false
