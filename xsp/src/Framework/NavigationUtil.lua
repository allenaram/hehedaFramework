-- NavigationUtility --
-----------------------

MController = 
{
	["Default"] = nil,
	["Login"] = LoginController,
	["LoginNotice"] = LoginNoticeController,
}


NavigationUtil = {}

function NavigationUtil:GoTo(from, to)
	local fromController = MController[from]
	if fromController == nil then
		return curAssemblyLine:ResetState()
	end
	
	if fromController.IsCheckView and not fromController:CheckView() then
		return curAssemblyLine:ResetState() 
	end
		
	local DoFunc = fromController.Do[to]
	if DoFunc ~= nil then
		DoFunc()
	end
	
	local JumpFunc = fromController.Jump[to]
	if JumpFunc == nil then
		return curAssemblyLine:ResetState()
	end
	JumpFunc()
	
	local AfterJumpFunc = fromController.AfterJump[to]
	if AfterJumpFunc ~= nil then
		AfterJumpFunc()
	end
end