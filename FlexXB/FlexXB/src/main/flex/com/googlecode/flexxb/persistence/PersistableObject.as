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
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.events.PropertyChangeEvent;	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	[Bindable]
	public class PersistableObject implements IPersistable, IEventDispatcher
	{		
		private var _modified  : Boolean;
		
		private var changeList : Dictionary;
		
		private var listen : Boolean = true;
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
		public function stopListening() : void{
			listen = false;
		}
		/**
		 * 
		 * 
		 */		
		public function startListening() : void{
			listen = true;
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
				for each(var tracker : ChangeTracker in changeList){
					this[tracker.fieldName]=tracker.persistedValue;
				}
				setModified(false);
			}
		}
		/**
		 * 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{}
		/**
		 * 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{}
		/**
		 * 
		 * @param event
		 * @return 
		 * 
		 */		
		public function dispatchEvent(event : Event):Boolean
		{
			if(event is PropertyChangeEvent && event.type == PropertyChangeEvent.PROPERTY_CHANGE){
				valueChanged(PropertyChangeEvent(event));
			}
			return true;
		}
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */		
		public function hasEventListener(type:String):Boolean{
			return type==PropertyChangeEvent.PROPERTY_CHANGE;
		}
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */		
		public function willTrigger(type:String):Boolean{
			return hasEventListener(type);
		}	
		
		private function valueChanged(event : PropertyChangeEvent) : void{
			if(listen){
				var name : String = event.property as String;
				if(changeList && changeList[name]){
					if(ChangeTracker(changeList[name]).persistedValue == event.newValue){
						delete changeList[name];
					}
					return;
				}
				var tracker : ChangeTracker = ChangeTracker.fromPropertyChange(event);
				if(!changeList){
					changeList = new Dictionary();
				}
				changeList[name] = tracker;
				setModified(true);
			}
		}
	}
}