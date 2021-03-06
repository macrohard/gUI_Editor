package com.macro.gUI.editor.project
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.describeType;


	public class SkinConfig
	{
		private var _contents:Dictionary;

		private var _config:XML;

		public function SkinConfig()
		{
			createDefaultConfig();
		}



		public function set configXML(value:XML):void
		{
			createDefaultConfig();

			if (value == null)
				return;

			for each (var xml:XML in value.item)
			{
				var item:XML = getDefine(xml.@id);
				if (item != null)
				{
					item.@filename = xml.@filename;
					item.@x = xml.@x;
					item.@y = xml.@y;
					item.@width = xml.@width;
					item.@height = xml.@height;
					item.@align = xml.@align;

					if (item.@filename != "")
						loadSkin(item.@id, item.@filename);
				}
			}
		}
		
		private function loadSkin(id:String, filename:String):void
		{
			var file:File = ProjectManager.inst.skinsDirectory.resolvePath(filename);
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest(file.nativePath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
				
				_contents[id] = loader.content;
				var item:XML = getDefine(id);
				GameUI.skinManager.createSkin(SkinDef[id], loader.content, new Rectangle(item.@x, item.@y, item.@width, item.@height),
					item.@align);
			});
		}

		public function get configXML():XML
		{
			return _config;
		}


		public function getDefine(id:String):XML
		{
			return _config.item.(@id == id)[0];
		}


		private function createDefaultConfig():void
		{
			var keyList:Vector.<String> = new Vector.<String>();
			var reflect:XMLList = describeType(SkinDef).constant;
			for each (var xml:XML in reflect)
			{
				keyList.push(xml.@name);
			}
			keyList.sort(0);

			_config = <skins/>;
			for each (var s:String in keyList)
			{
				_config.appendChild(<item id={s} />);
				GameUI.skinManager.setSkin(SkinDef[s], null);
			}

			_contents = new Dictionary();
		}
		
		
		public function getDisplayObject(id:String):DisplayObject
		{
			return _contents[id];
		}
		
		public function setDisplayObject(id:String, source:DisplayObject):void
		{
			_contents[id] = source;
		}
	}
}
