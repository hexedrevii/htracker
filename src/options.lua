local utils = require "src.utils"
local options = {}

---@param date string The date to convert and add
function options.addDate(date)
  local m, d, y = date:match("^(%d%d)/(%d%d)/(%d%d%d%d)$")
  if not m or not d or not y then
    print("ERROR: Invalid date format! Expected: mm/dd/yyyy")
    os.exit(1)
  end

  local osDate = os.time({
    year  = y,
    month = m,
    day   = d
  })

  local dataFile = utils.getDataFile()
  if not dataFile then
    print('ERROR: Running program on unsupported OS.')
    os.exit(1)
  end

  utils.writeData(dataFile, osDate)

  print('Successfully added data to charge log.')
end

function options.deleteData()
  local dataFile = utils.getDataFile()
  if not dataFile then
    print('ERROR: Running program on unsupported OS.')
    os.exit(1)
  end

  os.remove(dataFile)
end

function options.remove(id)
  local jsonDecoded = utils.getDataDecoded()
  local found = false
  for idx, date in ipairs(jsonDecoded.chargeData) do
    if date.id == id then
      table.remove(jsonDecoded.chargeData, idx)
      found = true

      break
    end
  end

  if found then
    utils.writeAll(jsonDecoded)
    print('Successfully removed entry with ID ' .. id)
  else
    print('No entry by that ID exits!')
  end
end

---@param id string
function options.listId(id)
  local jsonDecoded = utils.getDataDecoded()
  local found = false
  for _, date in pairs(jsonDecoded.chargeData) do
    if date.id == id then
      print('Headphones put to charge on \27[38;5;10m' .. date.fmt .. '\27[0m!')
      found = true
    end
  end

  if not found then
    print('No entry using that ID was found!')
  end
end

function options.listAll()
  local jsonDecoded = utils.getDataDecoded()
  for idx, date in ipairs(jsonDecoded.chargeData) do
    print('Headphones put to charge on \27[38;5;10m' .. date.fmt .. '\27[0m! \27[38;5;8m(' .. date.id .. ')\27[0m')
    if idx ~= #jsonDecoded.chargeData then
      print()
    end
  end
end

return options
