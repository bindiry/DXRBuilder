package 
{
	
	import flash.display.MovieClip;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	import org.flexlite.domDisplay.codec.DxrEncoder;
	import org.flexlite.domUtils.DomLoader;
	import org.flexlite.domUtils.FileUtil;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.core.SpriteVisualElement;
	
	/**
	 * 让用户选择文件
	 * @author Bindiry
	 */
	public class FileHandler
	{
		[Embed(source="DXRBuilderBgWorker.swf", mimeType="application/octet-stream")]
		private static var BgWorker_ByteClass:Class;

		/** 单例对象实例 */
		protected static var _instance:FileHandler;
		
		private var _btnSelectFiles:Button;
		private var _listFiles:List;
		private var _filesArrayList:ArrayList;
		
		private var _loadFileList:Array;
		private var _currentLoadFileIndex:int;
		
		private var _bgWorker:Worker;
		private var _bgWorkerCommandChannel:MessageChannel;
		private var _resultChannel:MessageChannel;
		
		private var _exportCompleted:Function;
		
		public function FileHandler()
		{			
			if (_instance != null)
				throw new Error("实例只能有一个");
		}
		
		/** 获取单例实例 */
		public static function getInstance():FileHandler
		{
			if (_instance == null)
				_instance = new FileHandler();
			
			return _instance;
		}
		
		/** 初始化 */
		public function initialize(pSelectFilesButton:Button, pLoadList:List):void
		{
			_btnSelectFiles = pSelectFilesButton;
			_listFiles = pLoadList;
			_listFiles.labelField = "field";
			_filesArrayList = new ArrayList();
			
//			registerClassAlias("Result", Result);
//			
//			_bgWorker = WorkerDomain.current.createWorker(BgWorker);
//			_bgWorkerCommandChannel = Worker.current.createMessageChannel(_bgWorker);
//			_bgWorker.setSharedProperty("incomingCommandChannel", _bgWorkerCommandChannel);
//			
//			_resultChannel = _bgWorker.createMessageChannel(Worker.current);
//			_resultChannel.addEventListener(Event.CHANNEL_MESSAGE, resultMessageHandler);
//			_bgWorker.setSharedProperty("resultChannel", _resultChannel);
//			
//			_bgWorker.addEventListener(Event.WORKER_STATE, bgWorkerStateChange);
		}
		
//		public static function get BgWorker():ByteArray
//		{
//			return new BgWorker_ByteClass();
//		}
		
//		protected function bgWorkerStateChange(e:Event):void
//		{
//			if (_bgWorker.state == WorkerState.RUNNING)
//			{
//				// 开始向后端Worker发送请求
//				trace("开始向后端Worker发送请求");
//				var len:int = _filesArrayList.source.length;
//				for each (var obj:Object in _filesArrayList.source)
//				{
//					_bgWorkerCommandChannel.send(["get_byte_array", obj.name, obj.mclist, obj.keylist, obj.formatlist]);
//				}
//			}
//		}
		
		/** 后台worker返回生成好的文件数据 */
//		protected function resultMessageHandler(e:Event):void
//		{
//			// 接收数据
//			var receiveResult:Result = _resultChannel.receive() as Result;
//			// 写入文件
//			var fileInfo:Object = getFileInfoFromListByName(receiveResult.name);
//			var len:int = fileInfo.mclist.length;
//			var path:String;
//			var successCount:int = 0;
//			var failCount:int = 0;
//			
//			if (Global.sameAsSource)
//				path = fileInfo.path.substring(0, fileInfo.path.lastIndexOf(".")) + ".dxr";
//			else
//				path = Global.exportPath + "\\" + fileInfo.name.substring(0, fileInfo.name.lastIndexOf(".")) + ".dxr";
//			
//			var result:Boolean = FileUtil.save(path, receiveResult.result);
//			if (result)
//				successCount++;
//			else
//				failCount++;
//			
//			removeItemFromListByName(receiveResult.name);
//			_listFiles.dataProvider = _filesArrayList;
//			
//			if (_filesArrayList.length <= 0)
//			{
//				Alert.show("转换完成，成功: {0}，失败: {1}"
//					.replace("{0}", successCount)
//					.replace("{1}", failCount)
//				);
//				successCount = 0;
//				failCount = 0;
//				if (_exportCompleted != null)
//				{
//					_exportCompleted();
//					_exportCompleted = null;
//				}
//			}
//		}
		
		private function removeItemFromListByName(pName:String):void
		{
			var len:int = _filesArrayList.source.length;
			for (var i:int = 0; i < len; i++)
			{
				if ((_filesArrayList.getItemAt(i) as Object).name == pName)
				{
					_filesArrayList.removeItemAt(i);
					break;
				}
			}
		}
		
		/**
		 * 根据文件名，从列表里查找文件信息 
		 * @param pName 文件名
		 */
		private function getFileInfoFromListByName(pName:String):Object
		{
			var result:Object;
			for each (var obj:Object in _filesArrayList.source)
			{
				if (obj.name == pName)
				{
					result = obj;
					break;
				}
			}
			return result;
		}

		/** 选择文件 */
		public function selectFiles():void
		{
			var file:File = new File();
			file.browseForOpenMultiple("选择需要导入的Swf文件", [new FileFilter("Swf文件", "*.swf")]);
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, onSelected);
		}
		
		/** 文件选择后的处理 */
		protected function onSelected(e:FileListEvent):void
		{
			_btnSelectFiles.enabled = false;
			_loadFileList = e.files;
			_currentLoadFileIndex = 0;
			loadFiles();
		}
		
		/** 拖拽文件到窗口中 */
		public function onDrop(pFiles:Array):void
		{
			_btnSelectFiles.enabled = false;
			_loadFileList = pFiles;
			_currentLoadFileIndex = 0;
			loadFiles();
		}
		
		public function updateFormatList():void
		{
			var len:int;
			for each (var obj:Object in _filesArrayList.source)
			{
				len = obj.formatlist.length;
				for (var i:int = 0; i < len; i++)
				{
					obj.formatlist[i] = Global.currentFormat;
				}
			}
			trace("1");
		}
		
		/** 开始读取文件 */
		private function loadFiles():void
		{
			if (_currentLoadFileIndex >= _loadFileList.length)
			{
				_listFiles.dataProvider = _filesArrayList;
				_btnSelectFiles.enabled = true;
			}
			else
			{
				var file:File = _loadFileList[_currentLoadFileIndex];
				if (!checkFileIsExist(file))
				{
					if (file.type.substring(1,file.type.length).toLowerCase() == "swf")
					{
						DomLoader.loadExternalClasses(file.nativePath, function(clslist:Array, keylist:Array):void {
							var mclist:Array = [];
							var formatList:Array = [];
							var mc:MovieClip;
							for each (var cls:Class in clslist)
							{
								mc = new cls();
								mc.gotoAndStop(1);
								mclist.push(mc);
								formatList.push(Global.currentFormat);
							}
							var extString:String = keylist.length > 0 ? " (" + keylist.length + "个导出元件)" : " (未找到可导出元件)";
							var field:String = file.name + extString;
							var obj:Object = {field: field, name: file.name, path: file.nativePath, mclist: mclist, keylist: keylist, formatlist: formatList};
							_filesArrayList.addItem(obj);
						});
					}
					_currentLoadFileIndex++;
					loadFiles();
				}
			}
		}
		
		/** 开始导出文件 */
		public function exportFiles(pContainer:SpriteVisualElement, pOnCompleted:Function):void
		{
			_exportCompleted = pOnCompleted;
			// 启动后台处理
//			_bgWorker.start();
			var dxrEncode:DxrEncoder = new DxrEncoder();
			var path:String;
			var successCount:int = 0;
			var failCount:int = 0;
			var i:int = _filesArrayList.length - 1;
			while (i > -1)
			{
				var obj:Object = _filesArrayList.getItemAt(i);
				if (Global.sameAsSource)
					path = obj.path.substring(0, obj.path.lastIndexOf(".")) + ".dxr";
				else
					path = Global.exportPath + "\\" + obj.name.substring(0, obj.name.lastIndexOf(".")) + ".dxr";
				
				// 将所有mc加到显示列表，防止air版movieclip的bug而出现重影
				// 参考：http://blog.domlib.com/articles/353.html
				for each (var mc:MovieClip in obj.mclist)
				{
					pContainer.addChild(mc);
				}
				if (obj.keylist.length > 0)
				{
					var dxrData:ByteArray = dxrEncode.encode(obj.mclist, obj.keylist, obj.formatlist);
					var result:Boolean = FileUtil.save(path, dxrData);
				}
				else
				{
					result = false;
				}
				
				if (result)
					successCount++;
				else
					failCount++;
				
				removeItemFromListByName(obj.name);
				_listFiles.dataProvider = _filesArrayList;
				
				// 把转换完的MC从显示列表移除
				removeAllChild(pContainer);
				i--;
			}
			
			Alert.show("转换完成，成功: {0}，失败: {1}"
				.replace("{0}", successCount)
				.replace("{1}", failCount)
			);
			successCount = 0;
			failCount = 0;
			if (_exportCompleted != null)
			{
				_exportCompleted();
				_exportCompleted = null;
			}
		}
		
		private function removeAllChild(pContainer:SpriteVisualElement):void
		{
			while(pContainer.numChildren > 0)
			{
				pContainer.removeChildAt(0);
			}
		}
		
		/** 检查是否有重复文件 */
		private function checkFileIsExist(pFile:File):Boolean
		{
			var result:Boolean = false;
			for each (var obj:Object in _filesArrayList.source)
			{
				if (obj.path == pFile.nativePath)
				{
					result = true;
					break;
				}
			}
			return result;
		}

		public function get bgWorker():Worker
		{
			return _bgWorker;
		}

		public function set bgWorker(value:Worker):void
		{
			_bgWorker = value;
		}

	}
}