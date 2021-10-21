package ro.ciacob.utils {
	public class Patterns {
		public static const ALL_EXCEPT_FILENAME_UNSAFE:String = '^/:*?"<>|\\\\';
		public static const SAFEST_FILENAME_ALL_PLATFORMS:String = '^./:*?"<>|\\\\';
		public static const REJECT_QUOTES_APOSTROPHE_BACKTICK:String = '^\x22\x27\x60';
		public static const REJECT_QUOTES_BACKTICK:String = '^\x22\x60';
		public static const REJECT_BROKEN_BAR:String = '^¦';
		public static const ALPHA_LOWER:String = 'a-z';
		public static const ALPHA_NUM_LOWER:String = '0-9a-z';
		public static const ALPHA_NUM_UPPER:String = '0-9A-Z';
		public static const ALPHA_UPPER:String = 'A-Z';
		public static const BACKTICK:RegExp = /\x60/;
		public static const BACKTICK_GLOBAL:RegExp = /\x60/g;
		public static const DOUBLE_QUOTE:RegExp = /\x22/;
		public static const DOUBLE_QUOTE_GLOBAL:RegExp = /\x22/g;
		public static const FQN_SEGMENT:RegExp = /[A-Za-z_\$][A-Za-z_\$\d]*[\.\:]?/g;
		public static const LEGAL_AS3_IDENTIFIER:RegExp = /[A-Za-z_\$][A-Za-z_\$\d]*/;
		public static const LEGAL_URL:RegExp = /^(http(s)?):\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w-.\/?:%+@&=]*)?)?(#(.*))?$/i;
		public static const MAC_EOL:RegExp = /\r(?!\n)/g;
		public static const NUMBERS_ONLY:String = '0-9';
		public static const SINGLE_QUOTE:RegExp = /\x27/;
		public static const SINGLE_QUOTE_GLOBAL:RegExp = /\x27/g;
		public static const UNIX_EOL:RegExp = /(?<!\r)\n/g;
		public static const WINDOWS_VALID_FILE_NAME:RegExp = /^[^\\\/\:\*\?\"<>\|]+$/;
		public static const NUMERIC_HTML_ENTITY_GLOBAL:RegExp = /\&\#(\d{1,})\;/g;
		public static const GENERIC_HTML_ENTITY_GLOBAL:RegExp = /\&\#?([\da-z]{1,})\;/gi;
		public static const UUID_CASE_INSENSITIVE:RegExp = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
	}
}
