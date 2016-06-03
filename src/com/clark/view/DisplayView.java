package com.clark.view;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Map;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.border.EmptyBorder;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import javax.swing.table.TableModel;
import javax.swing.text.TableView.TableRow;

import com.boyaa.clark.util.ViewUtils;
import com.clark.controller.ExecuteController;
import com.clark.controller.ViewController;

public class DisplayView extends JFrame{
	private static final String TITLE_STR = "结果界面";
	
	private static final int SCREEN_WIDTH = 1280;
	private static final int SCREEN_HEIGHT = 600;
	private JComboBox<String> listsCombox;
	private JLabel leftTitleStr;
	private JLabel rightTitleStr;
	private JTable leftTables;
	private JTable rightTables;
	private MyTableModel myLeftTableModel;
	private MyTableRightModel myRightTabelModel;
	private JComboBox<String> sizesCombox;
	
	private static String[] sizeLists = new String[]{"B","KB","MB"};
	private int bijiaoFileIndex;
	
	private Object[][] leftBObjects;
	private Object[][] leftKBObjects;
	private Object[][] leftMBObjects;
	
	private ArrayList<Object[][]> rightBObjects = new ArrayList<Object[][]>();
	private ArrayList<Object[][]> rightKBObjects = new ArrayList<Object[][]>();
	private ArrayList<Object[][]> rightMBObjects = new ArrayList<Object[][]>();
	
	public DisplayView(){
		this.setTitle(TITLE_STR);
		this.setResizable(false);
		this.setSize(SCREEN_WIDTH,SCREEN_HEIGHT);
		this.setLocation(ViewUtils.setScreenCenterWidth(SCREEN_WIDTH),ViewUtils.setScreenCenterHeight(SCREEN_HEIGHT));
		this.addWindowListener(new WindowAdapter() {
			   public void windowClosing(WindowEvent e) {
				   ViewController.getInstance().hideDisplayView();
				   ViewController.getInstance().showMainView();
			  }
		});
		init();
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
		
		downPanel.add(createIllustratePanel(), BorderLayout.NORTH);
		
		JPanel illustratePanel = new JPanel();
		
		JTextField color1Label = new JTextField(10);
		color1Label.setBackground(Color.YELLOW);
		color1Label.setEditable(false);
		illustratePanel.add(color1Label);
		
		JLabel color1Illustrate = new JLabel("添加的文件或者文件夹");
		illustratePanel.add(color1Illustrate);
		
		JTextField color2Label = new JTextField(10);
		color2Label.setBackground(Color.BLUE);
		color2Label.setEditable(false);
		illustratePanel.add(color2Label);
		
		JLabel color2Illustrate = new JLabel("仅大小有变化");
		illustratePanel.add(color2Illustrate);
		
		JTextField color3Label = new JTextField(10);
		color3Label.setBackground(Color.GREEN);
		color3Label.setEditable(false);
		illustratePanel.add(color3Label);
		
		JLabel color3Illustrate = new JLabel("文件夹");
		illustratePanel.add(color3Illustrate);
		
		downPanel.add(illustratePanel,BorderLayout.CENTER);
		
		return downPanel;
	}

	private JPanel createIllustratePanel() {
		JPanel illustratePanel = new JPanel();
		
		
		
		return illustratePanel;
	}

	private JPanel createContentPanel() {
		JPanel contentPanel = new JPanel();
		contentPanel.setLayout(new BorderLayout());
		contentPanel.add(createComboxPanel(),BorderLayout.NORTH);
		contentPanel.add(createListPanel(),BorderLayout.CENTER);
		
		return contentPanel;
	}
	
