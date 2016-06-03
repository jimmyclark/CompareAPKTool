local rankUserLayout=
{
	name="rankUserLayout",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,isLuaLocal=0,
	{
		name="img_bg",type=1,typeName="Image",time=77446291,x=0,y=0,width=700,height=390,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_noTitleBg.png",gridLeft=100,gridRight=100,gridTop=100,gridBottom=100,
		{
			name="view_body",type=0,typeName="View",time=77446547,x=0,y=0,width=600,height=300,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,
			{
				name="img_portrait",type=1,typeName="Image",time=79845957,x=10,y=0,width=220,height=220,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="ui/blank.png"
			},
			{
				name="view_nick",type=0,typeName="View",time=79846003,x=260,y=35,width=300,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
				{
					name="img_sex",type=1,typeName="Image",time=79846139,x=0,y=0,width=38,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="ui/blank.png"
				},
				{
					name="text_nick",type=4,typeName="Text",time=79846865,x=50,y=0,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=240,colorBlue=34
				}
			},
			{
				name="view_id",type=0,typeName="View",time=79846935,x=260,y=75,width=300,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
				{
					name="text_id",type=4,typeName="Text",time=79846937,x=70,y=0,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=240,colorBlue=34
				},
				{
					name="Text2",type=4,typeName="Text",time=79846958,x=0,y=0,width=78,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[I D ：]]
				}
			},
			{
				name="view_lv",type=0,typeName="View",time=79847033,x=260,y=115,width=300,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
				{
					name="text_lv",type=4,typeName="Text",time=79847034,x=70,y=0,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=240,colorBlue=34
				},
				{
					name="Text2",type=4,typeName="Text",time=79847035,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[等级：]]
				}
			},
			{
				name="view_win_rate",type=0,typeName="View",time=79847158,x=260,y=155,width=300,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
				{
					name="text_win_rate",type=4,typeName="Text",time=79847159,x=70,y=0,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=240,colorBlue=34
				},
				{
					name="Text2",type=4,typeName="Text",time=79847160,x=0,y=0,width=78,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[胜率：]]
				}
			},
			{
				name="view_coin",type=0,typeName="View",time=79847191,x=260,y=195,width=300,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
				{
					name="text_coin",type=4,typeName="Text",time=79847192,x=70,y=0,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=240,colorBlue=34
				},
				{
					name="Text2",type=4,typeName="Text",time=79847193,x=0,y=0,width=78,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[金币：]]
				}
			},
			{
				name="view_score",type=0,typeName="View",time=79847308,x=260,y=235,width=300,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
				{
					name="text_score",type=4,typeName="Text",time=79847309,x=70,y=0,width=200,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=240,colorBlue=34
				},
				{
					name="Text2",type=4,typeName="Text",time=79847310,x=0,y=0,width=78,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[战绩：]]
				}
			}
		}
	}
}
return rankUserLayout;