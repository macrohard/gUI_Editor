package com.macro.gUI.editor.style
{
	import flash.filters.BitmapFilter;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	public class FilterUtil
	{
		/**
		 * 支持以基本类型为构造参数的滤镜，如：BevelFilter、BlurFilter、ColorMatrixFilter、
		 * ConvolutionFilter、DropShadowFilter、GlowFilter、GradientBevelFilter、
		 * GradientGlowFilter等等，不支持DisplacementMapFilter、ShaderFilter。
		 * @param str
		 * @return
		 *
		 */
		public static function getFilters(str:String):Array
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
		
		private static function createFilter(className:String, parameter:String):BitmapFilter
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
		
		private static function newInstance(clz:Class, args:Array):Object
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