package com.macro.gUI.editor.project
{
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

					loadSkin(item.@id, item.@filename);
				}
			}
		}

		public function get configXML():XML
		{
			return _config;
		}


		public function setDefine(id:String, source:DisplayObject, grid:Rectangle, align:int, filename:String):void
		{
			var item:XML = getDefine(id);
			if (item == null)
				return;
			
			if (filename != null)
				item.@filename = filename;
			
			item.@x = grid.x;
			item.@y = grid.y;
			item.@width = grid.width;
			item.@height = grid.height;
			item.@align = align;

			_contents[id] = source;
		}

		public function getDefine(id:String):XML
		{
			return _config.item.(@id == id)[0];
		}


		private function loadSkin(id:String, filename:String):void
		{
			if (filename == "")
				return;

			var file:File = ProjectManager.inst.skinsDirectory.resolvePath(filename);
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest(file.nativePath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
				_contents[id] = loader.content;
			});
		}

		public function getDisplayObject(id:String):DisplayObject
		{
			return _contents[id];
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
			}
			
			_contents = new Dictionary();
		}
	}
}
