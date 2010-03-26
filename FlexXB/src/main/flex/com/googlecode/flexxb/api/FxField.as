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
package com.googlecode.flexxb.api {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import mx.utils.StringUtil;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	[XmlClass(alias="Field")]
	[ConstructorArg(reference="name")]
	[ConstructorArg(reference="type")]
	public class FxField {
		/**
		 *
		 */
		private var _name : String;
		/**
		 *
		 */
		private var _type : Class;
		/**
		 *
		 */
		private var _accessType : AccessorType;

		/**
		 *
		 * @param name
		 * @param type
		 * @param accessType
		 *
		 */
		public function FxField(name : String, type : Class, accessType : AccessorType = null) {
			this.name = name;
			this.type = type;
			if (accessType) {
				this.accessType = accessType;
			} else {
				this.accessType = AccessorType.READ_WRITE;
			}
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		public function get name() : String {
			return _name;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set name(value : String) : void {
			if (value == null || StringUtil.trim(value) == "") {
				throw new Error("Field name is null or empty!");
			}
			_name = value;
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		public function get type() : Class {
			return _type;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set type(value : Class) : void {
			if (value == null) {
				throw new Error("Field type is null!");
			}
			_type = value;
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		public function get accessType() : AccessorType {
			return _accessType;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set accessType(value : AccessorType) : void {
			if (value == null) {
				_accessType = AccessorType.READ_WRITE;
				return;
			}
			_accessType = value;
		}

		public function toXml() : XML {
			var xml : XML = <accessor />;
			xml.@name = name;
			xml.@type = getQualifiedClassName(type);
			xml.@access = accessType.toString();
			return xml;
		}

		public function toString() : String {
			return "Field[name: " + name + ", type:" + type + ", access: " + accessType + "]";
		}
	}
}