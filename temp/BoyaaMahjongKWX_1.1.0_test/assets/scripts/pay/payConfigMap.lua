
PayConfigMap = {}

-- 下单业务侧函数的obj和fuc
PayConfigMap.createOrderIdObj = app
PayConfigMap.createOrderIdFuc = app.createOrderReal

-- 显示营销页的obj和fuc
PayConfigMap.showPayConfirmWindowObj = app
PayConfigMap.showPayConfirmWindowFuc = app.showPayConfirmWindow

-- 显示支付选择框的obj和fuc
PayConfigMap.showPaySelectWindowObj = app
PayConfigMap.showPaySelectWindowFuc = app.showPaySelectWindow

-- 短信顯示小米提示
PayConfigMap.showXiaoMiSmsWindowObj = app
PayConfigMap.showXiaoMiSmsWindowFuc = app.showXiaoMiSmsWindow

kNoneSIM = -1
kYiDongSIM = 1
kLianTongSIM = 2
kDianXinSIM = 3

PayConfigMap.m_allPayConfig = {
	{
		pclientid = 4,
		pmode = 218,
		pname = "移动MM弱网",  -- just for descrption
		ptypename = "短信",
		ptypesim = kYiDongSIM,
		pimage = "img_sms.png",
	},
	{
		pclientid = 5,
		pmode = 109,
		pname = "联通支付",  -- just for descrption
		ptypename = "短信",
		ptypesim = kLianTongSIM,
		pimage = "img_sms.png",
	},
	{
		pclientid = 6,
		pmode = 198,
		pname = "银联支付",  -- just for descrption
		ptypename = "银联",
		ptypesim = kNoneSIM,
		pimage = "img_yinlian.png",
	},
	{
		pclientid = 9,
		pmode = 217,
		pname = "话付宝支付",  -- just for descrption
		ptypename = "短信",
		ptypesim = kYiDongSIM,
		pimage = "img_sms.png",
	},
	{
		pclientid = 10,
		pmode = 282,
		pname = "爱动漫",  -- just for descrption
		ptypename = "短信",
		ptypesim = kDianXinSIM,
		pimage = "img_sms.png",
	},
	{
		pclientid = 22,
		pmode = 34,
		pname = "爱游戏",  -- just for descrption
		ptypename = "短信",
		ptypesim = kDianXinSIM,
		pimage = "img_sms.png",
	},
	{
		pclientid = 24,
		pmode = 265,
		pname = "支付宝",  -- just for descrption
		ptypename = "支付宝",
		ptypesim = kNoneSIM,
		pimage = "img_zhifubao.png",
	},
	{
		pclientid = 26,
		pmode = 349,
		pname = "话付宝综合",  -- just for descrption
		ptypename = "短信",
		ptypesim = kYiDongSIM,
		pimage = "img_sms.png",
	},
	{
		pclientid = 27,
		pmode = 431,
		pname = "微信",  -- just for descrption
		ptypename = "微信",
		ptypesim = kNoneSIM,
		pimage = "img_weixin.png",
	},
	{
		pclientid = 1005,
		pmode = 31,
		pname = "基地支付",  -- just for descrption
		ptypename = "短信",
		ptypesim = kYiDongSIM,
		pimage = "img_sms.png",
	},
	{
		pclientid = 1103,
		pmode = 274,
		pname = "华为支付",  -- just for descrption
		ptypename = "华为",
		ptypesim = kNoneSIM,
		pimage = "huawei.png",
	},
	-- {
	-- 	pmode = 218,
	-- 	pname = "移动MM弱网"  -- just for descrption
	-- 	ptypename = "短信支付"
	-- 	ptypesim = kYiDongSIM
	-- },
	-- {
	-- 	pmode = 218,
	-- 	pname = "移动MM弱网"  -- just for descrption
	-- 	ptypename = "短信支付"
	-- 	ptypesim = kYiDongSIM
	-- }
	-- {
	-- 	pmode = 218,
	-- 	pname = "移动MM弱网"  -- just for descrption
	-- 	ptypename = "短信支付"
	-- 	ptypesim = kYiDongSIM
	-- }
}