package com.macro.gUI.editor.project
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.core.IContainer;
	
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;


	public class Workbench extends UIComponent
	{

		private var _displayObjectContainer:Sprite;
		

		public function Workbench()
		{
			super();

			_displayObjectContainer = new Sprite();
			addChild(_displayObjectContainer);
			GameUI.init(_displayObjectContainer);

			addEventListener(ResizeEvent.RESIZE, onResizeHandler);
			addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			addEventListener(DragEvent.DRAG_DROP, dragDropHandler);
		}
		
		
		private var _doc:IContainer;
		
		public function get doc():IContainer
		{
			return _doc;
		}
		

		protected function onResizeHandler(e:ResizeEvent):void
		{
			_displayObjectContainer.graphics.clear();
			_displayObjectContainer.graphics.beginFill(0x70b2ee);
			_displayObjectContainer.graphics.drawRect(0, 0, e.target.width, e.target.height);
		}

		private function dragEnterHandler(e:DragEvent):void
		{
			if (e.dragSource.hasFormat("component"))
			{
				DragManager.acceptDragDrop(this);
			}
		}

		private function dragDropHandler(e:DragEvent):void
		{
		}
	}
}