	private JPanel createComboxPanel(){
		JPanel comboxPanel = new JPanel();
		listsCombox = new JComboBox<String>(ExecuteController.getInstance().getFilesLists());
		listsCombox.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				@SuppressWarnings("unchecked")
				int itemIndex=((JComboBox<String>)e.getSource()).getSelectedIndex();//获取到项
				showDifferentBijiaoFile(itemIndex);
			}
		});
		comboxPanel.add(listsCombox);
		
		sizesCombox = new JComboBox<String>(sizeLists);
		comboxPanel.add(sizesCombox);
		
		sizesCombox.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				@SuppressWarnings("unchecked")
				int itemIndex=((JComboBox<String>)e.getSource()).getSelectedIndex();//获取到项
				showDifferentSize(itemIndex);
			}
		});
		
		return comboxPanel;
	}

	protected void showDifferentBijiaoFile(int itemIndex) {
		this.bijiaoFileIndex = itemIndex;
		setRightTitleSize(this.bijiaoFileIndex, sizesCombox.getSelectedIndex());
		setRightTableSize(sizesCombox.getSelectedIndex());
	}

	private void showDifferentSize(int itemIndex) {
		switch(itemIndex){
		case 0:
			System.out.println("B");
			setAllViewSizeToB();
			break;
		case 1:
			System.out.println("KB");
			setAllViewSizeToKB();
			break;
		case 2:
			System.out.println("MB");
			setAllViewSizeToMB();
			break;
		}
	}

	private void setAllViewSizeToB() {
		setLeftTitleSize(0);
		setLeftTableSize(0);
		setRightTitleSize(bijiaoFileIndex,0);
		setRightTableSize(0);
	}
	
	private void setAllViewSizeToKB(){
		setLeftTitleSize(1);
		setLeftTableSize(1);
		setRightTitleSize(bijiaoFileIndex,1);
		setRightTableSize(1);
	}
	
	private void setAllViewSizeToMB(){
		setLeftTitleSize(2);
		setLeftTableSize(2);
		setRightTitleSize(bijiaoFileIndex,2);
		setRightTableSize(2);
	}
	
	private void setRightTableSize(int itemIndex) {
		switch(itemIndex){
		case 0:
			myRightTabelModel.setLeftColumnValues(rightBObjects.get(this.bijiaoFileIndex));
			break;
		case 1:
			myRightTabelModel.setLeftColumnValues(rightKBObjects.get(this.bijiaoFileIndex));
			break;
		case 2:
			myRightTabelModel.setLeftColumnValues(rightMBObjects.get(this.bijiaoFileIndex));
			break;
		}
		myRightTabelModel.fireTableDataChanged();
	}

	private void setLeftTableSize(int itemIndex) {
		switch(itemIndex){
			case 0:
				myLeftTableModel.setLeftColumnValues(leftBObjects);
				break;
			case 1:
				myLeftTableModel.setLeftColumnValues(leftKBObjects);
				break;
			case 2:
				myLeftTableModel.setLeftColumnValues(leftMBObjects);
				break;
		}
		myLeftTableModel.fireTableDataChanged();
	}
	
	private void setLeftTitleSize(int itemIndex){
		String filePath = ExecuteController.getInstance().getOriginTestFiles();
		long fileSize = ExecuteController.getInstance().getCanzhaoFiles().get(filePath);
		switch(itemIndex){
		case 0:
			leftTitleStr.setText(filePath.substring(filePath.lastIndexOf("/")+1) + "  (" + fileSize + " " + sizeLists[0] + ")");
			break;
		case 1:
			leftTitleStr.setText(filePath.substring(filePath.lastIndexOf("/")+1) + "  (" + convertToKB(fileSize) + " " + sizeLists[1] + ")");
			break;
		case 2:
			leftTitleStr.setText(filePath.substring(filePath.lastIndexOf("/")+1) + "  (" + convertToMB(fileSize) + " " + sizeLists[2] + ")");
			break;
		}
	}
	
	private void setRightTitleSize(int fileIndex,int itemIndex){
		String filePath = ExecuteController.getInstance().getCompareFiles()[fileIndex];
		Long fileSize = ExecuteController.getInstance().getBijiaoFiles().get(filePath);
		switch(itemIndex){
		case 0:
			rightTitleStr.setText(filePath.substring(filePath.lastIndexOf("/")+1) + "  (" + fileSize + " " + sizeLists[0] + ")");
			break;
		case 1:
			rightTitleStr.setText(filePath.substring(filePath.lastIndexOf("/")+1) + "  (" + convertToKB(fileSize) + " " + sizeLists[1] + ")");
			break;
		case 2:
			rightTitleStr.setText(filePath.substring(filePath.lastIndexOf("/")+1) + "  (" + convertToMB(fileSize) + " " + sizeLists[2] + ")");
			break;
		}
	}

	private JPanel createListPanel() {
		JPanel listPanel = new JPanel();
		listPanel.setLayout(new BorderLayout());
		listPanel.add(createLeftPanel(),BorderLayout.WEST);
		
		listPanel.add(createRightPanel(), BorderLayout.EAST);
		
		return listPanel;
	}

	private JPanel createRightPanel() {
		JPanel rightPanel = new JPanel();
		rightPanel.setLayout(new BorderLayout());
		String filePath = ExecuteController.getInstance().getCompareFiles()[0];
		Long fileSize = ExecuteController.getInstance().getBijiaoFiles().get(filePath);
		
		rightTitleStr = new JLabel(filePath.substring(filePath.lastIndexOf("/")+1) + "  (" + fileSize + " B)");
		rightTitleStr.setBorder(new EmptyBorder(5, 140, 5, 30));
		rightTitleStr.setFont(new Font("楷体",Font.BOLD,15));
		rightTitleStr.setForeground(Color.RED);
		rightPanel.add(rightTitleStr,BorderLayout.NORTH);
		
		myRightTabelModel = new MyTableRightModel();
		initRightData(myRightTabelModel);
		
		rightTables = new JTable(){
			MyRightCellRenderer dataRender = new MyRightCellRenderer();
			public TableCellRenderer getCellRenderer(int row,int column){
				return dataRender;
			}
		};
		
		rightTables.setModel(myRightTabelModel);
		JScrollPane scrollPane = new JScrollPane(rightTables);
		rightPanel.add(scrollPane, BorderLayout.SOUTH);
		
		TableColumn column = null;  
        int colunms = rightTables.getColumnCount();  
        for(int i = 0; i < colunms; i++){  
            column = rightTables.getColumnModel().getColumn(i);  
            /*将每一列的默认宽度设置为100*/  
            if(i == 0 ){
            	column.setPreferredWidth(250);	
            }
            if(i == 2){
            	column.setPreferredWidth(124);
            }
            
            if(i == 3){
            	column.setMinWidth(0);   
            	column.setMaxWidth(0);
            	column.setWidth(0);
            	column.setPreferredWidth(0);
            }
         }
        
        ArrayList<Integer> myBiJiaoIsFolderNames = new ArrayList<Integer>();
        for(int i = 0 ; i<rightTables.getRowCount();i++){
        	if("文件夹".equals(rightTables.getValueAt(i,1))){
        		myBiJiaoIsFolderNames.add(i);
        		rightTables.setRowHeight(i,18);
	        }
        }
        ((MyRightCellRenderer)rightTables.getCellRenderer(0, 0)).setColor(myBiJiaoIsFolderNames,Color.ORANGE);
        
        ArrayList<Integer> myBiJiaoDifferentSizes = new ArrayList<Integer>();
        ArrayList<Integer> myBiJiaoDifferentFiles = new ArrayList<Integer>();
        for(int i = 0 ; i<rightTables.getRowCount();i++){
        	if("大小不同".equals(rightTables.getValueAt(i,3))){
        		myBiJiaoDifferentSizes.add(i);
	        }
        	if("完全不相同".equals(rightTables.getValueAt(i,3))){
        		myBiJiaoDifferentFiles.add(i);
        	}
        }
        ((MyRightCellRenderer)rightTables.getCellRenderer(0, 0)).setDifferentSizeColor(myBiJiaoDifferentSizes,Color.BLUE);
        ((MyRightCellRenderer)rightTables.getCellRenderer(0, 0)).setDifferentAllColor(myBiJiaoDifferentFiles,Color.YELLOW);
        
        rightTables.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		
		rightTables.setBorder(new EmptyBorder(0,0,0,10));
		return rightPanel;
	}

	private void initRightData(MyTableRightModel rightTableModel) {
		for(int i = 0 ; i<ExecuteController.getInstance().getBijiaoListsMap().size();i++){
			ArrayList<String> thisBiJiaoLists = ExecuteController.getInstance().getBijiaoListsMap().get(ExecuteController.getInstance().getFilesLists()[i]);
			Object[][] BRightObjects = new Object[thisBiJiaoLists.size()][rightTableModel.getColumnCount()];
			Object[][] KBRightObjects = new Object[thisBiJiaoLists.size()][rightTableModel.getColumnCount()];
			Object[][] MBRightObjects = new Object[thisBiJiaoLists.size()][rightTableModel.getColumnCount()];
			for(int j = 0 ;j < BRightObjects.length;j++){
				for(int k = 0;k<rightTableModel.getColumnCount();k++){
					String prefix = "";
					boolean isDirect = false;
					String filePath = thisBiJiaoLists.get(BRightObjects.length-j-1);
					long fileValue = ExecuteController.getInstance().getBijiaoFiles().get(filePath);
					if(new File(filePath).isDirectory()){
						prefix = "文件夹";
						isDirect = true;
					}
					switch(k){
					case 0:
						if(isDirect){
							String splitName = ExecuteController.getInstance().getFilesLists()[i].substring(ExecuteController.getInstance().getFilesLists()[i].lastIndexOf("/")+1,ExecuteController.getInstance().getFilesLists()[i].lastIndexOf("."));
							BRightObjects[j][k] = prefix + filePath.split(splitName)[1];
							KBRightObjects[j][k] = prefix + filePath.split(splitName)[1];
							MBRightObjects[j][k] = prefix + filePath.split(splitName)[1];
						}else{
							BRightObjects[j][k] =  prefix + filePath.substring(filePath.lastIndexOf("/")+1);
							KBRightObjects[j][k] = prefix + filePath.substring(filePath.lastIndexOf("/")+1);
							MBRightObjects[j][k] = prefix + filePath.substring(filePath.lastIndexOf("/")+1);
						}
						break;
					case 1:
						BRightObjects[j][k] = isDirect?"文件夹":"文件";
						KBRightObjects[j][k] = isDirect?"文件夹":"文件";
						MBRightObjects[j][k] = isDirect?"文件夹":"文件";
						break;
					case 2:
						BRightObjects[j][k] = fileValue + sizeLists[0];
						KBRightObjects[j][k] = convertToKB(fileValue) + sizeLists[1];
						MBRightObjects[j][k] = convertToMB(fileValue) + sizeLists[2];
						break;
					case 3:
						if(ExecuteController.getInstance().getDifferentFilesMap().get(ExecuteController.getInstance().getFilesLists()[i]).get(filePath) == null){
							String tempBijiaoFile = ExecuteController.getInstance().getFilesLists()[i].split("\n")[i].substring(ExecuteController.getInstance().getFilesLists()[i].split("\n")[i].lastIndexOf("/"),ExecuteController.getInstance().getFilesLists()[i].split("\n")[i].length()-4);
							String prefiDef = "/temp" + tempBijiaoFile;
							String orginDef = ExecuteController.getInstance().getOriginTestFiles();
							String canzhaoTempFile = System.getProperty("user.dir") + "/temp/" + orginDef.substring(orginDef.lastIndexOf("/")+1,orginDef.length() - 4);
							String convertDef = canzhaoTempFile + filePath.split(prefiDef)[1];
							long originLength = ExecuteController.getInstance().getCanzhaoFiles().get(convertDef);
							if(originLength == fileValue){
								BRightObjects[j][k] = "相同";
								KBRightObjects[j][k] = "相同";
								MBRightObjects[j][k] = "相同";
							}else{
								BRightObjects[j][k] = "大小不同";
								KBRightObjects[j][k] = "大小不同";
								MBRightObjects[j][k] = "大小不同";
							}
							
						}else{
							BRightObjects[j][k] = "完全不相同";
							KBRightObjects[j][k] = "完全不相同";
							MBRightObjects[j][k] = "完全不相同";
						}
						break;
					}
				}
			}
			
			rightBObjects.add(BRightObjects);
			rightKBObjects.add(KBRightObjects);
			rightMBObjects.add(MBRightObjects);
		}
		rightTableModel.setLeftColumnValues(rightBObjects.get(0));
	}

	private JPanel createLeftPanel() {
		JPanel leftPanel = new JPanel();
		leftPanel.setLayout(new BorderLayout());
		String filePath = ExecuteController.getInstance().getOriginTestFiles();
		long fileSize = ExecuteController.getInstance().getCanzhaoFiles().get(filePath);
		
		leftTitleStr = new JLabel(filePath.substring(filePath.lastIndexOf("/")+1) + "  (" + fileSize + " B)");
		leftTitleStr.setBorder(new EmptyBorder(5, 50, 5, 5));
		leftTitleStr.setFont(new Font("楷体",Font.BOLD,15));
		leftTitleStr.setForeground(Color.RED);
		leftPanel.add(leftTitleStr,BorderLayout.NORTH);
		
		myLeftTableModel = new MyTableModel();
		initData(myLeftTableModel);
		leftTables = new JTable(){
			MyCellRenderer dataRender = new MyCellRenderer();
			public TableCellRenderer getCellRenderer(int row,int column){
				return dataRender;
			}
		};
		
		leftTables.setModel(myLeftTableModel);
		JScrollPane scrollPane = new JScrollPane(leftTables);
		leftPanel.add(scrollPane, BorderLayout.SOUTH);
		
		TableColumn column = null;  
        int colunms = leftTables.getColumnCount();  
        for(int i = 0; i < colunms; i++){  
            column = leftTables.getColumnModel().getColumn(i);  
            /*将每一列的默认宽度设置为100*/  
            if(i == 0 ){
            	column.setPreferredWidth(250);	
            }
            if(i == 2){
            	column.setPreferredWidth(124);
            }
        }
        
        ArrayList<Integer> myCanZhaoIsFolderNames = new ArrayList<Integer>();
        for(int i = 0 ; i<leftTables.getRowCount();i++){
        	if("文件夹".equals(leftTables.getValueAt(i,1))){
        		myCanZhaoIsFolderNames.add(i);
        		leftTables.setRowHeight(i,18);
	        }
        }
        ((MyCellRenderer)leftTables.getCellRenderer(0, 0)).setColor(myCanZhaoIsFolderNames,Color.ORANGE);
		
		leftTables.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		
		return leftPanel;
	}

	private void initData(MyTableModel model) {
		leftBObjects = new Object[ExecuteController.getInstance().getCanzhaoLists().size()][model.getColumnCount()];
		leftKBObjects = new Object[ExecuteController.getInstance().getCanzhaoLists().size()][model.getColumnCount()];
		leftMBObjects = new Object[ExecuteController.getInstance().getCanzhaoLists().size()][model.getColumnCount()];
		for(int i = 0 ;i < leftBObjects.length;i++){
			for(int j = 0;j<model.getColumnCount();j++){
				String prefix = "";
				boolean isDirect = false;
				String filePath = ExecuteController.getInstance().getCanzhaoLists().get(leftBObjects.length-i-1);
				long fileValue = ExecuteController.getInstance().getCanzhaoFiles().get(filePath);
				if(new File(filePath).isDirectory()){
					prefix = "文件夹";
					isDirect = true;
				}
				switch(j){
				case 0:
					if(isDirect){
						String splitName = ExecuteController.getInstance().getOriginTestFiles().substring(ExecuteController.getInstance().getOriginTestFiles().lastIndexOf("/")+1,ExecuteController.getInstance().getOriginTestFiles().lastIndexOf("."));
						leftBObjects[i][j] = prefix + filePath.split(splitName)[1];
						leftKBObjects[i][j] = prefix + filePath.split(splitName)[1];
						leftMBObjects[i][j] = prefix + filePath.split(splitName)[1];
					}else{
						leftBObjects[i][j] = prefix + filePath.substring(filePath.lastIndexOf("/")+1);
						leftKBObjects[i][j] = prefix + filePath.substring(filePath.lastIndexOf("/")+1);
						leftMBObjects[i][j] = prefix + filePath.substring(filePath.lastIndexOf("/")+1);
					}
					break;
				case 1:
					leftBObjects[i][j] = isDirect?"文件夹":"文件";
					leftKBObjects[i][j] = isDirect?"文件夹":"文件";
					leftMBObjects[i][j] = isDirect?"文件夹":"文件";
					break;
				case 2:
					leftBObjects[i][j] = fileValue + sizeLists[0];
					leftKBObjects[i][j] = convertToKB(fileValue) + sizeLists[1];
					leftMBObjects[i][j] = convertToMB(fileValue) + sizeLists[2];
					break;
				}
				
			}
		}
		model.setLeftColumnValues(leftBObjects);
	}

	private JPanel createTitlePanel() {
		JPanel titlePanel = new JPanel();
		JLabel titleStr = new JLabel("结果");
		titleStr.setFont(new Font("宋体",Font.BOLD,20));
		titleStr.setForeground(Color.BLUE);
		titlePanel.add(titleStr,BorderLayout.CENTER);
		
		return titlePanel;
	}
	
	private String convertToKB(long Byte){
		if(Byte != 0){
			double byteD = Byte / 1024.0;
			DecimalFormat format = new DecimalFormat("#0.00");
			return format.format(byteD);
		}else{
			return Byte + "";
		}
	}
	
	private String convertToMB(long Byte){
		if(Byte != 0){
			double byteD = Byte / (1024.0 * 1024.0);
			DecimalFormat format = new DecimalFormat("#0.0000");
			return format.format(byteD);
		}else{
			return Byte + "";
		}
	}
}

