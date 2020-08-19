luxury_decor.upper_letters = function(str, s, e)
    if not e then e = str:len() end
    local substr1 = (s == 1 and "" or str:sub(1, s))
    local substr_replace = str:sub(s, e)
    local substr2 = (e == str:len() and "" or str:sub(e+1, str:len()))
    
    local new_upper_str = ""
    for s in substr_replace:gmatch(".") do
        new_upper_str = new_upper_str .. s:upper()
    end
    
    return substr1 .. new_upper_str .. substr2
end


