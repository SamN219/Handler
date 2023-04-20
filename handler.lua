local handler = {} --@class handler events

--@class pandora function
local getBot = _G.getBot
local getPlayers = _G.getPlayers
local getObjects = _G.getObjects
local getTiles = _G.getTiles
local getTile = _G.getTile
local getPing = _G.getPing

--@class lua api
local mfloor = math.floor
local tinsert = table.insert
local tremove = table.remove
local smatch = string.match
local sfind = string.find
local ssub = string.sub
local sgsub = string.gsub
local time = os.time

function handler.log(files,text)
    local file = io.open(files..".txt","a")
    file:write(text.."\n")
    file:close()
end

function handler.warp(world,id)
    local nuked = 0
    while getBot().status ~= "online" do
        connect()
        sleep(10000)
    end
    while getBot().world:upper() ~= world:upper() and not handler.nuked do
        sendPacket(3, "action|join_request\nname|"..world:upper().."\nvintedWorld|0")
        sleep(10000)
        if nuked >= 30 then
            handler.nuked = true
        else
            nuked = nuked + 1
        end
    end
    local stuck = 0
    while getTile(mfloor(getBot().x / 32),mfloor(getBot().y / 32)).fg == 6 and do
        sendPacket(3, "action|join_request\nname|"..world:upper().."|"..id:upper().."\nvintedWorld|0")
        sleep(5000)
        if stuck >= 20 then
            handler.stuck = true
            handler.log("stuck","["..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60)).."] "..getBot().name.." Stuck At "..getBot().world)
            break
        else
            stuck = stuck + 1
        end
    end
    handler.stuck = false
end

return handler
