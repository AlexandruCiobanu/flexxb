package model
{
	import com.googlecode.flexxb.IIdentifiable;
	
	[XmlClass(alias="CompanyDepartment", prefix="dept", uri="http://myCompanyUrl.com")]
	[ConstructrArg(reference="id")]
	[ConstructrArg(reference="name")]
	[Bindable]
	public class Department implements IIdentifiable
	{
		[XmlAttribute(alias="ID")]
		public var id : String;
		
		[XmlElement(alias="DepartmentName")]
		public var name : String;
		
		[XmlElement(alias="Leader")]
		public var departmentHead : Person;
		
		public function Department(id : String, name : String)
		{
			super();
			this.id = id;
			this.name = name;
		}
		
		public function get thisType():Class
		{
			return Department;
		}
		
	}
}