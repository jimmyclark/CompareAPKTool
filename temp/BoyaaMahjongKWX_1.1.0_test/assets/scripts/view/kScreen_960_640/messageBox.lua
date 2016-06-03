local messageBox=
{
	name="messageBox",type=0,typeName="View",time=0,x=0,y=0,width=660,height=420,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,isLuaLocal=0,
	{
		name="img_bg",type=1,typeName="Image",time=76670561,x=0,y=0,width=632,height=430,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_small.png",
		{
			name="Image1",type=1,typeName="Image",time=92982171,x=0,y=90,width=578,height=230,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30
		},
		{
			name="content_text",type=5,typeName="TextView",time=76670719,x=0,y=-10,width=540,height=160,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[是否确认退出]]
		},
		{
			name="left_btn",type=2,typeName="Button",time=76670779,x=-150,y=25,width=240,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_common/btn_red_big.png",
			{
				name="left_text",type=4,typeName="Text",time=76670930,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=36,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[取 消]]
			}
		},
		{
			name="right_btn",type=2,typeName="Button",time=78458588,x=150,y=25,width=240,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_common/btn_blue_big.png",
			{
				name="right_text",type=4,typeName="Text",time=78458589,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=36,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[确 认]]
			}
		},
		{
			name="title_text",type=4,typeName="Text",time=78458702,x=0,y=8,width=250,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=40,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[温馨提示]]
		},
		{
			name="close_btn",type=2,typeName="Button",time=98968298,x=50,y=28,width=60,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="ui/blank.png",
			{
				name="Image1",type=1,typeName="Image",time=98968299,x=0,y=0,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/btn_close.png"
			}
		}
	}
}
return messageBox;