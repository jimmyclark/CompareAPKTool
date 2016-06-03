local settingLayout1=
{
	name="settingLayout1",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="img_bg",type=1,typeName="Image",time=91850439,x=0,y=0,width=1038,height=642,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_big.png",
		{
			name="btn_close",type=2,typeName="Button",time=91850777,x=942,y=37,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/btn_close.png"
		},
		{
			name="Text1",type=4,typeName="Text",time=91850807,x=0,y=30,width=1038,height=50,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=40,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[设    置]]
		},
		{
			name="Image1",type=1,typeName="Image",time=91851394,x=29,y=95,width=980,height=485,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30,
			{
				name="scrollview_setting",type=0,typeName="ScrollView",time=91851601,x=20,y=20,width=940,height=445,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft
			}
		}
	}
}
return settingLayout1;