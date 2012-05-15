package com.macro.gUI.editor.work
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.composite.*;
	import com.macro.gUI.containers.*;
	import com.macro.gUI.controls.*;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.editor.project.inspectors.BackgroundPanelInspector;
	import com.macro.gUI.editor.project.inspectors.ButtonInspector;
	import com.macro.gUI.editor.project.inspectors.CanvasInspector;
	import com.macro.gUI.editor.project.inspectors.CheckBoxInspector;
	import com.macro.gUI.editor.project.inspectors.ComboBoxInspector;
	import com.macro.gUI.editor.project.inspectors.ContainerInspector;
	import com.macro.gUI.editor.project.inspectors.HScrollBarInspector;
	import com.macro.gUI.editor.project.inspectors.HSliderInspector;
	import com.macro.gUI.editor.project.inspectors.IInspector;
	import com.macro.gUI.editor.project.inspectors.IconButtonInspector;
	import com.macro.gUI.editor.project.inspectors.ImageBoxInspector;
	import com.macro.gUI.editor.project.inspectors.ImageButtonInspector;
	import com.macro.gUI.editor.project.inspectors.LabelInspector;
	import com.macro.gUI.editor.project.inspectors.LinkButtonInspector;
	import com.macro.gUI.editor.project.inspectors.ListInspector;
	import com.macro.gUI.editor.project.inspectors.PanelInspector;
	import com.macro.gUI.editor.project.inspectors.ProgressBarInspector;
	import com.macro.gUI.editor.project.inspectors.RadioButtonInspector;
	import com.macro.gUI.editor.project.inspectors.ScrollPanelInspector;
	import com.macro.gUI.editor.project.inspectors.SliceInspector;
	import com.macro.gUI.editor.project.inspectors.TabPanelInspector;
	import com.macro.gUI.editor.project.inspectors.TextAreaInspector;
	import com.macro.gUI.editor.project.inspectors.TextInputInspector;
	import com.macro.gUI.editor.project.inspectors.TitleBarInspector;
	import com.macro.gUI.editor.project.inspectors.ToggleButtonInspector;
	import com.macro.gUI.editor.project.inspectors.VScrollBarInspector;
	import com.macro.gUI.editor.project.inspectors.VSliderInspector;
	import com.macro.gUI.editor.project.inspectors.WindowInspector;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
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

		/**
		 * 界面文档容器
		 */
		public var docContainer:IContainer;
		
		/**
		 * 当前选择的控件
		 */
		public var selectedControl:IControl;
		
		
		private var _displayObjectContainer:Sprite;

		private var _cgroup:CGoup;

		private var _inspectors:Dictionary;


		public function Workbench()
		{
			super();

			_displayObjectContainer = new Sprite();
			_displayObjectContainer.addEventListener(MouseEvent.CLICK, onClickHandler);
			addChild(_displayObjectContainer);
			GameUI.init(_displayObjectContainer);
			
			_cgroup = new CGoup(this);
			addChild(_cgroup);
			

			addEventListener(ResizeEvent.RESIZE, onResizeHandler);
			addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			addEventListener(DragEvent.DRAG_DROP, dragDropHandler);
			
			

			// 初始化控件监视器
			_inspectors = new Dictionary();
			_inspectors["Label"] = new LabelInspector();
			_inspectors["LinkButton"] = new LinkButtonInspector();
			_inspectors["Button"] = new ButtonInspector();
			_inspectors["IconButton"] = new IconButtonInspector();
			_inspectors["ToggleButton"] = new ToggleButtonInspector();
			_inspectors["TextInput"] = new TextInputInspector();
			_inspectors["ImageBox"] = new ImageBoxInspector();
			_inspectors["ImageButton"] = new ImageButtonInspector();
			_inspectors["Canvas"] = new CanvasInspector();
			_inspectors["Slice"] = new SliceInspector();
			_inspectors["TitleBar"] = new TitleBarInspector();
			
			_inspectors["CheckBox"] = new CheckBoxInspector();
			_inspectors["RadioButton"] = new RadioButtonInspector();
			_inspectors["ComboBox"] = new ComboBoxInspector();
			_inspectors["List"] = new ListInspector();
			_inspectors["TextArea"] = new TextAreaInspector();
			_inspectors["ProgressBar"] = new ProgressBarInspector();
			_inspectors["HScrollBar"] = new HScrollBarInspector();
			_inspectors["VScrollBar"] = new VScrollBarInspector();
			_inspectors["HSlider"] = new HSliderInspector();
			_inspectors["VSlider"] = new VSliderInspector();
			
			_inspectors["Container"] = new ContainerInspector();
			_inspectors["Panel"] = new PanelInspector();
			_inspectors["ScrollPanel"] = new ScrollPanelInspector();
			_inspectors["BackgroundPanel"] = new BackgroundPanelInspector();
			_inspectors["TabPanel"] = new TabPanelInspector();
			_inspectors["Window"] = new WindowInspector();
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
			selectedControl = GameUI.uiManager.interactiveManager.mouseControl;
			_cgroup.select();
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
			if (docContainer == null)
				return;
			
			var xx:int = _displayObjectContainer.mouseX;
			var yy:int = _displayObjectContainer.mouseY;
			
			if (xx > docContainer.width || yy > docContainer.height)
				return;
			
			var ic:IControl = getInspector(e.dragSource.dataForFormat("component") as String).getControl();
			
			var ret:Vector.<IControl> = GameUI.uiManager.interactiveManager.findTargetControl(docContainer, _displayObjectContainer.mouseX, _displayObjectContainer.mouseY);
			if (ret == null)
			{
				ic.x = xx - docContainer.margin.left;
				ic.y = yy - docContainer.margin.top;
				docContainer.addChild(ic);
			}
			else
			{
				var t:IControl = ret[0];
				var c:IContainer = (t is IContainer ? t as IContainer : t.parent);
				var p:Point = c.globalToLocal(new Point(xx, yy));
				ic.x = p.x - c.margin.left;
				ic.y = p.y - c.margin.top;
				c.addChild(ic);
			}
		}
		
		
		private function getInspector(name:String):IInspector
		{
			return _inspectors[name];
		}
		
		


		/**
		 * 关闭
		 *
		 */
		public function close():void
		{
			if (docContainer == null)
				return;
			
			GameUI.uiManager.stage.removeChild(docContainer);
			docContainer = null;
			unsaved = false;
		}

		/**
		 * 创建
		 * @param base
		 *
		 */
		public function create(base:String):void
		{
			docContainer = getInspector(base).getControl() as IContainer;
			if (docContainer == null)
				return;

			GameUI.uiManager.stage.addChild(docContainer);
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
