package ro.ciacob.utils {

	import flash.utils.ByteArray;
	
	import mx.utils.ObjectUtil;

	public final class Arrays {
		
		
 		public static const FILTER_ANY : String = 'arraysFilterAny';
		public static const FILTER_ALL : String = 'arraysFilterAll';
		public static const FILTER_NONE : String = 'arraysFilterNone';
		public static const FILTER_SUBSTRING : String = 'arraysFilterSubstring';
		public static const INCLUDE_IF_ALL_KEYS_MISSING : String = 'arraysFilterIncludeIfAllKeysMissing';

		private static const COLLECTION_TOO_SMALL_ERROR : String = 'Cannot extract a subset of %d element(s) from an Array of %d element(s).';

		/**
		 * Adds all given arguments as members of an array, then returns the array. Any arrays given
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
	     *
	     * @param uniqueElements Whether each element must appear only once in the returned subset.
	     *         Optional, defults to `true`.
	     *
	     * @param workOnSource
	     *        Optional, default `false`. Only relevant when `uniqueElements` is `true`.
	     *        If engaged, modifies the original collection by removing from it the values that got
	     *        picked. When this argument is `true`, the `COLLECTION_TOO_SMALL_ERROR` error
	     *        mechanism is suppressed, and the error will not fire, not even in legit scenarios.
	     *
	     * @throws `COLLECTION_TOO_SMALL_ERROR`, if requesting a subset greater than the collection,
	     *         with all items in it unique.
	     */
	    public static function getSubsetOf(collection:Array, size:uint,
	                                       uniqueElements:Boolean = true, workOnSource:Boolean = false):Array {

	        var src:Array = workOnSource ? collection : collection.concat();
	        var srcSize:uint = src.length;
	        var srcLimit:uint = 0;
	        var dest:Array = [];
	        var destSize:uint = 0;
	        var randIndex:uint = 0;
	        var randElement:Object = null;
	        if (!workOnSource) {
	            if (size > srcSize && uniqueElements == true) {
	                throw(new Error(Strings.sprintf(COLLECTION_TOO_SMALL_ERROR, size, srcSize)));
	            }
	        }
	        while ((destSize = dest.length) < size) {
	            srcLimit = (srcSize - 1);
	            randIndex = NumberUtil.getRandomInteger(0, srcLimit);
	            randElement = (src[randIndex] as Object);
	            dest.push(randElement);
	            if (uniqueElements) {
	                src.splice(randIndex, 1);
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
	    public static function getRandomItem(collection:Array, remove:Boolean = false):Object {
	        if (!collection || collection.length == 0) {
	            return null;
	        }
	        return (getSubsetOf(collection, 1, remove, true)[0] as Object);
	    }

		/**
		 * Removes a single dupplicate from "array", modifying the Array in place, and without
		 * sorting it. The "beginFromEnd" argument determines whether to conduct the search 
		 * for dupplicates in reverse order, from the end of the Array rather than from its 
		 * beginning (the default).The equality test employed is "===".
		 * Returns Boolean "true" if a dupplicate was found and removed, or "false" otherwise.
		 */
		public static function removeOneDupplicate (array : Array, beginFromEnd : Boolean = false) : Boolean {
			if (!array || (array.length == 0)) {
				return false;
			}
			var matchIndices : Array = [];
			var searchIndex : int;
			var valueIndex : int;
			var searchValue : Object;
			if (beginFromEnd) {
				outerLoopA:
				for (valueIndex = array.length - 1; valueIndex >= 0; valueIndex--) {
					searchValue = array[valueIndex];
					innerLoopA:
					for (searchIndex = array.length - 1; searchIndex >= 0; searchIndex--) {
						if (searchIndex == valueIndex) {
							continue;
						}
						if (array[searchIndex] === searchValue) {
							matchIndices.push (searchIndex);
							break outerLoopA;
						}
					}
				}
			}
			else {
				outerLoopB:
			 	for (valueIndex = 0; valueIndex < array.length; valueIndex++) {
			 		searchValue = array[valueIndex];
			 		innerLoopB:
 					for (searchIndex = 0; searchIndex < array.length; searchIndex++) {
 						if (array[searchIndex] === searchValue) {
	 						if (searchIndex == valueIndex) {
								continue;
							}
 							matchIndices.push (searchIndex);
 							break outerLoopB;
 						}
 					}
 				}
			}
			if (matchIndices.length > 0) {
				var spliceIndex : uint = matchIndices[0];
				array.splice (spliceIndex, 1);
				return true;
			}
			return false;
		}

		/**
		 * Removes dupplicate elements within a given array. Modifies the array in place, and does not
		 * sort it. The equality test employed is `==`.
		 *
		 * @param	array The array to remove dupplicates from.
		 */
		public static function removeDuplicates (array : Array) : void {
			if (array != null && array.length > 0) {
				var tmp : Array = array.concat ();
				var objIndices : Array = [];
				array.splice (0);
				for (var i : int = 0; i < tmp.length; i++) {
					var el : Object = tmp[i];
					if (el.constructor && el.constructor == Object) {
						var identicalObjects : Array = objIndices.filter (
							function (objIndex : Object, i : int, arr: Array) : Boolean {
								var objToTest : Object = (array [objIndex as int] as Object);
								return (ObjectUtil.compare (el, objToTest) == 0);
							}
						);
						if (identicalObjects.length == 0) {
							array.push (el);
							objIndices.push (array.length - 1);
						}
					} else {
						if (array.indexOf (el) == -1) {
							array.push (el);
						}
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
		
		/**
		 * Returns an Array containing the intersection of two given Arrays, optionally filtering out dupplicates
		 * from the returned output. Returns an empty Array if either of `a` or `b` is empty. Always sorts resulting
		 * Array alphabetically.
		 * 
		 * IMPORTANT NOTE: Objects are ignored, unless they share the same instance. So, if both arrays have an
		 * object literal of {red : 0xff0000}, it will NOT be includded in the result, whereas, if the object was
		 * defined outside as `var myRed : Object = {red : 0xff0000}`, and then `myRed` includded in both arrays,
		 * it will.
		 * 
		 * @param a First of the two Arrays 
		 * @param b First of the two Arrays 
		 * @param noDupplicates Flag to set to have a dupplicates free output 
		 */
		public static function intersect (a : Array, b : Array, noDupplicates : Boolean) : Array {
			if (a.length == 0 || b.length == 0) {
				return [];
			}
			var t : Array;
			if (b.length > a.length) t = b, b = a, a = t; // swap to make sure "indexOf" runs over the shorter Array
			var result : Array = a.filter (function (e : Object, i : int, c : Array) : Boolean {
				return b.indexOf (e) > -1;
			});
			if (!noDupplicates) {
				removeDuplicates (result);
			}
			result.sort();
			return result;
		}
		
		
		/**
		 * Returns a filtered version of given `source` Array; In order for an items to be included in the resulting 
		 * Array it must pass the `condition` argument while also honouring any given `flags`.
		 * 
		 * @param	source
		 * 			Must be an Array containing Objects, such as:
		 * 
		 * 			// Example 1
		 * 			var source : Array = [
		 *	 			{ name : "red", hex : 0xff0000 },
		 * 				{ name : "green", hex : 0x00ff00 },
		 * 				{ name : "blue", hex : 0x0000ff }
		 * 			];
		 * 
		 * @param	condition
		 * 			An Object containing the key(s) to be tested and one or more permitted values, such as:
		 * 
		 * 		   	// Example 2
		 * 			var condition = {name: "red"} // Matches item at index `0` in previous Example 1
		 * 
		 * 		   	// Example 3
		 * 			var condition = {name: ["red", "green"]} // Matches items at indices `0` and `1` in Example 1
		 * 
		 * @param	flags
		 * 			Optional, a `rest` arguments containing directives that alter the overall behavior of the
		 * 			filter. Currently, the following flags are supported (the order of flags definitions in this 
		 * 			list also reflects the order they override each other, if ever the case):
		 * 
		 * 			// Matching mode flags
		 * 			Arrays.FILTER_ANY - an item is includded if either of the keys in `condition` has a match;
		 * 			Arrays.FILTER_ALL - an item is includded only if all of the keys in `condition` have matches (default);
		 * 			Arrays.FILTER_NONE - an item is includded only if none of the keys in `condition` have a match;
		 * 
		 * 			// Misc. Flags
		 * 			Arrays.FILTER_SUBSTRING - toggles substring matching for all string values in `condition` (false when missing);
		 * 			Arrays.INCLUDE_IF_ALL_KEYS_MISSING - assumes "match" for all the items that do not have any of the keys in 
		 * 			`condition`, at all (false when missing).
		 * 
		 * @return	A new, possible empty Array, containing the matching items.
		 */
		public static function filterObjectsArray (source : Array, condition : Object, ...flags) : Array {
			var hasFilterAny : Boolean = (flags.indexOf (FILTER_ANY) >= 0);
			var hasFilterAll : Boolean = (flags.indexOf (FILTER_ALL) >= 0);
			var hasFilterNone : Boolean = (flags.indexOf (FILTER_NONE) >= 0);
			var hasFilterSubstring : Boolean = (flags.indexOf (FILTER_SUBSTRING) >= 0);				
			var hasIncludeIfAllKeysMissing : Boolean = (flags.indexOf (INCLUDE_IF_ALL_KEYS_MISSING) >= 0);
			var matchingMode : String = hasFilterNone? FILTER_NONE : hasFilterAll? FILTER_ALL: hasFilterAny? FILTER_ANY: FILTER_ALL;
			var numConditionCriteria : int = Objects.getKeys(condition).length;
			
			return source.filter (function (rawItem : *, index : int, array : Array) : Boolean {
				var itemPasses : Boolean = false;
				var matchesNum : int = 0;
				var foundKeysNum : int = 0;
				var item : Object = (rawItem as Object);
				var conditionKey : String;
				var conditionVal : Object;
				var itemVal : Object;
				var haveAltMatch : Boolean
				for (conditionKey in condition) {
					conditionVal = condition[conditionKey];
					itemVal = null;
					
					if (conditionKey in item) {
						foundKeysNum++;
						itemVal = item[conditionKey];
						
						// If current condition's criteria value is an Array, any match against one of the values in that
						// Array (if FILTER_ANY or FILTER_ALL is in effect) or no match against any of the values in that
						// Array (if FILTER_NONE is in effect) will set the current item as passing.
						if (conditionVal is Array) {
							// treci prin conditionVal, care e un array, pentru fiecare conditionVal.searchValue fa:
							// (itemVal as Array).indexOf (conditionVal.searchValue);
							haveAltMatch = ((conditionVal as Array).indexOf (itemVal) >= 0);
							if (haveAltMatch && (matchingMode == FILTER_ALL || matchingMode == FILTER_ANY)) {
								matchesNum++;
							}
							if (!haveAltMatch && matchingMode == FILTER_NONE) {
								matchesNum++;
							}
						} else {
						
							// FILTER_SUBSTRING flag effect
							if (hasFilterSubstring && (conditionVal is String)) {
								if ((itemVal is String) && (itemVal as String).indexOf(conditionVal) >= 0) {
									matchesNum++;
								}
							} else {
								
								// Regular matching (no special case), using "==" for flexibility
								if (conditionVal == itemVal) {
									matchesNum++;
								}
							}
						}
					}
					
					// FILTER_* flags effect
					if (matchingMode == FILTER_ANY) {
						if (matchesNum > 0) {
							itemPasses = true;
							break;
						}
					} else if (matchingMode == FILTER_ALL) {
						if (matchesNum == numConditionCriteria) {
							itemPasses = true;
							break;
						}
					} else if (matchingMode == FILTER_NONE) {
						if (matchesNum == 0 && foundKeysNum == numConditionCriteria) {
							itemPasses = true;
							break;
						}
					}
				}

				// INCLUDE_IF_ALL_KEYS_MISSING flag effect
				if (hasIncludeIfAllKeysMissing) {
					if (foundKeysNum == 0) {
						itemPasses = true;
					}
				}
				
				// If 'itemPasses' is true, the item will be includded
				return itemPasses;
			});
		}
	}
}
