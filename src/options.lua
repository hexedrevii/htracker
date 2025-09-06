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
    print('Idek how this fucking happened lol')
    os.exit(1)
  end

  utils.writeData(dataFile, osDate)

  print('Successfully added data to charge log.')
end

function options.deleteData()
  local dataFile = utils.getDataFile()
  if not dataFile then
    print('Idek how this fucking happened lol')
    os.exit(1)
  end

  os.remove(dataFile)
end

return options
