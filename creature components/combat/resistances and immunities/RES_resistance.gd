# extends Resource
extends DamageTypes
class_name Resistance
@export var type:types
@export_range(0.0,0.99,1) var resPercent:float # try to keep this between 0 and 1 
var overflow:float 

func add(ammount):
    ''' add a value to the total resistance 
        only use this fro positive values
    '''
    var totalres = resPercent + ammount
    if totalres >= 1:
        overflow += (totalres-0.99)
    resPercent = clampf(totalres,0,0.99)

func subtract(ammount):
    ''' remove a value from the total
        use for negative values
    '''
    var totalres = resPercent - (ammount-overflow)
    match  ammount >= overflow:
        true:
            overflow = 0
        false:
            overflow -=ammount
    resPercent = clampf(totalres,0,0.99)