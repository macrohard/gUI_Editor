package com.macro.gUI.editor.work
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CPoint extends Sprite
	{
		public function CPoint(type:int)
		{
			this.useHandCursor = true;
			this.buttonMode = true;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.lineStyle(2, 0xff0000);
			if (type == 0)
				this.graphics.drawRect(0, 0, 8, 8);
			else if (type == 1)
				this.graphics.drawRect(-8, 0, 8, 8);
			else if (type == 2)
				this.graphics.drawRect(0, -8, 8, 8);
			else if (type == 3)
				this.graphics.drawRect(-8, -8, 8, 8);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		protected function onRemovedFromStage(event:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		
		protected function onMouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			e.stopPropagation();
		}
		
		protected function onMouseDownHandler(e:MouseEvent):void
		{
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			e.stopPropagation();
		}
		
		protected function onMouseMoveHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CHANGE));
			e.stopPropagation();
		}
	}
}