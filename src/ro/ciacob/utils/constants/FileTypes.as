package ro.ciacob.utils.constants {

	public final class FileTypes {

		// Any file (as in, file type not set)
		public static const ANY:String = '';
		
		// Only folders
		public static const FOLDERS_ONLY:String = 'foldersonly';
		
		// SOUND
		public static const ABC:String = 'abc';
		public static const MIDI:String = 'mid';
		public static const WAV:String = 'wav';
		public static const MP3:String = 'mp3';
		public static const AIFF:String = 'aiff';

		// Images
		public static const JPEG:String = 'jpeg';
		public static const JPG:String = 'jpg';
		public static const PNG:String = 'png';
		public static const GIF:String = 'gif';
		public static const ALLOWED_IMAGE_TYPES:Array = [FileTypes.JPEG, FileTypes.JPG, FileTypes.PNG];
		
		// Flash/AS3
		public static const SWF : String = 'swf';
		public static const SWC : String = 'swc';
		
		// Documents
		public static const PDF : String = 'pdf';
		public static const TXT : String = 'txt';
		public static const XML : String = 'xml';

		// Windows Executables
		public static const BAT:String = 'bat';
		public static const CMD:String = 'cmd';
		public static const COM:String = 'com';
		public static const CPL:String = 'cpl';
		public static const EXE:String = 'exe';
		public static const HTA:String = 'hta';
		public static const INF:String = 'inf';
		public static const JS:String = 'js';
		public static const JSE:String = 'jse';
		public static const MDB:String = 'mdb';
		public static const MSC:String = 'msc';
		public static const MSI:String = 'msi';
		public static const MSP:String = 'msp';
		public static const OCX:String = 'ocx';
		public static const PIF:String = 'pif'
		public static const SCR:String = 'scr';
		public static const SCT:String = 'sct';
		public static const SHS:String = 'shs';
		public static const SYS:String = 'sys';
		public static const VB:String = 'vb';
		public static const VBE:String = 'vbe';
		public static const VBS:String = 'vbs';
		public static const WSC:String = 'wsc';
		public static const WSF:String = 'wsf';
		public static const WSH:String = 'wsh';
		
		// Windows shortcuts
		public static const LNK:String = 'lnk';
		public static const URL:String = 'url';

		// Mac Executables
		public static const SH:String = 'sh';
		
		// Import and export
		public static const TPL:String = 'tpl';
		public static const CCL:String = 'ccl';
	}
}
