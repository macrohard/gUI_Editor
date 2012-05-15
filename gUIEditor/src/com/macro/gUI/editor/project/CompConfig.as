package com.macro.gUI.editor.project
{
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.editor.project.inspectors.IInspector;
	
	import flash.utils.getDefinitionByName;

	public class CompConfig
	{
		private static const CONTAINER_QNAME:String = "com.macro.gUI.containers.";
		
		private static const CONTROL_QNAME:String = "com.macro.gUI.controls.";
		
		private static const COMPOSITE_QNAME:String = "com.macro.gUI.composite.";
		
		
		public static const configXML:XMLList =
			<>
				<category type="Controls">
					<item type="Label"/>
					<item type="LinkButton"/>
					<item type="Button"/>
					<item type="IconButton"/>
					<item type="ToggleButton"/>
					<item type="TextInput"/>
					<item type="ImageBox"/>
					<item type="ImageButton"/>
					<item type="Canvas"/>
					<item type="Slice"/>
					<item type="TitleBar"/>
				</category>
				<category type="Composites">
					<item type="CheckBox"/>
					<item type="RadioButton"/>
					<item type="ComboBox"/>
					<item type="List"/>
					<item type="TextArea"/>
					<item type="ProgressBar"/>
					<item type="HScrollBar"/>
					<item type="VScrollBar"/>
					<item type="HSlider"/>
					<item type="VSlider"/>
				</category>
				<category type="Containers">
					<item type="Container"/>
					<item type="Panel"/>
					<item type="ScrollPanel"/>
					<item type="BackgroundPanel"/>
					<item type="TabPanel"/>
					<item type="Window"/>
				</category>
			</>;
		
		
		public static function getInspector(name:String):IInspector
		{
			var clz:Class = getDefinitionByName("com.macro.gUI.editor.project.inspectors." + name + "Inspector") as Class;
			return new clz();
		}
		
		public static function getControl(type:String):IControl
		{
			var qname:String;
			if (configXML[0].item.(@type == type)[0] != null)
			{
				qname = CONTROL_QNAME + type;
			}
			else if (configXML[1].item.(@type == type)[0] != null)
			{
				qname = COMPOSITE_QNAME + type;
			}
			else if (configXML[2].item.(@type == type)[0] != null)
			{
				qname = CONTAINER_QNAME + type;
			}
			
			var clz:Class = getDefinitionByName(qname) as Class;
			return new clz();
		}
	}
}