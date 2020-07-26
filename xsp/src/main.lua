require "Framework/BaseController"
require "UILoginController"
require "UILoginNoticeController"

require "Framework/BaseAssemblyLineManager"
require "Task1AssemblyLineManager"

require "Framework/NavigationUtil"
require "Framework/InteractiveUtil"
require "Framework/TextUtil"
require "Framework/Facade"
require "Framework/G_ui"

init("0", 1);
setScreenScale(640, 1136)
Config = 
{
	["Common"] = 
	{	
		ShowHud = true,
		ShowClickFinger = true,
		ScreenWidth = 1136,
		ScreenHeight = 640,
	},
}

MsgHud = nil
if Config.Common.ShowHud then
	MsgHud = createHUD()
end


curAssemblyLine = MAssemblyLine["task1"] --todo
curAssemblyLine:SetPath()
curAssemblyLine:SetState()

