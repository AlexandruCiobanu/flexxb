/**
 *   FxMOD - FLEX Model Object Designer 
 *   Copyright (C) 2008-2009 Alex Ciobanu
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 * 
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */ 
package com.googlecode.fxmod
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import com.googlecode.fxmod.ui.AboutView;
	import com.googlecode.fxmod.ui.HelpView;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenuItem;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.core.IFlexDisplayObject;
	import mx.core.WindowedApplication;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import com.fxmarker.VERSION;
	import com.googlecode.flexxb.VERSION;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class ApplicationController
	{
		private var view : FxMOD;
		
		private var appUpdater:ApplicationUpdaterUI;
		
		private var model : ApplicationModelLocator;
		
		public function ApplicationController()
		{
			appUpdater = new ApplicationUpdaterUI();
		}
		
		public function initialize(view : WindowedApplication) : void{
			this.view = view as FxMOD;
			model = this.view.model;
			checkForUpdate();
		}
		
		private function checkForUpdate():void {
			// The code below is a hack to work around a bug in the framework so that CMD-Q still works on MacOS
			// This is a temporary fix until the framework is updated
			// See http://www.adobe.com/cfusion/webforums/forum/messageview.cfm?forumid=72&catid=670&threadid=1373568
			NativeApplication.nativeApplication.addEventListener( Event.EXITING, 
				function(e:Event):void {
					var opened:Array = NativeApplication.nativeApplication.openedWindows;
					for (var i:int = 0; i < opened.length; i ++) {
						opened[i].close();
					}
			});	
	
			// Configuration stuff - see update framework docs for more details
			appUpdater.updateURL = "http://localhost/fxmod/updates/update.xml"; // Server-side XML file describing update
			appUpdater.isCheckForUpdateVisible = false; // We won't ask permission to check for an update
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate); // Once initialized, run onUpdate
			appUpdater.addEventListener(ErrorEvent.ERROR, onError); // If something goes wrong, run onError
			appUpdater.initialize(); // Initialize the update framework
		}
	
		private function onError(event:ErrorEvent):void {
			Alert.show(event.toString());
		}
		
		private function onUpdate(event:UpdateEvent):void {
			appUpdater.checkNow(); // Go check for an update now
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		public final function onHelpItemClick(event : Event) : void{
			var window : HelpView = new HelpView();
			window.open(true);
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		public final function onPreferencesItemClick(event : Event) : void{
			
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		public final function onExitItemClick(event : Event) : void{
			NativeApplication.nativeApplication.exit();
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public final function get themes() : Array{
			return Settings.instance.themes;
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		public final function onThemesItemClick(event : Event) : void{
			var item : NativeMenuItem = event.target as NativeMenuItem;
			if(item.checked){
				return;
			}
			checkSelectedItem(item);
			if(model.currentThemePath){
				//StyleManager.unloadStyleDeclarations(model.currentThemePath, true);
			}
			
			model.currentThemePath = String(item.data);
			
			if(model.currentThemePath){
				//StyleManager.loadStyleDeclarations(model.currentThemePath, true);
			}
		}
		public function onUpdateItemClick(event : Event) : void{
			
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function getComponentVersions() : Array{
			var versions : Array = [];
			versions.push(getVersionDescriptor(com.googlecode.fxmod.VERSION.Name, com.googlecode.fxmod.VERSION.Link, com.googlecode.fxmod.VERSION.Version));
			versions.push(getVersionDescriptor(com.googlecode.flexxb.VERSION.Name, com.googlecode.flexxb.VERSION.Link, com.googlecode.flexxb.VERSION.Version));
			versions.push(getVersionDescriptor(com.fxmarker.VERSION.Name, com.fxmarker.VERSION.Link, com.fxmarker.VERSION.Version));
			return versions;
		}
		/**
		 * 
		 * @param name
		 * @param link
		 * @param version
		 * @return 
		 * 
		 */		
		private function getVersionDescriptor(name : String, link : String, version : String) : Object{
			return {name: name, link: link, version: version};
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		public final function onAboutItemClick(event : Event) : void{
			var popup : AboutView = showAndCenterPopup(AboutView) as AboutView;
			popup.applicationController = this;
		}
		
		private function checkSelectedItem(item : NativeMenuItem) : void{
			item.checked = true;
			for each(var menuItem : NativeMenuItem in item.menu.items){
				if(item != menuItem){
					menuItem.checked = false;
				}
			}
		} 
		
		private function showAndCenterPopup(clasz : Class) : Object{
			var popup : IFlexDisplayObject = new clasz();
			popup.addEventListener(CloseEvent.CLOSE, viewClosed, false, 0, true);
			PopUpManager.addPopUp(popup, view, true);
			PopUpManager.centerPopUp(popup);
			return popup;
		}
		
		private function viewClosed(event : CloseEvent) : void{
			PopUpManager.removePopUp(event.target as IFlexDisplayObject);
		}
	}
}