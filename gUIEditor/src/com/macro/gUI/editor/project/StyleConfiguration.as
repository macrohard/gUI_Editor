package com.macro.gUI.editor.project
{
	public class StyleConfiguration
	{
		public function StyleConfiguration()
		{
		}
		
		private var _config:XML;
		
		public function set configXML(value:XML):void
		{
			_config = value == null ? <styles/> : value;
		}
		
		public function get configXML():XML
		{
			return _config;
		}
	}
}