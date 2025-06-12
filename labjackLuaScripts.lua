--[[
Wait for temp to hit 180
once temp hits 180 start loop
turn on nitrogen
When nitrogen gets to a certain point Bladder sensor will spike
when bladder pressure is within 200 psi of nitrogen supply cut nitogen supply 
wait 3 seconds
Turn on nitrogen exhaust
wait for exhaust spike. when exhaust > 200 psi close r3
wait 3 seconds 
repeat loop 
--]]
--------------------------------------
--Relay assignments
local nitrogen_Relay = "EIO0"
local nitorgen_Exhaust = "EIO1"
local heater_Connection = "EIO2"
local relay3 = "EIO3"
local relay4 = "EIO4"
local relay5 = "EIO5"
local relay6 = "EIO6"
local relay7 = "EIO7"
local relay8 = "CIO0"
local relay9 = "CIO1"
local relay10 = "CIO2"
local relay11 = "CIO3"
--------------------------------------
--Sensor Assignments
Hydrostatic_pressure = MB.readName("AIN10")
Nitrogen_supply = MB.readName("AIN6")
Exhaust_pressure = MB.readName("AIN8")
Bladder_pressure = MB.readName("AIN0")
temperature_sensor = MB.readName("AIN13")
--------------------------------------

local devtype = MB.readName("PRODUCT_ID")
print(devtype)

--May have to swap these through the conversion factor to translate from signal to actual
--local arbitraryValue = 0.000600
--local hydrostatic_threshold = 0.000600
--local nitrogen_threshold = 0.000600
local exhaust_threshold = 200
--local bladder_threshold = 0.000600
local temperature_threshold = 180
-- Configure a 100ms interval
LJ.IntervalConfig(0, 100)

MB.writeName(heater_Connection, 0) --Step 4

while at_temp = false do
    if LJ.CheckInterval(0) then
        if temperature_sensor >= temperature_threshold then
            at_temp = true 
            MB.writeName(heater_Connection, 1)
        else
            print("Current Temp: ", temperature_sensor, " F")
        end
    end
end
while at_temp = true do --Step 5
    if LJ.CheckInterval(0) then 
        MB.writeName(nitrogen_Relay, 0)
        --Step 6-----------------------
            -- nitrogen supply pressure increases at a certain point it triggers a spike in the bladder pressure when bladder pressure gets to within +- 200psi of nitrogen supply, cut the nitrogen supply
        --Step 7-----------------------
            --wait 3 seconds
        --Step 8-----------------------
        MB.writeName(nitorgen_Exhaust, 0)
        --Step 9-----------------------
        --Nitrogen supply will decrease and at a certain point trigger a spike in exhaust pressure when nitrogen supply exceeds 200 psi cut the exhaust 
        if MB.readName("AIN6") > 200 then
            MB.writeName(nitorgen_Exhaust, 1)
        end
        --Step 10----------------------
        --wait 3 seconds
        --Step 11----------------------
        --loop
    end
end
