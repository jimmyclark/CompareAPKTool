
local GameResMemory = class()

function GameResMemory:ctor()
	self.m_resMemoryTable = {}
end

function GameResMemory:dtor()
	for k, v in pairs(self.m_resMemoryTable) do
		delete(v.res)
	end
	self.m_resMemoryTable = {}
end

function GameResMemory:clearResMemory()
	for k, v in pairs(self.m_resMemoryTable) do
		delete(v.res)
	end
	self.m_resMemoryTable = {}
end

function GameResMemory:addRes(file)
	if not file then
		return
	end
	local fileName = nil
	if type(file) == "table" then
		fileName = file.file
	else
		fileName = file
	end
	-- printInfo("GameResMemory:addRes file : "..fileName)
	if fileName and self.m_resMemoryTable[fileName] then
		if self.m_resMemoryTable[fileName] then
			self.m_resMemoryTable[fileName].count = self.m_resMemoryTable[fileName].count + 1
		end
		return
	end
	self.m_resMemoryTable[fileName] = {}
	self.m_resMemoryTable[fileName].count = 0
	local res = new(ResImage, file)
	self.m_resMemoryTable[fileName].res = res
	self:clearResMemoryByPriority()
end

function GameResMemory:clearResMemoryByPriority()
	--如果纹理内存达到30M  则释放掉已经不需要的内存
	local memory = System.getTextureMemory() / (1024 * 1024)
	--printInfo("清理纹理内存 : "..memory)
	if memory >= 50 then
		printInfo("纹理内存超过限制，清理！！！")
		local tempMemoryTable = self.m_resMemoryTable
		self.m_resMemoryTable = {}
		for k, v in pairs(tempMemoryTable) do
			if v.count <= 0 then
				printInfo("清理了纹理文件: "..k)
				delete(v.res)
				v.count = 0
				v.res = nil
			else
				self.m_resMemoryTable[#self.m_resMemoryTable] = v
			end
		end
	end
end

function GameResMemory:reduceResMemoryCount(fileName)
	if self.m_resMemoryTable[fileName] then
		self.m_resMemoryTable[fileName].count = self.m_resMemoryTable[fileName].count - 1
		if self.m_resMemoryTable[fileName].count < 0 then
			self.m_resMemoryTable[fileName].count = 0
		end
	end
end

return GameResMemory