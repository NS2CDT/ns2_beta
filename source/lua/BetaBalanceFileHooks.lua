if Locale then
    local sntl_strings = {
        ["FOCUS"] = "Blight",
        ["FOCUS_TOOLTIP"] = "Upon a hit, parasites and indicates health",
    }

    local old_Locale_ResolveString = Locale.ResolveString
    function Locale.ResolveString(text)
        return sntl_strings[text] or old_Locale_ResolveString(text)
    end
end
