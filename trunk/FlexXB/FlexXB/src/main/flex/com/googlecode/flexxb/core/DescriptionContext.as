package com.googlecode.flexxb.core
{
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.contract.Constants;
	import com.googlecode.flexxb.annotation.contract.ConstructorArgument;
	import com.googlecode.flexxb.converter.IConverter;
	import com.googlecode.flexxb.error.DescriptorParsingError;

	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class DescriptionContext
	{
		private var _store : IDescriptorStore;
		private var _converterStore : ConverterStore;
		protected var _configuration : Configuration;
		private var _engine : FxBEngine;
		/**
		 * 
		 * @param store
		 * @param configuration
		 * 
		 */		
		public function DescriptionContext(){ }
		/**
		 * @private
		 * @param engine
		 * @param store
		 * @param configuration
		 * 
		 */		
		internal final function initializeContext(engine : FxBEngine, descriptorStore : IDescriptorStore) : void{
			_store = descriptorStore;
			_converterStore = new ConverterStore();
			_engine = engine;
			//register the annotations we know must always exist
			registerAnnotation(Constants.ANNOTATION_CONSTRUCTOR_ARGUMENT, ConstructorArgument, null);
			performInitialization();
		}
		/**
		 * @private
		 * @return 
		 * 
		 */		
		internal final function get converterStore() : ConverterStore{
			return _converterStore;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get configuration() : Configuration{
			if(!_configuration){
				_configuration = new Configuration();
			}
			return _configuration;
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set configuration(value : Configuration) : void{
			if(value){
				_configuration = value;
			}
		}
		/**
		 * Get the object type associated with the incoming serialized form.</br>
		 * Override this method in subclasses because each serialization format has 
		 * different ways of determining the type of teh object to be used in 
		 * deserialization.  
		 * @param source serialized form
		 * @return object type
		 * 
		 */		
		public function getIncomingType(source : Object) : Class{
			return null;
		}
		/**
		 * 
		 * @param descriptors
		 * 
		 */		
		public function handleDescriptors(descriptors : Array) : void {}
		/**
		 * Override in subclasses to initialize your context by 
		 * registering annotations and converters
		 * 
		 */		
		protected function performInitialization() : void { }
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected final function get descriptorStore() : IDescriptorStore{
			return _store;
		}
		/**
		 * 
		 * @param converter
		 * @param overrideExisting
		 * @return 
		 * 
		 */		
		public final function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean {
			return _converterStore.registerSimpleTypeConverter(converter, overrideExisting);
		}
		/**
		 * 
		 * @param name
		 * @param annotationClazz
		 * @param serializer
		 * @param overrideExisting
		 * 
		 */		
		public final function registerAnnotation(name : String, annotationClazz : Class, serializer : Class, overrideExisting : Boolean = false) : void {
			AnnotationFactory.instance.registerAnnotation(name, annotationClazz, serializer, this, overrideExisting);
		}
	}
}