package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public class Member extends UMLObject implements IMember
	{
		protected var _class : Class;
		
		protected var _scope : Scope;
		
		protected var _visibility : Visibility;
		
		public function Member(clasz : Class)
		{
			super();
			if(!clasz){
				throw new Error("Member cannot have a null owner class");
			}
			_class = clasz;
		}
		
		public function get classReference():Class
		{
			return _class;
		}
		
		public function set classReference(value:Class):void
		{
			_class = value;
		}
		
		public function get scope():Scope
		{
			return _scope;
		}
		
		public function set scope(value:Scope):void
		{
			_scope = value;
		}
		
		public function get visibility():Visibility
		{
			return _visibility;
		}
		
		public function set visibility(value:Visibility):void
		{
			_visibility = value;
		}		
	}
}