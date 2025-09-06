local lfs = require 'lfs'

local cjson = require 'cjson'
local cjson_safe = require 'cjson.safe'

local utils = {
  jsonParser = cjson.new()
}

-- From https://gist.github.com/jrus/3197011
function utils.newGuid()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and math.random(0, 15) or math.random(8, 11)
    return string.format('%x', v)
  end)
end

---Get the name of the running OS.
---@return 'Windows'|'Linux'
function utils.getOS()
  local nullDevice = package.config:sub(1,1) == "\\" and "NUL" or "/dev/null"

  local uname = io.popen('uname -s 2>' .. nullDevice)
  if uname then
    local osname = uname:read('*l')
    uname:close()

    if osname then
      return osname
    end
  end

  return "Windows"
end

--- Check if a path exists
---@param path string
---@return boolean
function utils.exists(path)
  local ex = lfs.attributes(path)
  if not ex then
    return false
  end

  return true
end

---Create a directory only if it does not exist
---@param path string
function utils.mkdir(path)
  if not utils.exists(path) then
    local success, err = lfs.mkdir(path)
    if success == nil then
      io.write('ERROR: could not create ' .. path .. ': ')
      print(err)

      os.exit(1)
    end
  end
end

---Write to an arbitrary file.
---@param path string
---@param data string
function utils.writeTo(path, data)
  local file, err = io.open(path, 'w')
  if not file then
    io.write('ERROR: Unable to write to ')
    print(err)

    os.exit(1)
  end

  file:write(data)
  file:close()
end

---Write the date to a json file.
---@param path string
---@param date integer
function utils.writeData(path, date)
  if not utils.exists(path) then
    local data = {
      { timeStamp = date, fmt = os.date('%A %d, %B %Y', date), id = utils.newGuid()},
    }

    setmetatable(data, cjson.array_mt)

    local json = cjson.encode({
      chargeData = data
    })

    utils.writeTo(path, json)
    return
  end

  local jsonDecoded = utils.getDataDecoded()
  table.insert(
    jsonDecoded.chargeData,
    { timeStamp = date, fmt = os.date('%A %d, %B %Y', date), id = utils.newGuid() }
  )

  local jsonEncoded = cjson.encode(jsonDecoded)

  utils.writeTo(path, jsonEncoded)
end

function utils.getDataDecoded()
  local path = utils.getDataFile()
  if not path then
    os.exit(1)
  end

  local file, err = io.open(path, 'rb')
  if not file then
    io.write('ERROR: Unable to read from ')
    print(err)

    os.exit(1)
  end

  local content = file:read('*a')
  file:close()

  return cjson.decode(content)
end

---Get the path of the data file.
---@return string|nil
function utils.getDataFile()
    local osname = utils.getOS()

  if osname == 'Linux' then
    local home  = os.getenv('HOME')
    local dataDir = home .. '/.local/share/headphone_battery'

    utils.mkdir(home .. '/.local')
    utils.mkdir(home .. '/.local/share')
    utils.mkdir(dataDir)

    return dataDir .. '/data.json'
  elseif osname == 'Windows' then
    local localAppData = os.getenv('LOCALAPPDATA')
    local program = localAppData .. '\\Programs' .. '\\HeadphoneBattery'

    utils.mkdir(localAppData .. '\\Programs')
    utils.mkdir(program)

    return program .. '\\data.json'
  end

  return nil
end

return utils
