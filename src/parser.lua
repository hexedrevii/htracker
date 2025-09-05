---@class parser
---@field options table
---@field private __values table
---@field private __flags boolean[]
---@field private __required table
local parser = {}
parser.__index = parser

function parser:new()
  local p = {
    options = {},

    __values = {},
    __flags  = {},
    __required = {}
  }

  return setmetatable(p, parser)
end

---Add new option to the parser
---@param long string
---@param short string
---@param isFlag boolean
---@param isRequired boolean
function parser:push(long, short, isFlag, isRequired)
  if isRequired then
    -- Set to false because they aren't provided yet!
    self.__required[long]  = false
    self.__required[short] = false
  end

  self.options['--'..long] = { flag = isFlag, required = isRequired, long = long, short = short }
  self.options['-'..short] = { flag = isFlag, required = isRequired, long = long, short = short }
end

---@param args string[]
function parser:parse(args)
  local value = false

  for i, arg in ipairs(args) do
    if value then
      value = false
      goto continue
    end

    local opt = self.options[arg]
    if opt == nil then
      print("Unrecognised flag or option: " .. arg)
      goto continue
    end

    if not opt.flag then
      local val = args[i + 1]
      self.__values[opt.short] = val
      self.__values[opt.long]  = val

      if opt.required then
        self.__required[opt.short] = true
        self.__required[opt.long]  = true
      end

      value = true
      goto continue
    end

    self.__flags[opt.short] = true
    self.__flags[opt.long]  = true

    if opt.required then
      self.__required[opt.short] = true
      self.__required[opt.long]  = true
    end

    ::continue::
  end

  -- Check if any required options aren't present
  local missing = {}
  for name, present in pairs(self.__required) do
    if not present then
      table.insert(missing, name)
    end
  end

  if #missing > 0 then
    print("Missing required options: " .. table.concat(missing, ", "))
    os.exit(1)
  end
end

function parser:getValue(name)
  return self.__values[name]
end

---@param name string
function parser:hasFlag(name)
  if self.__flags[name] then
    return true
  end

  return false
end

return parser
