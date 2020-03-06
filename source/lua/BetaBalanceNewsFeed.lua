Log("Loading BetaBalanceNewsFeed.lua for NS2 Balance Beta mod.")

local kBetaBalanceWebpageURL = "https://ns2cdt.github.io/ns2_beta/"
local function AddNewsFeed()
    local navBar = GetNavBar()
    if navBar then
        local newsFeed = navBar.newsFeed
        if newsFeed then
            local result = newsFeed:AddWebPage(
            {
                name = "betaBalanceChangelog",
                label = "Beta Changelog",
                webPageParams =
                {
                    url = kBetaBalanceWebpageURL,
                    clickMode = "Full",
                    wheelEnabled = true,
                },
            }, 1)
            if result then
                newsFeed:SetCurrentPage("betaBalanceChangelog")
            else
                Log("Failed to add beta balance changelog webpage to newsfeed. (name already taken?)")
            end
        else
            Log("Main menu news feed not found!  Cannot add beta balance changelog to newsfeed.")
        end
    else
        Log("Main menu nav bar not loaded!  Cannot add beta balance changelog to newsfeed.")
    end

end

local oldCreateMainMenu = CreateMainMenu
function CreateMainMenu()
    oldCreateMainMenu()

    AddNewsFeed()
end

local function showChangeLog()
    if Shine then
        Shine:OpenWebpage(kBetaBalanceWebpageURL, "Beta Balance Changelog")
    elseif Client.GetIsSteamOverlayEnabled() then
        Client.ShowWebpage(kBetaBalanceWebpageURL)
    else
        Print("Couldn't open changelog because no web view (steam overlay) is available")
    end
end
Event.Hook("Console_changelog", showChangeLog)