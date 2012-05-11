package com.macro.gUI.editor.project
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.core.IContainer;
	
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;


	public class Workbench extends UIComponent
	{
		/**
		 * 当有修改时，标记文档未保存
		 */
		public var unsaved:Boolean;
		

		private var _displayObjectContainer:Sprite;
		
		private var _doc:IContainer;
		
		private var _stage:IContainer;
		

		public function Workbench()
		{
			super();

			_displayObjectContainer = new Sprite();
			addChild(_displayObjectContainer);
			GameUI.init(_displayObjectContainer);
			_stage = GameUI.uiManager.stage;

			addEventListener(ResizeEvent.RESIZE, onResizeHandler);
			addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			addEventListener(DragEvent.DRAG_DROP, dragDropHandler);
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
			var clz:Class = getDefinitionByName("com.macro.gUI.containers." + base) as Class;
			_doc = new clz();
			
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
	}
}
