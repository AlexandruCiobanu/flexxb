package model
{
	import com.googlecode.flexxb.IIdentifiable;
	
	[XmlClass(alias="CompanyDepartment", prefix="dept", uri="http://myCompanyUrl.com")]
	[Bindable]
	public class Department implements IIdentifiable
	{
		[XmlAttribute(alias="ID")]
		public var id : String;
		
		[XmlElement(alias="DepartmentName")]
		public var name : String;
		
		[XmlElement(alias="Leader")]
		public var departmentHead : Person;
		
		public function Department()
		{
			//TODO: implement function
			super();
		}
		
		public function get thisType():Class
		{
			return Department;
		}
		
	}
}