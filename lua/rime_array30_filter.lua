--[[
這個檔案實作了rime-array30專用的filter
功能：
    - 將簡碼中的「NULL數字」轉成「□」
]]

local function filter(input, env)
    for cand in input:iter() do
        if string.match(cand.text, "NULL") then
            local c = Candidate(cand.type, cand.start, cand._end, "□", cand.comment)
            c.preedit = cand.preedit
            yield(c)
        else
            yield(cand)
        end
    end
end

return filter