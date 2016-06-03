local quickPurchaseLayout=
{
	name="quickPurchaseLayout",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="img_bg",type=1,typeName="Image",time=77446291,x=0,y=0,width=838,height=542,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_mid.png",
		{
			name="Image1",type=1,typeName="Image",time=94989686,x=30,y=92,width=778,height=335,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30
		},
		{
			name="view_header",type=0,typeName="View",time=77446515,x=0,y=10,width=800,height=85,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="text_title",type=4,typeName="Text",time=77446646,x=0,y=0,width=160,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=40,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[快速购买]]
			}
		},
		{
			name="view_body",type=0,typeName="View",time=77446547,x=0,y=85,width=790,height=410,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
			{
				name="view_tips",type=0,typeName="View",time=77446708,x=0,y=15,width=790,height=90,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="text_brokeTips",type=4,typeName="Text",time=77446735,x=0,y=0,width=420,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[购买超值金币，体验精彩游戏！]]
				}
			},
			{
				name="view_pay",type=0,typeName="View",time=77446856,x=0,y=90,width=790,height=210,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="btn_pay",type=1,typeName="Image",time=77447324,x=0,y=0,width=558,height=164,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/btn_shangPin.png",
					{
						name="view_payTips",type=0,typeName="View",time=77446989,x=170,y=8,width=350,height=75,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
						{
							name="pay_desc",type=4,typeName="Text",time=77681556,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=35,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[65,000金币=6.0元]]
						}
					},
					{
						name="view_icon",type=0,typeName="View",time=77681330,x=10,y=0,width=170,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,
						{
							name="icon_coin",type=1,typeName="Image",time=77681405,x=0,y=0,width=146,height=130,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_shop/img_pic.png"
						},
						{
							name="icon_jewel",type=1,typeName="Image",time=0,x=18,y=22,width=134,height=102,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_jewelD.png"
						}
					},
					{
						name="view_payPrice",type=0,typeName="View",time=77681522,x=170,y=85,width=350,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
						{
							name="pay_subject",type=4,typeName="Text",time=77681640,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[1.0元 = 10000金币]]
						}
					},
					{
						name="btn_switch",type=2,typeName="Button",time=77681701,x=-26,y=-20,width=82,height=82,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="kwx_common/bnt_updateCoin.png"
					}
				}
			},
			{
				name="view_bottom",type=0,typeName="View",time=77680735,x=0,y=-30,width=790,height=110,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
				{
					name="btn_confirm",type=2,typeName="Button",time=77680803,x=0,y=0,width=240,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/btn_blue_big.png",
					{
						name="text_title",type=4,typeName="Text",time=77680898,x=0,y=-3,width=90,height=36,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=36,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[确 定]]
					}
				},
				{
					name="left_btn",type=2,typeName="Button",time=82635473,x=-150,y=0,width=240,height=90,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/btn_red_big.png",
					{
						name="left_text",type=4,typeName="Text",time=82635474,x=0,y=-3,width=90,height=36,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=36,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[去低倍场]]
					}
				}
			}
		},
		{
			name="btn_close",type=2,typeName="Button",time=77447463,x=52,y=41,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="kwx_common/btn_close.png"
		}
	}
}
return quickPurchaseLayout;