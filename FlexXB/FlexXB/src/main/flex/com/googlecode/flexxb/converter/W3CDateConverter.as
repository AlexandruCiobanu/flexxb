/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008-2009 Alex Ciobanu
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
 package com.googlecode.flexxb.converter
{
	import com.googlecode.flexxb.FlexXBEngine;
	/**
	 * Date converter conforming to the W3C standard 
	 * @author Alexutz
	 * 
	 */	
	public class W3CDateConverter implements IConverter
	{
		public static function registerInSerializer() : void{
			FlexXBEngine.instance.registerSimpleTypeConverter(new W3CDateConverter(), true);
		}
		/**
		 * 
		 * @see IConverter#type() 
		 * 
		 */		
		public function get type():Class
		{
			return Date;
		}
		/**
		* Returns a date string formatted according to W3CDTF.
		* @param d
		* @param includeMilliseconds Determines whether to include the
		* milliseconds value (if any) in the formatted string.
		*
		* @returns
		*/
		public function toString(d:Object):String
		{
			var date:Number = d.getUTCDate();
			var month:Number = d.getUTCMonth();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var milliseconds:Number = d.getUTCMilliseconds();
			var timeOffset : Number = d.getTimezoneOffset();
			var sb:String = new String();
			
			sb += d.getUTCFullYear() + "-";
			
			sb += addLeadingZero(month + 1) + "-";
			
			sb += addLeadingZero(date);
			
			sb += "T";
			
			sb += addLeadingZero(hours) + ":";
			
			sb += addLeadingZero(minutes) + ":";
			
			sb += addLeadingZero(seconds);
			
			if (milliseconds >= 0){
				sb += ".";
				sb += addLeadingZero(milliseconds, 3);
			}
		
			if(timeOffset<0){
				sb+="+";
				timeOffset = -timeOffset;
			}else{
				sb+="-";
			}
			var offsetHour : int = timeOffset/60;
			
			sb+= addLeadingZero(offsetHour) + ":";
			
			var offsetMinute : int = timeOffset%60;
			
			sb+= addLeadingZero(offsetMinute);
			
			return sb;
		}
		
		private static function addLeadingZero(value : int, count : int = 2) : String {
			var val : String = value + "";
			while (val.length < count) {
				val = "0" + val;
			}
			return val;
		}
		/**
		* Parses dates that conform to the W3C Date-time Format into Date objects.
		* @param str
		* @returns
		*
		*/
		public function fromString(str:String):Object
		{
			var finalDate:Date;
			try
			{
				var dateStr:String = str.substring(0, str.indexOf("T"));
				var timeStr:String = str.substring(str.indexOf("T")+1, str.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
				
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
				
				if (timeStr.indexOf("Z") != -1)
				{
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				}
				else if (timeStr.indexOf("+") != -1)
				{
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				}
				else // offset is -
				{
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var utc:Number = Date.UTC(year, month-1, date, hour, minutes, seconds, milliseconds);
				var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
				finalDate = new Date(utc);
				//utc-offset?
				if (finalDate.toString() == "Invalid Date")
				{
					throw new Error("This date does not conform to W3CDTF.");
				}
			}
			catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
            return finalDate;
		}
		
	}
}