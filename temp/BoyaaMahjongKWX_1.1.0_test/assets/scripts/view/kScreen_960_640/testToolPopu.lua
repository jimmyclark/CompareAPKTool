local testToolPopu=
{
	name="testToolPopu",type=0,typeName="View",time=0,x=0,y=0,width=1280,height=720,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="img_bg",type=1,typeName="Image",time=82274941,x=0,y=0,width=838,height=542,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="kwx_common/img_tanKuang_mid.png",
		{
			name="Image1",type=1,typeName="Image",time=96273732,x=30,y=90,width=780,height=390,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="kwx_common/img_dikuang.png",gridLeft=30,gridRight=30,gridTop=30,gridBottom=30
		},
		{
			name="tool_view",type=0,typeName="ScrollView",time=82275610,x=0,y=90,width=800,height=380,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
			{
				name="account_tool",type=0,typeName="View",time=82275623,x=0,y=0,width=200,height=80,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="create_account",type=2,typeName="Button",time=82275446,x=30,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="account_text",type=4,typeName="Text",time=82275507,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[切换新账号]]
					}
				},
				{
					name="account_input_bg",type=1,typeName="Image",time=82275693,x=250,y=0,width=250,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/img_enterKuang.png",gridLeft=15,gridRight=15,gridTop=15,gridBottom=15
				},
				{
					name="account_editbox",type=6,typeName="EditText",time=82275688,x=260,y=0,width=230,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignLeft,colorRed=85,colorGreen=85,colorBlue=85
				},
				{
					name="random_btn",type=2,typeName="Button",time=82278333,x=520,y=0,width=44,height=46,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_tanKuang/lobbySetting/btn_process.png",gridLeft=30,gridRight=30
				},
				{
					name="history_btn",type=2,typeName="Button",time=88074025,x=590,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="history_text",type=4,typeName="Text",time=88074084,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[历史]]
					}
				}
			},
			{
				name="cut_server_tool",type=0,typeName="View",time=82276309,x=0,y=80,width=1280,height=160,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="cut_view",type=0,typeName="View",time=82276547,x=0,y=0,width=0,height=80,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
					{
						name="normal_btn",type=2,typeName="Button",time=82276310,x=30,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
						{
							name="normal_text",type=4,typeName="Text",time=82276311,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[正式服]]
						}
					},
					{
						name="test_btn",type=2,typeName="Button",time=82276344,x=250,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
						{
							name="test_text",type=4,typeName="Text",time=82276345,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[测试服]]
						}
					},
					{
						name="dev_btn",type=2,typeName="Button",time=82276390,x=470,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
						{
							name="dev_text",type=4,typeName="Text",time=82276391,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[开发服]]
						}
					}
				},
				{
					name="info_view",type=0,typeName="View",time=82276563,x=30,y=80,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
					{
						name="server_view",type=0,typeName="View",time=82277321,x=0,y=0,width=120,height=75,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
						{
							name="domain_input_bg",type=1,typeName="Image",time=82277322,x=120,y=0,width=420,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/img_enterKuang.png",gridLeft=15,gridRight=15,gridTop=15,gridBottom=15
						},
						{
							name="server_editbox",type=6,typeName="EditText",time=82277323,x=130,y=0,width=400,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignLeft,colorRed=85,colorGreen=85,colorBlue=85
						},
						{
							name="server_text",type=4,typeName="Text",time=82277324,x=0,y=0,width=120,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignLeft,colorRed=85,colorGreen=85,colorBlue=85,string=[[IP : 端口]]
						},
						{
							name="select_server_btn",type=2,typeName="Button",time=82277889,x=550,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
							{
								name="server_text",type=4,typeName="Text",time=82277890,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[选用]]
							}
						}
					},
					{
						name="domain_view",type=0,typeName="View",time=82276819,x=0,y=75,width=120,height=75,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
						{
							name="domain_input_bg",type=1,typeName="Image",time=82276804,x=120,y=0,width=420,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/img_enterKuang.png",gridLeft=15,gridRight=15,gridTop=15,gridBottom=15
						},
						{
							name="domain_editbox",type=6,typeName="EditText",time=82276806,x=130,y=0,width=400,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignLeft,colorRed=85,colorGreen=85,colorBlue=85
						},
						{
							name="domain_text",type=4,typeName="Text",time=82277202,x=0,y=0,width=120,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignLeft,colorRed=85,colorGreen=85,colorBlue=85,string=[[活动域名：]]
						},
						{
							name="select_domain_btn",type=2,typeName="Button",time=82277403,x=550,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
							{
								name="dev_text",type=4,typeName="Text",time=82277404,x=0,y=0,width=168,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[选用]]
							}
						}
					}
				}
			},
			{
				name="change_view",type=0,typeName="View",time=83148237,x=0,y=310,width=200,height=80,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
				{
					name="change_down",type=2,typeName="Button",time=83148259,x=300,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="down_text",type=4,typeName="Text",time=83148260,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[降场]]
					}
				},
				{
					name="change_btn",type=2,typeName="Button",time=83148264,x=30,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="change_text",type=4,typeName="Text",time=83148265,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[换场]]
					}
				},
				{
					name="change_up",type=2,typeName="Button",time=83148365,x=585,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="up_text",type=4,typeName="Text",time=83148366,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[升场]]
					}
				}
			},
			{
				name="reconn_tool",type=0,typeName="View",time=82275926,x=-100,y=392,width=248,height=80,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="reconn_type_btn1",type=2,typeName="Button",time=82275927,x=165,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="reconn_text",type=4,typeName="Text",time=82275928,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[x秒后立即重连]]
					}
				},
				{
					name="reconn_input_bg1",type=1,typeName="Image",time=82362477,x=30,y=0,width=120,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/img_enterKuang.png",gridLeft=15,gridRight=15,gridTop=15,gridBottom=15
				},
				{
					name="reconn_editbox1",type=6,typeName="EditText",time=82362479,x=40,y=0,width=100,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignCenter,colorRed=85,colorGreen=85,colorBlue=85,string=[[0]]
				},
				{
					name="reconn_type_btn2",type=2,typeName="Button",time=82364187,x=580,y=0,width=190,height=70,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="reconn_text1",type=4,typeName="Text",time=82364188,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=96,colorGreen=96,colorBlue=96,string=[[断开x秒后重连]]
					}
				},
				{
					name="reconn_input_bg2",type=1,typeName="Image",time=82364280,x=440,y=0,width=120,height=64,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/img_enterKuang.png",gridLeft=15,gridRight=15,gridTop=15,gridBottom=15
				},
				{
					name="reconn_editbox2",type=6,typeName="EditText",time=82364281,x=450,y=0,width=100,height=64,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignCenter,colorRed=85,colorGreen=85,colorBlue=85,string=[[0]]
				}
			},
			{
				name="common_tool",type=0,typeName="View",time=82692988,x=0,y=392,width=200,height=80,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="user_id_bg",type=1,typeName="Image",time=82693795,x=30,y=0,width=120,height=64,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/img_enterKuang.png",gridLeft=15,gridRight=15,gridTop=15,gridBottom=15
				},
				{
					name="user_id_editbox",type=6,typeName="EditText",time=82693800,x=40,y=0,width=100,height=64,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignCenter,colorRed=85,colorGreen=85,colorBlue=85,string=[[0]]
				},
				{
					name="update_btn",type=2,typeName="Button",time=82692990,x=30,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="normal_text",type=4,typeName="Text",time=82692991,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[同步信息]]
					}
				},
				{
					name="cards_btn",type=2,typeName="Button",time=88671324,x=585,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="carsd_text",type=4,typeName="Text",time=88671325,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[查看发牌]]
					}
				}
			},
			{
				name="moneyView",type=0,typeName="View",time=83815167,x=-100,y=474,width=248,height=80,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="money_change_btn",type=2,typeName="Button",time=83815168,x=250,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="money_text",type=4,typeName="Text",time=83815169,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[篡改金币]]
					}
				},
				{
					name="money_input",type=1,typeName="Image",time=83815170,x=30,y=0,width=200,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/img_enterKuang.png",gridLeft=15,gridRight=15,gridTop=15,gridBottom=15
				},
				{
					name="money_editbox",type=6,typeName="EditText",time=83815171,x=40,y=0,width=180,height=64,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=24,textAlign=kAlignCenter,colorRed=85,colorGreen=85,colorBlue=85,string=[[0]]
				},
				{
					name="first_pay_btn",type=2,typeName="Button",time=85540985,x=582,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,file="kwx_common/btn_blue_small.png",
					{
						name="normal_text",type=4,typeName="Text",time=85540986,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[模拟完成首充]]
					}
				}
			},
			{
				name="record_view",type=0,typeName="View",time=87016185,x=0,y=570,width=600,height=80,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
				{
					name="record_btn",type=2,typeName="Button",time=87016274,x=-100,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="kwx_common/btn_blue_small.png",
					{
						name="title_text",type=4,typeName="Text",time=87016275,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[开始录制]]
					}
				},
				{
					name="play_btn",type=2,typeName="Button",time=87016325,x=100,y=0,width=190,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="kwx_common/btn_blue_small.png",
					{
						name="title_text",type=4,typeName="Text",time=87016326,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=28,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[开始回放]]
					}
				}
			}
		},
		{
			name="title_text",type=4,typeName="Text",time=82276029,x=0,y=0,width=200,height=85,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=35,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[测试工具箱]]
		},
		{
			name="close_btn",type=2,typeName="Button",time=82276087,x=52,y=39,width=40,height=42,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="kwx_common/btn_close.png"
		}
	}
}
return testToolPopu;