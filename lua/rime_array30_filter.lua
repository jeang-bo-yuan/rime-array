--[[
這個檔案實作了rime-array30專用的filter
功能：
    - 將簡碼中的「NULL數字」轉成「□」
]]

local function filter(input, env)
    local input_str = env.engine.context.input
    local preserve_null = string.match(input_str, "^[a-z;,./][a-z;,./]?$") -- 只有輸入碼是簡碼時才要保留NULL

    for cand in input:iter() do
        if string.match(cand.text, "NULL") then
            if preserve_null then
                local c = Candidate(cand.type, cand.start, cand._end, "□", "")
                c.preedit = cand.preedit
                yield(c)
            end
        else
            yield(cand)
        end
    end
end

return filter