--[[
  Program to trigger relays depending on incoming sensor data. 
]]
--[[
4 solenoids
3 pressure sensors
1 thermocouple
--]]

-- Assume the user is using T7+RB12+CB37

--------------------------------------
--Relays assigned to pressure sensors
local prelay0 = "EIO0"
local prelay1 = "EIO1"
local prelay2 = "EIO2"
--------------------------------------
local relay3 = "EIO3"
local relay4 = "EIO4"
local relay5 = "EIO5"
local relay6 = "EIO6"
local relay7 = "EIO7"
local relay8 = "CIO0"
local relay9 = "CIO1"
local relay10 = "CIO2"
local relay11 = "CIO3"


local devtype = MB.readName("PRODUCT_ID")
print(devtype)

local arbitraryValue = 0.000600
local pressure_0_threshold = 0.000
local pressure_1_threshold = 0.000
local pressure_2_threshold = 0.000
-- Configure a 100ms interval
LJ.IntervalConfig(0, 100)

while true do
  -- If an interval is done
  if LJ.CheckInterval(0) then
    -- Get an input reading
    local pressure_sensor_0 = MB.readName("AIN6")
    print("AIN6: ", pressure_sensor_0, " whatever")
    
    local pressure_sensor_0 = MB.readName("AIN8")
    print("AIN8: ", pressure_sensor_0, " blamcos")
    
    local pressure_sensor_0 = MB.readName("AIN10")
    print("AIN10: ", pressure_sensor_0, " some unit of pressure I think")
   
  
    -- If pressures exceed or fall below threshold
    if pressure_sensor_0 > pressure_0_threshold then
      -- Set outpin high
      MB.writeName(prelay0, 1)
      --print(1, "high")
      print("triggered higher than threshold")
    elseif pressure_sensor_0 < pressure_0_threshold then
      -- Set outpin low
      --TRIGGERS RELAY
      MB.writeName(prelay0, 0)
     print("triggered lower than threshold")
    end
    if pressure_sensor_1 > pressure_1_threshold then
      -- Set outpin high
      MB.writeName(prelay1, 1)
      --print(1, "high")
      print("triggered higher than threshold")
    elseif pressure_sensor_1 < pressure_1_threshold then
      -- Set outpin low
      --TRIGGERS RELAY
      MB.writeName(prelay1, 0)
     print("triggered lower than threshold")
    end
    if pressure_sensor_2 > pressure_2_threshold then
      -- Set outpin high
      MB.writeName(prelay2, 1)
      --print(1, "high")
      print("triggered higher than threshold")
    elseif pressure_sensor_2 < pressure_2_threshold then
      -- Set outpin low
      --TRIGGERS RELAY
      MB.writeName(prelay2, 0)
     print("triggered lower than threshold")
    end
  end
end