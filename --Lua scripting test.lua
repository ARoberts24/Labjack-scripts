--[[
  Program to trigger relays depending on incoming sensor data. 
]]
--[[
Hydrostatic
Bladder
Nitrogen
exhaust_ 
--]]

-- Assume the user is using T7+RB12+CB37

--------------------------------------
--Relays assigned to pressure sensors
local prelay0 = "EIO0"
local prelay1 = "EIO1"
local prelay2 = "EIO2"
local prelay3 = "EIO3"
--------------------------------------
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

--May have to swap these through the conversion factor to translate from signal to actual
local arbitraryValue = 0.000600
local hydrostatic_threshold = 0.000600
local nitrogen_threshold = 0.000600
local exhaust_threshold = 0.000600
local bladder_threshold = 0.000600
local temperature_threshold = 180
-- Configure a 100ms interval
LJ.IntervalConfig(0, 100)
local at_temp = false 
if 
while at_temp do
  -- If an interval is done
  if LJ.CheckInterval(0) then
    -- Get an input reading
    local hydrostatic_sensor = MB.readName("AIN10")
    print("AIN10: ", hydrostatic_sensor, " psi")
    
    local nitrogen_sensor = MB.readName("AIN6")
    print("AIN8: ", nitrogen_sensor, " psi")
    
    local exhaust_sensor = MB.readName("AIN8")
    print("AIN10: ", exhaust_sensor, " psi")
    
    local bladder_sensor = MB.readName("AIN0")
    print("AIN13: ", bladder_sensor, " psi ")
    
    -- If pressures exceed or fall below threshold
    if hydrostatic_sensor > hydrostatic_threshold then
      -- Set outpin high
      MB.writeName(prelay0, 1)
      --print(1, "high")
      print("AIN10 triggered HIGHER than threshold")
    elseif hydrostatic_sensor < hydrostatic_threshold then
      -- Set outpin low
      --TRIGGERS RELAY
      MB.writeName(prelay0, 0)
     print("AIN10 triggered LOWER than threshold")
    end
    
    if nitrogen_sensor > nitrogen_threshold then
      -- Set outpin high
      MB.writeName(prelay1, 1)
      --print(1, "high")
      print("AIN8 triggered HIGHER than threshold")
    elseif nitrogen_sensor < nitrogen_threshold then
      -- Set outpin low
      --TRIGGERS RELAY
      MB.writeName(prelay1, 0)
     print("AIN8 triggered LOWER than threshold")
    end
    
    if exhaust_sensor > exhaust_threshold then
      -- Set outpin high
      MB.writeName(prelay2, 1)
      --print(1, "high")
      print("AIN10 triggered HIGHER than threshold")
    elseif exhaust_sensor < exhaust_threshold then
      -- Set outpin low
      --TRIGGERS RELAY
      MB.writeName(prelay2, 0)
     print("AIN10 triggered LOWER than threshold")
    end

    if bladder_sensor > bladder_threshold then
      -- Set outpin high
      MB.writeName(prelay3, 1)
      --print(1, "high")
      print("AIN10 triggered HIGHER than threshold")
    elseif bladder_sensor < bladder_threshold then
      -- Set outpin low
      --TRIGGERS RELAY
      MB.writeName(prelay3, 0)
     print("AIN10 triggered LOWER than threshold")
    end
    
  end
end