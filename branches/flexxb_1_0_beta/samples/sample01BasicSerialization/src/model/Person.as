package model
{
	import com.googlecode.flexxb.IIdentifiable;

	[XmlClass(alias="Person")]
	[Bindable]
	public class Person implements IIdentifiable
	{
		[XmlElement(alias="ID")]
		public var id : String = "1";
		[XmlAttribute(alias="FirstName")]
		public var firstName : String;
		[XmlAttribute(alias="LastName")]
		public var lastName : String;
		[XmlAttribute(alias="Age")]
		public var age : int;
		[XmlElement(alias="Position")]
		public var position : String;
		
		public function Person()
		{
			super();
		}
		
		public function get thisType():Class
		{
			return Person;
		}
		
	}
}