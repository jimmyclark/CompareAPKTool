local mailFriendMsgItem=
{
	name="mailFriendMsgItem",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="view_item",type=0,typeName="View",time=0,x=0,y=0,width=1172,height=160,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="Image4",type=1,typeName="Image",time=0,x=0,y=0,width=1172,height=160,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_mail/img_msgbg.png"
		},
		{
			name="text_msgtitle",type=4,typeName="Text",time=0,x=174,y=36,width=395.15,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[消息标题]]
		},
		{
			name="text_msg",type=4,typeName="Text",time=0,x=174,y=93,width=395.15,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=230,colorBlue=0,string=[[消息内容消息内容消息内容消息内容消息内容]]
		},
		{
			name="btn_see",type=1,typeName="Button",time=0,x=750,y=47,width=156,height=62,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/btn_blue_small.png",gridLeft=10,gridRight=10,gridTop=10,gridBottom=10,
			{
				name="text_seestr",type=4,typeName="Text",time=0,x=0,y=-3,width=60,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[收取]]
			}
		},
		{
			name="btn_del",type=1,typeName="Button",time=0,x=945,y=47,width=156,height=62,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/btn_red_small.png",gridLeft=10,gridRight=10,gridTop=10,gridBottom=10,
			{
				name="text_btn2str",type=4,typeName="Text",time=0,x=0,y=-2,width=48,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[同意]]
			}
		},
		{
			name="Image11",type=1,typeName="Image",time=0,x=-156,y=0,width=558,height=4,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_mail/img_line.png"
		},
		{
			name="btn_head",type=2,typeName="Button",time=76562826,x=17,y=-2,width=146,height=128,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="ui/blank.png",
			{
				name="view_head",type=0,typeName="View",time=76563690,x=0,y=0,width=112,height=112,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft
			},
			{
				name="img_headBg",type=1,typeName="Image",time=76563626,x=0,y=0,width=146,height=128,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,file="kwx_mail/img_headbg.png"
			}
		}
	}
}
return mailFriendMsgItem;