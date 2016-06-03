local roomPlyerInfo=
{
	name="roomPlyerInfo",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=100,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
	{
		name="view_playerInfo",type=0,typeName="View",time=90402617,x=0,y=0,width=1280,height=100,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="img_playerInfo",type=1,typeName="Image",time=90402618,x=0,y=0,width=1280,height=64,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottomLeft,file="kwx_room/img_palyerBg.png"
		},
		{
			name="btn_head",type=2,typeName="Button",time=90402619,x=10,y=0,width=100,height=98,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/btn_head.png"
		},
		{
			name="nickName",type=4,typeName="Text",time=90402620,x=110,y=60,width=130,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[我的名字]]
		},
		{
			name="img_zhuang",type=1,typeName="Image",time=90403788,x=257,y=51,width=44,height=46,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="kwx_room/img_zhuang.png"
		},
		{
			name="img_piao",type=1,typeName="Image",time=92911396,x=673,y=52,width=150,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_numberBg.png",gridLeft=20,gridRight=20,
			{
				name="Image1",type=1,typeName="Image",time=92911843,x=-3,y=-5,width=58,height=50,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_piao.png"
			},
			{
				name="view_piao",type=0,typeName="View",time=92912045,x=54,y=2,width=90,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft
			}
		},
		{
			name="view_remainCard",type=0,typeName="View",time=92974222,x=0,y=58,width=240,height=150,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,
			{
				name="img_remainCard",type=1,typeName="Image",time=90402836,x=0,y=0,width=30,height=28,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_remainCard.png"
			},
			{
				name="text_remainCard",type=4,typeName="Text",time=90402627,x=40,y=1,width=200,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=26,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[剩牌：1张]]
			}
		},
		{
			name="img_showtips",type=1,typeName="Image",time=97058488,x=487,y=-52,width=286,height=114,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_qipao.png",
			{
				name="TextView1",type=5,typeName="TextView",time=97058567,x=13,y=0,width=260,height=80,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=24,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[攒够一定数量话费劵就可以兑换奖品哦！]]
			}
		},
		{
			name="view_privateroom",type=0,typeName="View",time=0,x=0,y=22,width=1280,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,
			{
				name="img_scoreBg",type=1,typeName="Image",time=90402621,x=250,y=12,width=220,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_numberBg.png",gridLeft=20,gridRight=20,
				{
					name="img_icon",type=1,typeName="Image",time=90402622,x=1,y=1,width=46,height=38,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_score.png"
				},
				{
					name="view_score",type=0,typeName="View",time=90402623,x=51,y=2,width=168,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft
				}
			},
			{
				name="img_jewelBg",type=1,typeName="Image",time=90402621,x=480,y=12,width=175,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_numberBg.png",gridLeft=20,gridRight=20,
				{
					name="img_icon",type=1,typeName="Image",time=90402622,x=1,y=1,width=42,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/ico_jewel.png"
				},
				{
					name="view_jewel",type=0,typeName="View",time=90402623,x=39,y=2,width=113,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft
				}
			}
		},
		{
			name="view_commonroom",type=0,typeName="View",time=0,x=0,y=22,width=1280,height=64,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,
			{
				name="img_huaFeiBg",type=1,typeName="Image",time=90402624,x=487,y=12,width=170,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_numberBg.png",gridLeft=20,gridRight=20,
				{
					name="img_huaFei",type=1,typeName="Image",time=90402625,x=6,y=1,width=46,height=38,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_lobby/img_huaFei.png"
				},
				{
					name="view_huaFei",type=0,typeName="View",time=90402626,x=53,y=2,width=120,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft
				}
			},
			{
				name="img_coinBg",type=1,typeName="Image",time=90402621,x=250,y=12,width=220,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/img_numberBg.png",gridLeft=20,gridRight=20,
				{
					name="img_icon",type=1,typeName="Image",time=90402622,x=1,y=1,width=36,height=36,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_lobby/img_coin.png"
				},
				{
					name="view_coin",type=0,typeName="View",time=90402623,x=39,y=2,width=180,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft
				}
			},
			{
				name="btn_addCoin",type=2,typeName="Button",time=90403995,x=426,y=12,width=44,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_room/btn_addCoin.png"
			}
		}
	}
}
return roomPlyerInfo;