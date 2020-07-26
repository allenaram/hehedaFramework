LoginNoticeController = 
{
	BackBtn = {1069,136,1093,163},
}
setmetatable(LoginNoticeController, {__index = BaseController})

LoginNoticeController.Patterns = 
{
	["And"] = 
	{
		{0x965422,"3|25|0xffd69c,0|50|0x945221,-1|67|0x79502f,1|87|0xe7d6be,1|115|0x805635,0|133|0x79502f,3|156|0xe7d6be,-1|180|0x79502f,166|-54|0x411317", 95, 95, 101, 124, 133},
	},
	["Or"] = {}
}

function LoginNoticeController.DoSthBeforeGotoNotice()
	InteractiveUtil.ShowMsg(MsgHud, "准备回到登录界面")
	mSleep(2000)
end

function LoginNoticeController.GoToLogin()
	InteractiveUtil.ClickBtn(LoginNoticeController.BackBtn)
	mSleep(1000)
end

LoginNoticeController.Do["Login"] = LoginNoticeController.DoSthBeforeGotoLogin
LoginNoticeController.Jump["Login"] = LoginNoticeController.GoToLogin
