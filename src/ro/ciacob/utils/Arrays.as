/*//////////////////////////////////////////////////////////////////*/
/*                                                                  */
/*   Unless stated otherwise, all work presented in this file is    */
/*   the intelectual property of:                                   */
/*   @author Claudius Iacob <claudius.iacob@gmail.com>              */
/*                                                                  */
/*   All rights reserved. Obtain written permission from the author */
/*   before using/reusing/adapting this code in any way.            */
/*                                                                  */
/*//////////////////////////////////////////////////////////////////*/

package ro.ciacob.utils {

	import flash.utils.ByteArray;

	public final class Arrays {

		private static const COLLECTION_TOO_SMALL_ERROR : String = 'Cannot extract a subset of %d element(s) from an Array of %d element(s).';

		/**
		 * Adds all given arguments as members of an array, then returns the arrays. Any arrays given
		 * as members, to any level deep, are flatten out, that is, their members are added instead
		 * of the parent Array.
		 */
		public static function consolidate (... args) : Array {
			var i : int, el : Object, ret : Array = [];
			for (i = 0; i < args.length; i++) {
				el = args[i];
				if (el is Array) {
					el = consolidate.apply (null, el);
				}
				ret = ret.concat (el);
			}
			return ret;
		}

		/**
		 * Performs a deep clone operation of an array that contains basic types, such as boolean,
		 * int, uint, number, string, array, object.
		 *
		 * Important: if the array contains custom types, they will loose their type (although you
		 * might still be able to access their methods and properties). Using `registerClassAlias`
		 * & friends might help with that issue.
		 *
		 * @param	array The array to be deeply cloned.
		 *
		 * @return	A deep clone of the original array.
		 */
		public static function deepCloneArrayOfBasicTypes (array : Array) : Array {
			var myBA : ByteArray = new ByteArray;
			myBA.writeObject (array);
			myBA.position = 0;
			return (myBA.readObject () as Array);
		}

		/**
		 * Extracts and returns a subset of a given collection. The subset may, or may not be
		 * comprised of unique elements, based on the `uniqueElements` setting.
		 *
		 * @param collection The originating collection.
		 * @param size The size of the subset.
		 * @param uniqueElements Whether each element must appear only once in the returned subset.
		 *         Optional, defults to `true`.
		 *
		 * @throws `COLLECTION_TOO_SMALL_ERROR`, if requesting a subset greater than the collection,
		 *         while requiring that all items be unique.
		 */
		public static function getSubsetOf (collection : Array, size : uint,
			uniqueElements : Boolean = true) : Array {

			var src : Array = collection.concat ();
			var srcSize : uint = src.length;
			var srcLimit : uint = 0;

			var dest : Array = [];
			var destSize : uint = 0;

			var randIndex : uint = 0;
			var randElement : Object = null;

			if (size > srcSize && uniqueElements == true) {
				throw(new Error (Strings.sprintf (COLLECTION_TOO_SMALL_ERROR, size, srcSize)));
			}

			while ((destSize = dest.length) < size) {
				srcLimit = (srcSize - 1);
				randIndex = NumberUtil.getRandomInteger (0, srcLimit);
				randElement = (src[randIndex] as Object);
				dest.push (randElement);
				if (uniqueElements) {
					src.splice (randIndex, 1);
					srcSize = (src.length);
				}
			}

			return dest;
		}
		
		/**
		 * Convenience way to obtain a random element from a given Array. Whether the Array is modified
		 * depends on the `remove` parameter.
		 * 
		 * @param collection The originating Array.
		 * 
		 * @param remove Optional. If set to `true`, the picked item will be removed in-place from `collection`.
		 * 
		 * return An Object randomly picked from `collection`, or `null` if `collection` is empty or null.
		 */
		public static function getRandomItem (collection : Array, remove : Boolean = false) : Object {
			if (!collection || collection.length == 0) {
				return null;
			}
			return (getSubsetOf (collection, 1, remove)[0] as Object);
		}

		/**
		 * Removes dupplicate elements within a given array. Modifies the array in place, and does not
		 * sort it. The equality test employed is `==`.
		 *
		 * @param	array The array to remove dupplicates from.
		 */
		public static function removeDuplicates (array : Array) : void {
			// TODO: TEST THIS CODE
			if (array != null && array.length > 0) {
				var tmp : Array = array.concat ();
				array.splice (0);
				for (var i : int = 0; i < tmp.length; i++) {
					var el : Object = tmp[i];
					if (array.indexOf (el) == -1) {
						array.push (el);
					}
				}
			}
		}

		/**
		 * Randomizes in-place the given array.
		 * @param 	array The array to randomize.
		 */
		public static function shuffle (array : Array) : void {
			var randomSort : Function = function (a : Object, b : Object) : int {
				var r : Number = Math.random ();
				return (r > 0.65)? 1 : ((r > 0.32)? 0 : -1);
			}
			array.sort (randomSort);
		}

		/**
		 * Tests whether two arrays that only contain primitives (Numbers, ints, uints, Booleans,
		 * Strings) are identical after being sorted.
		 *
		 * @param	arrayA The first array to compare.
		 *
		 * @param	arrayB The second array to compare.
		 *
		 * @return	True if arrays are identical (contain each, the same values). Note: this function
		 *         modifies your arrays (sorts them in place).
		 */
		public static function sortAndTestForIdenticPrimitives (arrayA : Array, arrayB : Array) : Boolean {
			arrayA.sort ();
			arrayB.sort ();
			return (arrayA.join ('') == arrayB.join (''));
		}

		/**
		 * Tests whether two arrays are identical (same number items, all of which pass the equality
		 * test (`==`) and the proper order test (first item in A must equal first item in B, and
		 * so forth).
		 *
		 * The arrays are not modified durring the test. The arrays need not only contain primitives
		 * (as opposed to `sortAndTestForIdenticPrimitives`).
		 *
		 * @param	arrayA The first array to compare.
		 *
		 * @param	arrayB The second array to compare.
		 *
		 * @return	True if arrays are identical, false otherwise. Returns false if either of the
		 *         arguments is null (even if both are).
		 */
		public static function testForIdentity (arrayA : Array, arrayB : Array) : Boolean {
			if (arrayA == null) {
				return false;
			}
			if (arrayB == null) {
				return false;
			}
			
			var arrALen : uint = arrayA.length;
			if (arrALen != arrayB.length) {
				return false;
			}
			
			var i : int = 0; 
			for (i; i < arrALen; i++) {
				if (arrayA[i] != arrayB[i]) {
					return false;
				}
			}
			return true;
		}
	}
}
