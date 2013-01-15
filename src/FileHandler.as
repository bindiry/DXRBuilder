package 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayList;
	
	import org.flexlite.domDisplay.codec.DxrEncoder;
	import org.flexlite.domUtils.DomLoader;
	import org.flexlite.domUtils.FileUtil;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.List;
	
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
					DomLoader.loadExternalClasses(file.nativePath, function(pResult:Object):void {
						var mclist:Array = [];
						var mc:MovieClip;
						for each (var cls:Class in pResult.clslist)
						{
							mc = new cls();
							mclist.push(mc);
						}
						var keylist:Array = [];
						for each (var key:String in pResult.keylist)
						{
							keylist.push(key);
						}
						var field:String = file.name + " (" + pResult.clslist.length + "个导出元件)";
						var obj:Object = {field: field, name: file.name, path: file.nativePath, mclist: mclist, keylist: keylist};
						_filesArrayList.addItem(obj);
						_currentLoadFileIndex++;
						loadFiles();
					});
				}
			}
		}
		
		/** 开始导出文件 */
		public function exportFiles(pFormatList:DropDownList, pOnComplete:Function):void
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
				
				trace(FileUtil.save(path, dxrEncode.encode(obj.mclist, obj.keylist, formatList)));
			}
			pOnComplete();
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