import "Global";
local Player = import "PlayerHelper";
local Actor = {};

function Actor.GetChildrenTable(self)
	local children = {};
	for i,v in ipairs(self:GetChildren()) do
		local name = v:GetName();
		local c = children[name];
		if c then
			local t = {};
			if type(c) == "table" then
				t = c;
			else
				table.insert(t,c);
			end
			table.insert(t,v);
			children[name] = t;
		else
			children[name] = v;
		end
	end
	return children;
end

function Actor.SetPlayerProxy(self,pn,name)
	local player = Player.GetChild(pn);
	if player then
		local target = name and player:GetChild(name) or player;
		self:SetTarget(target);
		target:hidden(1);
		return self;
	end
end

function Actor.SetActorFrameTexture(self)
	self:SetWidth(DISPLAY:GetDisplayWidth());
	self:SetHeight(DISPLAY:GetDisplayHeight());
	self:EnablePreserveTexture(true);
	self:Create();
	return self;
end

function Actor.SetTexture(self,target)
	self:basezoomx(SCREEN_WIDTH/DISPLAY:GetDisplayWidth());
	self:basezoomy(SCREEN_HEIGHT/DISPLAY:GetDisplayHeight()*-1);
	self:SetTexture(target:GetTexture());
	return self;
end

return Actor;
