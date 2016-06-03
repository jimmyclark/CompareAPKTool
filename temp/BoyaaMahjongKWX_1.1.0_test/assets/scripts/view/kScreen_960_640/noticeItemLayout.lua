local noticeItemLayout=
{
	name="noticeItemLayout",type=0,typeName="View",time=0,x=0,y=0,width=730,height=370,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
	{
		name="img_title_bg",type=1,typeName="Image",time=77706804,x=0,y=0,width=730,height=60,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_tanKuang/notice/notice_bg.png",gridLeft=20,gridRight=20,gridTop=20,gridBottom=20,
		{
			name="text_title",type=4,typeName="Text",time=77707009,x=20,y=0,width=150,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=30,textAlign=kAlignLeft,colorRed=80,colorGreen=180,colorBlue=255,string=[[2015-11-03]]
		}
	},
	{
		name="view_body",type=0,typeName="View",time=79092772,x=20,y=70,width=690,height=65,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="text_notice",type=5,typeName="TextView",time=77707146,x=0,y=0,width=690,height=0,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignTopLeft,colorRed=255,colorGreen=255,colorBlue=255
		},
		{
			name="btn_link",type=2,typeName="Button",time=79151865,x=0,y=-35,width=0,height=0,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottomRight,file="ui/blank.png"
		}
	}
}
return noticeItemLayout;