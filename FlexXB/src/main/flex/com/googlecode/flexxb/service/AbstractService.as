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
	/**
	 * Base Service for communicating with the server. All data service classes should extend this class
	 * @author aciobanu
	 * 
	 */	
	public class AbstractService
	{
		private var _communicationHandler : ICommunicator = new Communicator();
		/**
		 * Constructor
		 * 
		 */		
		public function AbstractService()
		{
		}
		/**
		 * Configure the service settings 
		 * @param settings
		 * 
		 */		
		protected function configure(settings : IServiceSettings) : void{
			_communicationHandler.applySettings(settings);
		}
		/**
		 * Get communicator used for talking with the server
		 * @return 
		 * 
		 */		
		protected function get communicator() : ICommunicator{
			return _communicationHandler;
		}
		/**
		 * Set the communicator used for talking with the server
		 * @param value
		 * 
		 */		
		protected function set communicator(value  :ICommunicator) : void{
			_communicationHandler = value;
		}
	}
}