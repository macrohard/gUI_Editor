package com.macro.gUI.editor.project.inspectors
{
	import com.macro.gUI.core.IControl;
	
	import mx.controls.Menu;

	public interface IInspector
	{
		/**
		 * 获取控件的配置定义以保存
		 * @param control
		 * @return 
		 * 
		 */
		function getXML(control:IControl):XML;
		
		/**
		 * 从保存的配置定义中创建控件
		 * @param xml 为null时，创建一个默认控件
		 * @return 
		 * 
		 */
		function getControl(xml:XML = null):IControl;
		
		/**
		 * 获取弹出菜单
		 * @return 
		 * 
		 */
		function getMenu():Menu;
	}
}