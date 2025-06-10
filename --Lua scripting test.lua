--Lua scripting test
print("We  know how these shake out which is a good start")
--monitor all relevant data and trigger an event 
--Should probs get a list of incoming sensor data but for now we start with one 
--Shoot signal through relay board 

--if "sensor" hits "arbitrary number"
--then Flip relay

--[[
    Name: set_dio_based_on_voltage.lua
    Desc: This example shows how to set DIO according to an input voltage
    Note: This example requires firmware 1.0282 (T7) or 1.0023 (T4)
--]]

-- Assume the user is using a T7, toggle FIO3
local outpin = "EIO0"
local devtype = MB.readName("PRODUCT_ID")
print(devtype)
-- If the user is actually using a T4, toggle FIO5
if devtype == 4 then
  --outpin = "FIO5"
  print("I have no idea how we got here")
end
local arbitraryValue = 0.000600
local threshold = arbitraryValue
-- Configure a 100ms interval
LJ.IntervalConfig(0, 100)

while true do
  -- If an interval is done
  if LJ.CheckInterval(0) then
    -- Get an input reading
    local sensIn = MB.readName("AIN6")
    print("AIN1: ", sensIn, " whatever")
    -- If vin exceeds the threshold (2.5V)
    if sensIn > threshold then
      -- Set outpin high
      MB.writeName(outpin, 1)
      --print(1, "high")
      print("triggered higher than threshold")
    else
      -- Set outpin low
      MB.writeName(outpin, 0)
     -- print(0, "low")
     print("triggered lower than threshold")
    end
  end
end