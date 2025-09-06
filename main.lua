local argParser = require 'src.parser'
local options   = require 'src.options'

-- Initialise parser
local parser = argParser:new()

parser:pushOption('add', 'a', false)

-- Parse arguments
parser:parse(arg)

local date = parser:getValue('add')
if date then
  options.addDate(date)
end
