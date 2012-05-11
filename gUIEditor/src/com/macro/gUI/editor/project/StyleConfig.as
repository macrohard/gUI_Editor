package com.macro.gUI.editor.project
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.editor.style.FilterUtil;
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
					
					addStyle(item);
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
			
			addStyle(item);
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
				GameUI.skinManager.setStyle(StyleDef[s], null);
			}
		}
		
		private function addStyle(item:XML):void
		{
			var style:TextStyle = new TextStyle();
			if (item.@font != "")
				style.font = item.@font;
			if (item.@size != "")
				style.size = item.@size;
			if (item.@color != "")
				style.color = item.@color;
			if (item.@bold != "")
				style.bold = item.@bold == "true";
			if (item.@italic != "")
				style.italic = item.@italic == "true";
			if (item.@underline != "")
				style.underline = item.@underline == "true";
			if (item.@align != "")
				style.align = item.@align;
			if (item.@leftMargin != "")
				style.leftMargin = item.@leftMargin;
			if (item.@rightMargin != "")
				style.rightMargin = item.@rightMargin;
			if (item.@indent != "")
				style.indent = item.@indent;
			if (item.@blockIndent != "")
				style.blockIndent = item.@blockIndent;
			if (item.@leading != "")
				style.leading = item.@leading;
			if (item.@kerning != "")
				style.kerning = item.@kerning == "true";
			if (item.@letterSpacing != "")
				style.letterSpacing = item.@letterSpacing;
			
			style.multiline = item.@multiline == "true";
			style.wordWrap = item.@wordWrap == "true";
			style.maxChars = int(item.@maxChars);
			if (item.@filters != "")
				style.filters = FilterUtil.getFilters(item.@filters);
			
			GameUI.skinManager.setStyle(StyleDef[item.@id], style);
		}
	}
}
