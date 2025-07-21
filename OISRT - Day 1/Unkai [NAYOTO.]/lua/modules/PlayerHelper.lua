import "Global";
local PlayerHelper = {};

function PlayerHelper.GetChild(pn)
	return SCREENMAN:GetTopScreen():GetChild("PlayerP"..pn);
end

function PlayerHelper.SetInputPlayer(pn,ip)
	local c = PlayerHelper.GetChild(pn);
	if c then
		local ip = ip or math.mod(pn - 1,2);
		local pc = PREFSMAN:GetPreference("AutoPlay");
		c:SetAwake(true);
		c:SetInputPlayer(ip);
		c:SetPlayerController(pc);
		return c;
	end
end

function PlayerHelper.SetSpline(param)
	if not param.Player then
		for i = 1,NUM_PLAYFIELDS do
			param.Player = i;
			PlayerHelper.SetSpline(param);
		end
	else
		local c = PlayerHelper.GetChild(param.Player);
		if c then
			local column = param.Column and (param.Column - 1) or -1;
			local speed = param.Speed or -1;
			for k,v in next,param.Splines do
				local member = string.lower(k);
				for i = 1,table.getn(v) do
					local value,offset = v[i][2],v[i][1];
					if member == "x" then
						c:SetXSpline(i-1,column,PixelToPercent(value)*100,PixelToPercent(offset)*100,speed);
				elseif member == "y" then
						c:SetYSpline(i-1,column,PixelToPercent(value)*100,PixelToPercent(offset)*100,speed);
				elseif member == "z" then
						c:SetZSpline(i-1,column,PixelToPercent(value)*100,PixelToPercent(offset)*100,speed);
				elseif member == "rotx" or member == "rotationx" then
						c:SetRotXSpline(i-1,column,math.rad(value)*100,PixelToPercent(offset)*100,speed);
				elseif member == "roty" or member == "rotationy" then
						c:SetRotYSpline(i-1,column,math.rad(value)*100,PixelToPercent(offset)*100,speed);
				elseif member == "rotz" or member == "rotationz" then
						c:SetRotZSpline(i-1,column,math.rad(value)*100,PixelToPercent(offset)*100,speed);
				elseif member == "size" then
						c:SetSizeSpline(i-1,column,value*100,PixelToPercent(offset)*100,speed);
				elseif member == "skew" then
						c:SetSkewSpline(i-1,column,value*100,PixelToPercent(offset)*100,speed);
				elseif member == "stealth" then
						c:SetStealthSpline(i-1,column,value*100,PixelToPercent(offset)*100,speed);
					end
				end
			end
			c:NoClearSplines(param.NoClear or false);
			return c;
		end
	end
end

return PlayerHelper;
