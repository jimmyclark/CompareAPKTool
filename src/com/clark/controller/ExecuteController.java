package com.clark.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.boyaa.clark.util.FileUtils;
import com.boyaa.clark.util.ZipUtils;

public class ExecuteController {
	private ArrayList<String> canzhaoLists = new ArrayList<String>();
	public ArrayList<String> getCanzhaoLists() {
		return canzhaoLists;
	}
	
	private HashMap<String,ArrayList<String>> bijiaoListsMap = new HashMap<String,ArrayList<String>>();
	public HashMap<String, ArrayList<String>> getBijiaoListsMap() {
		return bijiaoListsMap;
	}

	private ArrayList<String> bijiaoLists = new ArrayList<String>();
	

	private HashMap<String,Long> canzhaoFiles = new HashMap<String,Long>();
	public HashMap<String, Long> getCanzhaoFiles() {
		return canzhaoFiles;
	}
	private HashMap<String,Long> bijiaoFiles = new HashMap<String,Long>();
	public HashMap<String, Long> getBijiaoFiles() {
		return bijiaoFiles;
	}
	private HashMap<String,HashMap<String,Long>> bijaoFilesMap = new HashMap<String,HashMap<String,Long>>();
	private HashMap<String,HashMap<String,Long>> sameFilesMap = new HashMap<String,HashMap<String,Long>>();
	public HashMap<String, HashMap<String, Long>> getSameFilesMap() {
		return sameFilesMap;
	}

	private HashMap<String,HashMap<String,Long>> differentFilesMap = new HashMap<String,HashMap<String,Long>>();
	public HashMap<String, HashMap<String, Long>> getDifferentFilesMap() {
		return differentFilesMap;
	}

	private String[] filesLists;
	private String originTestFiles;
	private String[] compareFiles;
	
	public String[] getCompareFiles() {
		return compareFiles;
	}

	public String getOriginTestFiles() {
		return originTestFiles;
	}

	public String[] getFilesLists() {
		return filesLists;
	}

	private ExecuteController(){}
	private static ExecuteController executeController;
	
	public static ExecuteController getInstance(){
		if(executeController == null){
			executeController = new ExecuteController();
		}
		return executeController;
	}
	
	public void excuteCompare(final String canzhaoFile,final String bijiaoFile){
		ViewController.getInstance().hideMainView();
		ViewController.getInstance().showLoadingView();
		
		canzhaoFiles.put(canzhaoFile,FileUtils.getFileSize(canzhaoFile));
		compareFiles = new String[bijiaoFile.split("\n").length];
		for(int i = 0 ;i<bijiaoFile.split("\n").length;i++){
			bijiaoFiles.put(bijiaoFile.split("\n")[i],FileUtils.getFileSize(bijiaoFile.split("\n")[i]));
			bijaoFilesMap.put(bijiaoFile.split("\n")[i],bijiaoFiles);
			compareFiles[i] = bijiaoFile.split("\n")[i];
		}
		
		new Thread(){
			public void run(){
				boolean canchaoFlag = unzipApk(canzhaoFile);
				boolean bijiaoFlag = false;
				if(canchaoFlag){
					System.out.println("解压" + canzhaoFile + "成功!");
					for(int i = 0;i<bijiaoFile.split("\n").length;i++){
						bijiaoFlag = unzipApk(bijiaoFile.split("\n")[i]);
						if(!bijiaoFlag){
							break;
						}else{
							System.out.println("解压" + bijiaoFile.split("\n")[i] + "成功!");
						}
					}
					
					if(bijiaoFlag){
						System.out.println("解压完毕");
					}
				}
//				
//				System.out.println("文件罗列并赋值");
				String canzhaoTempFile = System.getProperty("user.dir") + "/temp/" + canzhaoFile.substring(canzhaoFile.lastIndexOf("/")+1,canzhaoFile.length() - 4) + "/";
				originTestFiles = canzhaoFile;
				calcuAllOriginFileSize(canzhaoTempFile);
				
//				System.out.println(canzhaoFiles.size());
				
				filesLists = new String[bijiaoFile.split("\n").length];
				for(int i = 0;i<bijiaoFile.split("\n").length;i++){
					String tempBijiaoFile = bijiaoFile.split("\n")[i].substring(bijiaoFile.split("\n")[i].lastIndexOf("/"),bijiaoFile.split("\n")[i].length()-4);
					bijiaoLists = new ArrayList<String>();
					calcuAllBiJiaoFileSize(canzhaoTempFile,bijiaoFile.split("\n")[i], System.getProperty("user.dir") + "/temp" + tempBijiaoFile + "/");
					bijiaoListsMap.put(bijiaoFile.split("\n")[i], bijiaoLists);
					filesLists[i] = bijiaoFile.split("\n")[i];
				}
				
				ViewController.getInstance().cancelLoadingView();
				ViewController.getInstance().showDisplayView();
				
				FileUtils.deleteDirectory(canzhaoTempFile);
				
				for(int i = 0;i<bijiaoFile.split("\n").length;i++){
					String tempBijiaoFile = bijiaoFile.split("\n")[i].substring(bijiaoFile.split("\n")[i].lastIndexOf("/"),bijiaoFile.split("\n")[i].length()-4);
					String sPath = System.getProperty("user.dir") + "/temp" + tempBijiaoFile;
					FileUtils.deleteDirectory(sPath);
				}
				
			}
		}.start();
	}
	
