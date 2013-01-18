package
{
	public class Global
	{
		/** 文件导出路径 */
		public static var exportPath:String = "";
		/** 与源文件同目录 */
		public static var sameAsSource:Boolean = false;
		/** 当前选择格式 */
		public static var currentFormat:String = "jpeg32";
		
		public function Global()
		{
		}
		
		public static function getSimplePath(pPath:String):String
		{
			return pPath.substr(0, 3) + "..." + pPath.substring(pPath.length - 8);
		}

	}
}