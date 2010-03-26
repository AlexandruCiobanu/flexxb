/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.googlecode.flexxb.annotation {
	import flash.utils.getDefinitionByName;

	/**
	 * This is the base class for a field xml annotation.
	 * <p> It obtains basic informations about the field:
	 * <ul><li>Field name</li>
	 *     <li>Field type</li>
	 *     <li>Alias (the name under which the field will be used in the xml reprezentation)</li>
	 * </ul>
	 * </p>
	 * @author aCiobanu
	 *
	 */
	public class Annotation extends BaseAnnotation {
		
		public static const ARGUMENT_ALIAS : String = "alias";
		
		public static const ALIAS_ANY : String = "*";
		/**
		 * @private
		 */
		protected var _fieldName : QName;
		/**
		 * @private
		 */
		protected var _fieldType : Class;
		/**
		 * @private
		 */
		protected var _alias : String = "";
		
		private var _xmlName : QName;
		
		private var _nameSpace : Namespace;

		/**
		 * Constructor
		 * @param descriptor
		 *
		 */
		public function Annotation(descriptor : XML) {
			super(descriptor);
		}
		
		/**
		 * Get the annotation namespace
		 * @return namespace instance
		 *
		 */
		public function get nameSpace() : Namespace {
			return _nameSpace;
		}
		
		/**
		 * Set the annotation namepsace
		 *
		 */
		public function set nameSpace(value : Namespace) : void {
			_nameSpace = value;
		}
		
		/**
		 * Get the field name
		 * @return field name
		 *
		 */
		public function get fieldName() : QName {
			return _fieldName;
		}

		/**
		 * Get the field type
		 * @return field type
		 *
		 */
		public function get fieldType() : Class {
			return _fieldType;
		}

		/**
		 * Get the qualified xml name
		 * @return
		 *
		 */
		public function get xmlName() : QName {
			if (!_xmlName) {
				_xmlName = new QName(nameSpace, _alias == "" ? _fieldName : _alias);
			}
			return _xmlName;
		}

		/**
		 * Get the alias
		 * @return annotation alias
		 *
		 */
		public function get alias() : String {
			return _alias;
		}

		/**
		 * @private
		 * @param value name to be set
		 *
		 */
		protected function setAlias(value : String) : void {
			if (value == null)
				return;
			_alias = value;
			if (_alias.length == 0) {
				_alias = _fieldName.localName;
			}
		}

		/**
		 * Get a flag to signal wether this annotation declares a namespace or not
		 * @return true if it has namespace declarations, false otherwise
		 *
		 */
		public function hasNamespaceDeclaration() : Boolean {
			return nameSpace && nameSpace.uri && nameSpace.uri.length > 0;
		}

		/**
		 * Get a flag to signal wether to use the owner's alias or not
		 * @return true if it must use the owner's alias, false otherwise
		 *
		 */
		public function useOwnerAlias() : Boolean {
			return _alias == ALIAS_ANY;
		}

		/**
		 * @private
		 * Analyze field/class descriptor to extract base informations like field's name and type
		 * @param field field descriptor
		 *
		 */
		protected override function parse(field : XML) : void {
			if (field.@name.length() > 0) {
				_fieldName = new QName(field.@uri, field.@name);
			}
			if (field.@type.length() > 0) {
				_fieldType = getDefinitionByName(field.@type) as Class;
			}
			var metadata : XMLList = field.metadata.(@name == annotationName);
			if (metadata.length() > 0) {
				parseMetadata(metadata[0]);
			}
			return;
		}

		/**
		 * @private
		 * Process the metadata attached to the field to extract annotation specific data
		 * @param field field descriptor
		 *
		 */
		protected function parseMetadata(field : XML) : void {
		}
	}
}