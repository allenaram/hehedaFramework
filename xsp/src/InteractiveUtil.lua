-- Interactive Utility --

InteractiveUtil = {}

--Input
function InteractiveUtil.Click(p, dx, dy)
	local dx = dx or 0
	local dy = dy or 0
	holdtime = 100
	--math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	math.randomseed(tostring(mTime()):reverse():sub(1, 7))
	p.x = p.x + math.random(0, dx)
	p.y = p.y + math.random(0, dy)
	touchDown(1, p.x, p.y)
	holdtime = math.random(60,80)
	if Config.Common.ShowClickFinger then --todo
		local finger = createHUD()
		showHUD(finger,"",30,"0x00ff0000","icons/tap.png",0,p.x-27,p.y-15,80,96)
		setTimer(holdtime+20, hideHUD, finger)
	end
	mSleep(holdtime)
	touchUp(1, p.x, p.y)
	mSleep(20)
end

function InteractiveUtil.ClickBtn(button)
	if nil == button.x1 then
		button.x1 = button[1]
		button.y1 = button[2]
		button.x2 = button[3]
		button.y2 = button[4]
	end
	InteractiveUtil.Click({x=button.x1,y=button.y1},button.x2-button.x1,button.y2-button.y1)
end

function InteractiveUtil.Slide(x1, y1, x2, y2, T, ddx1, ddy1, ddx2, ddy2)
	T = T or 50
	ddx1 = ddx1 or 0
	ddy1 = ddy1 or 0
	ddx2 = ddx2 or 0
	ddy2 = ddy2 or 0
	wave = 5
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	x1 = x1 + math.random(-ddx1, ddx1)
	y1 = y1 + math.random(-ddy1, ddy1)
	x2 = x2 + math.random(-ddx2, ddx2)
	y2 = y2 + math.random(-ddy2, ddy2)
    local dt = 25
	local times = T / dt
    local stepx, stepy = math.ceil(math.abs(x2-x1)/times), math.ceil(math.abs(y2-y1)/times)
	local x, y = x1, y1 
	
	touchDown(1, x, y)
	if Config.Common.ShowClickFinger then
		finger = createHUD()
		showHUD(finger,"",30,"0x00ff0000","icons/tap.png",0,x-27,y-15,80,96)

	end
	
    local function move(from, to ,step)
      if from > to then
        do 
          return -1 * step 
        end
      else 
        return step 
      end 
    end
	
	local dx=0
	local dy=0
	local x_reached = false
	local y_reached = false
	local last_stepx = stepx
	local last_stepy = stepy
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    while not(x_reached) or not(y_reached) do
		--sysLog(string.format('%d,%d',last_stepx,last_stepy))
        if math.abs(x-x2) >= stepx and stepx>1 then
			if last_stepx <= stepx then
				dx = math.random(0, last_stepx/4+1) + last_stepx
			else
				dx = math.random(-last_stepx/4-1, 0) + last_stepx
			end
			x = x + move(x, x2, dx)
			last_stepx = dx
		else --if x reached, wander
			if not(x_reached) then x_reached=true end
			x = math.random(-wave, wave) + x2
		end
		
        if math.abs(y-y2) >= stepy and stepy>1 then
			if last_stepy <= stepy then
				dy = math.random(0, last_stepy/4+1) + last_stepy
			else
				dy = math.random(-last_stepy/4-1, 0) + last_stepy
			end
			y = y + move(y,y2,dy)
			last_stepy = dy
		else
			if not(y_reached) then y_reached=true end
			y = math.random(-wave, wave) + y2
		end
        touchMove(1, x, y)
		--sysLog(string.format('%d,%d',x,y))
		if Config.Common.ShowClickFinger then
			showHUD(finger,"",30,"0x00ff0000","icons/tap.png",0,x-27,y-15,80,96)
		end
        mSleep(dt/2)  --In theory, it should be dt, but considering the delay of the operation itself, dt/2 is used
    end
	touchMove(1, x, y)
	if Config.Common.ShowClickFinger then
		showHUD(finger,"",30,"0x00ff0000","icons/tap.png",0,x-27,y-15,80,96)
	end
    mSleep(80)
    touchUp(1, x, y)
	if Config.Common.ShowClickFinger then
		hideHUD(finger)
	end
end

function InteractiveUtil.Get(colortable)
	local tarPos = {x = -1, y = -1}
	tarPos.x, tarPos.y = findMultiColorInRegionFuzzy(colortable[1],colortable[2],colortable[3],colortable[4],colortable[5],colortable[6],colortable[7])
	return tarPos
end

function InteractiveUtil.Find(colortable)
	local tarPos = {x = -1, y = -1}
	tarPos.x, tarPos.y = findMultiColorInRegionFuzzy(colortable[1],colortable[2],colortable[3],colortable[4],colortable[5],colortable[6],colortable[7])
	if tarPos.x == -1 then 
		return false
	else
		return true
	end
end

