package ro.ciacob.utils {
	import flash.utils.describeType;
	
	import ro.ciacob.utils.Strings;

	/**
	 * Utility class, which allows using a constants class as a bare-bone
	 * database.
	 */
	public class ConstantUtils {

		/**
		 * Given "my name", or "myName", it turns it into "MY_NAME", and tries
		 * to match it against the public properties of the `constants` class of
		 * constants given.
		 *
		 * If found, the matching value (that is, `constants[MY_NAME]` is
		 * returned).
		 *
		 * @param 	constants
		 * 			A class containing constants, to match against.
		 *
		 * @param 	name
		 * 			A name to be matched against the constants in the class.
		 *
		 * @return	The value of the matching constant, if any.
		 */
		public static function getValueByMatchingName(constants:Class, name:String):Object {
			if (constants != null) {
				var key:String = Strings.toAS3ConstantCase(name);
				if (Object(constants).hasOwnProperty(key)) {
					return constants[key];
				}
			}
			return null;
		}
		
		/**
		 * Returns all names that point to a value that is equal to the given one.
		 * Matches checked (and stored) in alphabetical order.
		 * 
		 * @param 	constants
		 * 			A class containing constants, to match against.
		 * 
		 * @param	value
		 * 			A value to look for.
		 * 
		 * @return	A (possibly empty) Array with strings, representing names in the 
		 * 			constants class.
		 */
		public static function getNamesByMatchingValue(constants:Class, value : Object) : Array {
			var matches : Array = [];
			var allNames : Array = getAllNames(constants);
			for (var i:int = 0; i < allNames.length; i++) {
				var name : String = (allNames[i] as String);
				if (constants[name] === value) {
					matches.push(name);
				}
			}
			return matches;
		}

		/**
		 * Returns all values defined by a given class of constants.
		 *
		 * @param	constants
		 * 			The class of constants to retrieve values of.
		 *
		 * @return	An alphabetically sorted list with all the values found.
		 */
		public static function getAllValues(constants:Class):Array {
			var list:Array = [];
			var info:XML = describeType(constants);
			for each (var node:XML in info..constant) {
				var key:String = ('' + node.@name);
				list.push(constants[key]);
			}
			return list.sort();
		}

		/**
		 * Returns all names (or keys) defined by a given class of constants.
		 *
		 * @param	constants
		 * 			The class of constants to retrieve names of.
		 * 
		 * @param	includeAccessors
		 * 			Optional. If set to true, readable accessors in the class will
		 * 			be included as well.
		 *
		 * @return	An alphabetically sorted list with all the names found.
		 */
		public static function getAllNames(constants:Class, includeAccessors : Boolean = false):Array {
			var list:Array = [];
			var info:XML = describeType(constants);
			var node:XML;
			var key:String;
			for each (node in info..constant) {
				key = ('' + node.@name);
				list.push(key);
			}
			if (includeAccessors) {
				for each (node in info..accessor) {
					if (node.@access != "writeonly") {
						key = ('' + node.@name);
					}
					list.push(key);
				}
			}
			return list.sort();
		}

		/**
		 * Convenience way to confirm existence of a key in a constants class.
		 *
		 * @param	constants
		 * 			The class to lookup in.
		 *
		 * @param	key
		 * 			The key to lookup.
		 *
		 * @return	True if found.
		 */
		public static function hasName(constants:Class, key:String):Boolean {
			return (key in constants);
		}

		/**
		 * Confirms existence of a value in a constants class. The lookup can be 
		 * enhanced by specifying a custom comparison function to use in lieu of
		 * the mere `==` operator. 
		 * 
		 * @param	constants
		 * 			The class to lookup in.
		 * 			
		 * @param	value
		 * 			The value to look up.
		 * 
		 * @param	comparisonFunction
		 * 			An optional function to be used when looking up. Functions used
		 * 			as the lone argument of the `Array.sort()` method will fit 
		 * 			perfectly, see `Array` documentation for reference. If the function
		 * 			returns the integer 0, this will be considered a match, and the
		 * 			search will cease.
		 * 
		 * @return	True, if a match is found, false otherwise.
		 */
		public static function hasValue(constants:Class, value:Object, comparisonFunction:Function = null):Boolean {
			var values:Array = getAllValues(constants);
			if (values.length > 0) {
				if (comparisonFunction == null) {
					return (values.indexOf(value) >= 0);
				}
				for (var i:int = 0; i < values.length; i++) {
					var someValue:Object = values[i];
					var comparisonResult:int = comparisonFunction(someValue, value);
					if (comparisonResult == 0) {
						return true;
					}
				}
			}
			return false;
		}

	}
}
