package ro.ciacob.utils {
	import flash.system.Capabilities;

	public final class OSFamily {
		public static const LINUX:String = 'linux';
		public static const MAC:String = 'mac';
		public static const UNKNOWN:String = 'UNKNOWN';

		public static const WINDOWS:String = 'windows';
		
		private static var _osFamily:String;
		private static var _osName:String;

		public static function get isLinux():Boolean {
			return (osName.indexOf(LINUX) >= 0);
		}

		public static function get isMac():Boolean {
			return (osName.indexOf(MAC) >= 0);
		}

		public static function get isWindows():Boolean {
			return (osName.indexOf(WINDOWS) >= 0);
		}

		public static function get osFamily():String {
			if (_osFamily == null) {
				_osFamily = isWindows ? WINDOWS : isMac ? MAC : isLinux ? LINUX :
					UNKNOWN;
			}
			return _osFamily;
		}

		private static function get osName():String {
			if (_osName == null) {
				_osName = Capabilities.os.toLowerCase();
			}
			return _osName;
		}
	}
}