function InteractiveUtil.FindAndClick(colortable, not_click_allowed, dx, dy, mx, my, click_twice) -- click and return true, otherwise return false
	if not_click_allowed == nil then
		not_click_allowed = true
	end
	if click_twice == nil then
		click_twice = false
	end
	dx = dx or 0
	dy = dy or 0
	mx = mx or 0
	my = my or 0
	local tarPos={x=-1,y=-1}
	tarPos = InteractiveUtil.Get(colortable)
	if tarPos.x==-1 then
		if not_click_allowed then
			return false
		else
			-- todo
		end
	end
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	tarPos.x = tarPos.x + mx + math.random(-dx,-dx)
	tarPos.y = tarPos.y + my + math.random(-dy,-dy)
	InteractiveUtil.Click(tarPos)
	if click_twice then
		mSleep(300)
		InteractiveUtil.Click(tarPos)
	end
	
	return true
end

function InteractiveUtil.FindAll(colortable_group, hold_screen)
	if #colortable_group < 1 then
		return false
	end
	if hold_screen == nil then
		hold_screen = true
	end
	if hold_screen then
		keepScreen(true)
	end
	for i=1, #colortable_group do
		local colortable = colortable_group[i]
		local tarPos = {x=-1, y=-1}
		tarPos = InteractiveUtil.Get(colortable)
		if tarPos.x == -1 then
			if hold_screen then
				keepScreen(false)
			end
			return false
		end
	end
	if hold_screen then
		keepScreen(false)
	end
	return true
end

function InteractiveUtil.FindAllAndClick(colortable_group, click_index, dx, dy, mx, my) -- if patterns all found, click the click_index th pattern
	if #colortable_group < 1 then
		return false
	end
	dx = dx or 0
	dy = dy or 0
	mx = mx or 0
	my = my or 0
	local tarClickPos = {x=-1, y=-1}
	keepScreen(true)
	for i = 1, #colortable_group do
		local colortable = colortable_group[i]
		local tarPos = {x=-1, y=-1}
		tarPos = InteractiveUtil.Get(colortable)
		if tarPos.x == -1 then
			keepScreen(false)
			return false
		end
		if i == click_index then
			tarClickPos = tarPos
		end
	end
	keepScreen(false)
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	tarClickPos.x = tarClickPos.x + mx + math.random(-dx, dx)
	tarClickPos.y = tarClickPos.y + my + math.random(-dy, dy)
	InteractiveUtil.Click(tarClickPos)
	return true
end

function InteractiveUtil.FindOne(colortable_group, hold_screen)
	if #colortable_group < 1 then
		return false
	end
    if nil == hold_screen then
		hold_screen = true
	end
	if hold_screen then
		keepScreen(true)
	end
	for i = 1, #colortable_group do
		local colortable = colortable_group[i]
		local tarPos = {x=-1, y=-1}
		tarPos = InteractiveUtil.Get(colortable)
		if tarPos.x > -1 then
			if hold_screen then
				keepScreen(false)
			end
			return true
		end
	end
	if hold_screen then
		keepScreen(false)
	end
	return false
end

function InteractiveUtil.FindOneAndClick(colortable_group, not_click_allowed, dx, dy, mx, my, hold_screen)
	if #colortable_group < 1 then
		return false
	end
	if not_click_allowed == nil then
		not_click_allowed=true
	end
	dx = dx or 0
	dy = dy or 0
	mx = mx or 0
	my = my or 0
	if hold_screen == nil then 
		hold_screen = true
	end
	if hold_screen then
		keepScreen(true)
	end
	for i = 1, #colortable_group do
		local colortable=colortable_group[i]
		local tarPos={x=-1,y=-1}
		tarPos = InteractiveUtil.Get(colortable)
		if tarPos.x>-1 then
			if hold_screen then
				keepScreen(false)
			end
			tarPos.x = tarPos.x + mx + math.random(-dx, dx)
			tarPos.y = tarPos.y + my + math.random(-dy, dy)
			InteractiveUtil.Click(tarPos)
			return true
		end
	end
	if hold_screen then
		keepScreen(false)
	end
	return false
end

function InteractiveUtil.GetAll(colortable)
	local tarPosTable = findMultiColorInRegionFuzzyExt(colortable[1],colortable[2],colortable[3],colortable[4],colortable[5],colortable[6],colortable[7])
	return tarPosTable
end

function InteractiveUtil.GetImage(colortable)	
	local tarPos = {x=-1, y=-1}
	tarPos.x, tarPos.y = findImageInRegionFuzzy(colortable[1],colortable[2],colortable[3],colortable[4],colortable[5],colortable[6],colortable[7])
	return tarPos
end

function InteractiveUtil.GetOCR(rect, diff, whitelist, ocrConfig, ocr)
	--@para ocr: if given, new ocr willnot be created.
	whitelist = whitelist or "0123456789"
	ocrConfig = ocrConfig or {type = "tesseract"}
	local releaseOcr = not ocr
	ocr = ocr or createOCR(ocrConfig)
	local colorTbl = binarizeImage({
		rect = rect,
		diff = diff
	})
	local code, text = ocr:getText({
		data=colorTbl,
		whitelist = whitelist
	})
	if releaseOcr then
		ocr:release()
	end
	return TextUtil.Trim(text)
end

--Output
function InteractiveUtil.ShowMsg(myHud, str)
	if Config.Common.ShowHud then
		local hudw = Config.Common.ScreenWidth / 4
		local hudh = hudw / 12
		resetScreenScale()
		showHUD(myHud, str, Config.Common.ScreenHeight/30, "0xffffffff", "icons/infobg.png", 0, 3*hudh, hudh, hudw, 2*hudh)
		setScreenScale(640, 1136)    
	end
end
