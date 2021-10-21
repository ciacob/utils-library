package ro.ciacob.utils {
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import avmplus.getQualifiedClassName;
	
	import ro.ciacob.utils.constants.CommonStrings;

	public class ByteArrays {

		/**
		 * Finds the index position of the first occurrence of the indicated sequence of bytes in the target ByteArray.
		 *
		 * @param	target The target ByteArray to perform the search in.
		 * @param	pattern The sequence of bytes to find. This can be defined as a ByteArray, an Array of byte values, or a String.
		 * @param	fromIndex Optional. An integer indicating the index position in the target ByteArray to start searching.
		 * 			If a negative integer is specified, fromIndex is computed from the end of the ByteArray (so -1 is the last byte)
		 * 			and the search works backwards.
		 * @return	An integer indicating the index position of the occurrence found. If no match is found, the method returns -1.
		 */
		public static function indexOf(target:ByteArray, pattern:*, fromIndex:int = 0):int {
			var arr:Array, end:Boolean, found:Boolean, a:int, i:int, j:int, k:int;

			var toFind:ByteArray = toByteArray(pattern);
			if (toFind == null) {
				// ** type of pattern unsupported **
				throw new Error("Unsupported Pattern");
				return;
			}

			a = toFind.length;
			j = target.length - a;

			if (fromIndex < 0) {
				i = j + fromIndex;
				if (i < 0) {
					return -1;
				}
			} else {
				i = fromIndex;
			}

			while (!end) {
				if (target[i] == toFind[0]) {
					// ** found a possible candidate **
					found = true;
					k = a;
					while (--k) {
						if (target[i + k] != toFind[k]) {
							// ** doesn't match, false candidate **
							found = false;
							break;
						}
					}
					if (found) {
						return i;
					}
				}
				if (fromIndex < 0) {
					end = (--i < 0);
				} else {
					end = (++i > j);
				}
			}
			return -1;
		}


		/**
		 * Finds all occurrences of the indicated sequence of bytes in the target ByteArray.
		 *
		 * @param	target The target ByteArray to perform the search in.
		 * @param	pattern The sequence of bytes to find. This can be defined as a ByteArray, an Array of byte values, or a String.
		 * @param	fromIndex Optional. An integer indicating the index position in the target ByteArray to start searching.
		 * @return	An Array containing all the index positions found. If no match is found, the method returns an empty array.
		 */
		public static function indicesOf(target:ByteArray, pattern:*, fromIndex:uint = 0):Array {
			var arr:Array = [];
			var toFind:ByteArray = toByteArray(pattern);
			if (toFind == null) {
				// ** type of pattern unsupported **
				throw new Error("Unsupported Pattern");
				return;
			}
			var i:int = indexOf(target, toFind, fromIndex);
			while (i != -1) {
				arr[arr.length] = i;
				i = indexOf(target, toFind, i + 1);
			}
			return arr;
		}

		/**
		 * Finds the last occurrence of the indicated sequence of bytes in the target ByteArray.
		 *
		 * Calling this method is the same as calling indexOf(target, pattern, -1).
		 *
		 * @param	target The target ByteArray to perform the search in.
		 * @param	pattern The sequence of bytes to find. This can be defined as a ByteArray, an Array of byte values, or a String.
		 * @return	An integer indicating the index position of the occurrence found. If no match is found, the method returns -1.
		 */
		public static function lastIndexOf(target:ByteArray, pattern:*):int {
			return indexOf(target, pattern, -1);
		}

		/**
		 * Converts a String or an Array of byte values to a ByteArray object.
		 *
		 * @param	obj The String or Array to convert.
		 * @return	A ByteArray object.
		 */
		public static function toByteArray(obj:*):ByteArray {
			var ba:ByteArray;
			if (obj is ByteArray) {
				ba = obj;
			} else {
				ba = new ByteArray();
				if (obj is Array) {
					var i:int = obj.length;
					while (i--) {
						ba[i] = obj[i];
					}
				} else if (obj is String) {
					ba.writeUTFBytes(obj);
				} else {
					return null;
				}
			}
			return ba;
		}

		/**
		 * Compares two ByteArrays byte by byte.
		 * 
		 * @param 	ba1
		 * 			The first ByteArray to compare.
		 * 
		 * @param	ba2
		 * 			The second ByteArray to compare.
		 * 
		 * @return	True if the two contain exactly the same bytes, in the same order;
		 * 			False, otherwise.
		 */
		public static function testForEquality(ba1:ByteArray, ba2:ByteArray):Boolean {
			var size:uint = ba1.length;
			if (ba1.length == ba2.length) {
				ba1.position = 0;
				ba2.position = 0;
				while (ba1.position < size) {
					var v1:int = ba1.readByte();
					if (v1 != ba2.readByte()) {
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		/**
		 * Classical way of clonning an Object using native AMF serialization. Deemed to be the fastest
		 * way of clonning an object. Will not work for DisplayObject sub-classes, or for instances of
		 * classes that have mandatory constructor parameters. 
		 * 
		 * LIMITATIONS:
		 * - does not preserve references;
		 * - does not clone private members.
		 */
		public static function cloneObject (source : Object) : Object {
			if (source) {
				var srcClass : Class = source.constructor;
				var srcAlias : String = getQualifiedClassName(srcClass);
				registerClassAlias(srcAlias, srcClass);
				var b:ByteArray = new ByteArray();
				b.writeObject(source);
				b.position = 0;
				var clone:Object = b.readObject();
				return clone;
			}
			return null;			
		}
		
		/**
		 * Produces a String that pretty prints the bytes inside the given ByteArray, as hexadecimal numbers arranged
		 * in columns and rows.
		 * 
		 * @param	bytes
		 * 			The ByteArray whose bytes to print.
		 * 
		 * @param	numCols
		 * 			How many bytes to print per row. Optional, default to 32; `0`  is not an acceptable value and
		 * 			will trigger the default.
		 * 
		 * @param	separatorChar
		 * 			What char to use for separating columns. Optional, defaults to the TAB character; `empty string`
		 * 			is not an acceptable value and will trigger the default.
		 * 			
		 */
		public static function printBytes (bytes : ByteArray, numCols : uint = 32, 
										   separatorChar : String = '\t') : String {
			numCols = numCols || 32;
			separatorChar = separatorChar || CommonStrings.TAB;
			bytes.position = 0;
			var rows : Array = [];
			var row : Array = [];
			while (bytes.bytesAvailable) {
				if (row.length >= numCols) {
					rows.push (row.join (separatorChar));
					row.length = 0;
				}
				var byteHex : String = Strings.padLeft (
					bytes.readUnsignedByte().toString (16), CommonStrings.ZERO, 2);
				row.push (byteHex);
			}
			var lastRow : String = row.join (separatorChar);
			if (lastRow) {
				rows.push (lastRow);
			}
			return (rows.join (CommonStrings.NEW_LINE));
		}
	}
}
