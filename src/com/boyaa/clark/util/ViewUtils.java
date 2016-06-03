package com.boyaa.clark.util;

import java.awt.Dimension;
import java.awt.Toolkit;

/**
 * 界面工具类
 * @author ClarkWu
 *
 */
public class ViewUtils {
	
	/**
	 * 获取屏幕宽度的方法
	 * no parameters
	 * @return 屏幕宽度   int
	 */
	public static int getScreenWidth(){
		//获取屏幕大小
	    Dimension screenSize =Toolkit.getDefaultToolkit().getScreenSize();
	    return screenSize.width;
	}
	
	/**
	 * 获取屏幕高度的方法
	 * no parameters
	 * @return 屏幕高度   int
	 */
	public static int getScreenHeight(){
		//获取屏幕大小
	    Dimension screenSize =Toolkit.getDefaultToolkit().getScreenSize();
	    return screenSize.height;
	}
	
	/**
	 * 获取某个界面需要设置在屏幕中央的宽度
	 * @param view_width 某个界面的宽度
	 * @return 需要设置在屏幕中央的宽度
	 */
	public static int setScreenCenterWidth(int view_width){
		return (getScreenWidth()-view_width)/2;
	}
	
	/**
	 * 获取某个界面需要设置在屏幕中央的高度
	 * @param view_height 某个界面的高度
	 * @return 需要设置在屏幕中央的高度
	 */
	public static int setScreenCenterHeight(int view_height){
		return (getScreenHeight()-view_height)/2;
	}
}
