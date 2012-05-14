package com.macro.gUI.editor.project
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import com.macro.gUI.editor.work.Workbench;


	/**
	 * 管理项目目录结构及配置。
	 * 一个项目的基本结构是：一个配置文件（config.xml）及三个目录（skins、assets、interfaces）。
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ProjectManager
	{
		public var mainWindow:gUIEditor;


		/**
		 * 皮肤配置
		 */
		public var skinConfig:SkinConfig;

		/**
		 * 样式配置
		 */
		public var styleConfig:StyleConfig;


		/**
		 * 皮肤目录
		 */
		public var skinsDirectory:File;

		/**
		 * 资源目录
		 */
		public var assetsDirectory:File;

		/**
		 * 界面目录
		 */
		public var interfacesDirectory:File;

		/**
		 * 配置文件
		 */
		public var configFile:File;

		/**
		 * 当前编辑的界面文件
		 */
		public var workFile:File;

		/**
		 * 工作台
		 */
		public var workbench:Workbench;


		public function ProjectManager()
		{
			skinConfig = new SkinConfig();
			styleConfig = new StyleConfig();
		}

		private static var _inst:ProjectManager;

		public static function get inst():ProjectManager
		{
			if (_inst == null)
			{
				_inst = new ProjectManager()
			}
			return _inst;
		}



		public function createProject(file:File):void
		{
			var configFile:File = file.resolvePath("config.xml");
			if (!configFile.exists)
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open(configFile, FileMode.WRITE);
				fileStream.writeUTFBytes("");
				fileStream.close();
			}

			var skinDirectory:File = file.resolvePath("skins");
			if (!skinDirectory.exists)
			{
				skinDirectory.createDirectory();
			}
			else if (!skinDirectory.isDirectory)
			{
				throw new Error("存在同名的文件，无法创建目录！");
			}

			var assetDirectory:File = file.resolvePath("assets");
			if (!assetDirectory.exists)
			{
				assetDirectory.createDirectory();
			}
			else if (!assetDirectory.isDirectory)
			{
				throw new Error("存在同名的文件，无法创建目录！");
			}

			var interfaceDirectory:File = file.resolvePath("interfaces");
			if (!interfaceDirectory.exists)
			{
				interfaceDirectory.createDirectory();
			}
			else if (!interfaceDirectory.isDirectory)
			{
				throw new Error("存在同名的文件，无法创建目录！");
			}

			setProject(configFile, skinDirectory, assetDirectory, interfaceDirectory);
		}

		public function openProject(file:File):Boolean
		{
			var configFile:File = file.resolvePath("config.xml");
			if (!configFile.exists)
			{
				return false;
			}

			var skinDirectory:File = file.resolvePath("skins");
			if (!(skinDirectory.exists && skinDirectory.isDirectory))
			{
				return false;
			}

			var assetDirectory:File = file.resolvePath("assets");
			if (!(assetDirectory.exists && assetDirectory.isDirectory))
			{
				return false;
			}

			var interfaceDirectory:File = file.resolvePath("interfaces");
			if (!(interfaceDirectory.exists && interfaceDirectory.isDirectory))
			{
				return false;
			}

			setProject(configFile, skinDirectory, assetDirectory, interfaceDirectory);
			return true;
		}

		private function setProject(configF:File, skinsD:File, assetsD:File, interfaceD:File):void
		{
			// 打开项目时，关闭旧工作文档
			workbench.close();
			workFile = null;
			
			configFile = configF;
			skinsDirectory = skinsD;
			assetsDirectory = assetsD;
			interfacesDirectory = interfaceD;

			readConfig();
			setStatusText();
			setTitleText();
			
			if (mainWindow.skinEditor != null)
				mainWindow.skinEditor.close();
			if (mainWindow.styleEditor != null)
				mainWindow.styleEditor.close();
			mainWindow.outlinePanel.reset();
			mainWindow.inspector.reset();
		}
		
		private function readConfig():void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(configFile, FileMode.READ);
			var configXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();

			skinConfig.configXML = configXML.hasOwnProperty("skins") ? configXML.skins[0] : null;
			styleConfig.configXML = configXML.hasOwnProperty("styles") ? configXML.styles[0] : null;
		}

		public function saveConfig():void
		{
			var config:XML = <config/>;
			config.appendChild(skinConfig.configXML);
			config.appendChild(styleConfig.configXML);
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += config.toXMLString();
			var fileStream:FileStream = new FileStream();
			fileStream.open(configFile, FileMode.WRITE);
			fileStream.writeUTFBytes(outputString);
			fileStream.close();
		}


		public function saveAppConfig():void
		{
			// 保存打开项目到工程配置文件以便下次自动打开
			var prefsXML:XML = <prefs><workUrl>{configFile.parent.nativePath}</workUrl></prefs>;
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += prefsXML.toXMLString();

			var appConfig:File = File.applicationStorageDirectory.resolvePath("appConfig.xml");
			var fileStream:FileStream = new FileStream();
			fileStream.open(appConfig, FileMode.WRITE);
			fileStream.writeUTFBytes(outputString);
			fileStream.close();
		}

		public function loadAppConfig():void
		{
			var appConfig:File = File.applicationStorageDirectory.resolvePath("appConfig.xml");
			if (appConfig.exists)
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open(appConfig, FileMode.READ);
				var prefsXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fileStream.close();

				openProject(new File(prefsXML.workUrl));
			}
			else
			{
				setStatusText();
			}
		}



		public function hasSameDoc(name:String):Boolean
		{
			if (name.substr(name.lastIndexOf(".")) != ".xml")
				name += ".xml";

			var file:File = interfacesDirectory.resolvePath(name);
			return file.exists;
		}

		public function createDoc(name:String, base:String):void
		{
			workbench.create(base);
			if (name.substr(name.lastIndexOf(".")) != ".xml")
				name += ".xml";
			workFile = interfacesDirectory.resolvePath(name);
			setTitleText();
		}

		public function openDoc(file:File):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var doc:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			workbench.setDocXML(doc);
			
			workFile = file;
			setTitleText();
		}

		public function saveDoc():void
		{
			var doc:XML = workbench.getDocXML();
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += doc.toXMLString();
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(workFile, FileMode.WRITE);
			fileStream.writeUTFBytes(outputString);
			fileStream.close();
		}

		public function saveAsDoc(name:String):void
		{
			if (name.substr(name.lastIndexOf(".")) != ".xml")
				name += ".xml";
			workFile = interfacesDirectory.resolvePath(name);
			setTitleText();
			saveDoc();
		}


		private function setStatusText():void
		{
			mainWindow.statusText.text = (configFile == null ? "没有打开的项目" : "工作目录：" + configFile.nativePath);
		}
		
		private function setTitleText():void
		{
			mainWindow.title = (workFile == null ? "gUI界面编辑器" : "gUI界面编辑器: " + workFile.name);
		}
	}
}
