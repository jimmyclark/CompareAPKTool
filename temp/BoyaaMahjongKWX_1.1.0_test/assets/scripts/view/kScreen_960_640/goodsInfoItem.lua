local goodsInfoItem=
{
	name="goodsInfoItem",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,
	{
		name="view_goodsItem",type=0,typeName="View",time=0,x=0,y=0,width=208,height=245,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="btn_goodsItem",type=1,typeName="Button",time=0,x=0,y=0,width=208,height=245,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_goodsInfo/btn_goodsOptionN.png"
		},
		{
			name="img_optionState",type=1,typeName="Image",time=0,x=0,y=0,width=208,height=245,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_goodsInfo/btn_goodsOptionP.png"
		},
		{
			name="img_goodsIco",type=1,typeName="Image",time=0,x=-2,y=-32,width=4,height=12,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="common/scene_vline.png"
		},
		{
			name="text_goodsName",type=4,typeName="Text",time=0,x=8,y=187,width=192,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=32,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[道具名]]
		},
		{
			name="Image6",type=1,typeName="Image",time=0,x=171,y=-12,width=54,height=58,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_goodsInfo/img_goodsTipNum_Bg.png",
			{
				name="text_goodsNum",type=4,typeName="Text",time=0,x=-8,y=7,width=68,height=23.35,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[56]]
			}
		}
	}
}
return goodsInfoItem;