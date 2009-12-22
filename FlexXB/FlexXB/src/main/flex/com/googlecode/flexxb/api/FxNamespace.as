package com.googlecode.flexxb.api
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	[XmlClass(alias="Namespace")]
	[ConstructorArg(reference="prefix")]
	[ConstructorArg(reference="uri")]
	public final class FxNamespace
	{
		/**
		 * 
		 * @param ns
		 * @return 
		 * 
		 */		
		public static function create(ns : Namespace) : FxNamespace{
			if(ns){
				return new FxNamespace(ns.prefix, ns.uri);
			}
			return null;
		}
		
		private var _prefix : String;
		private var _uri : String
		
		/**
		 * 
		 * @param prefix
		 * @param uri
		 */
		public function FxNamespace(prefix : *, uri : *){
			_prefix = prefix;
			_uri = uri;
		}
		
		[XmlAttribute]
		/**
		 * 
		 * @return 
		 */
		public function get prefix() : String{
			return _prefix;
		}
		
		[XmlAttribute]
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get uri() : String{
			return _uri;
		}
		
		public function toXml() : XML{
			return <metadata name="Namespace">
								<arg key="prefix" value={prefix} />
								<arg key="uri" value={uri} />
							</metadata>
		}
		
		public function toString() : String{
			return "Namespace[ prefix: " + _prefix + ", uri: " + _uri + "]";
		}
	}
}