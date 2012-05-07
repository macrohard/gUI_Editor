package com.macro.gUI.editor.project
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;


	/**
	 * 管理项目目录结构及配置。
	 * 一个项目的基本结构是：一个配置文件（config.xml）及三个目录（skins、assets、interfaces）。
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ProjectManager
	{

		private var _skinConfig:SkinConfiguration = new SkinConfiguration();
		
		private var _styleConfig:StyleConfiguration = new StyleConfiguration();

		private var _skinsDirectory:File;

		private var _assetsDirectory:File;

		private var _interfacesDirectory:File;
		
		
		public function ProjectManager()
		{
		}
		
		public function get workUrl():String
		{
			if (_skinsDirectory)
				return _skinsDirectory.parent.nativePath;
			
			return null;
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
			_skinsDirectory = skinsD;
			_assetsDirectory = assetsD;
			_interfacesDirectory = interfaceD;
			
			var fileStream:FileStream = new FileStream(); 
			// 读取配置
			fileStream.open(configF, FileMode.READ); 
			var configXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable)); 
			fileStream.close();
			
			_skinConfig.setConfig(configXML.hasOwnProperty("skins") ? configXML.skins : null);
			_styleConfig.setConfig(configXML.hasOwnProperty("styles") ? configXML.styles : null);
			
			// 保存打开项目到工程配置文件以便下次自动打开
			var prefsXML:XML = <prefs><workUrl>{configF.parent.nativePath}</workUrl></prefs>; 
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n'; 
			outputString += prefsXML.toXMLString(); 
			
			var appConfig:File = File.applicationStorageDirectory.resolvePath("appConfig.xml");
			fileStream.open(appConfig, FileMode.WRITE);
			fileStream.writeUTFBytes(outputString); 
			fileStream.close(); 
		}
		
		public function loadConfig():void
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

		public function clearProjectResources():void
		{
			// TODO 清理项目冗余资源文件，后期功能
		}
	}
}
