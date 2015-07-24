# Introduction #

Besides the powerful xml processing capabilities, FlexXB also offers support for communicating with the server as well as the notion of persistable objects.

## Server communication ##

Having the ability to convert ActionScript objects to xml and vice versa is quite redundant if not for a means of communicating with the back end server consuming and producing the xml request and responses.
FlexXB offers server communication capabilities by the classes located in `com.googlecode.flex.service`. They are enumerated below along with a short description of their purpose:

  * `ITranslator` - Interface for defining a translator. Translators take care of creating the request objects, serialize them into a xml request, deserialize the xml response into a response object and retrieving the actual useful data from it.
  * `ICommunicator` - Interface for defining a communicator. It is basically a wrapper for the object that sends requests to the server in the protocol and format required and receives responses from it.
  * `Communicator` - Default implementation of ICommunicator. Allows sending/receiving xml via HTTP.
  * `AbstractService` - This is the base for all service classes. Uses an instance of an ICommunicator implemetor to send requests and retrieve responses.
  * `ServiceSettings` - Settings object for configuring the service. Contains several built-in variables covering the must-have settings like url, HTTP method etc.

If one can understand the need for the `AbstractService` or `ServiceSettings`, there are here two notions that might elude him/her: translators and communicators.

### 1. Translators ###

When communicating with a server, besides the useful data, there is a sometimes significant amount of "protocol overhead". For example, connecting to a server requires a login and then the use of a session identifier. When sending a request to create an object you must format it in a specific manner, adding the session identifier to allow for the server's authentication process. Also, when receiving a response, it may come with additional data to it in the form of a wrapper around the useful response data, containing the exact date and time the response was processed, the status of the operation (executed successfully or threw an error) etc.

All this apparent overhead represents the communication protocol with the server. It means that the xml received/sent has a specific format and must include some information besides of the data solely related with the operation being invoked (insert, update, delete etc). This protocol data doesn't need to be offered outside the service layer. It is related strictly with the communication with the server.

This is where the translators come in. They conceal the complexity of using the protocol objects by building the request in a form accepted by the server from application data and providing data that can be processed by the application from the server response. In this process they also take care of the AS3 - XML conversion specific to each communication stage (SEND, RECEIVE). You can see them as adapters.

Let's take a quick look at the ITranslator definition:

```
public interface ITranslator         
{                 
	/**
	* Create the XML request to be sent to the server                  
	* @return XML request                  
	*                   
	*/                              
	function createRequest() : XML;                 
	/**                  
	* Get the response xml from the server and convert it to the response object.                  
	* @param data xml response                  
	* @return actual response object                  
	*                   
	*/                              
	function parseResponse(data : XML) : Object;
	/**                  
	*                   
	* @param response the response received from the server.                  
	* @return the object the represents the response.                  
	*/                 
	function extractResponseData(response : Object) : Object;         
} 
```

The first method, `createRequest`, is responsible for building the actual XML to be sent to the server. There are two ways of building the request, basically: build the XML directly by simply writing it in the method's body or build the XML by creating the request object and then using the serializer to extract the xml request.

`parseResponse` is designed for performing the deserialization from the received xml to AS objects. Basically, the resulting object is a representation of the entire response, containing all protocol overhead. At this point you can run different checks, for the validity of the response for example. After checkups pass, you can extract the useful data from the response object, which is the purpose of the `extractResponseData` method.

### 2. Communicators ###

TODO

## Persistence ##

This option appeared in response to several issues I encountered at my job while working on editing an object. What we needed was to be able to edit an object without triggering bindings and also to be able to revert to the original object if canceling the edit.

Basically, the solution we employed back then was to clone the object. When we started the edit we would create a clone of the edited object; that clone would then be used in the view and be modified as needed. Upon cancel we would just discard the clone; on finish we would save the changed on the server then copy the values from the clone to the original object.

Another solution is to have an object aware of the changes that occur on it from the last save, a persistable object. This object would remember the fields that were changed and will have the ability to revert the changes made to it. Thus there would be no need for cloning the edited object and running into all the problems that come with it.

How would this work? Basically, a persistable object will hold an internal list with the fields whose values changed along with the original values. This is the foothold for allowing the object to revert the changes made to it by iterating the change list and reinstating the original values.

Let's take a look at the definition of a persitable object:

```
public interface IPersistable         
{                 
	/**                  
	 * Get the object's status: has it been modified since the previous commit?
	 * @return  true/false
	 *
	 */ 
	function get modified() : Boolean;
	/**
	 * 
	 * @return 
	 *       
	 */          
	function get editMode() : Boolean; 
	/**             
	 *             
	 * @param mode      
	 *               
         */                
	function setEditMode(mode : Boolean) : void;  
	/**            
	 * Commit the changes made to the object since the previous commit 
	 *            
	 */            
	function commit() : void;       
	/**            
	 * Revert all the changes made to the object since the previous commit  
	 *              
	 */               
	function rollback() : void;      
	/**               
	 * Stop listening for changes occurring to the object.        
	 * It is usually called before deserialization occurs.     
	 *         
	 */       
	function stopListening() : void;      
	/**             
	 * Start listening for changes occuring to the object.     
	 * Usually called after deserialization completes.
	 *
	 */  
	function startListening() : void;
} 
```

The main methods here are `commit()` and `rollback()`. As stated before an object will hold an internal list of changes. Upon commit, that list will be cleared making the current values resident. If rollback is done, then the values will be reverted to the original ones available from the latest commit. You can view it as a transactional object.

When editing the object you really do not want changes you make to be propagated to all components bound to it because you might decide to cancel and maybe some of those components are visible in the background and seeing them change the user might think he can't revert. For this reason, there is an `editMode` flag. When this flag is set, changes will not be propagated to bound listeners, by simply not firing the `PropertyChangeEvent`. The changes made will still be recorded by the Persistable object. You set the flag when the edit view is displayed and unset it when editing is finished, by using `setEditMode(mode : Boolean)` method.

On another hand, when receiving objects from the server you don't want during the deserialization process to have the object detect the changes being made. Since they come from the server, they are already persisted so they should be set on the object without changing the state. For this reason there are two methods defined: `startListening()` and `stopListening()`. You call `stopListening` before the deserialization starts and call `startListening` after deserialization finishes. FlexXB automatically handles calling these methods for persistable objects.

The `IPersistable` interface is implemented by two classes, `PersistableObject` and `ReferenceList`, all of them being located in the `com.googlecode.flexxb.persistence` namespace. `PersistableObject` provides persistence support for non list objects while `ReferenceList` offers it for list-like object, namely Array Collections.

There are some differences between the `PersistableObject` and `PersistableList` when it comes to tthe feature they offer due to the inherent nature of the changes they need to track.

A `PersistableObject` can become aware of changes within him or within associated objects that is, references to other objects. The watch feature is not meant for simple values or values whose class definitions do not implement `IPersistable` cos those objects do not monitor changes occuring on them or their fields. By using `watch(fieldName : String)` method the current object is instructed to monitor changes occuring on the value contained by the specified field. Whenever the value is modified, the current object will be marked as moodified also. By using `hasWatchedFields()` and `isWatched(fieldName : String)` methods, one could determine if an instance has been configured to watch any of it's fields or if a specific field is being watched. There are cases when some fields are used solely for display purposes, thus are not used in persisting object changes, for example, a selected flag signaling if an object has been selected from a list. In this case, the selected flag needs not be monitored and this can be configured by using the `exclude(fieldName : String)` method te exclude the field from being listened. The `PersistableList` does not have the features of watching connected objects or excluding fields from listening.