package com.clark.view;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import com.boyaa.clark.util.ViewUtils;
import com.clark.controller.ExecuteController;
import com.clark.controller.JudgeController;

public class MainView extends JFrame{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static final String TITLE_STR = "APK比较工具";
	private static final int SCREEN_WIDTH = 500;
	private static final int SCREEN_HEIGHT = 220;
	
	private static final String canzhaoPakageTitle = "请选择参照包体";
	private static final String bijiaoPackageTitle = "请选择比较包体";
	
	private static final String SCAN_STR = "浏览";
	private static final String COMPAREBTN_STR = "开始比较";
	
	private static final String SPLILT_ENTER = "\n";
	
	private JTextField canzhaoFile;
	private JTextArea bijiaoFile;
	
	public MainView(){
		this.setTitle(TITLE_STR);
		this.setResizable(false);
		this.setSize(SCREEN_WIDTH,SCREEN_HEIGHT);
		this.setLocation(ViewUtils.setScreenCenterWidth(SCREEN_WIDTH),ViewUtils.setScreenCenterHeight(SCREEN_HEIGHT));
		this.addWindowListener(new WindowAdapter() {
			   public void windowClosing(WindowEvent e) {
				   System.exit(-1);
			  }
		});
		init();
	}
	
	public void clearData(){
		if(canzhaoFile != null){
			canzhaoFile.setText("");
		}
		
		if(bijiaoFile != null){
			bijiaoFile.setText("");
		}
	}

	private void init() {
		Container container = this.getContentPane();
		container.setLayout(new BorderLayout());
		
		JPanel titlePanel = createTitlePanel();
		container.add(titlePanel,BorderLayout.NORTH);
		
		JPanel contentPanel = createContentPanel();
		container.add(contentPanel,BorderLayout.CENTER);
		
		JPanel downPanel = createDownPanel();
		container.add(downPanel,BorderLayout.SOUTH);
	}

	private JPanel createDownPanel() {
		JPanel downPanel = new JPanel();
		JButton compareBtn = new JButton(COMPAREBTN_STR);
		compareBtn.setFont(new Font("黑体",Font.BOLD,17));
		
		compareBtn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				compareAction();
			}
			
		});
		downPanel.add(compareBtn,BorderLayout.CENTER);
		return downPanel;
	}
	
	private void compareAction() {
//		canzhaoFile.setText("E:/clark/四川麻将/apk安装包/主版本安装包/大包/v5.1.5/v5.1.5_sc_mahjong_main.apk");
//		bijiaoFile.setText("D:/test_0601.apk");
		
		if(!JudgeController.getInstance().isApkFile(canzhaoFile.getText().trim())){
			JOptionPane.showMessageDialog(this, "比较的参照包格式异常，请check");
			return;	
		}
		
		for(int i = 0 ; i<bijiaoFile.getText().trim().split(SPLILT_ENTER).length;i++){
			if(!JudgeController.getInstance().isApkFile(bijiaoFile.getText().trim().split(SPLILT_ENTER)[i].trim())){
				JOptionPane.showMessageDialog(this, "要比较的包格式异常，请check");
				return ;
			}
		}
		
		ExecuteController.getInstance().excuteCompare(canzhaoFile.getText(),bijiaoFile.getText());
		
	}

	private JPanel createContentPanel() {
		JPanel contentPanel = new JPanel();
		contentPanel.setLayout(new GridLayout(2,1));
		JPanel canzhaoPanel = createCanZhaoPanel();
		JPanel bijiaoPanel = createBiJiaoPanel();
		contentPanel.add(canzhaoPanel);
		contentPanel.add(bijiaoPanel);
		return contentPanel;
	} 
	

	private JPanel createBiJiaoPanel() {
		JPanel bijiaoPanel = new JPanel();
		this.setLayout(new BorderLayout());
		JLabel bijiaoTitle = createColorfulLabel(bijiaoPackageTitle);
		bijiaoPanel.add(bijiaoTitle,BorderLayout.WEST);
		
		bijiaoFile = new JTextArea(4,25);
		bijiaoFile.setLineWrap(true);
		
		JScrollPane bijiaoFileScroll = new JScrollPane(bijiaoFile);
		bijiaoPanel.add(bijiaoFileScroll);
		
		JButton bijiaoScan = new JButton(SCAN_STR);
		bijiaoPanel.add(bijiaoScan, BorderLayout.EAST);
		
		bijiaoScan.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				String[] currentFiles = bijiaoFile.getText().split(SPLILT_ENTER);
				JFileChooser chooser = new JFileChooser();
				chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
				chooser.setCurrentDirectory(new File(currentFiles[currentFiles.length - 1]));
				int returnCode = chooser.showOpenDialog(MainView.this);
				if(returnCode == JFileChooser.APPROVE_OPTION) {
					  String path =chooser.getSelectedFile().getPath();
					  path = path.replace("\\", "/");
					  String thisText = bijiaoFile.getText() + SPLILT_ENTER + path;
					  bijiaoFile.setText(thisText.trim());
				}
			}
		});
		return bijiaoPanel;
	}

	private JPanel createCanZhaoPanel() {
		JPanel canzhaoPanel = new JPanel();
		this.setLayout(new BorderLayout());
		JLabel canzhaoTitle = createColorfulLabel(canzhaoPakageTitle);
		canzhaoPanel.add(canzhaoTitle,BorderLayout.WEST);
		
		canzhaoFile = new JTextField(25);
		canzhaoFile.setEditable(false);
		canzhaoPanel.add(canzhaoFile, BorderLayout.CENTER);
		
		JButton canzhaoScan = new JButton(SCAN_STR);
		canzhaoPanel.add(canzhaoScan, BorderLayout.EAST);
		
		canzhaoScan.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				JFileChooser chooser = new JFileChooser();
				chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
				chooser.setCurrentDirectory(new File(canzhaoFile.getText()));
				int returnCode = chooser.showOpenDialog(MainView.this);
				if(returnCode == JFileChooser.APPROVE_OPTION) {
					  String path =chooser.getSelectedFile().getPath();
					  path = path.replace("\\", "/");
					  canzhaoFile.setText(path);
				}
			}
		});
		
		return canzhaoPanel;
	}
	
	private JLabel createColorfulLabel(String str){
		JLabel label = new JLabel(str);
		label.setFont(new Font("楷体",Font.BOLD,15));
		label.setForeground(Color.RED);
		return label;
	}

	private JPanel createTitlePanel() {
		JPanel titlePanel = new JPanel();
		JLabel titleStr = new JLabel(TITLE_STR);
		titleStr.setFont(new Font("宋体",Font.BOLD,20));
		titleStr.setForeground(Color.BLUE);
		titlePanel.add(titleStr,BorderLayout.CENTER);
		
		return titlePanel;
	}
	
}
