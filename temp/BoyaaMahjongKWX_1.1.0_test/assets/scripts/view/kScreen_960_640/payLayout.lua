local payLayout=
{
	name="payLayout",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="img_bg",type=1,typeName="Image",time=77446291,x=0,y=0,width=838,height=542,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_mid.png",
		{
			name="Image1",type=1,typeName="Image",time=94382679,x=0,y=15,width=778,height=390,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30
		},
		{
			name="view_header",type=0,typeName="View",time=77446515,x=0,y=12,width=838,height=85,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
			{
				name="text_title",type=4,typeName="Text",time=77446646,x=0,y=0,width=120,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=40,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[请选择支付方式]]
			}
		},
		{
			name="view_body",type=0,typeName="View",time=77446547,x=0,y=85,width=790,height=390,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
			{
				name="view_tips",type=0,typeName="View",time=77446708,x=0,y=0,width=790,height=85,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="text_goodsInfo",type=4,typeName="Text",time=77446735,x=80,y=7,width=195,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255
				},
				{
					name="img_line",type=1,typeName="Image",time=77451223,x=0,y=0,width=740,height=2,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="kwx_common/img_h_split.png",gridLeft=5,gridRight=5,gridTop=2,gridBottom=3
				},
				{
					name="text_goodsPrice",type=4,typeName="Text",time=77679373,x=80,y=8,width=135,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignRight,fontSize=30,textAlign=kAlignRight,colorRed=255,colorGreen=255,colorBlue=255
				}
			},
			{
				name="view_pay",type=0,typeName="View",time=77446856,x=0,y=0,width=790,height=320,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
				{
					name="btn_pay_1",type=2,typeName="Button",time=77447324,x=35,y=0,width=170,height=212,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_tanKuang/login/btn_selectlogin.png",
					{
						name="view_payTips",type=0,typeName="View",time=77446989,x=0,y=7,width=274,height=65,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
						{
							name="text_text",type=4,typeName="Text",time=77447058,x=0,y=0,width=0,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255
						}
					},
					{
						name="img_payIcon",type=1,typeName="Image",time=77451491,x=0,y=-35,width=82,height=66,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_tanKuang/selectPay/img_sms.png"
					}
				},
				{
					name="btn_pay_2",type=2,typeName="Button",time=77451659,x=220,y=0,width=170,height=212,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_tanKuang/login/btn_selectlogin.png",
					{
						name="view_payTips",type=0,typeName="View",time=77451660,x=0,y=7,width=274,height=65,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
						{
							name="text_text",type=4,typeName="Text",time=77451661,x=0,y=0,width=0,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255
						}
					},
					{
						name="img_payIcon",type=1,typeName="Image",time=94386533,x=0,y=-35,width=82,height=66,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_tanKuang/selectPay/img_sms.png"
					}
				},
				{
					name="btn_pay_3",type=2,typeName="Button",time=77451705,x=405,y=0,width=170,height=212,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_tanKuang/login/btn_selectlogin.png",
					{
						name="view_payTips",type=0,typeName="View",time=77451706,x=0,y=7,width=274,height=65,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
						{
							name="text_text",type=4,typeName="Text",time=77451707,x=0,y=0,width=0,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255
						}
					},
					{
						name="img_payIcon",type=1,typeName="Image",time=94387104,x=0,y=-35,width=82,height=66,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_tanKuang/selectPay/img_sms.png"
					}
				},
				{
					name="btn_pay_4",type=2,typeName="Button",time=77451726,x=590,y=0,width=170,height=212,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_tanKuang/login/btn_selectlogin.png",
					{
						name="view_payTips",type=0,typeName="View",time=77451727,x=0,y=7,width=274,height=65,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
						{
							name="text_text",type=4,typeName="Text",time=77451728,x=0,y=0,width=0,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=30,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255
						}
					},
					{
						name="img_payIcon",type=1,typeName="Image",time=94387125,x=0,y=-35,width=82,height=66,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_tanKuang/selectPay/img_sms.png"
					}
				}
			}
		},
		{
			name="btn_close",type=2,typeName="Button",time=98968381,x=53,y=30,width=60,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="ui/blank.png",
			{
				name="Image1",type=1,typeName="Image",time=98968382,x=0,y=0,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/btn_close.png"
			}
		}
	}
}
return payLayout;