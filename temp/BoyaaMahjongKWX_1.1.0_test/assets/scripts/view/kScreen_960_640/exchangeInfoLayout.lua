local exchangeInfoLayout=
{
	name="exchangeInfoLayout",type=0,typeName="View",time=0,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="img_bg",type=1,typeName="Image",time=92404426,x=0,y=0,width=1038,height=642,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_big.png",
		{
			name="Image1",type=1,typeName="Image",time=92404789,x=25,y=95,width=988,height=440,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30
		},
		{
			name="view_header",type=0,typeName="View",time=92404637,x=0,y=0,width=1038,height=85,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
			{
				name="text_title",type=4,typeName="Text",time=92404638,x=0,y=15,width=240,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=40,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[兑换信息填写]]
			}
		},
		{
			name="view_desc",type=0,typeName="View",time=92404740,x=94,y=120,width=200,height=120,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="Text1",type=4,typeName="Text",time=92405335,x=140,y=30,width=576,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[话费将在3个工作日内发放，实物将在5个工作日内发放]]
			},
			{
				name="Text2",type=4,typeName="Text",time=92405409,x=140,y=70,width=576,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[如有疑问请联系：400-663-1888 或 0755-86166169]]
			}
		},
		{
			name="view_info",type=0,typeName="View",time=92405518,x=38,y=250,width=200,height=250,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="text_phone",type=4,typeName="Text",time=92405561,x=100,y=0,width=100,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[*手 机]]
			},
			{
				name="text_name",type=4,typeName="Text",time=92405645,x=100,y=90,width=100,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[*姓 名]]
			},
			{
				name="text_dizhi",type=4,typeName="Text",time=92405693,x=100,y=180,width=100,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[ 地 址]]
			},
			{
				name="img_phone_input",type=1,typeName="Image",time=92405929,x=220,y=-15,width=550,height=62,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_enterKuang.png",gridLeft=20,gridRight=20,gridTop=20,gridBottom=20,
				{
					name="text_phone_input",type=6,typeName="EditText",time=92405930,x=10,y=0,width=530,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=30,textAlign=kAlignLeft,colorRed=150,colorGreen=150,colorBlue=150
				}
			},
			{
				name="img_name_input",type=1,typeName="Image",time=92406085,x=220,y=75,width=550,height=62,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_enterKuang.png",gridLeft=20,gridRight=20,gridTop=20,gridBottom=20,
				{
					name="text_name_input",type=6,typeName="EditText",time=92406086,x=10,y=0,width=530,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=30,textAlign=kAlignLeft,colorRed=150,colorGreen=150,colorBlue=150
				}
			},
			{
				name="img_dizhi_input",type=1,typeName="Image",time=92406088,x=220,y=165,width=550,height=62,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_enterKuang.png",gridLeft=20,gridRight=20,gridTop=20,gridBottom=20,
				{
					name="text_dizhi_input",type=6,typeName="EditText",time=92406089,x=10,y=0,width=530,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=30,textAlign=kAlignLeft,colorRed=150,colorGreen=150,colorBlue=150
				}
			},
			{
				name="text_phone_desc",type=4,typeName="Text",time=92406352,x=800,y=0,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[必   填]]
			},
			{
				name="text_name_desc",type=4,typeName="Text",time=92406425,x=800,y=90,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[必   填]]
			},
			{
				name="text_dizhi_desc",type=4,typeName="Text",time=92406429,x=800,y=180,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[选   填]]
			}
		},
		{
			name="btn_mid",type=2,typeName="Button",time=92404879,x=0,y=20,width=240,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_common/btn_blue_big.png",
			{
				name="text_midName",type=4,typeName="Text",time=92404947,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=36,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255
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
return exchangeInfoLayout;