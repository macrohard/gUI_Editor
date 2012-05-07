package com.macro.gUI.editor.project
{
	import com.macro.gUI.skin.SkinDef;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import mx.controls.Alert;

	public class SkinConfiguration
	{
		private var _bitmaps:Dictionary;
		
		public function SkinConfiguration()
		{
			_bitmaps = new Dictionary();
			
			var describe:XML = describeType(SkinDef);
			for each (var xml:XML in describe.constant)
			{
				_bitmaps[xml.@name.toString()] = null;
			}
		}
		
		private var _config:XML;
		
		public function set configXML(value:XML):void
		{
			_config = <skins/>;
			for each (var xml:XML in value.item)
			{
				var id:String = xml.@id;
				var url:String = xml.@url;
				if (_bitmaps.hasOwnProperty(id))
				{
					loadSkin(id, url);
					_config.appendChild(xml);
				}
				else
				{
					Alert.show("错误的皮肤定义项：" + id);
				}
			}
		}
		
		public function get configXML():XML
		{
			return _config;
		}
		
		
		public function addDefine(id:String, url:String, grid:Rectangle, align:int):void
		{
			if (!_config.hasOwnProperty(id))
			{
				return;
			}
			
			// TODO 继续
			
			loadSkin(id, url);
		}
		
		private function loadSkin(id:String, url:String):void
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
				_bitmaps[id] = loader.content;
			});
		}
	}
}