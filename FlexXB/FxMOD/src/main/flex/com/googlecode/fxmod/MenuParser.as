package com.googlecode.fxmod
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
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
		
		private static const MENUITEM_NAME : String = "MenuItem";
		private static const MENUITEM_LABEL : String = "label";
		private static const MENUITEM_KEY : String = "shortcutKey";
		private static const MENUITEM_SEPARATOR : String = "separator";
		private static const MENUITEM_MNEMONIC : String = "mnemonicIndex";
		
		private static var menu : NativeMenu;
		
		public static function getMenu() : NativeMenu{
			if(!menu){
				var xmlMenu : XML = getMenuFile();
				menu = buildMenu(xmlMenu);
			}
			return menu;
		}
		
		private static function buildMenu(xmlMenu : XML) : NativeMenu{
			var menu : NativeMenu = new NativeMenu();
			var items : XMLList = xmlMenu.child(MENUITEM_NAME);
			for each(var menuItemXml : XML in items){
				menu.addItem(buildMenuItem(menuItemXml));
			}
			return menu;
		}
		
		private static function buildMenuItem(xml : XML) : NativeMenuItem{
			var label : String = xml.@[MENUITEM_LABEL];
			var separator : Boolean = xml.@[MENUITEM_SEPARATOR] == "true";
			var mnemonicIndex : int = Number(xml.@[MENUITEM_MNEMONIC]);
			
			var item : NativeMenuItem = new NativeMenuItem(label, separator);
			if(!separator){
				item.mnemonicIndex = mnemonicIndex;
				var items : XMLList = xml.child(MENUITEM_NAME);
				for each(var menuItemXml : XML in items){
					if(!item.submenu){
						item.submenu = new NativeMenu();
					}
					item.submenu.addItem(buildMenuItem(menuItemXml));
				}
			}
			return item;
		}
		
		private static function getMenuFile() : XML
		{
			var ba:ByteArrayAsset = ByteArrayAsset(new MenuResource());
   			return XML( ba.readUTFBytes( ba.length ));
		}
	}
}