local sysMsgAnnexLayout=
{
	name="sysMsgAnnexLayout",type=0,typeName="View",time=0,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="img_bg",type=1,typeName="Image",time=92404426,x=0,y=0,width=838,height=542,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_mid.png",
		{
			name="Image1",type=1,typeName="Image",time=92404789,x=38,y=95,width=765,height=339,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30
		},
		{
			name="view_header",type=0,typeName="View",time=92404637,x=0,y=2,width=838,height=83,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
			{
				name="text_title",type=4,typeName="Text",time=92404638,x=-26,y=14,width=160,height=41.25,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=40,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[附件标题]]
			}
		},
		{
			name="view_desc",type=0,typeName="View",time=92404740,x=0,y=115,width=838,height=296,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="textview_content",type=5,typeName="TextView",time=0,x=-3,y=6,width=692,height=296,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignTopLeft,colorRed=204,colorGreen=204,colorBlue=204,string=[[附件内容]]
			}
		},
		{
			name="btn_mid",type=2,typeName="Button",time=92404879,x=0,y=24,width=178,height=74,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_common/btn_blue_big.png",
			{
				name="text_midName",type=4,typeName="Text",time=92404947,x=0,y=0,width=178,height=74,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[知道了]]
			}
		},
		{
			name="btn_close",type=2,typeName="Button",time=98967989,x=53,y=32,width=60,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="ui/blank.png",
			{
				name="Image1",type=1,typeName="Image",time=98967990,x=0,y=0,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/btn_close.png"
			}
		}
	}
}
return sysMsgAnnexLayout;