local argParser = require 'src.parser'
local options   = require 'src.options'

-- Initialise parser
local parser = argParser:new()

parser:pushOption('add', 'a', false)

parser:pushFlag('remove-all-data-im-super-sure', nil, false)

-- Parse arguments
parser:parse(arg)

if parser:hasFlag('remove-all-data-im-super-sure') then
  options.deleteData()
  print('data.json has now been deleted and all data has been lost. I hope you are happy.')
end

local date = parser:getValue('add')
if date then
  options.addDate(date)
end
