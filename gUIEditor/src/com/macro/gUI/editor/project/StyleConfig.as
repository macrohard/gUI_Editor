package com.macro.gUI.editor.project
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.filters.BitmapFilter;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;


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
					
					GameUI.skinManager.setStyle(StyleDef[item.@id], getStyle(item));
				}
			}
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
		
		
		
		public function getStyle(item:XML):TextStyle
		{
			//				var filter:String = '[new GlowFilter(0x00ff00, 1, 2, 2, 16), ' + 
			//					'new GradientGlowFilter(0, 45, [0xFFFFFF, 0xFF0000, 0xFFFF00, 0x00CCFF], [0, 1, 1, 1], [0, 63, 126, 255], 50, 50, 2.5, 3, "outer", false), ' + 
			//					'new DropShadowFilter(5, 45, 0, 1, 2, 2, 0.5)]';
			
			var style:TextStyle = new TextStyle();
			if (item.@font.toString() != "")
				style.font = item.@font;
			if (item.@size.toString() != "")
				style.size = item.@size;
			if (item.@color.toString() != "")
				style.color = item.@color;
			if (item.@bold.toString() != "")
				style.bold = item.@bold == "true";
			if (item.@italic.toString() != "")
				style.italic = item.@italic == "true";
			if (item.@underline.toString() != "")
				style.underline = item.@underline == "true";
			if (item.@align.toString() != "")
				style.align = item.@align;
			if (item.@leftMargin.toString() != "")
				style.leftMargin = item.@leftMargin;
			if (item.@rightMargin.toString() != "")
				style.rightMargin = item.@rightMargin;
			if (item.@indent.toString() != "")
				style.indent = item.@indent;
			if (item.@blockIndent.toString() != "")
				style.blockIndent = item.@blockIndent;
			if (item.@leading.toString() != "")
				style.leading = item.@leading;
			if (item.@kerning.toString() != "")
				style.kerning = item.@kerning == "true";
			if (item.@letterSpacing.toString() != "")
				style.letterSpacing = item.@letterSpacing;
			
			style.multiline = item.@multiline == "true";
			style.wordWrap = item.@wordWrap == "true";
			style.maxChars = int(item.@maxChars);
			if (item.@filters.toString() != "")
				style.filters = getFilters(item.@filters);
			
			return style;
		}
		
		/**
		 * 支持以基本类型为构造参数的滤镜，如：BevelFilter、BlurFilter、ColorMatrixFilter、
		 * ConvolutionFilter、DropShadowFilter、GlowFilter、GradientBevelFilter、
		 * GradientGlowFilter等等，不支持DisplacementMapFilter、ShaderFilter。
		 * @param str
		 * @return
		 *
		 */
		private function getFilters(str:String):Array
		{
			var filters:Array = new Array();
			
			var pattern:RegExp = /new (\w+)\((.*?)\)/ig;
			var result:Object = pattern.exec(str);
			try
			{
				while (result != null)
				{
					var className:String = result[1];
					var parameter:String = result[2];
					
					filters.push(createFilter(className, parameter));
					
					result = pattern.exec(str);
				}
			}
			catch(e:Error)
			{
			}
			
			return filters;
		}
		
		private function createFilter(className:String, parameter:String):BitmapFilter
		{
			var clz:Class = getDefinitionByName("flash.filters." + className) as Class;
			var constructors:XMLList = describeType(clz).factory.constructor.parameter;
			
			var pattern:RegExp = /\s*/g;
			parameter = parameter.replace(pattern, "");
			
			var args:Array = [];
			for each (var xml:XML in constructors)
			{
				var type:String = xml.@type;
				
				var index:int;
				if (type == "int")
				{
					index = parameter.indexOf(",");
					index = index == -1 ? parameter.length : index;
					args.push(int(parameter.substr(0, index)));
				}
				else if (type == "uint")
				{
					index = parameter.indexOf(",");
					index = index == -1 ? parameter.length : index;
					args.push(uint(parameter.substr(0, index)));
				}
				else if (type == "Number")
				{
					index = parameter.indexOf(",");
					index = index == -1 ? parameter.length : index;
					args.push(Number(parameter.substr(0, index)));
				}
				else if (type == "Boolean")
				{
					index = parameter.indexOf(",");
					index = index == -1 ? parameter.length : index;
					args.push(parameter.substr(0, index) == "true");
				}
				else if (type == "String")
				{
					index = parameter.indexOf(",");
					index = index == -1 ? parameter.length : index;
					args.push(parameter.substring(1, index - 1));
				}
				else if (type == "Array")
				{
					var f:int = parameter.indexOf("[") + 1;
					var e:int = parameter.indexOf("]");
					var arr:Array = parameter.substring(f, e).split(",");
					var t:Array = [];
					for each (var s:String in arr)
					{
						t.push(Number(s));
					}
					args.push(t);
					index = parameter.indexOf(",", e);
					index = index == -1 ? parameter.length : index;
				}
				else
				{
					throw new Error("Unsupport parameter type!");
				}
				
				parameter = parameter.substr(index + 1);
				if (parameter.length == 0)
				{
					break;
				}
			}
			
			return newInstance(clz, args) as BitmapFilter;
		}
		
		private function newInstance(clz:Class, args:Array):Object
		{
			switch (args.length)
			{
				case 1:
					return new clz(args[0]);
				case 2:
					return new clz(args[0], args[1]);
				case 3:
					return new clz(args[0], args[1], args[2]);
				case 4:
					return new clz(args[0], args[1], args[2], args[3]);
				case 5:
					return new clz(args[0], args[1], args[2], args[3], args[4]);
				case 6:
					return new clz(args[0], args[1], args[2], args[3], args[4], args[5]);
				case 7:
					return new clz(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
				case 8:
					return new clz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
				case 9:
					return new clz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
				case 10:
					return new clz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
				case 11:
					return new clz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
				case 12:
					return new clz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10],
						args[11]);
				default:
					throw new Error("Unsupported number of Constructor args");
			}
		}
	}
}
