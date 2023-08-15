local original = _G.ChatEdit_InsertLink

function ChatEdit_InsertLink(text)
  local cursorPosition = MacroFrameText:GetCursorPosition()
  if MacroFrameText and MacroFrameText:HasFocus() and cursorPosition > 0 and strsub(MacroFrameText:GetText(), cursorPosition, cursorPosition) ~= '\n' then
    MacroFrameText:Insert(text)
  else
    return original(text)
  end
end

_G.ChatEdit_InsertLink = ChatEdit_InsertLink
