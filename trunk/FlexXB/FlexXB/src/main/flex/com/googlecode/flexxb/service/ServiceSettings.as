/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008 Alex Ciobanu
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
package com.googlecode.flexxb.service
{
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	[Event(name="settingsChange", type="com.googlecode.flexxb.service.SettingsChangedEvent")]
	public class ServiceSettings extends EventDispatcher
	{
		/**
		 * 
		 */		
		private var _url : String;
		/**
		 * 
		 */
		private var _method : String;
		/**
		 * 
		 */		
		private var _destination : String;
		/**
		 * 
		 */
		private var _timeout : int; 
		/**
		 * 
		 */		
		private var _logMessages : Boolean;
		
		public function ServiceSettings(url : String = "", method : String = "POST", destination : String = "", timeout : int = 60000, logMessages : Boolean = false)
		{
			this.url = url;
			this.method = method;
			this.destination = destination;
			this.timeout = timeout;
			this.logMessages = logMessages;
		}	
		/**
		 * Get the url
		 * @return 
		 * 
		 */		
		public function get url() : String{
			return _url;
		}	
		/**
		 * Set the url
		 * @param value
		 * 
		 */		
		public function set url(value : String) : void{
			_url = value;
			if(hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)){
				dispatchEvent(new SettingsChangedEvent());
			}
		}
		/**
		 * Get the method
		 * @return 
		 * 
		 */		
		public function get method() : String{
			return _method;
		}	
		/**
		 * Set the method
		 * @param value
		 * 
		 */		
		public function set method(value : String) : void{
			_method = value;
			if(hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)){
				dispatchEvent(new SettingsChangedEvent());
			}
		}
		/**
		 * Get the destination
		 * @return 
		 * 
		 */		
		public function get destination() : String{
			return _destination;
		}	
		/**
		 * Set the destination
		 * @param value
		 * 
		 */		
		public function set destination(value : String) : void{
			_destination = value;
			if(hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)){
				dispatchEvent(new SettingsChangedEvent());
			}
		}
		/**
		 * Get the timeout
		 * @return 
		 * 
		 */		
		public function get timeout() : int{
			return _timeout;
		}	
		/**
		 * Set the timeout
		 * @param value
		 * 
		 */		
		public function set timeout(value : int) : void{
			_timeout = value;
			if(hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)){
				dispatchEvent(new SettingsChangedEvent());
			}
		}
		/**
		 * Get the logMessages
		 * @return 
		 * 
		 */		
		public function get logMessages() : Boolean{
			return _logMessages;
		}	
		/**
		 * Set the logMessages
		 * @param value
		 * 
		 */		
		public function set logMessages(value : Boolean) : void{
			_logMessages = value;
			if(hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)){
				dispatchEvent(new SettingsChangedEvent());
			}
		}
	}
}