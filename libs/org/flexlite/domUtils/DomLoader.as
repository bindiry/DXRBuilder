package org.flexlite.domUtils
{
	import flash.system.ApplicationDomain;
	
	import org.flexlite.domUtils.loader.SingleLoader;


	/**
	 * 调用各种数据请求功能的入口类
	 * @author DOM
	 */	
	public class DomLoader
	{
		
	
		/**
		 * 根据url获取指定文件的Loader显示对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:Loader)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 * @param appDomain 加载使用的程序域
		 */		
		public static function loadLoader(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null,appDomain:ApplicationDomain=null):void
		{
			var ldLoader:SingleLoader = new SingleLoader;
			ldLoader.loadLoader(url,onComp,onProgress,onIoError,appDomain);
		}
		/**
		 * 根据url获取指定文件的Bitmap显示对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:Bitmap)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public static function loadBitmap(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			var bmLoader:SingleLoader = new SingleLoader;
			bmLoader.loadBitmap(url,onComp,onProgress,onIoError);
		}
		/**
		 * 根据url获取指定文件的BitmapData数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:BitmapData)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public static function loadBitmapData(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			var bdLoader:SingleLoader = new SingleLoader;
			bdLoader.loadBitmapData(url,onComp,onProgress,onIoError);
		}
		
		/**
		 * 根据url获取指定文件的Class类定义数据
		 * @param url 文件的url路径
		 * @param className 要获取的类名
		 * @param onComp 返回结果时的回调函数 onComp(data:Class)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent
		 * @param appDomain 加载使用的程序域
		 */	
		public static function loadExternalClass(url:String,className:String,onComp:Function,onProgress:Function=null,onIoError:Function=null,appDomain:ApplicationDomain=null):void
		{
			var classLoader:SingleLoader = new SingleLoader;
			classLoader.loadExternalClass(url,className,onComp,onProgress,onIoError,appDomain);
		}
		
		/**
		 * 根据url获取指定文件的所有Class类定义和键名数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(clslist:Array, keylist:Array)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent
		 * @param appDomain 加载使用的程序域
		 */
		public static function loadExternalClasses(url:String, onComp:Function, onProgress:Function=null, onIoError:Function=null,appDomain:ApplicationDomain=null):void
		{
			var classLoader:SingleLoader = new SingleLoader;
			classLoader.loadExternalClasses(url,onComp,onProgress,onIoError,appDomain);
		}
		
	
		//==========多个加载项=========end=========
		
	}
}