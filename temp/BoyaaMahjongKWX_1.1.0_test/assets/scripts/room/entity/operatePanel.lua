local RoomCoord = require("room.coord.roomCoord")
local ChoiceView = import(".choiceView")
local OperatePanel = class(BaseLayer)

OperatePanel.s_controls =
{
	giveUpBtn = 1,
	chiBtn = 2,
	pengBtn = 3,
	gangBtn = 4,
	tingBtn = 5,
	huBtn   = 6,
	opView = 7,
	passBtn = 8,
	opBg = 9,
}

function OperatePanel:ctor(viewConfig)
	self.m_ctrl = OperatePanel.s_controls
	self.m_root:setPos(0, display.bottom - 350)
	self.m_mutiOpCache = {
		chi = {},
		gang = {},
	}
	self.m_opCard = 0
	self:setLevel(RoomCoord.OperateLayer)
	self.m_opView = self:getControl(self.m_ctrl.opView)
	self.m_passBtn = self:getControl(self.m_ctrl.passBtn)
	self.m_imgLiang = self:findChildByName("img_liang")
	self.m_imgLiang:hide()
end

function OperatePanel:showOperationBtns(opBundle, cardValue)
	self.m_imgLiang:hide()
	self.selectTing = false
	self.m_opBundle = opBundle
	self.m_opCard = cardValue or 0
	-- 注意逆序 和顺序对应
	local operations = {opBundle.hu, opBundle.ting, opBundle.gang, opBundle.peng}
	local opViews = {self.m_ctrl.huBtn, self.m_ctrl.tingBtn, self.m_ctrl.gangBtn, self.m_ctrl.pengBtn}
	local pos = {x = 150, y = 0}
	
	self:setVisible(true)
	self.m_passBtn:hide()
	self.m_opView:show()
	-- kEffectPlayer:play(Effects.AudioTipOperate)
	local tingFlag = false
	for k,v in pairs(opViews) do
		local view = self:getControl(v)
		printInfo(k, operations[k], k, opBundle.gang)
		if operations[k] then  --有该操作
			printInfo("第" .. k .. "个有操作")
			view:setVisible(true)
			view:setPos(pos.x, pos.y)
			-- local anim = view:addPropScaleEase(101, kAnimNormal, ResDoubleArrayBounceOut, 500, 0, 0.9, 1.0, 0.9, 1.0)
			-- if anim then anim:setEvent(nil, function() view:removeProp(101) end) end
			pos.x = pos.x + view.m_width + 35
			if 2 == k then
				tingFlag = true
				GuideManager:showGuideMing(true, view)
			end
			if 3 == k and not tingFlag then
				GuideManager:showGuideGangCard(true, view)
			end
		else
			printInfo("第" .. k .. "个无操作")
			view:setVisible(false)
		end
	end
	local width = pos.x + 300
	if width < 656 then width = 656 end
	self:getControl(self.m_ctrl.opBg):setSize(width, nil)
	self:getControl(self.m_ctrl.giveUpBtn):setPos(pos.x, pos.y)
	self.m_mutiOpCache = {
		chi = opBundle.chiOp,
		gang = opBundle.gangTb,
	}

	-- 操作新手引导
	-- local opPriority = GuideManager:onOperateGuide({
	-- 	opValue	= opBundle.opValue,
	-- })
	-- if opPriority ~= kPriorityNone then
	-- 	local priorityToView = {
	-- 		[kPriorityPeng] = self.m_ctrl.pengBtn,
	-- 		[kPriorityGang] = self.m_ctrl.gangBtn,
	-- 		[kPriorityHu]	= self.m_ctrl.huBtn,
	-- 	}
	-- 	local ctrl = priorityToView[opPriority]
	-- 	if ctrl then
	-- 		local obj = self:getControl(ctrl)
	-- 		GuideManager:initObjAndEventCallback({
	-- 			arrowObj = obj, 
	-- 			obj = obj,
	-- 		})
	-- 	end
	-- end
end

function OperatePanel:setVisible(visible)
	self:getControl(self.m_ctrl.giveUpBtn):setVisible(true)
	if self.m_choiceView then
		self.m_choiceView:removeSelf() 
		self.m_choiceView = nil
	end
	self:getPlayer():onOperateHidden()
	OperatePanel.super.setVisible(self, visible)
end

function OperatePanel:onGiveUpClick()
	self:requestTakeOperate(kOpeCancel, 0)
	self:setVisible(false)
end

function OperatePanel:onChiClick()
	local chiOp = self.m_opBundle.chiOp
	if #chiOp > 1 then
		-- 自己操作 立即显示动画和 播放音效
		self:showMutilSelectWnd(chiOp, kPriorityChi)
	elseif #chiOp == 1 then
		-- 自己操作 立即显示动画和 播放音效
		self:requestTakeOperate(chiOp[1].operation, chiOp[1].card)
		self:setVisible(false)
	end
