package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.FlexXBEngine;
	
	import flash.net.registerClassAlias;
	
	import flexunit.framework.TestCase;
	
	public class CustomClassTest extends TestCase
	{
		public function CustomClassTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
		}
		
		public function testPanelSerialization() : void{
			var xml : XML = 
				<FlexXBAPI> 
				<Descriptors>
			        <Class type="com.googlecode.flexxb.api.FetchPanel"> 
			                <Members><Attribute> 
			                        <Field name="x" type="int"/> <!-- To serialize their positions. --> 
			                </Attribute> 
			                <Attribute> 
			                        <Field name="y" type="int"/> 
			                </Attribute>
 							</Members>
			        </Class>
				</Descriptors>
				</FlexXBAPI>;
			var engine : FlexXBEngine = new FlexXBEngine();
			engine.api.processDescriptorsFromXml(xml);
			var pipe : PipeLine = new PipeLine();
			pipe.name = "test";
			pipe.panels = [];	
			var panel : FetchPanel = new FetchPanel();
			panel.x = 2;
			panel.y = 2;
			pipe.panels.push(panel);
			panel = new FetchPanel();
			panel.x = 2;
			panel.y = 2;
			pipe.panels.push(panel);
			xml = engine.serialize(pipe);
		}		
	}
}