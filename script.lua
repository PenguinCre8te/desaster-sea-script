local executor = "unknown"
pcall(function()
    if identifyexecutor then
        executor = identifyexecutor():lower()
    end
end)
print("Running on executor:", executor)

local success, _queue = pcall(function()
    return (syn and syn.queue_on_teleport)
        or queue_on_teleport
        or (fluxus and fluxus.queue_on_teleport)
end)
local queue_on_tp = success and _queue or function(...) end

local targetPosition = Vector3.new(36, 123, -4122) -- Teleport location
local player = game:GetService("Players").LocalPlayer
local teleportService = game:GetService("TeleportService")
local remotesRoot1 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local remotePromiseFolder = game:GetService("ReplicatedStorage")
    :WaitForChild("Shared")
    :WaitForChild("Network")
    :WaitForChild("RemotePromise")
local remotesRoot2 = remotePromiseFolder:WaitForChild("Remotes")
local EndDecisionRemote = remotesRoot1:WaitForChild("EndDecision")

local hasPromise = true
local RemotePromiseMod
do
    local ok, mod = pcall(function()
        return require(remotePromiseFolder)
    end)
    if ok and mod then
        RemotePromiseMod = mod
    else
        hasPromise = false
        warn("↳ Free Executor doesn't support RemotePromise, using fallback method")
    end
end

-- Function to teleport and activate ProximityPrompt
local function teleportAndActivatePrompt()
    if player and player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(targetPosition)

            -- Small delay for teleport processing
            task.wait(0.5)

            -- Find and activate ProximityPrompt
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj:InputHoldBegin(player)
                    task.wait(0.5)
                    obj:InputHoldEnd(player)
                    break
                end
            end

            -- Wait 1 second before rejoining
            task.wait(1)

            -- Rejoin the game
            teleportService:Teleport(game.PlaceId, player)
			queue_on_tp('loadstring(game:HttpGet("https://raw.githubusercontent.com/PenguinCre8te/Auto-bond-dead-rails/refs/heads/main/script.lua"))()') -- For examlpe 'loadstring(game:HttpGet("https://raw.githubusercontent.com/PenguinCre8te/Auto-bond-dead-rails/refs/heads/main/script.lua"))()'
        end
    end
end

-- Execute teleportation & activation
teleportAndActivatePrompt()
