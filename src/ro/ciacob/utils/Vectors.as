package ro.ciacob.utils {
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

	public final class Vectors {

		/**
		 * Computes an average of all the integers contained by a vector.
		 */
		public static function averageIntegersVector(vector:Vector.<int>):Number {
			if (vector.length == 0) {
				return NaN;
			}
			return (sumIntegersVector(vector) / vector.length);
		}

		/**
		 * Performs a deep clone of a Vector that contains Vectors that contain integers,
		 * so that changing the inner vector copies do not alter the originals.
		 * @param	vector
		 * 			A two level integer Vector to be deeply cloned.
		 * @return 	The clone.
		 */
		public static function deepTwoLevelIntVectorClone(vector:Vector.<Vector.<int>>):Vector.<Vector.<int>> {
			var ba:ByteArray = new ByteArray();
			registerClassAlias("__AS3__.vec::Vector.<int>", Class(Vector.<int>));
			ba.writeObject(vector);
			ba.position = 0;
			return (ba.readObject());
		}

		/**
		 * Performs a deep clone of a Vector that contains Vectors that contain strings,
		 * so that changing the inner vector copies do not alter the originals.
		 * @param	vector
		 * 			A two level string Vector to be deeply cloned.
		 * @return 	The clone.
		 */
		public static function deepTwoLevelStringVectorClone(vector:Vector.<Vector.<String>>):Vector.<Vector.<String>> {
			var ba:ByteArray = new ByteArray();
			registerClassAlias("__AS3__.vec::Vector.<String>", Class(Vector.<String>));
			ba.writeObject(vector);
			ba.position = 0;
			return (ba.readObject());
		}

		public static function removeIntDuplicates(vector:Vector.<int>, sort : Boolean = false):void {
			if (sort) {
				vector.sort(integerSort);
				for (var i:int = vector.length - 1; i > 0; --i) {
					if (vector[i] == vector[i - 1]) {
						vector.splice(i, 1);
					}
				}
			}
		}

		/**
		 * Computes the sum of all integer elements in a vector.
		 */
		public static function sumIntegersVector(vector:Vector.<int>):Number {
			var result:Number = 0;
			var i:int = 0;
			while (i < vector.length) {
				result += vector[i];
				i++;
			}
			return result;
		}

		/**
		 * Tests for equality two integer vectors. Returns TRUE for equality, FALSE for inequality.
		 */
		public static function testIntVectorsEquality(a:Vector.<int>, b:Vector.<int>):Boolean {
			if (a.length != b.length) {
				return false;
			}
			for (var i:int = 0; i < a.length; i++) {
				if (a[i] != b[i]) {
					return false;
				}
			}
			return true;
		}

		/**
		 * Tests for equality two string vectors. Returns TRUE for equality, FALSE for inequality.
		 */
		public static function testStringVectorsEquality(a:Vector.<String>, b:Vector.<String>):Boolean {
			if (a.length != b.length) {
				return false;
			}
			for (var i:int = 0; i < a.length; i++) {
				if (a[i] != b[i]) {
					return false;
				}
			}
			return true;
		}

		/**
		 * Tests whether two integer vectors are equal. It operates on two-level vectors, e.g.,
		 * vectors that contain other vectors, that contain integers.
		 * @return 	True, if a flatten version of the two vectors would contain the same integers,
		 * 			in the same order.
		 */
		public static function testTwoLevelIntVectorsEquality(a:Vector.<Vector.<int>>, b:Vector.<Vector.<int>>):Boolean {
			if (a.length != b.length) {
				return false;
			}
			var ba1:ByteArray = new ByteArray();
			ba1.writeObject(a);
			ba1.position = 0;
			var ba2:ByteArray = new ByteArray();
			ba2.writeObject(b);
			ba2.position = 0;
			while (ba1.bytesAvailable) {
				if (ba1.readByte() != ba2.readByte()) {
					return false;
				}
			}
			return true;
		}

		public static function twoLevelRemoveIntDuplicates(vector:Vector.<Vector.<int>>, sort : Boolean = false):void {
			if (sort) {
				vector.sort(integerVectorSort);
				for (var i:int = vector.length - 1; i > 0; --i) {
					if (testIntVectorsEquality(vector[i], vector[i - 1])) {
						vector.splice(i, 1);
					}
				}			
			}
		}

		public static function twoLevelRemoveStringDupplicates(vector:Vector.<Vector.<String>>, sort : Boolean = false):void {
			if (sort) {
				vector.sort(stringVectorSort);
				for (var i:int = vector.length - 1; i > 0; --i) {
					if (testStringVectorsEquality(vector[i], vector[i - 1])) {
						vector.splice(i, 1);
					}
				}			
			} else {
				for (var j:int = 0; j < vector.length; j++) {
					do {
						var duplicateIndex : int = vector.indexOf (vector[j], j + 1);
						if (duplicateIndex == -1) {
							break;
						}
						vector.splice (duplicateIndex, 1);
					} while (true);
				}
			}
		}

		private static function integerSort(a:int, b:int):int {
			return a - b;
		}

		private static function integerVectorSort(a:Vector.<int>, b:Vector.<int>):int {
			a.sort(integerSort);
			b.sort(integerSort);
			return sumIntegersVector(a) - sumIntegersVector(b);
		}

		private static function stringSort(a:String, b:String):int {
			return (a > b) ? 1 : (a < b) ? -1 : 0;
		}

		private static function stringVectorSort(a:Vector.<String>, b:Vector.<String>):int {
			a.sort(stringSort);
			b.sort(stringSort);
			var tmpA:String = a.join('');
			var tmpB:String = b.join('');
			return (tmpA > tmpB) ? 1 : (tmpA < tmpB) ? -1 : 0;
		}
	}
}
