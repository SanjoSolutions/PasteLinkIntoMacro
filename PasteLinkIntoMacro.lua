do
  local original = _G.ChatEdit_InsertLink

  function ChatEdit_InsertLink(text)
    if MacroFrameText and MacroFrameText:HasFocus() then
      local cursorPosition = MacroFrameText:GetCursorPosition()
      if cursorPosition > 0 and strsub(MacroFrameText:GetText(), cursorPosition, cursorPosition) ~= '\n' then
        MacroFrameText:Insert(text)
        return true
      end
    end

    return original(text)
  end

  _G.ChatEdit_InsertLink = ChatEdit_InsertLink
end

do
  local originalUIParentLoadAddOn = _G.UIParentLoadAddOn

  local hasBeenPatched = false

  function UIParentLoadAddOn(name)
    local returnValue = originalUIParentLoadAddOn(name)

    if not hasBeenPatched and name == 'Blizzard_Professions' then
      local originalInitLinkDropdown = _G.ProfessionsCraftingPageMixin.InitLinkDropdown

      function InitLinkDropdown(self)
        originalInitLinkDropdown(self)

        do
          local info = UIDropDownMenu_CreateInfo()
          info.notCheckable = true
          info.text = 'Insert somewhere'
          info.isTitle = true
          UIDropDownMenu_AddButton(info)
        end

        do
          local info = UIDropDownMenu_CreateInfo()
          info.notCheckable = true
          info.func = function (_, channel)
            local link = C_TradeSkillUI.GetTradeSkillListLink()
            MacroFrameText:Insert(link)
          end
          info.text = 'Macro'
          info.disabled = not _G.MacroFrameText
          UIDropDownMenu_AddButton(info)
        end
      end

      _G.ProfessionsCraftingPageMixin.InitLinkDropdown = InitLinkDropdown

      local craftingPage = _G.ProfessionsFrame.CraftingPage
      local linkDropDown = craftingPage.LinkDropDown
      UIDropDownMenu_Initialize(linkDropDown, GenerateClosure(InitLinkDropdown, linkDropDown), 'MENU')

      hasBeenPatched = true
    end

    return returnValue
  end

  _G.UIParentLoadAddOn = UIParentLoadAddOn
end
