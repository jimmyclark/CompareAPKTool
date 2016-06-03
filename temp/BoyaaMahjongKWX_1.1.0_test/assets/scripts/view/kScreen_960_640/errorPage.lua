local errorPage=
{
	name="errorPage",type=0,typeName="View",time=0,x=0,y=0,width=960,height=640,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="sky",type=1,typeName="Image",time=84597723,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,file="kwx_lobby/lobbyBackGround.jpg"
	},
	{
		name="bg",type=1,typeName="Image",time=31807474,x=0,y=-50,width=294,height=360,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_lobby/img_2.png"
	},
	{
		name="centerView",type=0,typeName="View",time=34845162,x=0,y=0,width=700,height=800,visible=1,fillParentWidth=0,fillParentHeight=1,nodeAlign=kAlignCenter,
		{
			name="confirm",type=2,typeName="Button",time=31807866,x=0,y=240,width=240,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/btn_blue_big.png",
			{
				name="confirmText",type=4,typeName="Text",time=31807899,x=0,y=-3,width=84,height=28,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=32,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=220,string=[[确 定]]
			}
		},
		{
			name="errorTip",type=4,typeName="Text",time=31807664,x=0,y=0,width=1000,height=340,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=32,textAlign=kAlignBottom,colorRed=255,colorGreen=255,colorBlue=0,string=[[亲，游戏玩累了，喝杯清茶休息一会儿吧！]]
		},
		{
			name="errorLog",type=5,typeName="TextView",time=34846196,x=0,y=0,width=1000,height=340,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=23,textAlign=kAlignBottom,colorRed=255,colorGreen=255,colorBlue=255
		}
	}
}
return errorPage;