class MyTableModel extends AbstractTableModel {
	private static final String[] columnNames = new String[]{"文件名","是否文件夹","大小"}; 
    
	private Object[][] leftColumnValues;
    
    public Object[][] getLeftColumnValues() {
		return leftColumnValues;
	}
	public void setLeftColumnValues(Object[][] leftColumnValues) {
		this.leftColumnValues = leftColumnValues;
	}
	
	//实现必须方法
    public Object getValueAt(int row, int col) {
       return leftColumnValues[row][col];
    }
    public String getColumnName(int col) { return columnNames[col];}
    public int getColumnCount() { return columnNames.length;}
    public int getRowCount() { return leftColumnValues.length; }
}

class MyTableRightModel extends AbstractTableModel{
	private static final String[] columnNames = new String[]{"文件名","是否文件夹","大小","与参照版本大小是否相同"}; 
    
	private Object[][] rightColumnValues;
    
    public Object[][] getRightColumnValues() {
		return rightColumnValues;
	}
	public void setLeftColumnValues(Object[][] rightColumnValues) {
		this.rightColumnValues = rightColumnValues;
	}
	
	//实现必须方法
    public Object getValueAt(int row, int col) {
       return rightColumnValues[row][col];
    }
    public String getColumnName(int col) { return columnNames[col];}
    public int getColumnCount() { return columnNames.length;}
    public int getRowCount() { return rightColumnValues.length; }
}