end

function OperatePanel:onPengClick()
	-- 自己操作 立即显示动画和 播放音效
	if self.m_opBundle.peng then
		self:requestTakeOperate(kOpePeng, self.m_opCard)
	end
	self:setVisible(false)
end

function OperatePanel:onGangClick()
	local gangTb = self.m_opBundle.gangTb
	GuideManager:showGuideGangCard(false)
	if #gangTb == 1 then
		self:requestTakeOperate(gangTb[1].operation, gangTb[1].card)
		self:setVisible(false)
	elseif #gangTb > 1 then
		self:showMutilSelectWnd(gangTb, kPriorityGang)
	end
end

function OperatePanel:onTingClick()
	self:getPlayer():onSelectTing()
	-- self:requestTakeOperate(kOpeTing, 0)
	-- 听牌的时候 如果需要发听牌操作 则需要重新把面板显示出来
	self:show()
	self.m_opView:hide()
	self.m_passBtn:show()
end

function OperatePanel:onLiangClick()
	printInfo("OperatePanel:onLiangClick")
	GuideManager:showGuideMing(false)
	self:show()
	self.m_opView:hide()
	self:showViewLiang(true, 1)
	local liangTb = self.m_opBundle.liangTb
	dump(liangTb)
	self:getPlayer():onSelectLiang(self.m_opBundle.liangTb)
end

function OperatePanel:showViewLiang(isShow, step)
	printInfo("showViewLiang  sdsddsd")
	for i = 1, 3 do
		local imgStep = self.m_imgLiang:findChildByName(string.format("img_tips%d",i))
		if imgStep then
			imgStep:hide()
		end
	end
	if not step or step < 1 or not isShow then
		-- 如果step为空或者小于1,或者不显示 则隐藏
		self.m_imgLiang:hide()
		return
	end
	printInfo("showViewLiang  sdsddsd22222")
	local imgStep = self.m_imgLiang:findChildByName(string.format("img_tips%d",step))
	if imgStep then
		printInfo("showViewLiang  sdsddsd33333")
		if 1 == step then
			imgStep:findChildByName("btn_liang"):setOnClick(self, function(self)
				self:showViewLiang(true, 2)
				self:getPlayer():onSelectLiangOutCard()
			end)
		end
		imgStep:show()
		self.m_imgLiang:show()
	end
end

function OperatePanel:onHuBtnClick()
	local huTb = self.m_opBundle.huTb
	self:requestTakeOperate(huTb[1].operation, huTb[1].card)
end

function OperatePanel:onPassBtnClick()
	self:requestTakeOperate(kOpeCancel, 0)
end

function OperatePanel:requestTakeOperate(operation, opCard)
	self:getPlayer():requestTakeOperate(operation, opCard)
	self:setVisible(false)
end

-- type == kPriorityChi 为多吃 kPriorityGang 为多杠
function OperatePanel:showMutilSelectWnd(opTable, opPriority)
	if self.m_choiceView then 
		self.m_choiceView:removeSelf() 
		self.m_choiceView = nil
	end
	self.m_choiceView = new(ChoiceView, opTable, opPriority)
		:addTo(self)
	self.m_opView:hide()
	self.m_passBtn:show()
end

function OperatePanel:getPlayer()
	return self:getParent()
end

-----------------消息收发处理
OperatePanel.s_controlFuncMap = 
{
	[OperatePanel.s_controls.giveUpBtn] = OperatePanel.onGiveUpClick,
	[OperatePanel.s_controls.chiBtn]  	= OperatePanel.onChiClick,
	[OperatePanel.s_controls.pengBtn] 	= OperatePanel.onPengClick,
	[OperatePanel.s_controls.gangBtn] 	= OperatePanel.onGangClick,
	[OperatePanel.s_controls.tingBtn] 	= OperatePanel.onLiangClick,
	[OperatePanel.s_controls.huBtn] 	= OperatePanel.onHuBtnClick,
	[OperatePanel.s_controls.passBtn]   = OperatePanel.onPassBtnClick,
}

OperatePanel.s_controlConfig = 
{
	[OperatePanel.s_controls.opView] = {"operateView"},
	[OperatePanel.s_controls.passBtn] = {"passBtn"},
	[OperatePanel.s_controls.giveUpBtn] = {"operateView", "giveUpBtn"},

	[OperatePanel.s_controls.opBg] = {"operateView", "opBg"},
	[OperatePanel.s_controls.chiBtn] = {"operateView", "chiBtn"},
	[OperatePanel.s_controls.pengBtn] = {"operateView", "pengBtn"},
	[OperatePanel.s_controls.gangBtn] = {"operateView", "gangBtn"},
	[OperatePanel.s_controls.tingBtn] = {"operateView", "tingBtn"},
	[OperatePanel.s_controls.huBtn] = {"operateView", "huBtn"},
}

return OperatePanel