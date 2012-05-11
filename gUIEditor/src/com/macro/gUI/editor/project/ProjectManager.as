package com.macro.gUI.editor.project
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;


	/**
	 * 管理项目目录结构及配置。
	 * 一个项目的基本结构是：一个配置文件（config.xml）及三个目录（skins、assets、interfaces）。
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ProjectManager
	{

		public var skinConfig:SkinConfig = new SkinConfig();

		public var styleConfig:StyleConfig = new StyleConfig();


		public var skinsDirectory:File;

		public var assetsDirectory:File;

		public var interfacesDirectory:File;
		
		
		private var _configFile:File;
		
		private var _workbench:Workbench;


		public function ProjectManager()
		{
		}

		private static var _inst:ProjectManager = new ProjectManager();

		public static function get inst():ProjectManager
		{
			return _inst;
		}

		/**
		 * 项目目录
		 * @return 
		 * 
		 */
		public function get folder():String
		{
			return _configFile ? _configFile.parent.nativePath : null;
		}
		
		
		/**
		 * 工作台
		 * @return 
		 * 
		 */
		public function get workbench():Workbench
		{
			if (_workbench == null)
			{
				_workbench = new Workbench();
				_workbench.x = 0;
				_workbench.y = 30;
				_workbench.percentWidth = 100;
				_workbench.percentHeight = 100;
			}
			return _workbench;
		}


		public function createProject(file:File):void
		{
			var configFile:File = file.resolvePath("config.xml");
			if (!configFile.exists)
			{
				createEmptyFile(configFile);
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
			_configFile = configF;
			skinsDirectory = skinsD;
			assetsDirectory = assetsD;
			interfacesDirectory = interfaceD;

			readConfig();
		}

		private function readConfig():void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(_configFile, FileMode.READ);
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
			fileStream.open(_configFile, FileMode.WRITE);
			fileStream.writeUTFBytes(outputString);
			fileStream.close();
		}


		public function saveAppConfig():void
		{
			// 保存打开项目到工程配置文件以便下次自动打开
			var prefsXML:XML = <prefs><workUrl>{_configFile.parent.nativePath}</workUrl></prefs>;
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
		}
		
		
		
		public function hasSameInterface(name:String):Boolean
		{
			if (name.substr(name.lastIndexOf(".")) != ".xml")
				name += ".xml";
			
			var file:File = interfacesDirectory.resolvePath(name);
			return file.exists;
		}
		
		public function createInterface(name:String, base:String):void
		{
			if (name.substr(name.lastIndexOf(".")) != ".xml")
				name += ".xml";
			var file:File = interfacesDirectory.resolvePath(name);
			
			createEmptyFile(file);
		}
		
		public function openInterface(file:File):void
		{
			// TODO 打开界面
		}
		
		public function saveInterface():void
		{
			// TODO 保存界面
		}
		
		public function saveAsInterface(name:String):void
		{
			if (name.substr(name.lastIndexOf(".")) != ".xml")
				name += ".xml";
			var file:File = interfacesDirectory.resolvePath(name);
			
			createEmptyFile(file);
		}
		
		
		private function createEmptyFile(file:File):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes("");
			fileStream.close();
		}
	}
}
