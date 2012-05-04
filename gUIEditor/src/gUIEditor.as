import com.macro.gUI.editor.ComponentsPanel;
import com.macro.gUI.editor.Inspector;
import com.macro.gUI.editor.skin.SkinEditor;
import com.macro.gUI.editor.style.StyleEditor;
import com.macro.gUI.editor.TreePanel;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;

import mx.collections.*;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.events.ResizeEvent;
import mx.managers.PopUpManager;

public var gUIRoot:Sprite;

private var _uiContainer:UIComponent;

private var _skinEditor:SkinEditor;

private var _styleEditor:StyleEditor;

private var _componentsPanel:ComponentsPanel;

private var _treePanel:TreePanel;

private var _inspector:Inspector;


protected function menuItemClickHandler(e:MenuEvent):void
{
	var key:String = e.item.@data;
	switch (key)
	{
		case "new":
		{
			break;
		}
		case "open":
		{
			break;
		}
		case "save":
		{
			break;
		}
		case "saveAs":
		{
			break;
		}
		case "createProject":
		{
			break;
		}
		case "openProject":
		{
			break;
		}
		case "exportActionScript":
		{
			break;
		}
		case "exportSkinStyle":
		{
			break;
		}
		case "exportResource":
		{
			break;
		}
		case "exit":
		{
			this.exit();
			break;
		}
		case "component":
		{
			PopUpManager.addPopUp(_componentsPanel, this);
			break;
		}
		case "tree":
		{
			PopUpManager.addPopUp(_treePanel, this);
			break;
		}
		case "properties":
		{
			PopUpManager.addPopUp(_inspector, this);
			break;
		}
		case "skins":
		{
			if (_skinEditor == null || _skinEditor.closed)
			{
				_skinEditor = new SkinEditor();
				_skinEditor.open();
			}
			_skinEditor.orderToFront();
			break;
		}
		case "styles":
		{
			if (_styleEditor == null || _styleEditor.closed)
			{
				_styleEditor = new StyleEditor();
				_styleEditor.open();
			}
			_styleEditor.orderToFront();
			break;
		}
		case "resources":
		{
			break;
		}
		case "layout":
		{
			resetPanelLayout();
			break;
		}
		case "help":
		{
			break;
		}
	}
}


protected function creationCompleteHandler(e:FlexEvent):void
{
	_uiContainer = new UIComponent();
	_uiContainer.x = 0;
	_uiContainer.y = 30;
	_uiContainer.percentWidth = 100;
	_uiContainer.percentHeight = 100;

	gUIRoot = new Sprite();
	_uiContainer.addChild(gUIRoot);

	_uiContainer.addEventListener(ResizeEvent.RESIZE, onResizeHandler);
	this.addElement(_uiContainer);

	resetPanelLayout();
	
	var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
	var ns:Namespace = appXml.namespace();
	var ver:String = "版本号：" + appXml.ns::versionNumber;
	menuDefines[2].appendChild(<menuitem label={ver}/>);
}


private function resetPanelLayout():void
{
	var t:int = 40;
	var b:int = 40;
	var gap:int = 10;
	var w:int = 300;
	var h:int = 150;

	// 总高度 - 顶部留空 - 底部留空 - 间距
	var ph:int = (this.height - t - b - gap) >> 1;

	// 组件面板
	if (_componentsPanel == null)
		_componentsPanel = new ComponentsPanel();
	_componentsPanel.width = w;
	_componentsPanel.height = ph;
	_componentsPanel.x = this.width - _componentsPanel.width - gap;
	_componentsPanel.y = t;
	PopUpManager.addPopUp(_componentsPanel, this);

	// 大纲面板
	if (_treePanel == null)
		_treePanel = new TreePanel();
	_treePanel.width = w;
	_treePanel.height = ph;
	_treePanel.x = _componentsPanel.x;
	_treePanel.y = _componentsPanel.y + _componentsPanel.height + gap;
	PopUpManager.addPopUp(_treePanel, this);

	// 初始化属性面板
	if (_inspector == null)
		_inspector = new Inspector();
	_inspector.width = _componentsPanel.x - gap * 2;
	_inspector.height = h;
	_inspector.x = gap;
	_inspector.y = this.height - _inspector.height - b;
	PopUpManager.addPopUp(_inspector, this);
}


protected function onResizeHandler(e:ResizeEvent):void
{
	gUIRoot.graphics.clear();
	gUIRoot.graphics.beginFill(0x70b2ee);
	gUIRoot.graphics.drawRect(0, 0, e.target.width, e.target.height);
}


protected function closeWindowHandler(e:Event):void
{
	//				e.preventDefault();
}
