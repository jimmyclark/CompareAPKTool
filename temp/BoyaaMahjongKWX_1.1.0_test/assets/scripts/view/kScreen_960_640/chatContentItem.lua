local chatContentItem=
{
	name="chatContentItem",type=0,typeName="View",time=0,x=0,y=0,width=796,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,isLuaLocal=0,
	{
		name="view_chatItem",type=0,typeName="View",time=0,x=0,y=0,width=790,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="view_touch",type=0,typeName="View",time=0,x=11,y=15,width=149,height=38,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,isLock=1
		},
		{
			name="text_msg",type=5,typeName="TextView",time=0,x=10,y=6,width=768,height=57,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=24,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[TextView]]
		},
		{
			name="img_chatItem_bg",type=1,typeName="Image",time=0,x=0,y=0,width=790,height=68,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_chat/img_chatText_bg.png"
		},
		{
			name="text_title",type=4,typeName="Text",time=0,x=13,y=20,width=100,height=24,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=24,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[Text]]
		}
	}
}
return chatContentItem;