local RefriendItem=
{
	name="RefriendItem",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="view_item",type=0,typeName="View",time=0,x=0,y=0,width=486,height=98,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="Image5",type=1,typeName="Image",time=0,x=12,y=9,width=80,height=80,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_womanHead.png"
		},
		{
			name="View8",type=0,typeName="View",time=0,x=104,y=9,width=231,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="img_sex",type=1,typeName="Image",time=0,x=8,y=4,width=30,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_woman.png"
			},
			{
				name="text_nick",type=4,typeName="Text",time=0,x=54,y=6,width=134.15,height=24.3,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=24,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[好友昵称]]
			}
		},
		{
			name="View81",type=0,typeName="View",time=0,x=105,y=54,width=235,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="img_coin",type=1,typeName="Image",time=0,x=8,y=4,width=30,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_lobby/img_coin.png"
			},
			{
				name="text_goldnum",type=4,typeName="Text",time=0,x=53,y=6,width=134.15,height=24.3,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=24,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[999999]]
			}
		},
		{
			name="btn_add",type=1,typeName="Button",time=0,x=366,y=15,width=115,height=66,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="ui/button.png",gridLeft=10,gridRight=10,gridTop=10,gridBottom=10,
			{
				name="Text15",type=4,typeName="Text",time=0,x=33,y=21,width=48.55,height=24.3,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=28,textAlign=kAlignLeft,colorRed=51,colorGreen=51,colorBlue=51,string=[[添加]]
			}
		}
	}
}
return RefriendItem;