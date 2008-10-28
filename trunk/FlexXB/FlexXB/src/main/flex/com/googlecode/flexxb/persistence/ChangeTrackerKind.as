package com.googlecode.flexxb.persistence
{
	internal class ChangeTrackerKind
	{
		public static const UPDATE : String = "update";
		public static const ADD : String = "add";
		public static const REMOVE : String = "remove";
		public static const MOVE : String = "move";
		public static const REPLACE : String = "replace";
		
		public static function isActionTracked(action : String) : Boolean{
			return  action == UPDATE || 
					action == ADD || 
					action == REMOVE ||
					action == MOVE || 
					action == REPLACE;
		}
		
		public function ChangeTrackerKind()
		{
			throw new Error("Don't instanciate this class.");
		}

	}
}