	private boolean unzipApk(final String fileName){
		if(fileName.trim().length() == 0 ) return false;
		
		final String decompileFileName = System.getProperty("user.dir") + "/temp/" + fileName.substring(fileName.lastIndexOf("/")+1,fileName.length() - 4) + "/";
		decompileFileName.replaceAll("\\\\", "/");
		try{
			return ZipUtils.unzip(fileName, decompileFileName);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}

	private void calcuAllOriginFileSize(String tempFile){
		if(tempFile.trim().length() == 0) return;
		File tempFiles = new File(tempFile);
		if(!tempFiles.exists()) return;
		for(int i = 0 ;i<tempFiles.list().length;i++){
			File file = new File(tempFile + tempFiles.list()[i]);
			if(file.isDirectory()){
				calcuAllOriginFileSize(tempFile + tempFiles.list()[i] + "/");
				canzhaoLists.add(tempFile + tempFiles.list()[i]);
				canzhaoFiles.put(tempFile + tempFiles.list()[i], getFileSize(file));
			}else{
				canzhaoLists.add(tempFile + tempFiles.list()[i]);
				canzhaoFiles.put(tempFile + tempFiles.list()[i], FileUtils.getFileSize(tempFile + tempFiles.list()[i]));
			}
		}
	}
	
	private long getFileSize(File f){
		long  size =  0 ;  
		File flist[] = f.listFiles();
		for  ( int  i =  0 ; i < flist.length; i++){  
			if(flist[i].isDirectory()){  
				size = size + getFileSize(flist[i]);  
		    } else{  
		        size = size + flist[i].length();  
		    }  
		}  
		return size;  
	}
	
	private void calcuAllBiJiaoFileSize(String originPath,String rootFile,String tempFile){
		if(tempFile.trim().length() == 0) return;
		File tempFiles = new File(tempFile);
		if(!tempFiles.exists()) return;
		String fileName = rootFile.substring(rootFile.lastIndexOf("/")+1,rootFile.length() - 4) + "/";
		for(int i = 0 ;i<tempFiles.list().length;i++){
			File file = new File(tempFile + tempFiles.list()[i]);
			if(file.isDirectory()){
				calcuAllBiJiaoFileSize(originPath,rootFile,tempFile + tempFiles.list()[i] + "/");
				bijiaoLists.add(tempFile + tempFiles.list()[i]);
				bijaoFilesMap.get(rootFile).put(tempFile + tempFiles.list()[i], getFileSize(file));
				String temp = originPath + (tempFile + tempFiles.list()[i]).split(fileName)[1];
				if(canzhaoFiles.get(temp)!= null){
					if(sameFilesMap.get(rootFile)==null){
						HashMap<String,Long> tempMap = new HashMap<String,Long>();
						sameFilesMap.put(rootFile, tempMap);
					}
					sameFilesMap.get(rootFile).put(tempFile + tempFiles.list()[i], getFileSize(file));
				}else{
					if(differentFilesMap.get(rootFile)==null){
						HashMap<String,Long> tempMap = new HashMap<String,Long>();
						differentFilesMap.put(rootFile, tempMap);
					}
					differentFilesMap.get(rootFile).put(tempFile + tempFiles.list()[i], getFileSize(file));
				}
			}else{
				bijaoFilesMap.get(rootFile).put(tempFile + tempFiles.list()[i], FileUtils.getFileSize(tempFile + tempFiles.list()[i]));
				String temp = originPath + (tempFile + tempFiles.list()[i]).split(fileName)[1];
				bijiaoLists.add(tempFile + tempFiles.list()[i]);
				if(canzhaoFiles.get(temp)!= null){
					if(sameFilesMap.get(rootFile)==null){
						HashMap<String,Long> tempMap = new HashMap<String,Long>();
						sameFilesMap.put(rootFile, tempMap);
					}
					sameFilesMap.get(rootFile).put(tempFile + tempFiles.list()[i], FileUtils.getFileSize(tempFile + tempFiles.list()[i]));
				}else{
					if(differentFilesMap.get(rootFile)==null){
						HashMap<String,Long> tempMap = new HashMap<String,Long>();
						differentFilesMap.put(rootFile, tempMap);
					}
					differentFilesMap.get(rootFile).put(tempFile + tempFiles.list()[i], FileUtils.getFileSize(tempFile + tempFiles.list()[i]));
				}
			}
		}
		
		
	}
	
}
