package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public interface IPackageMember extends IUMLObject
	{
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get packageReference() : Package;
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set packageReference(value : Package) : void;		
	}
}