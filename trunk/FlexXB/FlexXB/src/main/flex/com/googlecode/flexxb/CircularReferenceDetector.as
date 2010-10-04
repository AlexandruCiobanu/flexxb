/**
 *   FlexXB
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
package com.googlecode.flexxb
{
	/**
	 * 
	 * @author User
	 * 
	 */	
	public class CircularReferenceDetector
	{
		private var cycleDetectionStack : Array;
		/**
		 * 
		 * 
		 */		
		public function CircularReferenceDetector(){
			cycleDetectionStack = [];
		}
		/**
		 * 
		 * @param item
		 * @return 
		 * 
		 */		
		public function push(item : Object) : Boolean{
			if(cycleDetectionStack.indexOf(item) == -1){
				cycleDetectionStack.push(item);
				return true;
			}
			return false;
		}
		/**
		 * 
		 * @param item
		 * 
		 */		
		public function pushNoCheck(item : Object) : void{
			cycleDetectionStack.push(item);
		} 
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function pop() : Object{
			return cycleDetectionStack.pop();
		}
		/**
		 * Returns a reference to the current object being processed
		 * @return 
		 * 
		 */	
		public function getCurrent() : Object{
			if(cycleDetectionStack.length > 0){
				return cycleDetectionStack[cycleDetectionStack.length - 1];
			}
			return null;
		}
		/**
		 * Returns a reference to the current object's parent. 
		 * @return 
		 * 
		 */		
		public function getParent() : Object{
			if(cycleDetectionStack.length > 1){
				return cycleDetectionStack[cycleDetectionStack.length - 2];
			}
			return null;
		}
		
		public function clear() : void{
			while(cycleDetectionStack.length > 0){
				cycleDetectionStack.pop();
			}
		}
	}
}