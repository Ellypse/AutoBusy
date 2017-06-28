local EVENTS = {
	ADDON_LOADED = "ADDON_LOADED",
	PLAYER_FLAGS_CHANGED = "PLAYER_FLAGS_CHANGED",
	PLAYER_LOGIN = "PLAYER_LOGIN"
};
local defaultOptions = {
	message = "I'm busy right now, can't answer you. Sorry.";
}

local function goDND()
	if not UnitIsDND("player") then
		SendChatMessage(EAB_Options.message, "DND");
	end
end

local function resetDND()
	if UnitIsDND("player") then
		SendChatMessage("", "DND");
	end
end

local function AddOn_Loaded()
	if not EAB_Options then
		EAB_Options = defaultOptions;
	end
end

local function OnEvent(self, event, ...)
	if event == EVENTS.ADDON_LOADED then
		if ... == "Ellypse_AutoBusy" then
			AddOn_Loaded();
		end
	elseif event == EVENTS.PLAYER_LOGIN or event == EVENTS.PLAYER_FLAGS_CHANGED then
		goDND();
	end
end

local frame = CreateFrame("FRAME", "Ellypse_AutoBusy");
for _, event in pairs(EVENTS) do
	frame:RegisterEvent(event);
end
frame:SetScript("OnEvent", OnEvent);

SLASH_EAB1 = '/eab';
SlashCmdList["EAB"] = function (msg)
	if not msg or msg == "" then
		print("No message provided for AutoBusy. Correct usage : /eab message");
	else
		EAB_Options.message = msg;
		resetDND();
		goDND();
	end
end;