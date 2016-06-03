package com.clark.controller;

import com.clark.view.DisplayView;
import com.clark.view.LoadingView;
import com.clark.view.MainView;

public class ViewController {
	private ViewController(){}
	private static ViewController viewController;
	
	private MainView mainView;
	private LoadingView loadingView;
	private DisplayView displayView;
	
	public static ViewController getInstance(){
		if(viewController == null){
			viewController = new ViewController();
		}
		return viewController;
	}
	
	public void showMainView(){
		if(mainView == null){
			mainView = new MainView();
		}
		mainView.clearData();
		mainView.setVisible(true);
	}
	
	public void hideMainView(){
		if(mainView != null){
			mainView.setVisible(false);
		}
	}

	public void cancelLoadingView() {
		if(loadingView != null){
			loadingView.setVisible(false);
		}
	}
	
	public void showLoadingView(){
		if(loadingView == null){
			loadingView = new LoadingView();
		}
		loadingView.setVisible(true);
	}
	
	public void showDisplayView(){
		if(displayView == null){
			displayView = new DisplayView();
		}
		displayView.setVisible(true);
	}
	
	public void hideDisplayView(){
		if(displayView != null){
			displayView.setVisible(false);
		}
	}
}
