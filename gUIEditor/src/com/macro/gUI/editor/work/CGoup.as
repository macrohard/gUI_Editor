package com.macro.gUI.editor.work
{
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class CGoup extends Sprite
	{
		private var _tl:CPoint;
		
		private var _tr:CPoint;
		
		private var _bl:CPoint;
		
		private var _br:CPoint;
		
		private var _workbench:Workbench;
		
		private var _offsetP:Point;
		
		
		public function CGoup(workbench:Workbench)
		{
			_workbench = workbench;
			this.buttonMode = true;
			this.useHandCursor = true;
			
			_tl = new CPoint(0);
			_tl.addEventListener(Event.CHANGE, onTLChanged);
			_tr = new CPoint(1);
			_tr.addEventListener(Event.CHANGE, onTRChanged);
			_bl = new CPoint(2);
			_bl.addEventListener(Event.CHANGE, onBLChanged);
			_br = new CPoint(3);
			_br.addEventListener(Event.CHANGE, onBRChanged);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(e:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		protected function keyDownHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ESCAPE)
			{
				_workbench.selectedControl = null;
				select();
			}
		}
		
		protected function mouseDownHandler(e:MouseEvent):void
		{
			_offsetP = new Point(_workbench.mouseX - _tl.x, _workbench.mouseY - _tl.y);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		protected function mouseUpHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		protected function mouseMoveHandler(e:MouseEvent):void
		{
			if (_workbench.selectedControl == null || _workbench.selectedControl == _workbench.docContainer)
				return;
			
			_tl.x = _workbench.mouseX - _offsetP.x;
			_tl.y = _workbench.mouseY - _offsetP.y;
			_tr.x = _tl.x + _workbench.selectedControl.width;
			_tr.y = _tl.y;
			_bl.x = _tl.x;
			_bl.y = _tl.y + _workbench.selectedControl.height;
			_br.x = _tr.x;
			_br.y = _bl.y;
			moveControl();
			drawSelectBox();
		}
		
		protected function onBRChanged(e:Event):void
		{
			if (_br.x <= _bl.x)
				return;
			
			if (_br.y <= _tr.y)
				return;
			
			_tr.x = _br.x;
			_bl.y = _br.y;
			resizeControl();
			drawSelectBox();
		}
		
		protected function onBLChanged(e:Event):void
		{
			if (_bl.x >= _br.x)
				return;
			
			if (_bl.y <= _tl.y)
				return;
			
			if (_workbench.selectedControl != _workbench.docContainer)
			{
				_tl.x = _bl.x;
				_br.y = _bl.y;
				moveControl();
			}
			else
			{
				_bl.x = _tl.x;
				_br.y = _bl.y;
			}
			resizeControl();
			drawSelectBox();
		}
		
		protected function onTRChanged(e:Event):void
		{
			if (_tr.x <= _tl.x)
				return;
			
			if (_tr.y >= _br.y)
				return;
			
			if (_workbench.selectedControl != _workbench.docContainer)
			{
				_br.x = _tr.x;
				_tl.y = _tr.y;
				moveControl();
			}
			else
			{
				_br.x = _tr.x;
				_tr.y = _tl.y;
			}
			resizeControl();
			drawSelectBox();
		}
		
		protected function onTLChanged(e:Event):void
		{
			if (_tl.x >= _tr.x)
				return;
			
			if (_tl.y >= _bl.y)
				return;
			
			if (_workbench.selectedControl != _workbench.docContainer)
			{
				_bl.x = _tl.x;
				_tr.y = _tl.y;
				moveControl();
			}
			else
			{
				_tl.x = _bl.x;
				_tl.y = _tr.y;
			}
			resizeControl();
			drawSelectBox();
		}
		
		private function resizeControl():void
		{
			_workbench.selectedControl.resize(_br.x - _bl.x, _br.y - _tr.y);
		}
		
		private function moveControl():void
		{
			var p:Point = _workbench.selectedControl.parent.globalToLocal(new Point(_tl.x, _tl.y));
			_workbench.selectedControl.x = p.x - _workbench.selectedControl.parent.margin.left;
			_workbench.selectedControl.y = p.y - _workbench.selectedControl.parent.margin.top;
		}
		
		private function drawSelectBox():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0, 0.3);
			this.graphics.drawRect(_tl.x, _tl.y, _br.x - _bl.x, _br.y - _tr.y);
		}
		
		
		/**
		 * 选择控件
		 * @param control
		 * 
		 */
		public function select():void
		{
			if (_workbench.selectedControl == null)
			{
				if (_tl.parent == this)
					this.removeChild(_tl);
				if (_tr.parent == this)
					this.removeChild(_tr);
				if (_bl.parent == this)
					this.removeChild(_bl);
				if (_br.parent == this)
					this.removeChild(_br);
				
				this.graphics.clear();
			}
			else
			{
				var p:Point = _workbench.selectedControl.localToGlobal();
				_tl.x = p.x;
				_tl.y = p.y;
				
				_tr.x = p.x + _workbench.selectedControl.width;
				_tr.y = p.y;
				
				_bl.x = p.x;
				_bl.y = p.y + _workbench.selectedControl.height;
				
				_br.x = _tr.x;
				_br.y = _bl.y;
				
				this.addChild(_tl);
				this.addChild(_tr);
				this.addChild(_bl);
				this.addChild(_br);
				
				drawSelectBox();
			}
		}
	}
}