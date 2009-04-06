/**
 *   FxMOD
 *   Copyright (C) 2008 - 2009 Alex Ciobanu
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
package com.googlecode.fxmod
{
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.fxmod.settings.model.Menu;
	import com.googlecode.fxmod.settings.model.MenuItem;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	import mx.core.ByteArrayAsset;
	
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public class MenuParser
	{
		[Embed("/assets/xml/menu.xml", mimeType="application/octet-stream")]
		private static const MenuResource : Class;

		private static var menu : NativeMenu;
		
		public static function getMenu(host : Object) : NativeMenu{
			if(!menu){
				var xmlMenu : XML = getMenuFile();
				menu = buildMenu(xmlMenu, host);
			}
			return menu;
		}
		
		private static function buildMenu(xmlMenu : XML, host : Object) : NativeMenu{
			var menu : NativeMenu = new NativeMenu();
			
			var settingsMenu : Menu = FlexXBEngine.instance.deserialize(xmlMenu, Menu) as Menu;
					
			for each(var menuItem : MenuItem in settingsMenu.items){
				menu.addItem(buildMenuItem(menuItem, host));
			}
			return menu;
		}
		
		private static function buildMenuItem(menuItem : MenuItem, host : Object) : NativeMenuItem{					
			var item : NativeMenuItem = new NativeMenuItem(menuItem.label, menuItem.separator);
			if(!menuItem.separator){
				item.mnemonicIndex = menuItem.mnemonicIndex;
				if(menuItem.hasSubItems()){
					buildSubMenu(item, menuItem, host);
				}
				if(!menuItem.hasDataProvider()){
					setSelectHandler(item, menuItem, host);
				}
			}
			return item;
		}
		
		private static function buildSubMenu(item : NativeMenuItem, menuItem : MenuItem, host : Object) : void{
			if(menuItem.hasDataProvider()){
				var dataProvider : Object;
				if(host){
					dataProvider = host[menuItem.dataProvider];
				}
				if(dataProvider){
					for each(var element : Object in dataProvider){
						if(!item.submenu){
							item.submenu = new NativeMenu();
						}
						var sub : NativeMenuItem = new NativeMenuItem();
						sub.label = element[menuItem.labelField];
						sub.data = element[menuItem.dataField];
						setSelectHandler(sub, menuItem, host);
						item.submenu.addItem(sub);
					}
				}
			}
			for each(var subItem : MenuItem in menuItem.subItems){
				if(!item.submenu){
					item.submenu = new NativeMenu();
				}
				item.submenu.addItem(buildMenuItem(subItem, host));
			}
		}
		
		private static function setSelectHandler(item : NativeMenuItem, data : MenuItem, host : Object) : void{
			if(data.selectHandler && host && host[data.selectHandler] is Function){
				item.addEventListener(Event.SELECT, host[data.selectHandler] as Function);
			}
		}
		
		private static function getMenuFile() : XML
		{
			var ba:ByteArrayAsset = ByteArrayAsset(new MenuResource());
   			return XML( ba.readUTFBytes( ba.length ));
		}
	}
}