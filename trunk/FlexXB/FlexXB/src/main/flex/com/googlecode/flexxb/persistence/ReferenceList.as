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
package com.googlecode.flexxb.persistence
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class ReferenceList extends ArrayCollection implements IPersistable
	{
		private var _modified : Boolean;
		private var listen : Boolean = true;
		private var changeList : Dictionary;
		/**
		 * 
		 * @param source
		 * 
		 */		
		public function ReferenceList(source:Array=null)
		{
			super(source);
			addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
		}
		/**
		 * 
		 * @param item
		 * @return 
		 * 
		 */		
		public function removeItem(item : Object) : Boolean{
			if(item){
				var index : int = getItemIndex(item);
				if(index > -1){
					removeItemAt(index);
					return true;
				}
			}
			return false;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get modified():Boolean
		{
			return _modified;
		}
		/**
		 * 
		 * 
		 */		
		public function commit():void
		{
			if(modified){
				setModified(false);
			}
		}
		/**
		 * 
		 * 
		 */		
		public function rollback():void
		{
			if(modified){
				listen = false;
				var tracker : ChangeTracker = changeList[ChangeTrackerKind.UPDATE];
				removeAll();
				for each(var item : Object in tracker.persistedValue){
					addItem(item);
				}
				setModified(false);
			}
		}
		
		private function setModified(value : Boolean) : void{
			_modified = value;
			if(!value && changeList){
				for(var tracker : * in changeList){
					delete changeList[tracker];
				}
			}
			listen = true;
		}
		
		protected function onCollectionChange(event : CollectionEvent) : void{
			if(listen && !modified && ChangeTrackerKind.isActionTracked(event.kind)){
				var initial : Array = [];
				for each(var item : Object in this){
					initial.push(item);
				}
				var tracker : ChangeTracker = new ChangeTracker("", initial, ChangeTrackerKind.UPDATE);
				if(!changeList){
					changeList = new Dictionary();
				}
				changeList[ChangeTrackerKind.UPDATE] = tracker;
				setModified(true);
			}
		} 
	}
}