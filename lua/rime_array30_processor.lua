--[[
這個檔案實作了rime-array30專用的processor
功能：
    - 輸入碼為「w + 數字鍵」或「emoji」時，將「空白」轉「Page_Down」以將menu翻頁
    - 在輸入行列碼時，按下「空白」會轉成「!」，以輸入「特別碼」或「重碼字」
    - 輸入碼中有「未上屏的特別碼」 且 「用戶已開始輸入下一個字的字碼」，則直接上屏特別碼
]]

local Rejected, Accepted, Noop = 0, 1, 2
local alphabet = ""
local rime_array30_processor = {}

rime_array30_processor.init = function(env)
    alphabet = env.engine.schema.config:get_string("speller/alphabet")
end

rime_array30_processor.func = function(key_event, env)
    local input = env.engine.context.input -- 輸入的字串
    local is_ascii, ch = pcall(string.char, key_event.keycode) -- 按下的鍵

    -- 不處理按鍵䆁放 和 不是ascii的按鍵
    if key_event:release() or not is_ascii then
        return Noop
    end

    -- 「空白」轉「Page_Down」
    if (string.match(input, "^w[0-9]$") or string.match(input, "^[ASDFGHJKL]")) and ch == " " then
        env.engine:process_key(KeyEvent("Page_Down"))
        return Accepted
    -- 「空白」 轉 「!」
    elseif string.match(input, "^[a-z;,./]+$") and ch == " " then
        env.engine:process_key(KeyEvent("!"))
        return Accepted
    -- 自動上屏特別碼
    elseif string.match(input, "^.+!$") and string.find(alphabet, ch) then
        env.engine.context:confirm_current_selection()
        env.engine.context:clear()
        env.engine.context:push_input(ch)
        return Accepted
    end

    return Noop
end

return rime_array30_processor