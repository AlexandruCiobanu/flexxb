# Introduction #

We're all familiar with the power of AMF and how easy it makes the communication with the backend server. It is a binary protocol (thus very compact and fast), basically [ActionScript](http://en.wikipedia.org/wiki/ActionScript) bytecode that is natively interpreted into an AS3 object. The only "issue" would be the backend server that will have to know AMF (sure, there have been, for quite some time now, a variety of products that provide a seamless way for AMF serialization: [BlazeDS](http://opensource.adobe.com/wiki/display/blazeds/BlazeDS), [FluorineFX](http://www.fluorinefx.com/), just to name a few).

What happens if one finds oneself in the company of an "XML spitting server" (like the situation I find myself in some of my work projects) for compatibility sake, with no way of making any common sens changes to it (like adding a communication layer smart enough to make the switch between XML and AMF serialization on demand -  talk xml with legacy clients and AMF with the cool kids :D)? In that case one might be forced to implement a way to send and receive objects through XML. Fortunately, thanks to E4X the task is not quite as horrific as it might appear. Still, a multitude of issues appear with XML communication:

  * How do we handle object duplication?
  * How do we handle versioning?
  * What if we want only some fields of an object to be sent to the server? etc.

**FlexXB** appeared in my mind as an attempt to shed some light into all of these problems and, hopefully, more: a way to automate the serialization/deserialization process while keeping the model objects used in the communication free of ugly `toXML() : XML` and `fromXML(xmlData : XML) : Object`. The most simple way of marking the model objects for serialization seemed to be the use of annotations (to some extent similar to [JAXB](http://java.sun.com/developer/technicalArticles/WebServices/jaxb/) approach, that is, if I'm not terribly mistaking).

I plan to include in this project what I've learned and continue to learn about talking XML with a backend server and hope that all this fuss will someday help someone who might find himself in the same position as I did.

# What is FlexXB? #

**FlexXB** is an [ActionScript](http://en.wikipedia.org/wiki/ActionScript) library designed to automate the AS3 objects' serialization to XML to be sent to a backend server and the xml deserialization into AS3 objects of a response received from that server.

# How does it work? #

In order for **FlexXB** to be able to automate the (de)serialization process, the model objects involved must be "decorated" with [AS3 metadata tags](http://livedocs.adobe.com/flex/3/html/help.html?content=metadata_3.html) that will instruct it on how they should be processed:

  * Which object fields translate into xml attributes, which into xml elements and which should be ignored?
  * Should we use namespaces to build the request xml and parse the response one? If so, what are the namespaces?
  * The object's fields need to have different names in the xml representation?

All this information is linked to the object by adding metadata tags (annotations - in Java - or attributes - in .NET) to the class definition of the object in question.

When an object is passed to it for serialization, it inspects the object's definition and extracts a list of annotations describing the way an object of that type needs to be (de)serialized. It keeps the generated list in a cache in order to reuse it if need arises and then builds the corresponding XML using the information provided by the annotations. Any object field that does not have an annotation defined is ignored in the (de)serialization process of that object.

There are six built-in annotations for describing object serialization, one being class-scoped, the other field-scoped:
  * **[XmlClass](Architecture.md)**: Defines class's namespace (by uri and prefix) and xml alias;
  * **[ConstructorArg](Architecture.md)**: Defines the arguments with which the constructor should be run. Applies to classes with non default constructors and is defined at the same level with XmlXClass;
  * **[Namespace](Architecture.md)**: Allows definition of multiple namespaces used by the annotations defined in the class. These namespaces can be referenced in the field annotations by their prefix;
  * **[XmlAttribute](Architecture.md)**: Marks the field to be rendered as an attribute of the xml representation of the parent object;
  * **[XmlElement](Architecture.md)**: Marks the field to be rendered as a child element of the xml representation of the parent object;
  * **[XmlArray](Architecture.md)**: Is a particular type of element since it marks a field to be rendered as an Array of elements of a certain type.