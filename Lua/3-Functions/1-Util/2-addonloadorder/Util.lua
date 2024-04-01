local HM = hypermod

--- returns if `value` exists and is `valid`
--- @return boolean
HM.valid = function(mo) return mo and mo.valid end

--- returns if the `value` exists and is higher than `value2`
--- @return boolean
HM.higherthan = function(value, value2) return value and value > value2 end

--- returns one of SRB2's video transparency values based on a number
---
--- example: `function(50)` would return `V_50TRANS`
--- @return V_nnTRANS
HM.TimeTrans = function(time, speed)
    speed = speed or 1
    local level = (time / speed / 10) * 10
    level = max(10, min(100, level))
    
    if level == 100 then
        return nil
    else
        return _G["V_" .. (100 - level) .. "TRANS"]
    end
end

--- makes a number respect its bounds by wrapping around them.
---
--- example: `function(7, 1, 5)` would return `2`.
--- why? because the moment it exceeds the `maxValue`, it wrapped back to `minValue`
--- and accounted for the remainder. if the number was much higher, the process would repeat until there is no remainder
--- @return int
HM.wrapValue = function(value, minValue, maxValue)
    local range = maxValue - minValue + 1
    return ((value - minValue) % range + range) % range + minValue
end	