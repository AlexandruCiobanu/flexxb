FlexXB is a serializer for Flex and Air applications, using annotations in order to automate the (de)serialization process. It has built-in support for (de)serializing xml.

**Current Version**: **2.3.1**

**Next Version**: *v2.4.0*

# How does FlexXB work?

In order for **FlexXB** to be able to automate the (de)serialization process, the model objects involved must be "decorated" with [AS3 metadata tags](http://livedocs.adobe.com/flex/3/html/help.html?content=metadata_3.html) that will instruct it on how they should be processed.

When an object is passed to it for serialization, it inspects the object's definition and extracts a list of annotations describing the way an object of that type needs to be (de)serialized. It keeps the generated list in a cache in order to reuse it if need arises and then builds the corresponding serialized data using the information provided by the annotations. 

Any object field that does not have an annotation defined is ignored in the (de)serialization process of that object.

FlexXB offers built-in support for handling xml and there are six built-in annotations for describing object serialization, one being class-scoped, the other field-scoped:
 - *[XmlClass|Xml-Annotations#xmlclass]*: Defines class's namespace (by uri and prefix) and xml alias;
 - *[ConstructorArg|Xml-Annotations#constructorarg]*: Defines the arguments with which the constructor should be run. Applies to classes with non default constructors and is defined at the same level with XmlXClass;
 - *[Namespace|Xml-Annotations#namespace]*: Allows definition of multiple namespaces used by the annotations defined in the class. These namespaces can be referenced in the field annotations by their prefix;
 - *[XmlAttribute|Xml-Annotations#xmlattribute]*: Marks the field to be rendered as an attribute of the xml representation of the parent object;
 - *[XmlElement|Xml-Annotations#xmlelement]*: Marks the field to be rendered as a child element of the xml representation of the parent object;
 - *[XmlArray|Xml-Annotations#xmlarray]*: Is a particular type of element since it marks a field to be rendered as an Array of elements of a certain type.

*Please refer to the [General Description|General-Description] page for more details about the purpose and structure of this project.*



# What can it do?

Here is a list of FlexXB's main features:

 - **Serialization format support**: FlexXB is now serialization format agnostic and allows users to extend the engine and add support for different serialization formats (JSON, etc) while still sharing the base features such as object caching, circular reference handling, constructor annotations, id fields, version extraction. The advantage is that the base features are integrated by default with the new serialization context that defines the new format and one should only care about the actual AS3 object - ? conversions.

 - **Support for object namespacing**;

 - **Integrated model object cache to insure object uniqueness**:

 - **Class type identification by response's namespace on deserialization**: Object types that should be used in deserialization can be determined from the namespaces present in the xml response.

 - **Custom to and from string conversion for simple types**: Some simple types (such as Date) may require custom conversion methods to and from String values and FlexXB supports the defintion of converters for those types.

 - **Support for custom object (de)serialization**: Objects that require special handling can implement the IXmlserializable interface and take care of their own (de)serialization.

 - **Support for signaling processing execution**: FlexXB emits signals on various stages of the object/xml processing. These signals can be further processed by listening for those events or processed objects can implements specific interfaces that notify the engine to send the signals to them.

 - **FlexXB Annotation API**: FlexXB provides an API to allow developers to programatically describe object types to be registered in the FlexXB engine. This is especially useful when you can't access the class defintiion to decorate it with metadata

 - **Annotation versioning**: FlexXB allows multiple annotations per field differentiated by a version. This is extremely useful when the same object can be rendered to xml in different ways according to the end server it is talking to.

 - **Circular reference handling**: This feature is the same as offered by JAXB: https://jaxb.dev.java.net/guide/Mapping_cyclic_references_to_XML.html. When encountering objects cycles, the application can recover from it without ending up in a stack overflow exception. Thus you are able to specify objects once in the xml document and reference them by id wherever is needed; also one may implement a custom interface allowing the replacement of the current object with a new one that will break the cycle.

*Please refer to the [[Features|Features]] and [[Road Map|Road Map]] pages for more details  on the library's capabilities and version vs. feature maps.*


# How do I use the FlexXB library?

FlexXB 2.x allows extensions to support different serialization formats. Due to the architectural changes to support this feature, the main access point from the 1.x version, com.googlecode.serializer.flexxb.FlexXBEngine is deprecated in FlexXB 2.x. However, for compatibility reasons this class is still available; it will only work for xml serialization and provide the same methods as in previous versions. Do not use FlexXBEngine class if you need to support a new serialization format.

### Using built-in XML serialization

To get the serializer to be used in xml handling:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer() : IFlexXB`

To serialize an object to xml:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().serialize(object)`

To deserialize a received xml to an object, given the object's class:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().deserialize(xml, class)`

To get the configuration for the xml serializer. One may need to convert teh configuration instance to its true type, `com.googlecode.flexxb.xml.XmlConfiguration` in order to access all settings:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().configuration`

To do an early processing of class types required for deserialization so as not to have problems when classes are not known:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().processTypes(...args) : void`

To register a custom annotation:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().context.registerAnnotation(name, annotationClass, serializerClass, overrideExisting)`

To register a class type converter:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getXmlSerializer().context.registerSimpleTypeConverter(converterInstance, overrideExisting)`

In order to register a class descriptor created via the FlexXB API for classes that cannot be accessed in order to add annotations:
`com.googlecode.flexxb.core.FxBEngine.instance.api.processTypeDescriptor(apiTypeDescriptor)`

To provide an API descriptor file content in which the class descriptors are depicted in an XML format:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.api.processDescriptorsFromXml(xml)`

### Customizing serialization format

To create a description context, the core of your custom serialization, extend 
`com.googlecode.flexxb.core.DescriptionContext`. Overridable methods:
 - `protected function performInitialization() : void` - Initialize your context registering annotations, serializers and converters you need. You should set the configuration object extending `com.googlecode.flexxb.core.Configuration` if you require special settings.
 - `public function handleDescriptors(descriptors : Array) : void` - Once a new type has been processed, the context has the chance to handle the descriptors in order to construct internal structures it may need (for example, in handling XML, determine the type by the namespace used).
 - `public function getIncomingType(source : Object) : Class` - Determine the object type associated with the incoming serialized form at runtime. It is recommended that you override this method in subclasses because each serialization format has different ways of determining the type of the object to be used in deserialization.

To register the new serialization format context:
`com.googlecode.flexxb.core.FxBEngine.instance.registerDescriptionContext(name : String, context : DescriptionContext) : void`

To get the associated serializer:
`com.googlecode.flexxb.core.FxBEngine.instance.getSerializer(name : String) : IFlexXB`

To serialize an object to the custom format:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getSerializer(name : String).serialize(object)`

To deserialize a received data ina custom format to an object, given the object's class:<br/>
`com.googlecode.flexxb.core.FxBEngine.instance.getSerializer(name : String).deserialize(xml, class)`

### Using the api

In order to register a class descriptor created via the FlexXB API for classes that cannot be accessed in order to add annotations:<br/>
`com.googlecode.serializer.flexxb.core.FxBEngine.instance.api.processTypeDescriptor(apiTypeDescriptor)`

To provide an API descriptor file content in which the class descriptors are depicted in an XML format:<br/>
`com.googlecode.serializer.flexxb.core.FxBEngine.instance.api.processDescriptorsFromXml(xml)`
# Show me some samples!

*Please refer to the [FlexXB usage samples](Usage2x) page for more details about how to use the library.*

## Basic sample using xml annotations

This is a simple example on using xml annotations. Only fields that have been decorated with an annotation will be taken into account in the (de)serialization process. Notice the idField attribute. It specifies that this object supports a compact method of defining it in xml, by only specifying the id. The id will be rendered as element or attribute in the owner xml.

```
        [idField="id")](XmlClass(alias="MOck2Replacement",)
	public class Mock3
	{
		[[Xml Attribute]]
		public var id : Number = 3;
		[[Xml Attribute]]
		public var attribute : Boolean;
		[public var version : Number;
		
		public function Mock3()
		{
			super();
		}
	}
```

The object has been built as:

```
        var target : Mock3 = new Mock3();
	target.attribute = true;
	target.id = 5;
	target.version = 33;
```

The resulting XML is:

```
<MOck2Replacement attribute="true" id="5">
  <objectVersion>
    33
  </objectVersion>
</MOck2Replacement>
```

# Can I help?

Sure! If you happen to find a problem I'll greatly appreciate it if you filed an issue in the issues section or posted a question in the [FlexXB Discussion Group](http://groups.google.com/group/flexxb). If you can, please provide as much details as possible regarding your issue so I may diagnose and fix the problem ASAP. Also you are free to send me patches that correct wrong behaviors of the library and I'll be more than happy to validate and include them in the codebase.

If you think the project meets your needs and you'd like to express your gratitude you can buy me a couple of beers by donating whatever you see fit via Paypal. Just follow the link at the top ot the one below and you can make my day :)

[https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=MV3LSJCMGNWH2&lc=RO&item_name=Alex%20Ciobanu&item_number=AC_flexxb_Donation&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)
