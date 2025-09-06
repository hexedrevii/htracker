# Headphone charge tracker

A small CLI app I wrote to track my headphone battery lifetime.

# Usage
```txt
$ htracker -h
Headphone Charge Tracker! (v1.0)

Easily track how long your battery lasts with this simple CLI Utility!

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

This program is licensed under GPL 3.0 <3
```

# Running

## Build without compilation
This is a Lua app, so it is really simple to run.

Just download the dependencies.
```bash
# Getting lua

## Windows
winget install DEVCOM.Lua Git.git

## Ubuntu/Debian
sudo apt install lua5.4 luarocks git

## Fedora
sudo dnf install lua luarocks git

# Getting runtime dependencies
luarocks install lua-cjson
luarocks install luafilesystem
```

Now, you can clone and run.
```bash
git clone https://github.com/EveMeows/htracker
cd htracker

lua main.lua --help
```

## Compiling
If you want to turn the program into an executable, you can use luastatic.

```bash
# Get luastatic (works the same on both Linux and Windows)
luarocks install luastatic
```

First, we will need the lua development libraries

```bash
# Linux
## Ubuntu/Debian
sudo apt install liblua5.4-dev gcc g++ make

## Fedora
sudo dnf install lua-devel gcc g++ make

# Compiling
## Fedora
luastatic main.lua src/options.lua src/parser.lua src/utils.lua /usr/lib64/lua/5.4/lfs.so /usr/lib64/lua/5.4/cjson.so /usr/lib64/liblua-5.4.so -I/usr/include -o htracker

## Ubuntu
luastatic main.lua src/options.lua src/parser.lua src/utils.lua /usr/local/lib/lua/5.4/lfs.so /usr/local/lib/lua/5.4/cjson.so /usr/lib/x86_64-linux-gnu/liblua-5.4.so -I/usr/include/lua5.4 -o htracker

# Windows
I can't get it to work no matter how much I try :(
```

# License
MIT
