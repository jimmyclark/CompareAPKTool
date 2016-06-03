package com.boyaa.clark.util;

import java.io.File;

public class FileUtils {
	public static long getFileSize(String fileName){
		File file = new File(fileName);
		if(!file.exists()) return 0;
		return file.length();
	}
	
	/**
	 * 删除文件夹的方法
	 * @param sPath   文件路径
	 * @return true  文件删除成功
	 * 		   false 文件删除失败
	 */
	public static boolean deleteDirectory(String sPath){
		if(!sPath.endsWith("/")){
			sPath += "/";
		}
		
		File dirFile = new File(sPath);
		if(!dirFile.exists() || !dirFile.isDirectory()){
			return false;
		}
		boolean flag = true;
		File[] files = dirFile.listFiles();
		for(int i=0;i<files.length;i++){
			if(files[i].isFile()){
				flag = deleteFile(files[i].getAbsolutePath());
				if(!flag) break;
			}
			else{
				flag = deleteDirectory(files[i].getAbsolutePath());
				if(!flag) break;
			}
		}
		if(!flag) return false;
		//删除当前目录
		if(dirFile.delete()){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 删除单个文件
	 * @param sPath 文件路径
	 * @return 	 true 文件删除成功
	 *  	 	false 文件删除失败
	 */
	private static boolean deleteFile(String sPath){
		boolean flag = false;
		File file = new File(sPath);
		//路径为文件且不为空则进行删除
		if(file.exists() && file.isFile()){
			file.delete();
			flag = true;
		}
		return flag;
	}
}
