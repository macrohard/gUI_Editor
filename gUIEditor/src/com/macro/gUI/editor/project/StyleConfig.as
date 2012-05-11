package com.macro.gUI.editor.project
{
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.skin.StyleDef;

	import flash.utils.describeType;


	public class StyleConfig
	{
		private var _config:XML;

		public function StyleConfig()
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

		public function setDefine(id:String, font:String, size:String, color:String, bold:String, italic:String, underline:String,
								  align:String, leftMargin:String, rightMargin:String, indent:String, blockIndent:String, leading:String,
								  kerning:String, letterSpacing:String, multiline:String, wordWrap:String, maxChars:String,
								  filters:String):void
		{
			var item:XML = getDefine(id);
			if (item == null)
				return;
			
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
		
		
		private function createDefaultConfig():void
		{
			var keyList:Vector.<String> = new Vector.<String>();
			var reflect:XMLList = describeType(StyleDef).constant;
			for each (var xml:XML in reflect)
			{
				keyList.push(xml.@name);
			}
			keyList.sort(0);
			
			_config = <styles/>;
			for each (var s:String in keyList)
			{
				_config.appendChild(<item id={s} />);
			}
		}
	}
}
