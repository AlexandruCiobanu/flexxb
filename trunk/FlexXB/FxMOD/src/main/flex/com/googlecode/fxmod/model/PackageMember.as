package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	[Bindable]
	public class PackageMember extends UMLObject implements IPackageMember, IType
	{
		protected var _packageReference : Package;
		/**
		 * Constructor 
		 * 
		 */		
		public function PackageMember()
		{
			super();
		}
		/**
		 * 
		 * @see IPackageMember#packageReference()
		 * 
		 */		
		public function get packageReference() : Package
		{
			/return _packageReference;
		}
		/**
		 * 
		 * @see IPackageMember#packageReference()
		 * 
		 */			
		public function set packageReference(value : Package):void
		{
			_packageReference = value;
		}
		/**
		 * 
		 * @see IType#shortName()
		 * 
		 */		
		public function get shortName() : String{
			return name;
		}
		/**
		 * 
		 * @see IType#longName()
		 * 
		 */		
		public function get longName() : String{
			if(_packageReference){
				return _packageReference.name + "." + name;
			}
			return name;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function toString() : String{
			return longName;
		}		
	}
}