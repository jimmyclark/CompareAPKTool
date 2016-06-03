package com.boyaa.clark.test;

import com.clark.controller.ViewController;

public class test {
	public static void gradletest(){
//		
//	    try{
//	    	Runtime.getRuntime().exec(
//					"cmd " + System.getProperty("user.dir")
//							+ ConstantValue.FILE_SEPARTOR + "key"
//							+ ConstantValue.FILE_SEPARTOR + "gradle");
//			String cmdFile = System.getProperty("user.dir")
//					+ ConstantValue.FILE_SEPARTOR + "key"
//					+ ConstantValue.FILE_SEPARTOR + "gradle"
//					+ ConstantValue.FILE_SEPARTOR + "gradlepackage.bat";
//			Process ObjPrcess= Runtime.getRuntime()
//					.exec("cmd.exe /c start " + cmdFile);
//	    }catch(Exception e){
//	    	e.printStackTrace();
//	    }
	}
	
	public static void main(String[] args) throws Exception {
		ViewController.getInstance().showMainView();
//		ViewController.getInstance().showDisplayView();
	}
}
