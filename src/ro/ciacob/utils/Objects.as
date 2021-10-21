package ro.ciacob.utils {

	import flash.utils.getQualifiedClassName;

	public class Objects {
		private static const ARRAY_TYPE : String = 'Array';
		private static const OBJECT_TYPE : String = 'Object';
		
		private static const KEY_ALREADY_EXISTS : String = 'Provided key already exists in given object.';
		private static const KEY_DOES_NOT_EXISTS : String = 'Required key does not exist in given object.';
		private static const VALUE_NOT_EMPTY : String = 'Value pointed by the given key is not empty.';

		public static function assertEmpty (key : String, object : Object) : void {
			if (object[key] === undefined || object[key] === null) {
				return;
			}
			throw(new Error (VALUE_NOT_EMPTY));
		}

		public static function assertExisting (key : String, object : Object) : void {
			if (object[key] === undefined) {
				throw(new Error (KEY_DOES_NOT_EXISTS));
			}
		}

		public static function assertNonExisting (key : String, object : Object) : void {
			if (object[key] !== undefined) {
				throw(new Error (KEY_ALREADY_EXISTS));
			}
		}

		/**
		 * Returns a (possible empty) Array with all the keys found within the given Object instance.
		 *
		 * @param object The Object whose keys are to be listed.
		 * @param sortAlphabetically Whether to apply a simple (alphabetical) sort to the resulting
		 *         Array.
		 * @param keysToOmit An Array with keys to ommit from the list reported.
		 *
		 * @return An Array with keys.
		 */
		public static function getKeys (object : Object, sortAlphabetically : Boolean = false, keysToOmit : Array = null) : Array {
			var ret : Array = [];
			for (var key : String in object) {
				if (keysToOmit == null || keysToOmit.indexOf (key) == -1) {
					ret.push (key);
				}
			}
			if (sortAlphabetically) {
				ret.sort ();
			}
			return ret;
		}

		/**
		 * Inspects the provided value and returns true if it is not null AND: - is not a primitive,
		 * not an Object and not an Array; - is an Object and one of its non-null properties is not
		 * a primitive, not an Object and not an Array; - is an Object that contains nested
		 * Objects, and one of the non-null properties of such a nested Object is not a primitive,
		 * not an Object and not an Array; The same goes for Arrays. Nesting to any level deep is
		 * supported.
		 *
		 * @param	value The value to inspect.
		 * @param	recurse Whether to also inspect the children of `value`, should it have any, and
		 *         their children, and so on. Optional, defaults to true.
		 * @return True if this is not null, not a primitive, not an Object and not an Array, i.e.,
		 *         pass an UIComponent in and you'll have a return value of true; false if this is,
		 *         or contains, any of: primitives, Objects or Arrays.
		 */
		public static function hasCustomType (value : *, recurse : Boolean = true) : Boolean {
			var ret : Boolean = false;
			if (value != null) {
				var valueIsPrimitive : Boolean = (value is Number || value is int || value is uint || value is Boolean || value is
					String);
				if (!valueIsPrimitive) {
					var typeOfValue : String = getQualifiedClassName (value);
					if (typeOfValue != OBJECT_TYPE && typeOfValue != ARRAY_TYPE) {
						ret = true;
					} else if (recurse) {
						for each (var childValue : * in value) {
							ret = hasCustomType (childValue);
							if (ret == true) {
								break;
							}
						}
					}
				}
			}
			return ret;
		}

		/**
		 * Adds values from `source` into `target`.
		 *
		 * @param	source The source object to add values from.
		 *
		 * @param	target The target to add values into.
		 *
		 * @param	overwrite Whether to overrite overlapping values (true) or skip them (false).
		 *         Default is true.
		 */
		public static function importInto (source : Object, target : Object, overwrite : Boolean = true) : void {
			for (var key : String in source) {
				var value : Object = source[key];
				if (!(key in target) || overwrite) {
					target[key] = value;
				}
			}
		}

		/**
		* Returns `true` if given Object is empty, i.e., it has no keys. Returns `false` if given Object has at 
		* least one key.
		*/
		public static function isEmpty (object : Object) : Boolean {
			for (var key : String in object) {
				return false;
			}
			return true;
		}

	}
}
