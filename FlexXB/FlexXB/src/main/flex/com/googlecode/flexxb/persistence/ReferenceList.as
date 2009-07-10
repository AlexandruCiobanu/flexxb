/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
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
package com.googlecode.flexxb.persistence
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	/**
	 * Adds to ArrayCollection the functionalities specified by IPersistable.
	 * Should be used in model objects the require having lists of referenced objects.
	 * @see PersistableObject
	 * @author aciobanu
	 * 
	 */	
	public class ReferenceList extends ArrayCollection implements IPersistable
	{
		private var _modified : Boolean;
		
		private var listen : Boolean = true;
		
		private var changeList : Dictionary;
		
		private var _editMode : Boolean;
		/**
		 * Constructor
		 * @param source
		 * 
		 */		
		public function ReferenceList(source:Array=null)
		{
			super(source);
			addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange, false, Number.MAX_VALUE, false);
		}
		/**
		 * 
		 * @see IPersistable#editMode() 
		 * 
		 */		
		public final function get editMode() : Boolean{
			return _editMode;
		}
		/**
		 * 
		 * @see IPersistable#setEditMode()
		 * 
		 */		
		public final function setEditMode(mode : Boolean) : void{
			_editMode = mode;
		}
		/**
		 * Stop listening for changes occuring to the object.
		 * It is usually called before deserialization occurs.
		 * 
		 */		
		public final function stopListening() : void{
			listen = false;
		}
		/**
		 * Start listening for changes occuring to the object.
		 * Usually called after deserialization completes.
		 * 
		 */		
		public final function startListening() : void{
			listen = true;
		}
		/**
		 * 
		 * @param item
		 * @return 
		 * 
		 */		
		public final function removeItem(item : Object) : Boolean{
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
		 * @param index
		 * @return 
		 * 
		 */		
		public override function removeItemAt(index:int):Object{
			if (index >= 0 && index < length){
				onCollectionChange(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false,false, CollectionEventKind.REMOVE, index, -1, null));
			}
			return super.removeItemAt(index);
		}
		/**
		 * 
		 * @param item
		 * @param index
		 * 
		 */		
		public override function addItemAt(item:Object, index:int):void{
			if (list && index >= 0 && index <= length){
				onCollectionChange(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false,false, CollectionEventKind.ADD, index, -1, [item]));
			}
			super.addItemAt(item, index);
		}
		/**
		 * 
		 * @param item
		 * @param index
		 * @return 
		 * 
		 */		
		public override function setItemAt(item:Object, index:int):Object{
			if (list && index >= 0 && index < length){
				onCollectionChange(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false,false, CollectionEventKind.REPLACE, index, -1, [item]));
			}
			return super.setItemAt(item, index);
		}
		/**
		 * 
		 * @param s
		 * 
		 */		
		public override function set source(s:Array):void{
			if(source && s!= source){
				onCollectionChange(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			}else{
				listen = false;
			}
			super.source = s;
			listen = true;
		}
		/**
		 * @see IPersistable#modified()
		 * 
		 */			
		public final function get modified():Boolean
		{
			return _modified;
		}
		/**
		 * @see IPersistable#commit()
		 * 
		 */		
		public final function commit():void
		{
			if(modified){
				setModified(false);
			}
		}
		/**
		 * @see IPersistable#rollback()
		 * 
		 */			
		public final function rollback():void
		{
			if(modified){
				listen = false;
				var tracker : ChangeTracker = changeList[ChangeTrackerKind.UPDATE];
				source = tracker.persistedValue as Array;
				refresh();
				setModified(false);
			}
		}
		/**
		 * 
		 * @see flash.events.EventDispatcher#dispatchEvent() 
		 * 
		 */		
		public override final function dispatchEvent(event:Event) : Boolean{
			if(event is CollectionEvent && editMode){
				return true;
			}
			return super.dispatchEvent(event);
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		private function setModified(value : Boolean) : void{
			_modified = value;
			if(!value && changeList){
				for(var tracker : * in changeList){
					delete changeList[tracker];
				}
			}
			listen = true;
		}
		/**
		 * Occurs whenever the collection changes by adding/ removing an object etc. 
		 * @param event
		 * 
		 */		
		private function onCollectionChange(event : CollectionEvent) : void{
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