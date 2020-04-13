ModLoader.SetupFileHook("lua/menu2/GUIMainMenu.lua", "lua/BetaBalanceNewsFeed.lua", "post")
ModLoader.SetupFileHook("lua/Player_Client.lua", "lua/BetaBalancePlayer.lua", "post")

if Locale then
    local sntl_strings = {
        
    }

    local old_Locale_ResolveString = Locale.ResolveString
    function Locale.ResolveString(text)
        return sntl_strings[text] or old_Locale_ResolveString(text)
    end
end

