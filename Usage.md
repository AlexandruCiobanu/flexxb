# Using the FlexXB library #

To serialize an object to xml:<br />
`com.googlecode.serializer.flexxb.FlexXBEngine.serialize(object)`

To deserialize a received xml to an object, given the object's class:<br />
`com.googlecode.serializer.flexxb.FlexXBEngine.deserialize(xml, class)`

To register a custom annotation, subclass of `com.googlecode.serializer.flexxb.Annotation`:<br />
`com.googlecode.serializer.flexxb.FlexXBEngine.registerAnnotation(name, annotationClass, serializerClass, overrideExisting)`

To register a converter that will handle how an object of a specific type is converted to a String value that will be attached to the xml representation and viceversa:<br />
`com.googlecode.serializer.flexxb.FlexXBEngine.registerSimpleTypeConverter(converterInstance, overrideExisting)`

To enable/diable object caching:
```
//disable
com.googlecode.serializer.flexxb.FlexXBEngine.configuration.cacheProvider = null;
//enable
com.googlecode.serializer.flexxb.FlexXBEngine.configuration.cacheProvider = new com.googlecode.flexxb.cache.ObjectCache();
   //or
com.googlecode.serializer.flexxb.FlexXBEngine.configuration.cacheProvider = new com.googlecode.flexxb.cache.ObjectPool();
```

In order to register a class descriptor created via the FlexXB API for classes that cannot be accessed in order to add annotations:
`com.googlecode.serializer.flexxb.FlexXBEngine.instance.api.processTypeDescriptor(apiTypeDescriptor)`

To provide an API descriptor file content in which the class descriptors are depicted in an XML format:<br />
`com.googlecode.serializer.flexxb.FlexXBEngine.instance.api.processDescriptorsFromXml(xml)`

**Note**: Make sure you add the following switches to your compiler settings: `-keep-as3-metadata XmlClass -keep-as3-metadata XmlAttribute -keep-as3-metadata XmlElement -keep-as3-metadata XmlArray -keep-as3-metadata ConstructorArg`

# Annotating model classes #

There are four annotations defined:

> XmlClass `[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName", idField="idFieldName", prefix="my", uri="http://www.your.site.com/schema/", defaultValueField="fieldName", ordered="true|false", version="versionValue")] `

> XmlAttribute `[XmlAttribute(alias="attribute", ignoreOn="serialize|deserialize", order="orderIndex", version="versionValue")]`

> XmlElement `[XmlElement(alias="element", getFromCache="true|false", ignoreOn="serialize|deserialize", serializePartialElement="true|false", order="orderIndex", version="versionValue")]`

> XmlArray `[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false", type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false", order="orderIndex", version="versionValue")]`

**Note**: Using as alias "`*`" on a field will force the serializer to serialize that
field using an alias computed at runtime by the runtime type of the field's value, except for XmlArray.
For XmlArray using the "`*`" alias will cause the members of the array value to be rendered as children of the owner object xml rather than children of an xml element specifying the array.