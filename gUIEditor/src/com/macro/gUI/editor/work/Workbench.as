package com.macro.gUI.editor.work
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.composite.*;
	import com.macro.gUI.containers.*;
	import com.macro.gUI.controls.*;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;


	public class Workbench extends UIComponent
	{
		private static const CONTAINER_QNAME:String = "com.macro.gUI.containers.";

		private static const CONTROL_QNAME:String = "com.macro.gUI.controls.";

		private static const COMPOSITE_QNAME:String = "com.macro.gUI.composite.";

		/**
		 * 当有修改时，标记文档未保存
		 */
		public var unsaved:Boolean;


		private var _displayObjectContainer:Sprite;

		private var _doc:IContainer;

		private var _stage:IContainer;

		private var _mouseControl:IControl;
		
		

		private var _tl:CPoint;

		private var _tr:CPoint;

		private var _bl:CPoint;

		private var _br:CPoint;
		
		private var _controlKey:Boolean;


		public function Workbench()
		{
			super();

			_displayObjectContainer = new Sprite();
			_displayObjectContainer.addEventListener(MouseEvent.CLICK, onClickHandler);
			addChild(_displayObjectContainer);
			GameUI.init(_displayObjectContainer);
			_stage = GameUI.uiManager.stage;

			_tl = new CPoint(0);
			_tl.addEventListener(Event.CHANGE, onTLChanged);
			_tr = new CPoint(1);
			_tr.addEventListener(Event.CHANGE, onTRChanged);
			_bl = new CPoint(2);
			_bl.addEventListener(Event.CHANGE, onBLChanged);
			_br = new CPoint(3);
			_br.addEventListener(Event.CHANGE, onBRChanged);

			addEventListener(ResizeEvent.RESIZE, onResizeHandler);
			addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			addEventListener(DragEvent.DRAG_DROP, dragDropHandler);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			// TEMP
			Button;
			Canvas;
			IconButton;
			ImageBox;
			ImageButton;
			Label;
			LinkButton;
			Slice;
			TextInput;
			TitleBar;
			ToggleButton;

			CheckBox;
			ComboBox;
			HScrollBar;
			HSlider;
			List;
			ProgressBar;
			RadioButton;
			TextArea;
			VScrollBar;
			VSlider;

			BackgroundPanel;
			Container;
			Panel;
			ScrollPanel;
			TabPanel;
			Window;
		}
		
		protected function onAddedToStage(event:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
		}
		
		protected function onKeyDownHandler(e:KeyboardEvent):void
		{
			_controlKey = e.controlKey;
		}
		
		protected function onKeyUpHandler(e:KeyboardEvent):void
		{
			_controlKey = e.controlKey;
		}
		
		protected function onBRChanged(e:Event):void
		{
			if (_controlKey)
			{
				_tl.x = _br.x - _mouseControl.width;
				_tl.y = _br.y - _mouseControl.height;
				
				_tr.x = _br.x;
				_tr.y = _tl.y;
				
				_bl.x = _tl.x;
				_bl.y = _br.y;
				
				moveControl();
				return;
			}
			
			if (_br.x <= _bl.x)
				return;
			
			if (_br.y <= _tr.y)
				return;
			
			_tr.x = _br.x;
			_bl.y = _br.y;
			resizeControl();
		}

		protected function onBLChanged(e:Event):void
		{
			if (_mouseControl == _doc)
			{
				_bl.x = _tl.x;
				_bl.y = _br.y;
				return;
			}
			
			if (_controlKey)
			{
				_tl.x = _bl.x;
				_tl.y = _bl.y - _mouseControl.height;
				
				_tr.x = _bl.x + _mouseControl.width;
				_tr.y = _tl.y;
				
				_br.x = _tr.x;
				_br.y = _bl.y;
				
				moveControl();
				return;
			}
			
			if (_bl.x >= _br.x)
				return;
			
			if (_bl.y <= _tl.y)
				return;
			
			_tl.x = _bl.x;
			_br.y = _bl.y;
			moveControl();
			resizeControl();
		}

		protected function onTRChanged(e:Event):void
		{
			if (_mouseControl == _doc)
			{
				_tr.x = _br.x;
				_tr.y = _tl.y;
				return;
			}
			
			if (_controlKey)
			{
				_tl.x = _tr.x - _mouseControl.width;
				_tl.y = _tr.y;
				
				_bl.x = _tl.x;
				_bl.y = _tr.y + _mouseControl.height;
				
				_br.x = _tr.x;
				_br.y = _bl.y;
				
				moveControl();
				return;
			}
			
			if (_tr.x <= _tl.x)
				return;
			
			if (_tr.y >= _br.y)
				return;
			
			_br.x = _tr.x;
			_tl.y = _tr.y;
			moveControl();
			resizeControl();
		}

		protected function onTLChanged(e:Event):void
		{
			if (_mouseControl == _doc)
			{
				_tl.x = _bl.x;
				_tl.y = _tr.y;
				return;
			}
			
			if (_controlKey)
			{
				_tr.x = _tl.x + _mouseControl.width;
				_tr.y = _tl.y;
				
				_bl.x = _tl.x;
				_bl.y = _tl.y + _mouseControl.height;
				
				_br.x = _tr.x;
				_br.y = _bl.y;
				
				moveControl();
				return;
			}
			
			if (_tl.x >= _tr.x)
				return;
			
			if (_tl.y >= _bl.y)
				return;
			
			_bl.x = _tl.x;
			_tr.y = _tl.y;
			moveControl();
			resizeControl();
		}
		
		private function resizeControl():void
		{
			_mouseControl.resize(_br.x - _bl.x, _br.y - _tr.y);
		}
		
		private function moveControl():void
		{
			var p:Point = _mouseControl.parent.globalToLocal(new Point(_tl.x, _tl.y));
			_mouseControl.x = p.x;
			_mouseControl.y = p.y;
		}
		

		protected function onResizeHandler(e:ResizeEvent):void
		{
			_displayObjectContainer.graphics.clear();
			_displayObjectContainer.graphics.beginFill(0x70b2ee);
			_displayObjectContainer.graphics.drawRect(0, 0, e.target.width, e.target.height);
			
			GameUI.uiManager.resizeStage(e.target.width, e.target.height);
		}

		protected function onClickHandler(e:MouseEvent):void
		{
			_mouseControl = GameUI.uiManager.interactiveManager.mouseControl;
			if (_mouseControl == null)
			{
				if (_tl.parent == this)
					this.removeChild(_tl);
				if (_tr.parent == this)
					this.removeChild(_tr);
				if (_bl.parent == this)
					this.removeChild(_bl);
				if (_br.parent == this)
					this.removeChild(_br);
			}
			else
			{
				var p:Point = _mouseControl.localToGlobal();
				_tl.x = p.x;
				_tl.y = p.y;

				_tr.x = p.x + _mouseControl.width;
				_tr.y = p.y;

				_bl.x = p.x;
				_bl.y = p.y + _mouseControl.height;

				_br.x = _tr.x;
				_br.y = _bl.y;

				this.addChild(_tl);
				this.addChild(_tr);
				this.addChild(_bl);
				this.addChild(_br);
			}
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


		/**
		 * 关闭
		 *
		 */
		public function close():void
		{
			if (_doc != null)
			{
				_stage.removeChild(_doc);
			}
			unsaved = false;
		}

		/**
		 * 创建
		 * @param base
		 *
		 */
		public function create(base:String):void
		{
			_doc = getControl(CONTAINER_QNAME + base) as IContainer;
			if (_doc == null)
				return;

			_stage.addChild(_doc);
			unsaved = true;
		}

		/**
		 * 加载
		 * @param doc
		 *
		 */
		public function setDocXML(doc:XML):void
		{

		}

		/**
		 * 解析
		 * @return
		 *
		 */
		public function getDocXML():XML
		{
			unsaved = false;
			return null;
		}


		private function getControl(qname:String):IControl
		{
			var clz:Class = getDefinitionByName(qname) as Class;
			return new clz();
		}
	}
}
