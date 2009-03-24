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
	 * Communication interface
	 * @author aciobanu
	 * 
	 */	
	public interface ICommunicator
	{
		/**
		 * Apply communication settings
		 * @param settings
		 * @param detectSettingsChange
		 * 
		 */		
		function applySettings(settings : ServiceSettings, detectSettingsChange : Boolean = false) : void;
		/**
		 * 
		 * @param translator
		 * @param resultHandler Metod callback that will be called if the request receives a success response
		 * @param faultHandler Metod callback that will be called if the request fails
		 * 
		 */			
		function sendRequest(translator : ITranslator, resultHandler : Function, faultHandler : Function = null) : void;
		/**
		 * Release all resources
		 * 
		 */		
		function destroy() : void;
	}
}