class MyCellRenderer extends DefaultTableCellRenderer {
	ArrayList<Integer> num;
	Color color;
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected,boolean hasFocus, int row, int column) {
        Component cell = super.getTableCellRendererComponent( table, value,isSelected, hasFocus, row, column);
        for(int i = 0 ; i <num.size();i++){
        	if(num.get(i) == row){
        		cell.setBackground(color);
        		cell.setForeground(Color.DARK_GRAY);
            	cell.setFont(new Font("楷体",Font.BOLD,18));
        		return cell;
        	}
        }
        cell.setBackground(null);
        cell.setForeground(Color.BLACK);
    	cell.setFont(new Font("宋体",Font.PLAIN,14));
        return cell;
    }
    
    public void setColor(ArrayList<Integer> nums,Color color){
    	num = nums;
    	this.color = color;
    }
}

class MyRightCellRenderer extends DefaultTableCellRenderer {
	ArrayList<Integer> num;
	Color color;
	ArrayList<Integer> rowNums;
	Color rowSizeColor;
	ArrayList<Integer> allDifferentRows;
	Color allDifferentColor;
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected,boolean hasFocus, int row, int column) {
        Component cell = super.getTableCellRendererComponent( table, value,isSelected, hasFocus, row, column);
        for(int i = 0 ; i <num.size();i++){
        	if(num.get(i) == row){
        		cell.setBackground(color);
        		cell.setForeground(Color.DARK_GRAY);
            	cell.setFont(new Font("楷体",Font.BOLD,18));
            	for(int j = 0 ;j<rowNums.size();j++){
            		if(rowNums.get(j) == row){
            			if(column == 2){
            				cell.setBackground(rowSizeColor);
            				cell.setForeground(Color.ORANGE);
            				cell.setFont(new Font("楷体",Font.BOLD,18));
            				return cell;
            			}
            		}
            	}
            	for(int k = 0 ;k<allDifferentRows.size();k++){
            		if(allDifferentRows.get(k) == row){
            			cell.setBackground(allDifferentColor);
            			return cell;
            		}
            	}
        		return cell;
        	}
        }
        
        
        cell.setBackground(null);
        cell.setForeground(Color.BLACK);
    	cell.setFont(new Font("宋体",Font.PLAIN,14));
    	for(int i = 0 ;i<rowNums.size();i++){
    		if(rowNums.get(i) == row){
    			if(column == 2){
    				cell.setBackground(rowSizeColor);
    				cell.setForeground(Color.ORANGE);
    				cell.setFont(new Font("宋体",Font.BOLD,18));
    				return cell;
    			}
    		}
    	}
    	for(int i = 0 ;i<allDifferentRows.size();i++){
    		if(allDifferentRows.get(i) == row){
    			cell.setBackground(allDifferentColor);
    			return cell;
    		}
    	}
        return cell;
    }
    
    public void setColor(ArrayList<Integer> nums,Color color){
    	num = nums;
    	this.color = color;
    }
    
    public void setDifferentSizeColor(ArrayList<Integer> rowNums,Color color){
    	this.rowNums = rowNums;
    	this.rowSizeColor = color;
    }
    
    public void setDifferentAllColor(ArrayList<Integer> allDifferentRows,Color color){
    	this.allDifferentRows = allDifferentRows;
    	this.allDifferentColor = color;
    }
}


