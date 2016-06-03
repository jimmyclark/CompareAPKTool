local userPanel=
{
	name="userPanel",type=0,typeName="View",time=0,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="userView",type=0,typeName="View",time=77437183,x=0,y=0,width=200,height=200,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="headView",type=0,typeName="View",time=77438708,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop
		},
		{
			name="infoView",type=0,typeName="View",time=77353001,x=0,y=100,width=0,height=100,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="nick",type=4,typeName="Text",time=77353424,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=24,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[nick]]
			},
			{
				name="money",type=4,typeName="Text",time=77353470,x=0,y=35,width=0,height=0,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=24,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[1000]]
			}
		}
	},
	{
		name="readyView",type=0,typeName="View",time=77437212,x=0,y=50,width=200,height=100,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="ready_icon",type=1,typeName="Image",time=77357617,x=0,y=0,width=49,height=55,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_room/ok.png"
		}
	}
}
return userPanel;