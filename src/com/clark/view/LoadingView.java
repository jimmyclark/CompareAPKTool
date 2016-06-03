package com.clark.view;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRootPane;
import javax.swing.border.EmptyBorder;

import com.boyaa.clark.util.ViewUtils;
import com.clark.controller.ViewController;

public class LoadingView extends JFrame{
	/**
	 *序列Id
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 标题名字
	 */
	private static final String TITLE_STR = "正在解析，请稍候。。。";
	/**
	 * Loading界面的宽度 
	 */
	private static final int SCREEN_WIDTH = 300;
	/**
	 * Loading界面的高度 
	 */
	private static final int SCREEN_HEIGHT = 100;
	
	/**
	 * 构造一个Loading界面
	 * @param mainView 主页面的引用
	 */
	public LoadingView(){
		this.setTitle(TITLE_STR);
		this.setResizable(false);
		this.setSize(SCREEN_WIDTH,SCREEN_HEIGHT);
		this.setLocation(ViewUtils.setScreenCenterWidth(SCREEN_WIDTH),ViewUtils.setScreenCenterHeight(SCREEN_HEIGHT));
		this.setUndecorated(true);
		this.getRootPane().setWindowDecorationStyle(JRootPane.INFORMATION_DIALOG);
		this.addWindowListener(new WindowAdapter() {
			   public void windowClosing(WindowEvent e) {
				   ViewController.getInstance().cancelLoadingView();
			  }
		});
		initView();
	}
	
	public void initView(){
		this.setLayout(new BorderLayout());
		
		JPanel onePanel  = createTitlePanel();
		this.add(onePanel,BorderLayout.CENTER);
		
	}
	
	private JPanel createTitlePanel() {
		JPanel textViewPanel = new JPanel();
		textViewPanel.setLayout(new BorderLayout());
		textViewPanel.setBorder(new EmptyBorder(10,10,10,10));
		JLabel titleLabel = new JLabel(TITLE_STR);
		titleLabel.setFont(new Font("黑体",Font.BOLD,20));
		titleLabel.setForeground(Color.BLUE);
		textViewPanel.add(titleLabel, BorderLayout.CENTER);
		return textViewPanel;
	}
}
