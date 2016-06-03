local payConfirmLayout=
{
	name="payConfirmLayout",type=0,typeName="View",time=0,x=0,y=0,width=660,height=420,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,
	{
		name="img_bg",type=1,typeName="Image",time=76670561,x=0,y=0,width=632,height=430,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_small.png",
		{
			name="Image1",type=1,typeName="Image",time=97933854,x=30,y=90,width=572,height=230,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30
		},
		{
			name="content_text",type=5,typeName="TextView",time=76670719,x=0,y=-30,width=520,height=130,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignTopLeft,colorRed=255,colorGreen=255,colorBlue=255
		},
		{
			name="btn_close",type=2,typeName="Button",time=76670952,x=52,y=38,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="kwx_common/btn_close.png"
		},
		{
			name="btn_comfirm",type=2,typeName="Button",time=78458588,x=0,y=24,width=240,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_common/btn_blue_big.png",
			{
				name="right_text",type=4,typeName="Text",time=78458589,x=0,y=0,width=90,height=36,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=36,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[确 认]]
			}
		},
		{
			name="title_text",type=4,typeName="Text",time=78458702,x=0,y=6,width=250,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=40,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[温馨提示]]
		},
		{
			name="text_contact",type=4,typeName="Text",time=84442273,x=131,y=260,width=234,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[如有问题，请联系：]]
		},
		{
			name="btn_tel",type=2,typeName="Button",time=84506185,x=360,y=260,width=160,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="ui/blank.png",
			{
				name="Text1",type=4,typeName="Text",time=84508993,x=0,y=0,width=156,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[400-663-1888]]
			}
		}
	}
}
return payConfirmLayout;