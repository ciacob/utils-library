package ro.ciacob.utils.constants {
	
	public final class HtmlEntity {
		private var _name : String;
		private var _number : uint;
		
		public function HtmlEntity (name : String, number : uint) {
			_name = name;
			_number = number;
		}

		public function get number():uint {
			return _number;
		}

		public function get name():String {
			return _name;
		}

	}
}