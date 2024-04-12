-- 在 modmain.lua 中
AddComponentPostInit("inspectable", function(self)
    -- 保存原始的 GetDescription 函数
    local originalGetDescription = self.GetDescription

    -- 重写 GetDescription 函数
    self.GetDescription = function(self, viewer)
        -- 调用原始函数获取默认描述
        local desc, context, author = originalGetDescription(self, viewer)

        -- 检查是否有特定的条件覆盖默认描述
        if not desc or viewer:HasTag("playerghost") or viewer:HasTag("mime") then
            return desc, context, author
        end

        -- 这里添加你的自定义描述逻辑
        -- 例如，对所有物品添加通用的自定义描述
        desc = "这是我观察到的一件非常有趣的物品。"

        -- 返回自定义描述
        return desc, context, author
    end
end)
