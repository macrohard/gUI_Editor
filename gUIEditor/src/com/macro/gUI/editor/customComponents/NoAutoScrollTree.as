package com.macro.gUI.editor.customComponents
{
	import mx.controls.Tree;
	
	public class NoAutoScrollTree extends Tree
	{
		public function NoAutoScrollTree()
		{
			super();
		}
		
		override protected function dragScroll():void
		{
		}
	}
}