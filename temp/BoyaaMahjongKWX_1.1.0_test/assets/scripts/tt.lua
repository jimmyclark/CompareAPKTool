-- tt.lua
-- Author:
-- Date:
-- Last modification:
-- Description:
-- Note:

tt.s_controls =
{
	img_lobbyBg = 1,
	img_decoration_1 = 2,
	img_decoration_2 = 3,
	img_decoration_3 = 4,
	img_logo = 5,
	img_coinIcon = 6,
	Button1 = 7,
	img_headBg = 8,
	Button2 = 9,
	Button3 = 10,
	Button3 = 11,
	btn_quickStart = 12,
	btn_icon = 13,
	btn_icon = 14,
	btn_icon = 15,
	btn_icon = 16,
	btn_icon = 17,
};


----------------------------  config  --------------------------------------------------------

local view_farthest = {"view_bg","view_farthest"};
local view_nearest = {"view_bg","view_nearest"};
local view_left = {"view_ui","view_left"};
local view_logo = {"view_left","view_logo"};
local view_majhongs = {"view_left","view_majhongs"};
local view_right = {"view_ui","view_right"};
local view_player = {"view_right","view_player"};
local img_coinBg = {"view_player","img_coinBg"};
local view_recharge = {"view_player","view_recharge"};
local text_nick = {"view_player","text_nick"};
local btn_head = {"view_player","btn_head"};
local view_tool = {"view_right","view_tool"};
local View1 = {"view_tool","View1"};
local View2 = {"view_tool","View2"};
local View21 = {"view_tool","View21"};
local view_roomIcon = {"view_right","view_roomIcon"};
local Image2 = {"view_roomIcon","Image2"};
local view_quickStart = {"Image2","view_quickStart"};
local view_bottom = {"view_ui","view_bottom"};
local view_buttons = {"view_bottom","view_buttons"};
local view_shop = {"view_buttons","view_shop"};
local view_task = {"view_buttons","view_task"};
local view_rank = {"view_buttons","view_rank"};
local view_activity = {"view_buttons","view_activity"};
local view_friend = {"view_buttons","view_friend"};

tt.s_controlConfig = 
{
	[tt.s_controls.img_lobbyBg] = {view_farthest, "img_lobbyBg"},
	[tt.s_controls.img_decoration_1] = {view_nearest, "img_decoration_1"},
	[tt.s_controls.img_decoration_2] = {view_nearest, "img_decoration_2"},
	[tt.s_controls.img_decoration_3] = {view_nearest, "img_decoration_3"},
	[tt.s_controls.img_logo] = {view_logo, "img_logo"},
	[tt.s_controls.img_coinIcon] = {img_coinBg, "img_coinIcon"},
	[tt.s_controls.Button1] = {view_recharge, "Button1"},
	[tt.s_controls.img_headBg] = {btn_head, "img_headBg"},
	[tt.s_controls.Button2] = {View1, "Button2"},
	[tt.s_controls.Button3] = {View2, "Button3"},
	[tt.s_controls.Button3] = {View21, "Button3"},
	[tt.s_controls.btn_quickStart] = {view_quickStart, "btn_quickStart"},
	[tt.s_controls.btn_icon] = {view_shop, "btn_icon"},
	[tt.s_controls.btn_icon] = {view_task, "btn_icon"},
	[tt.s_controls.btn_icon] = {view_rank, "btn_icon"},
	[tt.s_controls.btn_icon] = {view_activity, "btn_icon"},
	[tt.s_controls.btn_icon] = {view_friend, "btn_icon"},
};

tt.s_controlFuncMap = 
{
	[tt.s_controls.img_lobbyBg] = tt.onImg_lobbyBgClick;
	[tt.s_controls.img_decoration_1] = tt.onImg_decoration_1Click;
	[tt.s_controls.img_decoration_2] = tt.onImg_decoration_2Click;
	[tt.s_controls.img_decoration_3] = tt.onImg_decoration_3Click;
	[tt.s_controls.img_logo] = tt.onImg_logoClick;
	[tt.s_controls.img_coinIcon] = tt.onImg_coinIconClick;
	[tt.s_controls.Button1] = tt.onButton1Click;
	[tt.s_controls.img_headBg] = tt.onImg_headBgClick;
	[tt.s_controls.Button2] = tt.onButton2Click;
	[tt.s_controls.Button3] = tt.onButton3Click;
	[tt.s_controls.Button3] = tt.onButton3Click;
	[tt.s_controls.btn_quickStart] = tt.onBtn_quickStartClick;
	[tt.s_controls.btn_icon] = tt.onBtn_iconClick;
	[tt.s_controls.btn_icon] = tt.onBtn_iconClick;
	[tt.s_controls.btn_icon] = tt.onBtn_iconClick;
	[tt.s_controls.btn_icon] = tt.onBtn_iconClick;
	[tt.s_controls.btn_icon] = tt.onBtn_iconClick;
};
