--! @return Empty table is return true.
function table:empty()
	return self == nil or not next(self);
end

--! @return Return keys.
function table:keys()
	local res = {};
	for k,v in pairs(self) do
		table.insert(res,k);
	end
	return res;
end

--! @return Return values.
function table:values()
	local res = {};
	for k,v in pairs(self) do
		table.insert(res,v);
	end
	return res;
end

function table:haskey(key)
	for k,v in pairs(self) do
		if k == key then
			return true;
		end
	end
	return false;
end

function table:hasvalue(value)
	for k,v in pairs(self) do
		if v == value then
			return true;
		end
	end
	return false;
end

function table:each(func)
	for k,v in pairs(self) do
		func(v,k);
	end
end

function table:eachi(func)
	for i,v in ipairs(self) do
		func(v,i);
	end
end

function table:map(func)
	local res = {};
	for k,v in pairs(self) do
		res[k] = func(v,k);
	end
	return res;
end
table.collect = table.map;

function table:select(func)
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

function table:pluck(key)
	local function func(v,k)
		return type(v) == "table" and v[key];
	end
	return table.map(self,func);
end

function table:reduce(func,value)
	for k,v in pairs(self) do
		value = func(value,v,k);
	end
	return value;
end
table.inject = table.reduce;
table.foldl = table.reduce;

function table:reject(func)
	local function func(v,k)
		return not func(v,k);
	end
	return table.select(self,func);
end

function table:merge(other)
	for k,v in pairs(other) do
		if type(self[k]) == "table" and type(v) == "table" then
			table.merge(self[k],v);
		else
			self[k] = v;
		end
	end
	return self;
end

function table:min(key)
	local function func(value,v,k)
		local x = type(v) == "table" and v[key] or v;
		if not value or type(x) == "number" and value > x then
			return x;
		end
		return value;
	end
	return table.reduce(self,func);
end

function table:max(key)
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

function table:push(param)
	for k,v in pairs(param) do
		table.insert(self,v);
	end
	return self;
end

function table:reverse()
	local n = table.getn(self);
	for i = 1,math.floor(n/2) do
		local j = n - i + 1;
		self[i],self[j] = self[j],self[i];
	end
	return self;
end

function table:shuffle()
	for i = 2,table.getn(self) do
		local r = math.random(i);
		self[i],self[r] = self[r],self[i];
	end
	return self;
end

function table:add(other)
	local function func(v,k)
		return v + (type(other) == "table" and other[k] or other or 0);
	end
	return table.map(self,func);
end

function table:sub(other)
	local function func(v,k)
		return v - (type(other) == "table" and other[k] or other or 0);
	end
	return table.map(self,func);
end

function table:mul(other)
	local function func(v,k)
		return v * (type(other) == "table" and other[k] or other or 0);
	end
	return table.map(self,func);
end

function table:div(other)
	local function func(v,k)
		return v / (type(other) == "table" and other[k] or other or 0);
	end
	return table.map(self,func);
end

function table:pow(other)
	local function func(v,k)
		return v ^ (type(other) == "table" and other[k] or other or 0);
	end
	return table.map(self,func);
end
