local leaveGamePopu=
{
	name="leaveGamePopu",type=0,typeName="View",time=0,x=0,y=0,width=660,height=420,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,
	{
		name="img_bg",type=1,typeName="Image",time=76670561,x=0,y=0,width=632,height=430,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_small.png",
		{
			name="Image1",type=1,typeName="Image",time=92470437,x=27,y=88,width=578,height=225,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30,
			{
				name="view_content",type=0,typeName="View",time=92471935,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
				{
					name="btn_enterHuoDong",type=2,typeName="Button",time=92474887,x=0,y=30,width=506,height=116,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="kwx_tanKuang/exitGame/btn_enterHuoDong.png",
					{
						name="Image3",type=1,typeName="Image",time=92473064,x=13,y=13,width=90,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_tanKuang/exitGame/img_iconHuoDong.png"
					},
					{
						name="textview_desc",type=5,typeName="TextView",time=92473093,x=130,y=0,width=380,height=116,visible=1,fillParentWidth=0,fillParentHeight=1,nodeAlign=kAlignTopLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[亲，您今天的活动/任务奖励没有领取，赶快去参加吧！]]
					}
				},
				{
					name="Text1",type=4,typeName="Text",time=92472931,x=0,y=30,width=200,height=40,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=24,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[短暂的离别是为了更好的相遇，客官你要回来哦！]]
				}
			}
		},
		{
			name="btn_left",type=2,typeName="Button",time=76670779,x=-160,y=27,width=240,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_common/btn_blue_big.png",
			{
				name="left_text",type=4,typeName="Text",time=76670930,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=36,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[退出游戏]]
			}
		},
		{
			name="btn_right",type=2,typeName="Button",time=78458588,x=160,y=27,width=240,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_common/btn_red_big.png",
			{
				name="right_text",type=4,typeName="Text",time=78458589,x=0,y=0,width=90,height=36,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=36,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[去赢话费]]
			}
		},
		{
			name="title_text",type=4,typeName="Text",time=78458702,x=0,y=7,width=250,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=40,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[温馨提示]]
		},
		{
			name="btn_close",type=2,typeName="Button",time=98968211,x=50,y=27,width=60,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="ui/blank.png",
			{
				name="Image1",type=1,typeName="Image",time=98968212,x=0,y=0,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/btn_close.png"
			}
		}
	}
}
return leaveGamePopu;