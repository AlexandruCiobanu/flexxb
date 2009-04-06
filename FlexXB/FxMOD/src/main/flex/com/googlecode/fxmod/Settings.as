/**
 *   FxMOD
 *   Copyright (C) 2008 - 2009 Alex Ciobanu
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
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */
	public class Settings extends EventDispatcher
	{
		private static const _instance : Settings = new Settings();
		
		public static function get instance() : Settings{
			return _instance;
		}
		/**
		 * 
		 */		
		private var _watcher : ChangeWatcher;
		/**
		 * 
		 */		
		private var _appDescriptor : XML;
		/**
		 * 
		 */		
		private var ns : Namespace;
		/**
		 * 
		 * 
		 */		
		public function Settings()
		{
			if(_instance){
				throw new Error("Use Settings.instance!");
			}
			buildWatcher();
		}
		/**
		 * 
		 * 
		 */		
		public function destroy() : void{
			if(_watcher){
				_watcher.unwatch();
				_watcher = null;
			}
		}
		/**
		 * 
		 * 
		 */		
		private function buildWatcher() : void{
			if(!_watcher){
				_watcher = BindingUtils.bindSetter(appDescriptorChanged, NativeApplication.nativeApplication, "applicationDescriptor");
				appDescriptorChanged(_watcher.getValue() as XML); 
			}
		}
		/**
		 * 
		 * @param newAppDescriptor
		 * 
		 */		
		private function appDescriptorChanged(newAppDescriptor : XML) : void{
			if(newAppDescriptor == null){
				throw new Error("Application settings descriptor is empty");
			}
			_appDescriptor = newAppDescriptor;
			ns = newAppDescriptor.namespace();
			dispatchEvent(new Event("ApplicationDescriptorChange"));
		}
				
		[Bindable(event="ApplicationDescriptorChange")]
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get themes() : Array{
			default xml namespace = ns;
			var themeList : XMLList = _appDescriptor.themes.theme;
			var result : Array = [];
			var label : String;
			var path : String;
			for each(var theme : XML in themeList){
				label = theme.@label;
				path = theme.@path;
				result.push({label:label, path: path});
			}
			return result;
		}
	}
}