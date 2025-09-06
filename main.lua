local argParser = require 'src.parser'
local options   = require 'src.options'

-- Set random seed for GUID generation
math.randomseed(os.time())

-- Initialise parser
local parser = argParser:new()

parser:pushOption('add', 'a', false)
parser:pushOption('list-id', 'i', false)

parser:pushFlag('delete-all-data-im-super-sure', nil, false)
parser:pushFlag('list', 'l', false)

-- Parse arguments
parser:parse(arg)

if parser:hasFlag('delete-all-data-im-super-sure') then
  options.deleteData()
  print('data.json has now been deleted and all data has been lost. I hope you are happy.')

  os.exit(0)
end

local lsId = parser:getValue('list-id')
if lsId then
  options.listId(lsId)
end

local date = parser:getValue('add')
if date then
  options.addDate(date)
  os.exit(0)
end

if parser:hasFlag('list') then
  options.listAll()
  os.exit(0)
end


