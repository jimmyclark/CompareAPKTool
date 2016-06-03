local sysNoticeLayout=
{
	name="sysNoticeLayout",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
	{
		name="img_bg",type=1,typeName="Image",time=77446291,x=0,y=0,width=838,height=542,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_mid.png",
		{
			name="Image1",type=1,typeName="Image",time=91621702,x=29,y=94,width=780,height=384,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30,
			{
				name="sc_notice",type=0,typeName="ScrollView",time=77705187,x=0,y=0,width=740,height=370,fillTopLeftX=25,fillTopLeftY=25,fillBottomRightX=25,fillBottomRightY=25,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft
			}
		},
		{
			name="view_header",type=0,typeName="View",time=77446515,x=0,y=13,width=800,height=85,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="text_title",type=4,typeName="Text",time=77446646,x=0,y=0,width=160,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=40,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[系统公告]]
			}
		},
		{
			name="btn_close",type=2,typeName="Button",time=77447463,x=60,y=42,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="kwx_common/btn_close.png"
		}
	}
}
return sysNoticeLayout;