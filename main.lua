local argParser = require 'src.parser'
local options   = require 'src.options'

local helpString = [[

Options:
  [LONG]     [SHORT] [VAR]   [DESCRIPTION]
  --add      -a      [date]  Add a new date to the logs. (mm/dd/yyyy format)
  --list-id  -i      [ID]    Show a specific entry using its ID.
  --remove   -r      [ID]    Remove an entry based on its ID

Flags:
  [LONG]    [SHORT]  [DESCRIPTION]
  --list    -l       List every single entry in the logs.
  --help    -h       Display this message

  --delete-all-data-im-super-sure    Remove every single entry from the logs (CANNOT BE UNDONE.)

This program is licensed under GPL 3.0 <3]]

-- Set random seed for GUID generation
math.randomseed(os.time())

-- Initialise parser
local parser = argParser:new()

parser:setNothingProvided(function ()
  print('No Option or Flag provided!\nUSAGE: lua main.lua [Options] [Flags] OR ./htrack [Options] [Flags]')
  print(helpString)
end)

parser:pushOption('add', 'a', false)
parser:pushOption('list-id', 'i', false)
parser:pushOption('remove', 'r', false)

parser:pushFlag('delete-all-data-im-super-sure', nil, false)
parser:pushFlag('list', 'l', false)
parser:pushFlag('help', 'h', false)

-- Parse arguments
parser:parse(arg)

if parser:hasFlag('help') then
  print("Headphone Charge Tracker! (v1.0)\n\nEasily track how long your battery lasts with this simple CLI Utility!")
  print(helpString)

  os.exit(1)
end

if parser:hasFlag('delete-all-data-im-super-sure') then
  options.deleteData()
  print('data.json has now been deleted and all data has been lost. I hope you are happy.')

  os.exit(0)
end

local lsId = parser:getValue('list-id')
if lsId then
  options.listId(lsId)
end

local rmId = parser:getValue('remove')
if rmId then
  options.remove(rmId)
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


