
local ActivityPopu = class(require("popu.gameWindow"))

function ActivityPopu:ctor()
    GameSetting:setIsSecondScene(true)
end

function ActivityPopu:initView(data)

    -- NativeEvent.getInstance():openWeb(kPHPActivityURL);
    NativeEvent.getInstance():openWebView({})
end

function ActivityPopu:dismiss(...)
    GameSetting:setIsSecondScene(false)
    return ActivityPopu.super.dismiss(self, ...)
end

return ActivityPopu