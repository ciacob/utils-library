package ro.ciacob.utils {

	public class Assertions {
		
		public static function assertNotNull(element:*, detail:String = ''):void {
			if (element === null) {
				throw(new Error('NOT NULL assertion failed. ' + detail));
			}
		}

		public static function assertNotZero(element:*, detail:String = ''):void {
			if (element === 0) {
				throw(new Error('NOT ZERO assertion failed. ' + detail));
			}
		}

		public static function assertNotNaN(element:*, detail:String = ''):void {
			if (isNaN (element)) {
				throw(new Error('NOT NaN assertion failed. ' + detail));
			}
		}

		public static function assertGreaterThan(elementA:*, elementB:*, detail:String = ''):void {
			if (elementA <= elementB) {
				throw(new Error('GREATER THAN assertion failed. ' + detail));
			}
		}
	}
}
