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
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		protected function onMouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
			this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			e.stopImmediatePropagation();
		}
		
		protected function onMouseDownHandler(e:MouseEvent):void
		{
			this.startDrag();
			this.parent.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			e.stopImmediatePropagation();
		}
		
		protected function onMouseMoveHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CHANGE));
			e.stopImmediatePropagation();
		}
	}
}