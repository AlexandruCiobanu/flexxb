/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
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
package com.googlecode.flexxb.service {
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	/**
	 * Communicates with the server by sending xml requests and receiving xml responses
	 * @author aciobanu
	 *
	 */
	public class Communicator implements ICommunicator {
		/**
		 *
		 */
		private var _settings : ServiceSettings;
		/**
		 *
		 */
		private var service : HTTPService;

		/**
		 * Constructor
		 * @param settings
		 *
		 */
		public function Communicator(settings : ServiceSettings = null, detectSettingsChange : Boolean = false) {
			service = new HTTPService();
			applySettings(settings, detectSettingsChange);
		}

		/**
		 *
		 * @see ICommunicator#applySettings()
		 *
		 */
		public function applySettings(settings : ServiceSettings, detectSettingsChange : Boolean = false) : void {
			if (_settings) {
				_settings.removeEventListener(SettingsChangedEvent.SETTINGSCHANGE, settingsChangeHandler);
			}
			_settings = settings;
			if (settings) {
				if (detectSettingsChange) {
					_settings.addEventListener(SettingsChangedEvent.SETTINGSCHANGE, settingsChangeHandler);
				}
				configureService(service, _settings);
			}
		}

		/**
		 *
		 * @see ICommunicator#sendRequest()
		 *
		 */
		public function sendRequest(translator : ITranslator, resultHandler : Function, faultHandler : Function = null) : AsyncToken {
			if (translator == null || !(resultHandler is Function)) {
				throw new Error("Error sending request: request body and result handler can't be null");
			}
			var xmlRequest : XML = translator.createRequest();
			service.request = xmlRequest;
			var onResult : Function = function(event : ResultEvent) : void {
					var xmlResponse : XML = event.result as XML;
					var response : Object = translator.parseResponse(xmlResponse);
					var responseData : Object = translator.extractResponseData(response);
					resultHandler(responseData);
				};

			var onError : Function = function(event : FaultEvent) : void {
					if (faultHandler is Function) {
						faultHandler(event.fault);
					}
				};
			var token : AsyncToken = service.send();
			token.addResponder(new Responder(onResult, onError));
			return token;
		}

		/**
		 * Cancel the last request made
		 *
		 */
		public function cancelRequest() : void {
			service.cancel();
		}

		/**
		 * @see ICommunicator#destroy()
		 *
		 */
		public function destroy() : void {
			if (service) {
				service.disconnect();
				service = null;
			}
			_settings = null;
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function settingsChangeHandler(event : SettingsChangedEvent) : void {
			configureService(service, _settings);
		}

		/**
		 *
		 * @param srv
		 * @param settings
		 *
		 */
		private function configureService(srv : HTTPService, settings : ServiceSettings) : void {
			srv.url = settings.url;
			srv.destination = settings.destination;
			srv.contentType = HTTPService.CONTENT_TYPE_XML;
			srv.requestTimeout = settings.timeout;
			srv.method = settings.method;
			srv.resultFormat = HTTPService.RESULT_FORMAT_E4X;
		}
	}
}