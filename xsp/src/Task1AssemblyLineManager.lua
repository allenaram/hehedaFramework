-- 抢装备 --

Task1AssemblyLineManager = {}
setmetatable(Task1AssemblyLineManager, {__index = BaseAssemblyLineManager})

function Task1AssemblyLineManager:SetPath()
	self.Path = 
	{
		["Login"] = "LoginNotice",
		["LoginNotice"] = "Login",
	}
end