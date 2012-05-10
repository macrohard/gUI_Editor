package com.macro.gUI.editor
{
	import com.macro.gUI.GameUI;
	
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;


	public class Workstation extends UIComponent
	{

		private var _guiRoot:Sprite;


		public function Workstation()
		{
			super();

			_guiRoot = new Sprite();
			addChild(_guiRoot);
			GameUI.init(_guiRoot);

			addEventListener(ResizeEvent.RESIZE, onResizeHandler);
			addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			addEventListener(DragEvent.DRAG_DROP, dragDropHandler);
		}

		protected function onResizeHandler(e:ResizeEvent):void
		{
			_guiRoot.graphics.clear();
			_guiRoot.graphics.beginFill(0x70b2ee);
			_guiRoot.graphics.drawRect(0, 0, e.target.width, e.target.height);
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
