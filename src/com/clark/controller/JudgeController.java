package com.clark.controller;

public class JudgeController {
	private JudgeController(){}
	private static JudgeController judgeController;
	
	public static JudgeController getInstance(){
		if(judgeController == null){
			judgeController = new JudgeController();
		}
		return judgeController;
	}
	
	public boolean isApkFile(String inputStr){
		if(inputStr.trim().length() == 0) return false;
		if("apk".equals(inputStr.substring(inputStr.lastIndexOf("apk")))){
			return true;
		}
		return false;
	}
	
}
