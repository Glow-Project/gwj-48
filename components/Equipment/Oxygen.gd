extends Spatial

# emit signal that oxygen has been lost with convenient values
signal loss(loss, seconds_left, percent_left)

# emit signal when oxygen tank is empty
signal empty()

# Define the initial supply of oxygen in seconds (if loss_rate is set to 1).
export(int,60,600,60) var initial_supply = 5*60

# Define how fast the oxygen should fall. If set to one, the oxygen falls 1/second.
export(float) var loss_rate = 1.0

export var supply_left: int = initial_supply

func _on_Timer_timeout() -> void:
	# Decrement supply once per tick, if the supply should be falling
	# faster/slower, please use the loss_rate.
	# Having the supply_left decremented with a loss_rate of 1, makes
	# the supply decrease once per second. The supply_left will equal
	# the remaining seconds until no oxygen is left anymore.
	supply_left -= 1

	# If the supply_left is less than zero, emit the empty signal.
	if supply_left == 0:
		emit_signal("empty")

	emit_signal("loss", loss_rate, supply_left, percent()) 

	# update wait time if loss rate has been changed due to a smaller or
	# bigger crack in the helmet.
	$Timer.wait_time = 1.0/loss_rate

func percent() -> float:
	return clamp(100.0 / initial_supply * supply_left, 0,100)

func _on_OxygenTank_loss(_loss, _seconds_left, percent_left) -> void:
	$Barometer/Needle.rotation_degrees = Vector3(0,-((180+112)/100.0*percent_left),0)
