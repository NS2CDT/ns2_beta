if Player.OnInitLocalClient then
    local oldOnInitLocalClient = Player.OnInitLocalClient
    function Player:OnInitLocalClient()
        oldOnInitLocalClient(self)

        local oldVersion = Client.GetOptionInteger("balancemod_version", 0)
        if kBBMVersion > oldVersion then
            Client.SetOptionInteger("balancemod_version", kBBMVersion)
            Shared.ConsoleCommand("changelog")
        end

    end
end