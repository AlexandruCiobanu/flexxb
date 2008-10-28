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
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class Communicator implements ICommunicator
	{
		private var _settings : IServiceSettings;
		
		private var service : HTTPService;
		
		public function Communicator(settings : IServiceSettings = null)
		{
			service = new HTTPService();
			applySettings(settings);
		}
		
		public function applySettings(settings : IServiceSettings) : void{
			if(settings){
				_settings = settings;
				configureService(service, _settings);
			}
		}
		
		public function sendRequest(translator : ITranslator, resultHandler : Function, faultHandler : Function = null): void{
			if(translator == null || !(resultHandler is Function)){
				throw new Error("Error sending request: request body and result handler can't be null");
			}
			var xmlRequest : XML = translator.createRequest();
			service.request = xmlRequest;
			
			var onResult : Function = function(event : ResultEvent) : void{
				var xmlResponse : XML = event.result as XML;
				var response : Object = translator.parseResponse(xmlResponse);
				var responseData : Object = translator.extractResponseData(response);
				resultHandler(responseData);
			};
			
			var onError : Function = function(event : FaultEvent) : void{
				if(faultHandler is Function){
					faultHandler(event.fault);
				}
			};
			var token : AsyncToken = service.send();			
			token.addResponder(new Responder(onResult, onError));
		}
		
		public function cancelRequest() : void{
			service.cancel();
		}
		
		public function destroy() : void{
			service.disconnect();
			service = null;
			_settings = null;
		}
		
		private function configureService(srv : HTTPService, settings : IServiceSettings) : void{
			srv.url = settings.url;
			srv.contentType = HTTPService.CONTENT_TYPE_XML;
			srv.requestTimeout = settings.timeout;
			srv.method = settings.method;
			srv.resultFormat= HTTPService.RESULT_FORMAT_E4X;
		}		
	}
}