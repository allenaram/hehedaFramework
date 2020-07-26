LoginController = 
{
	NoticeBtn = {1074,116,1103,138},
}
setmetatable(LoginController, {__index = BaseController})

LoginController.Patterns = 
{
	["And"] = 
	{
		{0xf7f7e7,"-16|-25|0xef7f7f,19|-27|0xf38888,-10|-38|0xf7f7e7,538|-468|0xe3d2b1,572|-423|0xe8d7ad", 95, 70, 510, 85, 533},
	},
	["Or"] = {}
}

function LoginController.DoSthBeforeGotoNotice()
	InteractiveUtil.ShowMsg(MsgHud, "准备打开公告")
	mSleep(2000)
end

function LoginController.GoToLoginNotice()
	InteractiveUtil.ClickBtn(LoginController.NoticeBtn)
	mSleep(1000)
end

LoginController.Do["LoginNotice"] = LoginController.DoSthBeforeGotoNotice
LoginController.Jump["LoginNotice"] = LoginController.GoToLoginNotice


