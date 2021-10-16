extends WorkstationData
class_name ForgeData


var maxHeat: float
var heat: float
var targetHeat: float
var heatAccumulation: float # range(1, 10), determines how quickly the forge reaches its target heat
var heatDissipation: float # range(1, 10), determines how quickly the forge loses heat


func rankUp() -> void:
	upgradeLevel += 1
	# increase stats
	return


func accumulateHeat(delta: float) -> void:
	if heat == 0: # prevents division by zero
		heat = 1
		return
	
	heat *= 1 + (float(heatAccumulation / 50.0) * (targetHeat / heat) * delta)
	if heat > maxHeat:
		heat = maxHeat
	return


func dissipateHeat(delta: float) -> void:
	heat *= 1 - (((float(11 - heatDissipation) / 100.0)) * (heat / maxHeat) * delta)
	if heat < 0:
		heat = 0
		return
	
	targetHeat *= 1 - (((float(11 - heatDissipation) / 100.0)) * ((heat / maxHeat) if targetHeat < heat else 1.0) * delta)
	if targetHeat < 0:
		targetHeat = 0
	return
