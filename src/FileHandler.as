package 
{
	import flash.display.MovieClip;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	import org.flexlite.domDisplay.codec.DxrEncoder;
	import org.flexlite.domUtils.DomLoader;
	import org.flexlite.domUtils.FileUtil;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.core.SpriteVisualElement;
	
	/**
	 * 让用户选择文件
	 * @author Bindiry
	 */
	public class FileHandler extends File
	{
		/** 单例对象实例 */
		protected static var _instance:FileHandler;
		
		private var _btnSelectFiles:Button;
		private var _listFiles:List;
		private var _filesArrayList:ArrayList;
		
		private var _loadFileList:Array;
		private var _currentLoadFileIndex:int;
		
		public function FileHandler()
		{
			super(null);
			
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
		public function init(pSelectFilesButton:Button, pLoadList:List):void
		{
			_btnSelectFiles = pSelectFilesButton;
			_listFiles = pLoadList;
			_listFiles.labelField = "field";
			_filesArrayList = new ArrayList();
		}
		
		/** 选择文件 */
		public function selectFiles():void
		{
			browseForOpenMultiple("选择需要导入的Swf文件", [new FileFilter("Swf文件", "*.swf")]);
			addEventListener(FileListEvent.SELECT_MULTIPLE, onSelected);
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
				if (!checkFileIsExist(file) && file.extension.toLowerCase() == "swf")
				{
					DomLoader.loadExternalClasses(file.nativePath, function(clslist:Array, keylist:Array):void {
						var mclist:Array = [];
						var mc:MovieClip;
						for each (var cls:Class in clslist)
						{
							mc = new cls();
							mc.gotoAndStop(1);
							mclist.push(mc);
						}
						var field:String = file.name + " (" + clslist.length + "个导出元件)";
						var obj:Object = {field: field, name: file.name, path: file.nativePath, mclist: mclist, keylist: keylist};
						_filesArrayList.addItem(obj);
						_currentLoadFileIndex++;
						loadFiles();
					});
				}
			}
		}
		
		/** 开始导出文件 */
		public function exportFiles(pFormatList:DropDownList, pContainer:SpriteVisualElement, pOnComplete:Function):void
		{
			var formatList:Array = [];
			var dxrEncode:DxrEncoder = new DxrEncoder();
			var path:String;
			for each(var obj:Object in _filesArrayList.source)
			{
				var len:int = obj.mclist.length;
				for (var i:int = 0; i < len; i++)
				{
					formatList.push(pFormatList.selectedItem.value);
				}
				
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
				
				var result:Boolean = FileUtil.save(path, dxrEncode.encode(obj.mclist, obj.keylist, formatList));
//				MonsterDebugger.trace(result, null);
				
				var resultMessage:String = result ? "转换成功" : "转换失败";
				Alert.show(resultMessage);
				
				// 把转换完的MC从显示列表移除
				removeAllChild(pContainer);
			}
			pOnComplete();
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
	}
}