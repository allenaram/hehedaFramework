-- Base Controller --

BaseController = 
{
	IsCheckView = true,

	Patterns = 
	{
		["And"] = {},
		["Or"] = {}
	},				
	
	-- list of operation before switch according to distination 
	Do = 
	{
		["Default"] = null,
	},
	
	Jump = 
	{
		["Default"] = null,
	},
	
	AfterJump = 
	{
		["Default"] = null,
	},

}

function BaseController:FastCheckView()
	local IdentifyFunc = nil
	local IdentifyPatterns = nil
	if self.IsCheckView then
		if (next(self.Patterns["And"]) ~= nil) then
			IdentifyFunc = InteractiveUtil.FindAll
			IdentifyPatterns = self.Patterns["And"]
		elseif (next(self.Patterns["Or"]) ~= nil) then
			IdentifyFunc = InteractiveUtil.FindOne
			IdentifyPatterns = self.Patterns["Or"]
		end
	end
	
	if IdentifyFunc == nil or IdentifyPatterns == nil then
		return false
	end
	
	return IdentifyFunc(IdentifyPatterns, false)
end

function BaseController:CheckView()
	local IdentifyFunc = nil
	local IdentifyPatterns = nil
	if self.IsCheckView then
		if (next(self.Patterns["And"]) ~= nil) then
			IdentifyFunc = InteractiveUtil.FindAll
			IdentifyPatterns = self.Patterns["And"]
		elseif (next(self.Patterns["Or"]) ~= nil) then
			IdentifyFunc = InteractiveUtil.FindOne
			IdentifyPatterns = self.Patterns["Or"]
		end
	end
	
	if IdentifyFunc == nil or IdentifyPatterns == nil then
		return false
	end
	
	local holdScreen = IdentifyPatterns ~= 1
	for i = 1,5 do
		if IdentifyFunc(IdentifyPatterns, holdScreen) then
			break
		elseif i == 5 then
			return false
		end
		mSleep(300)
	end
	
	return true
end

function BaseController:IsNeedToDo()
	return true
end

