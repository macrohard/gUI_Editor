package com.macro.gUI.editor.project
{
	import com.macro.gUI.skin.SkinDef;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	import mx.controls.Alert;


	public class SkinConfiguration
	{
		private var _contents:Dictionary;

		private var _config:XML = <skins>
					<item id="TEXTINPUT_BG" />
					<item id="TEXTINPUT_BG_DISABLE" />
					<item id="TEXTAREA_BG" />
					<item id="TITLEBAR_BG" />

					<item id="BUTTON" />
					<item id="BUTTON_OVER" />
					<item id="BUTTON_DOWN" />
					<item id="BUTTON_DISABLE" />

					<item id="TOGGLEBUTTON" />
					<item id="TOGGLEBUTTON_OVER" />
					<item id="TOGGLEBUTTON_DOWN" />
					<item id="TOGGLEBUTTON_DISABLE" />
					<item id="TOGGLEBUTTON_SELECTED" />
					<item id="TOGGLEBUTTON_SELECTED_OVER" />
					<item id="TOGGLEBUTTON_SELECTED_DOWN" />
					<item id="TOGGLEBUTTON_SELECTED_DISABLE" />

					<item id="ICONBUTTON" />
					<item id="ICONBUTTON_OVER" />
					<item id="ICONBUTTON_DOWN" />
					<item id="ICONBUTTON_DISABLE" />

					<item id="CHECKBOX" />
					<item id="CHECKBOX_DISABLE" />
					<item id="CHECKBOX_SELECTED" />
					<item id="CHECKBOX_SELECTED_DISABLE" />

					<item id="RADIOBUTTON" />
					<item id="RADIOBUTTON_DISABLE" />
					<item id="RADIOBUTTON_SELECTED" />
					<item id="RADIOBUTTON_SELECTED_DISABLE" />

					<item id="PROGRESSBAR_BG" />
					<item id="PROGRESSBAR_FILLING" />

					<item id="SLIDER_HORIZONTAL_BG" />
					<item id="SLIDER_VERTICAL_BG" />
					<item id="SLIDER_BLOCK" />
					<item id="SLIDER_BLOCK_OVER" />
					<item id="SLIDER_BLOCK_DOWN" />
					<item id="SLIDER_BLOCK_DISABLE" />

					<item id="SCROLLBAR_HORIZONTAL_BG" />
					<item id="SCROLLBAR_HORIZONTAL_BLOCK" />
					<item id="SCROLLBAR_HORIZONTAL_BLOCK_OVER" />
					<item id="SCROLLBAR_HORIZONTAL_BLOCK_DOWN" />
					<item id="SCROLLBAR_HORIZONTAL_BLOCK_DISABLE" />
					<item id="SCROLLBAR_LEFT" />
					<item id="SCROLLBAR_LEFT_OVER" />
					<item id="SCROLLBAR_LEFT_DOWN" />
					<item id="SCROLLBAR_LEFT_DISABLE" />
					<item id="SCROLLBAR_RIGHT" />
					<item id="SCROLLBAR_RIGHT_OVER" />
					<item id="SCROLLBAR_RIGHT_DOWN" />
					<item id="SCROLLBAR_RIGHT_DISABLE" />

					<item id="SCROLLBAR_VERTICAL_BG" />
					<item id="SCROLLBAR_VERTICAL_BLOCK" />
					<item id="SCROLLBAR_VERTICAL_BLOCK_OVER" />
					<item id="SCROLLBAR_VERTICAL_BLOCK_DOWN" />
					<item id="SCROLLBAR_VERTICAL_BLOCK_DISABLE" />
					<item id="SCROLLBAR_UP" />
					<item id="SCROLLBAR_UP_OVER" />
					<item id="SCROLLBAR_UP_DOWN" />
					<item id="SCROLLBAR_UP_DISABLE" />
					<item id="SCROLLBAR_DOWN" />
					<item id="SCROLLBAR_DOWN_OVER" />
					<item id="SCROLLBAR_DOWN_DOWN" />
					<item id="SCROLLBAR_DOWN_DISABLE" />

					<item id="LIST_ITEM_BG" />
					<item id="LIST_ITEM_OVER_BG" />
					<item id="LIST_ITEM_SELECTED_BG" />
					<item id="LIST_BG" />

					<item id="COMBO_INPUT_BG" />
					<item id="COMBO_INPUT_BG_DISABLE" />
					<item id="COMBO_BUTTON" />
					<item id="COMBO_BUTTON_OVER" />
					<item id="COMBO_BUTTON_DOWN" />
					<item id="COMBO_BUTTON_DISABLE" />
					<item id="COMBO_LIST_ITEM_BG" />
					<item id="COMBO_LIST_ITEM_OVER_BG" />
					<item id="COMBO_LIST_ITEM_SELECTED_BG" />
					<item id="COMBO_LIST_BG" />

					<item id="PANEL_BG" />
					<item id="SCROLLPANEL_BG" />

					<item id="WINDOW_BG" />
					<item id="WINDOW_MINIMIZE_BUTTON" />
					<item id="WINDOW_MINIMIZE_BUTTON_OVER" />
					<item id="WINDOW_MINIMIZE_BUTTON_DOWN" />
					<item id="WINDOW_MINIMIZE_BUTTON_DISABLE" />
					<item id="WINDOW_MAXIMIZE_BUTTON" />
					<item id="WINDOW_MAXIMIZE_BUTTON_OVER" />
					<item id="WINDOW_MAXIMIZE_BUTTON_DOWN" />
					<item id="WINDOW_MAXIMIZE_BUTTON_DISABLE" />
					<item id="WINDOW_CLOSE_BUTTON" />
					<item id="WINDOW_CLOSE_BUTTON_OVER" />
					<item id="WINDOW_CLOSE_BUTTON_DOWN" />

					<item id="TABPANEL_BG" />
					<item id="TABPANEL_TAB" />
					<item id="TABPANEL_TAB_SELECTED" />
				</skins>;

		public function SkinConfiguration()
		{
			_contents = new Dictionary();
		}



		public function set configXML(value:XML):void
		{
			if (value == null)
				return;

			for each (var xml:XML in value.item)
			{
				var item:XML = getDefine(xml.@id);
				if (item != null)
				{
					item.@url = xml.@url;
					item.@x = xml.@x;
					item.@y = xml.@y;
					item.@width = xml.@width;
					item.@height = xml.@height;
					item.@align = xml.@align;
					
					loadSkin(item.@id, item.@url);
				}
			}
		}

		public function get configXML():XML
		{
			return _config;
		}


		public function setDefine(id:String, url:String, grid:Rectangle, align:int):void
		{
			if (!_config.hasOwnProperty(id))
			{
				return;
			}

			var item:XML = getDefine(id);
			item.@url = url;
			item.@x = grid.x;
			item.@y = grid.y;
			item.@width = grid.width;
			item.@height = grid.height;
			item.@align = align;

			loadSkin(id, url);
		}

		public function getDefine(id:String):XML
		{
			return _config.item.(@id == id)[0];
		}


		private function loadSkin(id:String, url:String):void
		{
			if (url == "")
				return;

			var loader:Loader = new Loader();
			loader.load(new URLRequest(url));
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


	}
}
