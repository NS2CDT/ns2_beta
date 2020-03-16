--[[
	Mod error report handling.
]]
if not Shine then return end -- Using some shine lib features

local ErrorQueue = {}
local Reported = {}

local URL = "http://ghoulofgsg9.bplaced.net/errorreport.php"

local BuildNumber = Shared.GetBuildNumber()
local OS = jit and jit.os or "Unknown"
local VM = decoda_name or "Unknown"

local StringFormat = string.format
local TableConcat = table.concat
local TableEmpty = table.Empty
local TableInsert = table.insert
local tonumber = tonumber
local tostring = tostring

local function ReportErrors()
    if #ErrorQueue == 0 then return end

    TableInsert(
            ErrorQueue,
            1,
            StringFormat(
                    "VM: %s Operating system: %s. Build number: %s.",
                    VM,
                    OS,
                    BuildNumber
            )
    )

    if Server then
        local ModCount = Server.GetNumActiveMods()
        local Mods = {}
        for i = 1, ModCount do
            Mods[ i ] = tostring( tonumber( Server.GetActiveModId( i ), 16 ) )
        end

        TableInsert( ErrorQueue, 2, "Installed mods: " .. TableConcat( Mods, ", " ) )
    end

    local PostData = TableConcat( ErrorQueue, "\n" )

    Shared.SendHTTPRequest( URL, "POST", { error = PostData, secret = "8RY86D14Dp" } )

    TableEmpty( ErrorQueue )
end

if Server  then
    Shine.Hook.Add( "EndGame", "ReportQueuedErrors", ReportErrors )
end

local ErrorReportTimer
local function ReportError(Error)
    if Reported[Error] then return end -- don't report the same error more than once per session

    Reported[Error] = true
    ErrorQueue[ #ErrorQueue + 1 ] = Error

    -- We cannot send error reports on disconnect/map change anymore due to HTTP requests being cancelled,
    -- thus we need to send errors as soon as possible after they occur to avoid them being lost.
    -- We debounce to ensure we catch a sequence of errors in a single request.
    ErrorReportTimer = ErrorReportTimer or Shine.Timer.Simple( 1, function()
        ErrorReportTimer = nil
        ReportErrors()
    end )
    ErrorReportTimer:Debounce()
end
Event.Hook("ErrorCallback", ReportError)