/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.service {
	import flash.events.EventDispatcher;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	[Event(name="settingsChange", type="com.googlecode.flexxb.service.SettingsChangedEvent")]
	public class ServiceSettings extends EventDispatcher {
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

		public function ServiceSettings(url : String = "", method : String = "POST", destination : String = "", timeout : int = 60000, logMessages : Boolean = false) {
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
		public function get url() : String {
			return _url;
		}

		/**
		 * Set the url
		 * @param value
		 *
		 */
		public function set url(value : String) : void {
			_url = value;
			if (hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)) {
				dispatchEvent(new SettingsChangedEvent());
			}
		}

		/**
		 * Get the method
		 * @return
		 *
		 */
		public function get method() : String {
			return _method;
		}

		/**
		 * Set the method
		 * @param value
		 *
		 */
		public function set method(value : String) : void {
			_method = value;
			if (hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)) {
				dispatchEvent(new SettingsChangedEvent());
			}
		}

		/**
		 * Get the destination
		 * @return
		 *
		 */
		public function get destination() : String {
			return _destination;
		}

		/**
		 * Set the destination
		 * @param value
		 *
		 */
		public function set destination(value : String) : void {
			_destination = value;
			if (hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)) {
				dispatchEvent(new SettingsChangedEvent());
			}
		}

		/**
		 * Get the timeout
		 * @return
		 *
		 */
		public function get timeout() : int {
			return _timeout;
		}

		/**
		 * Set the timeout
		 * @param value
		 *
		 */
		public function set timeout(value : int) : void {
			_timeout = value;
			if (hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)) {
				dispatchEvent(new SettingsChangedEvent());
			}
		}

		/**
		 * Get the logMessages
		 * @return
		 *
		 */
		public function get logMessages() : Boolean {
			return _logMessages;
		}

		/**
		 * Set the logMessages
		 * @param value
		 *
		 */
		public function set logMessages(value : Boolean) : void {
			_logMessages = value;
			if (hasEventListener(SettingsChangedEvent.SETTINGSCHANGE)) {
				dispatchEvent(new SettingsChangedEvent());
			}
		}
	}
}