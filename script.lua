local targetPosition = Vector3.new(36, 123, -4122) -- Teleport location
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

            -- Rejoin the game
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end

-- Execute teleportation & activation
teleportAndActivatePrompt()
