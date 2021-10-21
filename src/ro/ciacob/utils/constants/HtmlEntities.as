package ro.ciacob.utils.constants {
	import ro.ciacob.utils.ConstantUtils;

	public final class HtmlEntities {

		public static const NON_BREAKING_SPACE : HtmlEntity = new HtmlEntity ('nbsp', 160);
		public static const LESS_THAN : HtmlEntity = new HtmlEntity ('lt', 60);
		public static const GREATER_THAN : HtmlEntity = new HtmlEntity ('gt', 62);
		public static const AMPERSAND : HtmlEntity = new HtmlEntity ('amp', 38);
		public static const CENT : HtmlEntity = new HtmlEntity ('cent', 162);
		public static const POUND : HtmlEntity = new HtmlEntity ('pound', 163);
		public static const YEN : HtmlEntity = new HtmlEntity ('yen', 165);
		public static const EURO : HtmlEntity = new HtmlEntity ('euro', 8364);
		public static const COPYRIGHT : HtmlEntity = new HtmlEntity ('copy', 169);
		public static const REGISTERED_TRADEMARK : HtmlEntity = new HtmlEntity ('reg', 174);
		public static const LEFTWARDS_ARROW : HtmlEntity = new HtmlEntity ('larr', 8592);
		public static const UPWARDS_ARROW : HtmlEntity = new HtmlEntity ('uarr', 8593);
		public static const RIGHTWARDS_ARROW : HtmlEntity = new HtmlEntity ('rarr', 8594);
		public static const DOWNWARDS_ARROW : HtmlEntity = new HtmlEntity ('darr', 8595);
		public static const CARRIAGE_RETURN_ARROW : HtmlEntity = new HtmlEntity ('crarr', 8629);
		public static const SINGLE_LEFT_ANGLE_QUOTATION : HtmlEntity = new HtmlEntity ('lsaquo', 8249);
		public static const SINGLE_RIGHT_ANGLE_QUOTATION : HtmlEntity = new HtmlEntity ('rsaquo', 8249);
		public static const HORIZONTAL_ELLIPSIS : HtmlEntity = new HtmlEntity ('hellip', 8230);
		public static const BULLET : HtmlEntity = new HtmlEntity ('bull', 8226);
		public static const LEFT_DOUBLE_QUOTATION_MARK : HtmlEntity = new HtmlEntity ('ldquo', 8220);
		public static const RIGHT_DOUBLE_QUOTATION_MARK : HtmlEntity = new HtmlEntity ('rdquo', 8221);
		public static const LEFT_SINGLE_QUOTATION_MARK : HtmlEntity = new HtmlEntity ('lsquo', 8216);
		public static const RIGHT_SINGLE_QUOTATION_MARK : HtmlEntity = new HtmlEntity ('rsquo', 8217);
		public static const EM_DASH : HtmlEntity = new HtmlEntity ('mdash', 8212);
		public static const EN_DASH : HtmlEntity = new HtmlEntity ('ndash', 8211);
		
		private static var _all : Array;
		
		public static function get all () : Array {
			if (_all == null) {
				_all = ConstantUtils.getAllValues (HtmlEntities);
			}
			return _all;
		}
	}
}