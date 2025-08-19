local table = import "table";

function table.empty(self)
	return self == nil or not next(self);
end

function table.keys(self)
	local res = {};
	for k,v in pairs(self) do
		table.insert(res,k);
	end
	return res;
end

function table.values(self)
	local res = {};
	for k,v in pairs(self) do
		table.insert(res,v);
	end
	return res;
end

function table.haskey(self,key)
	for k,v in pairs(self) do
		if k == key then
			return true;
		end
	end
	return false;
end

function table.hasvalue(self,value)
	for k,v in pairs(self) do
		if v == value then
			return true;
		end
	end
	return false;
end

function table.each(self,func)
	for k,v in pairs(self) do
		func(v,k);
	end
end

function table.eachi(self,func)
	for i,v in ipairs(self) do
		func(v,i);
	end
end

function table.map(self,func)
	local res = {};
	for k,v in pairs(self) do
		res[k] = func(v,k);
	end
	return res;
end
table.collect = table.map;

function table.select(self,func)
	local res = {};
	for k,v in pairs(self) do
		if func(v,k) then
			if type(k) == "number" then
				table.insert(res,v);
			else
				res[k] = v;
			end
		end
	end
	return res;
end
table.filter = table.select;

function table.pluck(self,key)
	local function func(v,k)
		return type(v) == "table" and v[key];
	end
	return table.map(self,func);
end

function table.reduce(self,func,value)
	for k,v in pairs(self) do
		value = func(value,v,k);
	end
	return value;
end
table.inject = table.reduce;
table.foldl = table.reduce;

function table.reject(self,func)
	local function func(v,k)
		return not func(v,k);
	end
	return table.select(self,func);
end

function table.merge(self,other)
	for k,v in pairs(other) do
		if type(self[k]) == "table" and type(v) == "table" then
			table.merge(self[k],v);
		elseif type(k) == "number" then
			table.insert(self,v);
		else
			self[k] = v;
		end
	end
	return self;
end

function table.min(self,key)
	local function func(value,v,k)
		local x = type(v) == "table" and v[key] or v;
		if not value or type(x) == "number" and value > x then
			return x;
		end
		return value;
	end
	return table.reduce(self,func);
end

function table.max(self,key)
	local function func(value,v,k)
		local x = type(v) == "table" and v[key] or v;
		if not value or type(x) == "number" and value < x then
			return x;
		end
		return value;
	end
	return table.reduce(self,func);
end

function table.pack(...)
	return { unpack(arg) };
end

table.unpack = unpack;

function table.push(self,param)
	for k,v in pairs(param) do
		table.insert(self,v);
	end
	return self;
end

function table.reverse(self)
	local n = table.getn(self);
	for i = 1,math.floor(n/2) do
		local j = n - i + 1;
		self[i],self[j] = self[j],self[i];
	end
	return self;
end

function table.shuffle(self)
	for i = 2,table.getn(self) do
		local r = math.random(i);
		self[i],self[r] = self[r],self[i];
	end
	return self;
end

return table;
