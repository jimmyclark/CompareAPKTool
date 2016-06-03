local roomTimer=
{
	name="roomTimer",type=0,typeName="View",time=0,x=0,y=0,width=164,height=108,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
	{
		name="timer_bg",type=1,typeName="Image",time=79091901,x=0,y=0,width=164,height=108,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_room/room_timer/timerBg.png",
		{
			name="timer_light_1",type=1,typeName="Image",time=79091952,x=0,y=10,width=118,height=28,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_room/room_timer/img_bTimer.png"
		},
		{
			name="timer_light_2",type=1,typeName="Image",time=79092025,x=10,y=0,width=32,height=68,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignRight,file="kwx_room/room_timer/img_rTimer.png"
		},
		{
			name="timer_light_4",type=1,typeName="Image",time=79092135,x=10,y=0,width=32,height=68,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_room/room_timer/img_lTimer.png"
		},
		{
			name="view_timerNumber",type=0,typeName="View",time=90472802,x=0,y=0,width=50,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter
		}
	}
}
return roomTimer;