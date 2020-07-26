-- Base Assembly Line Manager --

BaseAssemblyLineManager = 
{
	m_CurState = nil,
	
	Path = {}
}

function BaseAssemblyLineManager:Routine()
	while true do --todo add end condition
		local from = m_CurState
		local to = self.Path[m_CurState]
		if from ~= nil and to ~= nil then
			NavigationUtil:GoTo(from, to)
		end
	end
end

function BaseAssemblyLineManager:SetState()
	while true do
		InteractiveUtil.ShowMsg(MsgHud, "识别中...")
		keepScreen(true)
		for from, to in pairs(self.Path) do
			local curCtrl = MController[from]
			if curCtrl ~= nil and curCtrl:FastCheckView() then
				keepScreen(false)
				NavigationUtil:GoTo(from, to)
				m_CurState = to
				return self:Routine()
			end
			mSleep(30)
		end
		keepScreen(false)
		mSleep(1000)
	end
end

function BaseAssemblyLineManager:ResetState()
	self:SetState()
end

function BaseAssemblyLineManager:SetPath()

end
