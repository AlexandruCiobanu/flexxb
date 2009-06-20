package model
{

	[Bindable]
	public class Department
	{
		
		public var id : String;
		
		public var name : String;
		
		public var departmentHead : Person;
		
		public function Department(id : String, name : String)
		{
			super();
			this.id = id;
			this.name = name;
		}	
	}
}