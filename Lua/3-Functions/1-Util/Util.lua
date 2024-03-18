local HM = hypermod

--- returns if `value` exists and is `valid`
--- @return boolean
HM.valid = function(mo) return mo and mo.valid end

--- returns if the `value` exists and is higher than `value2`
--- @return boolean
HM.higherthan = function(value, value2) return value and value > value2 end