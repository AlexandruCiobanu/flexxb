package model
{
	[Bindable]
	public class Person
	{
		public var id : String = "1";
		
		public var firstName : String;
		
		public var lastName : String;
		
		public var age : int;
		
		public var position : String;
		
		public function Person(firstName : String, lastName : String)
		{
			super();
			this.firstName = firstName;
			this.lastName = lastName;
		}		
	}
}