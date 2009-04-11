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
		
	[Bindable]
	/**
	 * Main implementation of IPersistable. It should be base for all model objects that need initial state memory capabilities such as IPersistable allows.
	 * It uses the methods <code>commit()</code> and <code>rollback()</code> to save the
	 * current state or to revert to the previously saved state.
	 * <p>Basically, this object listens for changes to all its public properties and 
	 * variables and saves the initial value set for that field. Upon commit, the list of 
	 * initial values is discarded, the new values thus becoming initial values. On rollback,
	 * the initial values are reinstated the object returning to the state before eny change 
	 * had been made.</p>
	 * <p><b>Note</b>: Subclasses should be decorated with the <code>[Bindable]</code> annotation so all 
	 * changes to the public fields would be registered.</p>
	 * @author Alexutz
	 * 
	 */	
	public class PersistableObject implements IPersistable, IEventDispatcher
	{		
		private var _modified  : Boolean;
		
		private var changeList : Dictionary;
		
		private var listen : Boolean = true;
		/**
		 * 
		 * @see IPersistable#modified() 
		 * 
		 */		
		public function get modified():Boolean
		{
			return _modified;
		}
		/**
		 * Stop listening for changes occuring to the object.
		 * It is usually called before deserialization occurs.
		 * 
		 */		
		public function stopListening() : void{
			listen = false;
		}
		/**
		 * Start listening for changes occuring to the object.
		 * Usually called after deserialization completes.
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
		 * @see IPersistable#commit() 
		 * 
		 */		
		public function commit():void
		{
			if(modified){
				setModified(false);
			}
		}
		/**
		 * @see IPersistable#rollback()
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
		 * Add a listener for an event type
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{}
		/**
		 * Remove a registered listener for an event type
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{}
		/**
		 * Dispacth the specified event
		 * @param event
		 * @return dispatch succeeded
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
		 * Check if there is an event listener specified for the specific event
		 * @param type event type
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