/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.FlexXBEngine;
	
	import flash.net.registerClassAlias;
	
	public class CustomClassTest
	{
		
		[Test]
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