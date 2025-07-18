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
local nitrogen_Exhaust = "EIO1"
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
--Sensor Baselines
Hydrostatic_pressure_baseline = (MB.readName("AIN10")  * 2798)-2456
Nitrogen_supply_baseline      = (MB.readName("AIN6")   * 2798)-2456
Exhaust_pressure_baseline     = (MB.readName("AIN8")   * 2798)-2456
Bladder_pressure_baseline     = (MB.readName("AIN0")   * 2798)-2456
temperature_sensor_baseline   = (MB.readName("AIN13")  * 2798)-2456

local devtype = MB.readName("PRODUCT_ID")
print(devtype)

--May have to swap these through the conversion factor to translate from signal to actual
--local arbitraryValue = 0.000600
--local hydrostatic_threshold = 0.000600
--local nitrogen_threshold = 0.000600
local exhaust_threshold = 200
--local bladder_threshold = 0.000600
local temperature_threshold = 180

-- Configure a timing intervals
LJ.IntervalConfig(0, 100)
LJ.IntervalConfig(1,3000)

--Shut All Relays 
MB.writeName(heater_Connection, 1)
MB.writeName(nitrogen_Relay,    1)
MB.writeName(nitrogen_Exhaust,  1)
--------------------------------------

MB.writeName(heater_Connection, 0) --Step 4
print("Checking temp")
local at_temp = false
while at_temp == false do
    if LJ.CheckInterval(0) then
        if ((MB.readName("AIN13") * 2798)-2456)>= temperature_threshold then
            at_temp = true 
            MB.writeName(heater_Connection, 1)
            print("TEMP DEBUG")
            break
        else
            print("Current Temp: ", (MB.readName("AIN13") * 2798)-2456, " F")
        end
    end
end
print("LINE 64 DEBUG")
while at_temp == true do --Step 5
    MB.writeName(nitrogen_Relay, 0)
    --Step 6-----------------------
        -- nitrogen supply pressure increases at a certain point it triggers a spike in the bladder pressure when bladder pressure gets to within +- 200psi of nitrogen supply, cut the nitrogen supply
        print("LINE 69 DEBUG nice")
    local is_it_eq_yet = false
    while is_it_eq_yet == false do
        if MB.readName("AIN0") >= ((MB.readName("AIN6")  * 2798)-2456)+200 and (MB.readName("AIN0")  * 2798)-2456 <= ((MB.readName("AIN6")  * 2798)-2456)-200 then
            MB.writeName(nitrogen_Relay, 1)
            print("Triggered Step 6")
            is_it_eq_yet = true
            break
        end
    end  
        --Step 7-----------------------
        --wait 3 seconds
        while true do
            if LJ.CheckInterval(1) then
              print(" Step 7 Wait is done")
              break
            end
          end
    --Step 8-----------------------
    MB.writeName(nitrogen_Exhaust, 0)
    --Step 9-----------------------
    --Nitrogen supply will decrease and at a certain point trigger a spike in exhaust pressure when nitrogen supply exceeds 200 psi cut the exhaust 
    if ((MB.readName("AIN6")  * 2798)-2456) > 200 then
        MB.writeName(nitrogen_Exhaust, 1)
        print("Triggered Step 9")
    end
    --Step 10----------------------
    --wait 3 seconds
    while true do
        if LJ.CheckInterval(1) then
          print("Step 10 wait is done looping")
          break
        end
      end
    --Step 11----------------------
    --loop
end