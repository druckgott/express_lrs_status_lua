-- Variables used across all instances

local function getV(id)
  -- Return the getValue of ID or nil if it does not exist
  local vcache = {} -- valueId cache
  local cid = vcache[id]
  if cid == nil then
    local info = getFieldInfo(id)
    -- use 0 to prevent future lookups
    cid = info and info.id or 0
    vcache[id] = cid
  end
  if cid == nil then return end
  return cid ~= 0 and getValue(cid) or nil
end

local function pwrToIdx(powval)
  local POWERS = {10, 25, 50, 100, 250, 500, 1000, 2000}
  for k, v in ipairs(POWERS) do
    if powval == v then return k - 1 end
  end
  return 7 -- 2000
end

local function drawPowerLvl(tlm)
  if tlm.tpwr == nil then return end
  lcd.drawText(0, 33, "Power:  " .. tostring(tlm.tpwr) .. "mW" , SMLSIZE)
  local curp = pwrToIdx(tlm.tpwr)
  lcd.drawGauge(87, 33, 40, 7, curp, 7)
end

local function drawRange(tlm)
    if tlm.ant == nil or ( tlm.rssi2 == nil and tlm.rssi1 == nil ) or tlm.rfmd+1 == nil then return end
    local rssi = (tlm.ant == 1) and tlm.rssi2 or tlm.rssi1
    local RFRSSI = {-128,-123, -115, -117, -112, -112, -112, -108, -105, -105, -104, -104, -104, -104, -112}
    local minrssi = (RFRSSI and RFRSSI[tlm.rfmd+1]) or -128
    if rssi > -50 then rssi = -50 end
    local rangePct = math.floor(100 * (rssi + 50) / (minrssi + 50) + 0.5)
    local rangePctStr = string.format("%d%%", rangePct)

    lcd.drawText(0, 44, "Range:  " .. rangePctStr, SMLSIZE)
    lcd.drawGauge(87, 44, 40, 7, rangePct, 100)
end

local function drawRfModeText(tlm)
  local RFMOD = {"-", "25Hz", "50Hz", "100Hz", "100HzFull", "150Hz", "200Hz", "250Hz", "333HzFull", "500Hz", "D250", "D500", "F500", "F1000", "D50"}
  if tlm.rfmd == nil or tlm.rfmd+1 == nil or tlm.rqly == nil then return end
  local modestr = (RFMOD and RFMOD[tlm.rfmd+1]) or ("RFMD " .. tostring(tlm.rfmd))
  lcd.drawText(0, 0, string.format("LQ:       %d%% (%d%%, %d%%)", tlm.rqly, tlm.rqly_min, tlm.rqly_max), SMLSIZE)
  lcd.drawText(0, 11, string.format("PaRate: %s", modestr), SMLSIZE)
end

local function drawRssiLq(tlm)
  if tlm.ant == nil or ( tlm.rssi2 == nil and tlm.rssi1 == nil ) then return end
  local rssi = (tlm.ant == 1) and tlm.rssi2 or tlm.rssi1
  local rssi_min = (tlm.ant_min == 1) and tlm.rssi2_min or tlm.rssi1_min
  local rssi_max = (tlm.ant_max == 1) and tlm.rssi2_max or tlm.rssi1_max
  lcd.drawText(0, 22, "Signal: " .. tostring(rssi) .. "dBm" .. " (" .. tostring(rssi_min) .. " " .. tostring(rssi_max) .. ")dBm", SMLSIZE)
  --lcd.drawText(0, 22, string.format("Signal: %d%dbm (%d%dbm, %d%dbm)", tonumber(rssi), tonumber(rssi_min), tonumber(rssi_max)), SMLSIZE)
end


local function run(event)
  -- Runs periodically only when telemetry script is active
  -- Update telemetry data and draw on the screen
  lcd.clear()
  
  local tlm = {
    rfmd = getV("RFMD"),
    rssi1 = getV("1RSS"),
    rssi1_min = getV("1RSS-"),
    rssi1_max = getV("1RSS+"),
    rssi2 = getV("2RSS"),
    rssi2_min = getV("2RSS-"),
    rssi2_max = getV("2RSS+"),
    rqly = getV("RQly"),
    rqly_min = getV("RQly-"),
    rqly_max = getV("RQly+"),
    ant = getV("ANT"),
    ant_min = getV("ANT-"),
    ant_max = getV("ANT+"),
    tpwr = getV("TPWR"),
  }
  
  local tlm_not_nil = true
  
  for k, v in pairs(tlm) do
    if v == nil then
        tlm_not_nil = false
        -- print("Der Wert für " .. k .. " ist nil.")
        -- Hier könntest du weitere Aktionen durchführen, wenn ein Wert nil ist
    end
    end

  if not tlm_not_nil then return end
  
  -- Draw telemetry data
  drawRange(tlm)
  drawRfModeText(tlm) -- nil fehler
  drawRssiLq(tlm)
  drawPowerLvl(tlm)

end

return { run=run }

