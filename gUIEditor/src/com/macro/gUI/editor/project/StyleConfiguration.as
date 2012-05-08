package com.macro.gUI.editor.project
{
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.skin.StyleDef;

	import flash.utils.describeType;


	public class StyleConfiguration
	{
		private var _config:XML = <styles>
					<item id="LABEL" />
					<item id="TEXTINPUT" />
					<item id="TEXTINPUT_DISABLE" />
					<item id="TEXTAREA" />
					<item id="TITLEBAR" />

					<item id="LIST_ITEM" />
					<item id="LIST_ITEM_SELECTED" />
					<item id="COMBO_INPUT" />
					<item id="COMBO_INPUT_DISABLE" />
					<item id="COMBO_LIST_ITEM" />
					<item id="COMBO_LIST_ITEM_SELECTED" />

					<item id="WINDOW_TITLE" />
					<item id="TAPPANEL_TITLE" />

					<item id="LINKBUTTON_NORMAL" />
					<item id="LINKBUTTON_OVER" />
					<item id="LINKBUTTON_DOWN" />
					<item id="LINKBUTTON_DISABLE" />

					<item id="BUTTON_NORMAL" />
					<item id="BUTTON_OVER" />
					<item id="BUTTON_DOWN" />
					<item id="BUTTON_DISABLE" />

					<item id="ICONBUTTON" />
					<item id="ICONBUTTON_DISABLE" />

					<item id="TOGGLEBUTTON_SELECTED" />
					<item id="TOGGLEBUTTON_SELECTED_OVER" />
					<item id="TOGGLEBUTTON_SELECTED_DOWN" />
					<item id="TOGGLEBUTTON_SELECTED_DISABLE" />
				</styles>;

		public function StyleConfiguration()
		{
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
					item.@font = xml.@font;
					item.@size = xml.@size;
					item.@color = xml.@color;
					item.@bold = xml.@bold;
					item.@italic = xml.@italic;
					item.@underline = xml.@underline;
					item.@align = xml.@align;
					item.@leftMargin = xml.@leftMargin;
					item.@rightMargin = xml.@rightMargin;
					item.@indent = xml.@indent;
					item.@blockIndent = xml.@blockIndent;
					item.@leading = xml.@leading;
					item.@kerning = xml.@kerning;
					item.@letterSpacing = xml.@letterSpacing;
					item.@multiline = xml.@multiline;
					item.@wordWrap = xml.@wordWrap;
					item.@maxChars = xml.@maxChars;
					item.@filters = xml.@filters;
				}
			}
		}

		public function get configXML():XML
		{
			return _config;
		}

		public function setDefine(id:String, font:String = null, size:Object = null, color:Object = null, bold:Object = null,
								  italic:Object = null, underline:Object = null, align:String = null, leftMargin:Object = null,
								  rightMargin:Object = null, indent:Object = null, blockIndent:Object = null, leading:Object = null,
								  kerning:Object = null, letterSpacing:Object = null, multiline:Boolean = false, wordWrap:Boolean = false,
								  maxChars:int = 50, filters:String = null):void
		{
			if (!_config.hasOwnProperty(id))
			{
				return;
			}

			var item:XML = getDefine(id);
			item.@font = font;
			item.@size = size;
			item.@color = color;
			item.@bold = bold;
			item.@italic = italic;
			item.@underline = underline;
			item.@align = align;
			item.@leftMargin = leftMargin;
			item.@rightMargin = rightMargin;
			item.@indent = indent;
			item.@blockIndent = blockIndent;
			item.@leading = leading;
			item.@kerning = kerning;
			item.@letterSpacing = letterSpacing;
			item.@multiline = multiline;
			item.@wordWrap = wordWrap;
			item.@maxChars = maxChars;
			item.@filters = filters;
		}

		public function getDefine(id:String):XML
		{
			return _config.item.(@id == id)[0];
		}
	}
}
