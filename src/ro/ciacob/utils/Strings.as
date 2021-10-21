package ro.ciacob.utils {
	import ro.ciacob.utils.constants.CommonStrings;
	import ro.ciacob.utils.constants.HtmlEntities;
	import ro.ciacob.utils.constants.HtmlEntity;

	/**
	 *  Collection of string utilities carried out by various authors (Grant Skinner
	 *  started this collection). Added here my own stuff too.
	 *	Claudius Tiberiu Iacob <claudius.iacob@gmail.com>
	 *
	 * 	String Utilities class by Ryan Matsikas, Feb 10 2006
	 *	Visit www.gskinner.com for documentation, updates and more free code.
	 * 	You may distribute this code freely, as long as this comment block remains intact.
	 */
	/**
	 *
	 * @author Claudius
	 */
	public class Strings {
		
		public static const DEFAULT_UIDS_POOL:Object = {};
		
		/**
		 * The length, in chars, of an RFC4122 compliant Universally Unique Identifier.
		 * @see https://tools.ietf.org/html/rfc4122#section-3
		 */
		public static const UUID_LENGTH : uint = 36;

		/**
		 *
		 * @default
		 */
		public static const DEQUOTE_BACKTICK:int = 4;

		/**
		 *
		 * @default
		 */
		public static const DEQUOTE_DOUBLE:int = 1;
		/**
		 *
		 * @default
		 */
		public static const DEQUOTE_SINGLE:int = 2;
		
		public static function toPercentageFormat (value:Number) : String {
			return Math.round (value * 100).toString ().concat (CommonStrings.PERCENT);
		}
		
		/**
		 * Deprecated function, added here to keep old dependent code from breaking.
		 */
		public static function ensureNoTLF (text : String) : String {
			return text;
		}
		
		/**
		 * Adds a string to each element in a list of (other) strings. By default unshifts the new string
		 * on top of existing values, with no intervening space. An optional function can be passed in to 
		 * change that. It will receive the stamp and the current element (Strings), and should produce the 
		 * resulting (also a String).
		 * 
		 * @param $with The string to 'stamp' with.
		 * 
		 * @param all Array of strings. Any non-string will be converted to a string before stamping.
		 * 
		 * @return	Always a new Array, possibly empty (if `$with` or `all` are null/empty).
		 */
		public static function stamp ($with : String, all : Array, procedure : Function = null) : Array {
			var ret : Array = [];
			if ($with && all) {
				var i : int = 0
				var numElements : int = all.length;
				var el : String = null;
				for (i; i < numElements; i++) {
					el = (CommonStrings.EMPTY.concat(all[i]));
					if (procedure != null) {
						ret[i] = procedure ($with, el);
					} else {
						ret[i] = $with.concat(el);
					}
				}
			}
			return ret;
		}

		/**
		 *	Returns everything after the first occurrence of the provided (sub-)string in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function afterFirst(p_string:String, p_char:String):String {
			if (p_string == null) {
				return '';
			}
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) {
				return '';
			}
			idx += p_char.length;
			return p_string.substr(idx);
		}
		
		/**
		 * Returns given string pluralized by English grammar rules
		 */
		public static function pluralize (p_string : String) : String {
			return Inflect.pluralize(p_string);
		}

		/**
		 *	Returns everything after the last occurence of the provided character in p_string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function afterLast(p_string:String, p_char:String):String {
			if (p_string == null) {
				return '';
			}
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) {
				return '';
			}
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		 */
		public static function applyXMLFormatting(obj:*):String {
			var str:String = ('' + obj);
			var xml:XML;
			try {
				xml = XML(str);
				str = xml.toXMLString();
			} catch (e:Error) {
				// Just ignore everything that can't be parsed as XML.
			}
			return str;
		}

		/**
		 *	Returns everything before the first occurrence of the provided character in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beforeFirst(p_string:String, p_char:String):String {
			if (p_string == null) {
				return '';
			}
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) {
				return '';
			}
			return p_string.substr(0, idx);
		}

		/**
		 *	Returns everything before the last occurrence of the provided character in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beforeLast(p_string:String, p_char:String):String {
			if (p_string == null) {
				return '';
			}
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) {
				return '';
			}
			return p_string.substr(0, idx);
		}

		/**
		 *	Determines whether the specified string begins with the specified prefix.
		 *
		 *	@param p_string The string that the prefix will be checked against.
		 *
		 *	@param p_begin The prefix that will be tested against the string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beginsWith(p_string:String, p_begin:String):Boolean {
			if (p_string == null) {
				return false;
			}
			return p_string.indexOf(p_begin) == 0;
		}

		/**
		 *	Returns everything after the first occurance of p_start and before
		 *	the first occurrence of p_end in p_string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_start The character or sub-string to use as the start index.
		 *
		 *	@param p_end The character or sub-string to use as the end index.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function between(p_string:String, p_start:String, p_end:String):String {
			var str:String = '';
			if (p_string == null) {
				return str;
			}
			var startIdx:int = p_string.indexOf(p_start);
			if (startIdx != -1) {
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf(p_end, startIdx);
				if (endIdx != -1) {
					str = p_string.substr(startIdx, endIdx - startIdx);
				}
			}
			return str;
		}

		/**
		 *	Description, Utility method that intelligently breaks up your string,
		 *	allowing you to create blocks of readable text.
		 *	This method returns you the closest possible match to the p_delim paramater,
		 *	while keeping the text length within the p_len paramter.
		 *	If a match can't be found in your specified length an  '...' is added to that block,
		 *	and the blocking continues untill all the text is broken apart.
		 *
		 *	@param p_string The string to break up.
		 *
		 *	@param p_len Maximum length of each block of text.
		 *
		 *	@param p_delim delimter to end text blocks on, default = '.'
		 *
		 *	@returns Array
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function block(p_string:String, p_len:uint, p_delim:String = "."):Array {
			var arr:Array = new Array();
			if (p_string == null || !contains(p_string, p_delim)) {
				return arr;
			}
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp("[^" + escapePattern(p_delim) + "]+$");
			while (chrIndex < strLen) {
				var subString:String = p_string.substr(chrIndex, p_len);
				if (!contains(subString, p_delim)) {
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}

		/**
		 * Determines whether given string possibly contains meaningful information in it, that is,
		 * letters and/or numbers.
		 *
		 * @param p_string	The string to check
		 * @return	True: at least one alpha numeric char was found.
		 */
		public static function canHaveInfo(p_string:String):Boolean {
			return p_string != null && (((/\w/) as Object).test(p_string));
		}

		/**
		 *	Capitallizes the first word in a string or all words..
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_all (optional) Boolean value indicating if we should
		 *	capitalize all words or only the first.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function capitalize(p_string:String, ... args):String {
			var str:String = trimLeft(p_string);
			if (args[0] === true) {
				return str.replace(/^.|\b./g, _upperCase);
			} else {
				return str.replace(/(^\w)/, _upperCase);
			}
		}
		
		/**
		 *	The exact reverse of the `captitalize()` function.
		 */
		public static function uncapitalize(p_string:String, ... args):String {
			var str:String = trimLeft(p_string);
			if (args[0] === true) {
				return str.replace(/^.|\b./g, _lowerCase);
			} else {
				return str.replace(/(^\w)/, _lowerCase);
			}
		}

		/**
		 *	Determines whether the specified string contains any instances of p_char.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string we are looking for.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function contains(p_string:String, p_char:String):Boolean {
			if (p_string == null) {
				return false;
			}
			return p_string.indexOf(p_char) != -1;
		}

		/**
		 *	Determines the number of times a charactor or sub-string appears within the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string to count.
		 *
		 *	@param p_caseSensitive (optional, default is true) A boolean flag to indicate if the
		 *	search is case sensitive.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function countOf(p_string:String, p_char:String, p_caseSensitive:Boolean =
			true):uint {
			if (p_string == null) {
				return 0;
			}
			var char:String = escapePattern(p_char);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.match(new RegExp(char, flags)).length;
		}

		/**
		 * Changes "myString" into "my string".
		 *
		 * Note that this doesn't work well with strings containing non
		 * ASCII chars.
		 */
		public static function deCamelize(str:String):String {
			return str.replace(/((?<=[a-z0-9])[A-Z])/g, ' $1');
		}

		/**
		 *
		 * @param p_string
		 * @param mode
		 * @return
		 */
		public static function deQuote(p_string:String, mode:int = -1):String {
			if (mode == -1) {
				mode = (DEQUOTE_DOUBLE | DEQUOTE_SINGLE | DEQUOTE_BACKTICK);
			}
			var remDouble:Boolean = ((mode & DEQUOTE_DOUBLE) == DEQUOTE_DOUBLE);
			var remSingle:Boolean = ((mode & DEQUOTE_SINGLE) == DEQUOTE_SINGLE);
			var remBacktick:Boolean = ((mode & DEQUOTE_BACKTICK) == DEQUOTE_BACKTICK);
			if (remDouble) {
				p_string = p_string.replace(Patterns.DOUBLE_QUOTE_GLOBAL, '');
			}
			if (remSingle) {
				p_string = p_string.replace(Patterns.SINGLE_QUOTE_GLOBAL, '');
			}
			if (remBacktick) {
				p_string = p_string.replace(Patterns.BACKTICK_GLOBAL, '');
			}
			return p_string;
		}

		/**
		 *	Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		 *	The distance is the number of deletions, insertions, or substitutions required to
		 *	transform p_source into p_target.
		 *
		 *	@param p_source The source string.
		 *
		 *	@param p_target The target string.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function editDistance(p_source:String, p_target:String):uint {
			var i:uint;

			if (p_source == null) {
				p_source = '';
			}
			if (p_target == null) {
				p_target = '';
			}

			if (p_source == p_target) {
				return 0;
			}

			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			var j:uint;

			if (n == 0) {
				return m;
			}
			if (m == 0) {
				return n;
			}

			for (i = 0; i <= n; i++) {
				d[i] = new Array();
			}
			for (i = 0; i <= n; i++) {
				d[i][0] = i;
			}
			for (j = 0; j <= m; j++) {
				d[0][j] = j;
			}

			for (i = 1; i <= n; i++) {

				var s_i:String = p_source.charAt(i - 1);
				for (j = 1; j <= m; j++) {

					var t_j:String = p_target.charAt(j - 1);

					if (s_i == t_j) {
						cost = 0;
					} else {
						cost = 1;
					}

					d[i][j] = _minimum(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] +
						cost);
				}
			}
			return d[n][m];
		}

		/**
		 *	Determines whether the specified string ends with the specified suffix.
		 *
		 *	@param p_string The string that the suffix will be checked against.
		 *
		 *	@param p_end The suffix that will be tested against the string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function endsWith(p_string:String, p_end:String):Boolean {
			return p_string.lastIndexOf(p_end) == p_string.length - p_end.length;
		}

		/**
		 *
		 * @param p_pattern
		 * @return
		 */
		public static function escapePattern(p_pattern:String):String {
			return p_pattern.replace(/(\$|\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		/**
		 * Changes "MY_STRING" into "my string". Note that you should take all
		 * precautions for this functions NOT to generate dupplicates (it doesn't
		 * do it for you).
		 */
		public static function fromAS3ConstantCase(str:String):String {
			return str.replace(/_+/g, ' ').toLowerCase();
		}

		/**
		 * Generates a random id, which is unique in a given context.
		 * @param	uniqueIdsPool
		 * @param	idLength
		 * @deprecated Use `UUID` instead.
		 * @return
		 */
		public static function generateUniqueId(uniqueIdsPool:Object, idLength:int = 2):String {
			if (uniqueIdsPool == null) {
				uniqueIdsPool = DEFAULT_UIDS_POOL;
			}
			var ret:String = "";
			var chars:String = "abcdefghijklmnopqrstuvxwzABCDEFGHIJKLMNOPQRSTUVXWZ0123456789";
			var counter:int = 0;
			do {
				do {
					var char:String = chars.charAt(Math.round(Math.random() * (chars.length -
						1)));
					ret += char;
					counter++;
				} while (counter < idLength);
				if (uniqueIdsPool[ret] === undefined) {
					uniqueIdsPool[ret] = null;
					break;
				} else {
					var poolSize:Number = 0;
					for (var tmp:String in uniqueIdsPool) {
						poolSize++;
					}
					// FIX ME!
					// This code is faulty. Rewrite it.
					// var arePermutationsExhausted:Boolean = (poolSize == NumberUtil.computePermutationsNumber(chars.
					// 	length, idLength));
					// if (arePermutationsExhausted) {
					// 	throw(new Error('UID Generator: cannot generate an unique id; All combinations exhausted.'));
					// }
				}
			} while (true);
			return ret;
		}
		
		/**
		 * Fast UUID generator, RFC4122 version 4 compliant.
		 * 
		 * Adapted from:
		 * @author Jeff Ward (jcward.com).
		 * @license MIT license
		 * @link http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript/21963136#21963136
		 **/
		public static function get UUID () : String {
			var lut : Array = [];
			var i : int = 0;
			for (i; i < 256; i++) {
				lut[i] = ((i < 16)? '0' : '') + (i).toString (16);
			}
			var d0 : Number = Math.random() * 0xffffffff|0;
			var d1 : Number = Math.random() * 0xffffffff|0;
			var d2 : Number = Math.random() * 0xffffffff|0;
			var d3 : Number = Math.random() * 0xffffffff|0;
			return (lut[d0&0xff]+lut[d0>>8&0xff]+lut[d0>>16&0xff]+lut[d0>>24&0xff]+'-'+
			lut[d1&0xff]+lut[d1>>8&0xff]+'-'+lut[d1>>16&0x0f|0x40]+lut[d1>>24&0xff]+'-'+
			lut[d2&0x3f|0x80]+lut[d2>>8&0xff]+'-'+lut[d2>>16&0xff]+lut[d2>>24&0xff]+
			lut[d3&0xff]+lut[d3>>8&0xff]+lut[d3>>16&0xff]+lut[d3>>24&0xff]);
		}
		
		/**
		 * Generates a RFC4122 version 4 compliant globally unique number, with a collision chance lower than 1 in a million.
		 * Credits: http://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript
		 */
		public static function generateRFC4122GUID () : String {
			var template : String = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
			return template.replace (/[xy]/g, 
				function (c : String, ... rest) : String {
				var r : Number = (Math.random() * 16 | 0);
				var v : Number = (c == 'x')? r : (r & 0x3 | 0x8);
				return v.toString (16);
			});
		}

		/**
		 *	Determines whether the specified string contains text.
		 *
		 *	@param p_string The string to check.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function hasText(p_string:String):Boolean {
			var str:String = removeExtraWhitespace(p_string);
			return !!str.length;
		}

		/**
		 * Convenience method to check whether some given string "is" or "equals" any of
		 * a given set of alternatives.
		 *
		 * @param	p_string
		 * 			The string to check.
		 *
		 * @param	p_alternatives
		 * 			The alternatives to check against.
		 *
		 * @return	True if there is at least one match, false otherwise.
		 */
		public static function isAny(p_string:String, ... p_alternatives):Boolean {
			for (var i:int = 0; i < p_alternatives.length; i++) {
				var alternative:String = (p_alternatives[i] as String);
				if (p_string == alternative) {
					return true;
				}
			}
			return false;
		}

		/**
		 *	Determines whether the specified string contains any characters.
		 *
		 *	@param p_string The string to check
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function isEmpty(p_string:String):Boolean {
			if (p_string == null) {
				return true;
			}
			return !p_string.length;
		}

		/**
		 *	Determines whether the specified string is numeric.
		 *
		 *	@param p_string The string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function isNumeric(p_string:String):Boolean {
			if (p_string == null) {
				return false;
			}
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(p_string);
		}

		/**
		 * Pads p_string with specified character to a specified length from the left.
		 *
		 *	@param p_string String to pad
		 *
		 *	@param p_padChar Character for pad.
		 *
		 *	@param p_length Length to pad to.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) {
				s = p_padChar + s;
			}
			return s;
		}

		/**
		 * Pads p_string with specified character to a specified length from the right.
		 *
		 *	@param p_string String to pad
		 *
		 *	@param p_padChar Character for pad.
		 *
		 *	@param p_length Length to pad to.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function padRight(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) {
				s += p_padChar;
			}
			return s;
		}
		
		/**
		 * Pads `p_string` simetrically, on both left and right, effectivelly "centering" it using given chars.
		 * 
		 * @param p_string The string to pad.
		 * 
		 * @param p_padChar The char used for padding. Optional, defaults to the empty space.
		 * 
		 * @param p_length The length of either right or left padding - NOTE that this is very different than
		 * 				   the similarily named argument of `padLeft` or `padRight`. Optional, defaults to `1`.
		 * 
		 * 				   // Example:
		 * 				   simPad ('My Heading', '-', 3); // ---My Heading---
		 * 
		 * @return The new string. 
		 */
		public static function simPad (p_string : String, p_padChar : String = null, p_length : uint = 0) : String {
			
			if (p_padChar == null) {
				p_padChar = CommonStrings.SPACE;
			}
			
			if (p_length == 0) {
				p_length = 1;
			}
			
			p_string = padLeft (p_string, p_padChar, p_string.length + p_length);
			p_string = padRight (p_string, p_padChar, p_string.length + p_length);
			return p_string;
		}

		/**
		 *	Properly cases' the string in "sentence format".
		 *
		 *	@param p_string The string to check
		 *
		 *	@returns String.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function properCase(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			var str:String = p_string.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}

		/**
		 *	Escapes all of the characters in a string to create a friendly "quotable" sting
		 *
		 *	@param p_string The string that will be checked for instances of remove
		 *	string
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function quote(p_string:String):String {
			var regx:RegExp = /[\\"\r\n]/g;
			return '"' + p_string.replace(regx, _quote) + '"'; //"
		}

		/**
		 *	Removes instances of the remove string in the input string.
		 *
		 *	@param p_string The string that will be checked for instances of remove
		 *	string
		 *
		 *	@param p_remove The string that will be removed from the input string.
		 *
		 *	@param p_caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		 *
		 *  @param p_firstOnly An optional boolean indicating whether to remove the first occurence only, or all of them.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function remove(p_string:String, p_remove:String, p_caseSensitive:Boolean =
			true, p_firstOnly:Boolean = false):String {
			if (p_string == null) {
				return '';
			}
			var rem:String = escapePattern(p_remove);
			var gFlag:String = (!p_firstOnly) ? 'g' : '';
			var flags:String = (!p_caseSensitive) ? 'i' : '';
			flags += gFlag;
			return p_string.replace(new RegExp(rem, flags), '');
		}

		/**
		 *	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		 *	specified string.
		 *
		 *	@param p_string The String whose extraneous whitespace will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function removeExtraWhitespace(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			var str:String = trim(p_string);
			return str.replace(/\s+/g, ' ');
		}

		/**
		 */
		public static function removeNewLines(obj:*):String {
			var str:String = ('' + obj);
			str = Strings.trim(str);
			str = str.replace(/[\n\r]/g, ' ');
			str = str.replace(/\s{2,}/g, ' ');
			return str;
		}

		/**
		 * Repeats a given string a number of times and returns the result.
		 *
		 * @param	string
		 * 			String to repeat.
		 * @param	times
		 * 			The number of times to repeat.
		 * @return	The given string, concatenated with itself the given number of times.
		 */
		public static function repeatString(string:String, times:int):String {
			var ret:Array = [];
			for (var i:int = 0; i < times; i++) {
				ret.push(string);
			}
			return ret.join('');
		}

		/**
		 *	Returns the specified string in reverse character order.
		 *
		 *	@param p_string The String that will be reversed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function reverse(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.split('').reverse().join('');
		}

		/**
		 *	Returns the specified string in reverse word order.
		 *
		 *	@param p_string The String that will be reversed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function reverseWords(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.split(/\s+/).reverse().join('');
		}

		/**
		 *	Determines the percentage of similiarity, based on editDistance
		 *
		 *	@param p_source The source string.
		 *
		 *	@param p_target The target string.
		 *
		 *	@returns Number
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function similarity(p_source:String, p_target:String):Number {
			var ed:uint = editDistance(p_source, p_target);
			var maxLen:uint = Math.max(p_source.length, p_target.length);
			if (maxLen == 0) {
				return 100;
			} else {
				return (1 - ed / maxLen) * 100;
			}
		}

		/**
		 *	Remove's all < and > based tags from a string
		 *
		 *	@param p_string The source string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function stripTags(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/<\/?[^>]+>/igm, '');
		}

		/**
		 *	Swaps the casing of a string.
		 *
		 *	@param p_string The source string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function swapCase(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/(\w)/, _swapCase);
		}
		
		/**
		 * Peels given HTML-like markup, i.e., remove outer tags that fully encompass the content. 
		 * Example (line breaks and indentation added for legibility):
		 * 
		 * peelMarkup ('<TEXTFORMAT LEADING="2">
		 * 					<P ALIGN="LEFT">
		 * 						<FONT FACE="Arial" SIZE="14" COLOR="#FFFFFF" LETTERSPACING="0" KERNING="0">
		 * 							My text
		 * 						</FONT>
		 * 					</P>
		 * 				</TEXTFORMAT>', 2);
		 * 
		 * Output: <FONT FACE="Arial" SIZE="14" COLOR="#FFFFFF" LETTERSPACING="0" KERNING="0">
		 * 				My text
		 * 		   </FONT>
		 * 
		 * @param markup The markup to process, as a string. Must be well-formed XML.
		 * 
		 * @param maxPeelLevels The maximum number of outer tags to "peel". Optional, if omitted, will
		 * "peel" all outer tags having one child or less.
		 */
		public static function peelMarkup (markup:String, maxPeelLevels:int = int.MAX_VALUE):String {
			var output : String = markup;
			if (maxPeelLevels > 0) {
				var xml:XML;
				try {
					XML.ignoreWhitespace = true;
					XML.ignoreComments = true;
					XML.ignoreProcessingInstructions = true;
					xml = XML(output);
					while (maxPeelLevels > 0) {
						if (xml.children().length() > 1) {
							break;
						}
						xml = xml.children()[0];
						maxPeelLevels--;
					}
					output = xml.toXMLString();
					output = Strings.removeNewLines(output);
				} catch (e:Error) {
					// Could not create XML object; revert to original string.
					output = markup;
				}
			}
			return output;
		}

		/**
		 * Changes "myString", or "my string" into "MY_STRING".
		 *
		 * Note that you should take all precautions for this functions NOT to
		 * generate dupplicates (it doesn't do it for you).
		 */
		public static function toAS3ConstantCase(str:String):String {
			str = deCamelize(str);
			str = str.replace(/\W/g, '_').replace(/_{2,}/g, '_').toUpperCase();
			return str;
		}

		/**
		 * Represents a given string as a succession of hexadecimal
		 * digits, notated as /(0x)?[0-9a-f]+/ . This is useful for some command line
		 * tools, which require input as hexadecimal numbers.
		 *
		 * @param	p_string
		 * 			The string to convert
		 *
		 * @param	prepend0X
		 * 			Whether to add a leading '0x' prefix to each hexadecimal digit
		 * 			(i.e., "0xff" instead of just "ff"); Defaults to false.
		 *
		 * @param	addSpaceBetween
		 * 			Whether to add a whitespace between the resulting
		 * 			hexadecimal numbers, or stick them together. Defaults to false.
		 *
		 * @return	A string containing hexadecimal numbers. Sample output: "86BD69AB", or "86 BD 69 AB",
		 * 			or "0x860xBD0x690xAB", or "0x86 0xBD 0x69 0xAB".
		 */
		public static function toHexadecimalNotation(p_string:String, prepend0X:Boolean = false,
			addSpaceBetween:Boolean = false):String {
			var ret:Array = [];
			if (p_string != null) {
				for (var i:int = 0; i < p_string.length; i++) {
					var char:Number = p_string.charCodeAt(i);
					ret.push(String(prepend0X ? '0x' : '').concat(char.toString(16)));
				}
			}
			return ret.join(addSpaceBetween ? ' ' : '');
		}


		/**
		 *	Removes whitespace from the front and the end of the specified
		 *	string.
		 *
		 *	@param p_string The String whose beginning and ending whitespace will
		 *	will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trim(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/^\s+|\s+$/g, '');
		}

		/**
		 *	Removes whitespace from the front (left-side) of the specified string.
		 *
		 *	@param p_string The String whose beginning whitespace will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trimLeft(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/^\s+/, '');
		}

		/**
		 *	Removes whitespace from the end (right-side) of the specified string.
		 *
		 *	@param p_string The String whose ending whitespace will be removed.
		 *
		 *	@returns String	.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trimRight(p_string:String):String {
			if (p_string == null) {
				return '';
			}
			return p_string.replace(/\s+$/, '');
		}

		/**
		 *	Returns a string truncated to a specified length with optional suffix
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_len The length the string should be shortend to
		 *
		 *	@param p_suffix (optional, default=...) The string to append to the end of the truncated string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function truncate(p_string:String, p_len:uint, p_suffix:String = "..."):String {
			if (p_string == null) {
				return '';
			}
			p_len -= p_suffix.length;
			var trunc:String = p_string;
			if (trunc.length > p_len) {
				trunc = trunc.substr(0, p_len);
				if ((/[^\s]/ as Object).test(p_string.charAt(p_len))) {
					trunc = trimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += p_suffix;
			}

			return trunc;
		}

		/**
		 *	Determins the number of words in a string.
		 *
		 *	@param p_string The string.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function wordCount(p_string:String):uint {
			if (p_string == null) {
				return 0;
			}
			return p_string.match(/\b\w+\b/g).length;
		}

		/**
		 * Similar to the "wrap()" function in PHP. Wraps the given string into lines (most usefull for logs
		 * or consoles). Note that there is no "breakWord" argument. Words longer than maximum line length
		 * will always be broken.
		 *
		 * @param p_string		The strin gto wrap.
		 *
		 * @param p_maxLen		The maximum length of a line, in chars. Optional, defaults to 70.
		 *
		 * @param p_delimiters	An array with chars (strings of length "one") that can be used as delimiters
		 * 						for breaking the string. Optional, defaults to one whitespace.
		 *
		 * @return				An array with lines of text. Returns an empty array for null or empty strings
		 * 						(white space don't count).
		 */
		public static function wrap(p_string:String, p_maxLen:int = 70, p_delimiters:Array =
			null):Array {
			var lines:Array = [];
			// Default delimiter is a space
			if (p_delimiters == null) {
				p_delimiters = [' '];
			}
			p_string = trim(p_string);
			if (!isEmpty(p_string)) {
				// Tokenize the string
				var tokens:Array = [];
				var currToken:Array = [];
				for (var i:int = 0; i < p_string.length; i++) {
					var currChar:String = p_string.charAt(i);
					currToken.push(currChar);
					var isDelimiter:Boolean;
					for (var j:int = 0; j < p_delimiters.length; j++) {
						if (currChar == p_delimiters[j]) {
							isDelimiter = true;
							break;
						}
					}
					if (isDelimiter || (i == p_string.length - 1)) {
						isDelimiter = false;
						while (currToken.length > p_maxLen) {
							var slice:Array = currToken.slice(0, p_maxLen);
							tokens.push(slice);
							currToken.splice(0, p_maxLen);
						}
						if (currToken.length > 0) {
							tokens.push(currToken);
						}
						currToken = [];
					}
				}
				// Attempt to place tokens in lines
				var line:String = '';
				while (tokens.length > 0) {
					var token:Array = tokens[0];
					if (line.length + token.length <= p_maxLen) {
						line += token.join('');
						tokens.splice(0, 1);
					} else {
						if (line.length > 0) {
							lines.push(line);
							line = '';
						}
					}
				}
				if (line.length > 0) {
					lines.push(line);
				}
			}
			return lines;
		}

		private static function _minimum(a:uint, b:uint, c:uint):uint {
			return Math.min(a, Math.min(b, Math.min(c, a)));
		}

		private static function _quote(p_string:String, ... args):String {
			switch (p_string) {
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		private static function _swapCase(p_char:String, ... args):String {
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch (p_char) {
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}

		private static function _upperCase(p_char:String, ... args):String {
			return p_char.toUpperCase();
		}
		
		private static function _lowerCase(p_char:String, ... args):String {
			return p_char.toLowerCase();
		}

		/*  sprintf(3) implementation in ActionScript 3.0.
		*
		*  Author:  Manish Jethani (manish.jethani@gmail.com)
		*  Date:    April 3, 2006
		*  Version: 0.1
		*
		*  Copyright (c) 2006 Manish Jethani
		*
		*  Permission is hereby granted, free of charge, to any person obtaining a
		*  copy of this software and associated documentation files (the "Software"),
		*  to deal in the Software without restriction, including without limitation
		*  the rights to use, copy, modify, merge, publish, distribute, sublicense,
		*  and/or sell copies of the Software, and to permit persons to whom the
		*  Software is furnished to do so, subject to the following conditions:
		*
		*  The above copyright notice and this permission notice shall be included in
		*  all copies or substantial portions of the Software.
		*
		*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		*  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		*  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
		*  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
		*  DEALINGS IN THE SOFTWARE.
		*/


		/*  sprintf(3) implementation in ActionScript 3.0.
		*
		*  http://www.die.net/doc/linux/man/man3/sprintf.3.html
		*
		*  The following flags are supported: '#', '0', '-', '+'
		*
		*  Field widths are fully supported.  '*' is not supported.
		*
		*  Precision is supported except one difference from the standard: for an
		*  explicit precision of 0 and a result string of "0", the output is "0"
		*  instead of an empty string.
		*
		*  Length modifiers are not supported.
		*
		*  The following conversion specifiers are supported: 'd', 'i', 'o', 'u', 'x',
		*  'X', 'f', 'F', 'c', 's', '%'
		*
		*  Report bugs to manish.jethani@gmail.com
		*/
		public static function sprintf(format:String, ... args):String {
			var result:String = "";

			var length:int = format.length;
			for (var i:int = 0; i < length; i++) {
				var c:String = format.charAt(i);

				if (c == "%") {
					var next:*;
					var str:String;
					var pastFieldWidth:Boolean = false;
					var pastFlags:Boolean = false;

					var flagAlternateForm:Boolean = false;
					var flagZeroPad:Boolean = false;
					var flagLeftJustify:Boolean = false;
					var flagSpace:Boolean = false;
					var flagSign:Boolean = false;

					var fieldWidth:String = "";
					var precision:String = "";

					c = format.charAt(++i);

					while (c != "d" && c != "i" && c != "o" && c != "u" && c != "x" && c !=
						"X" && c != "f" && c != "F" && c != "c" && c != "s" && c != "%") {
						if (!pastFlags) {
							if (!flagAlternateForm && c == "#")
								flagAlternateForm = true;
							else if (!flagZeroPad && c == "0")
								flagZeroPad = true;
							else if (!flagLeftJustify && c == "-")
								flagLeftJustify = true;
							else if (!flagSpace && c == " ")
								flagSpace = true;
							else if (!flagSign && c == "+")
								flagSign = true;
							else
								pastFlags = true;
						}

						if (!pastFieldWidth && c == ".") {
							pastFlags = true;
							pastFieldWidth = true;

							c = format.charAt(++i);
							continue;
						}

						if (pastFlags) {
							if (!pastFieldWidth)
								fieldWidth += c;
							else
								precision += c;
						}

						c = format.charAt(++i);
					}

					switch (c) {
						case "d":
						case "i":
							next = args.shift();
							str = String(Math.abs(int(next)));

							if (precision != "")
								str = padLeft(str, "0", int(precision));

							if (int(next) < 0)
								str = "-" + str;
							else if (flagSign && int(next) >= 0)
								str = "+" + str;

							if (fieldWidth != "") {
								if (flagLeftJustify)
									str = padRight(str, " ", int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = padLeft(str, "0", int(fieldWidth));
								else
									str = padLeft(str, " ", int(fieldWidth));
							}

							result += str;
							break;

						case "o":
							next = args.shift();
							str = uint(next).toString(8);

							if (flagAlternateForm && str != "0")
								str = "0" + str;

							if (precision != "")
								str = padLeft(str, "0", int(precision));

							if (fieldWidth != "") {
								if (flagLeftJustify)
									str = padRight(str, " ", int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = padLeft(str, "0", int(fieldWidth));
								else
									str = padLeft(str, " ", int(fieldWidth));
							}

							result += str;
							break;

						case "u":
							next = args.shift();
							str = uint(next).toString(10);

							if (precision != "")
								str = padLeft(str, "0", int(precision));

							if (fieldWidth != "") {
								if (flagLeftJustify)
									str = padRight(str, " ", int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = padLeft(str, "0", int(fieldWidth));
								else
									str = padLeft(str, " ", int(fieldWidth));
							}

							result += str;
							break;

						case "X":
							var capitalise:Boolean = true;
						case "x":
							next = args.shift();
							str = uint(next).toString(16);

							if (precision != "")
								str = padLeft(str, "0", int(precision));

							var prepend:Boolean = flagAlternateForm && uint(next) != 0;

							if (fieldWidth != "" && !flagLeftJustify && flagZeroPad && precision ==
								"")
								str = padLeft(str, "0", prepend ? int(fieldWidth) - 2 : int(fieldWidth));

							if (prepend)
								str = "0x" + str;

							if (fieldWidth != "") {
								if (flagLeftJustify)
									str = padRight(str, " ", int(fieldWidth));
								else
									str = padLeft(str, " ", int(fieldWidth));
							}

							if (capitalise)
								str = str.toUpperCase();

							result += str;
							break;

						case "f":
						case "F":
							next = args.shift();
							str = Math.abs(Number(next)).toFixed(precision != "" ? int(precision) :
								6);

							if (int(next) < 0)
								str = "-" + str;
							else if (flagSign && int(next) >= 0)
								str = "+" + str;

							if (flagAlternateForm && str.indexOf(".") == -1)
								str += ".";

							if (fieldWidth != "") {
								if (flagLeftJustify)
									str = padRight(str, " ", int(fieldWidth));
								else if (flagZeroPad && precision == "")
									str = padLeft(str, "0", int(fieldWidth));
								else
									str = padLeft(str, " ", int(fieldWidth));
							}

							result += str;
							break;

						case "c":
							next = args.shift();
							str = String.fromCharCode(int(next));

							if (fieldWidth != "") {
								if (flagLeftJustify)
									str = padRight(str, " ", int(fieldWidth));
								else
									str = padLeft(str, " ", int(fieldWidth));
							}

							result += str;
							break;

						case "s":
							next = args.shift();
							str = String(next);

							if (precision != "")
								str = str.substring(0, int(precision));

							if (fieldWidth != "") {
								if (flagLeftJustify)
									str = padRight(str, " ", int(fieldWidth));
								else
									str = padLeft(str, " ", int(fieldWidth));
							}

							result += str;
							break;

						case "%":
							result += "%";
					}
				} else {
					result += c;
				}
			}

			return result;
		}
		
		/**
		 * Produces a "comma and a space" separated listing of the elements in the `source` Array,
		 * with the last one being separated by the provided `finalToken` (except for the case where
		 * the `source` contains exactly one element.
		 * 
		 * @param source An Array containing the items to list.
		 * 
		 * @param finalToken A string to use as a separator before the last item in a `source`
		 * 					 containing two or more items. Optional, defaults to "and".
		 */
		public static function list (source : Array, finalToken : String = '') : String {
			
			finalToken = trim (finalToken);
			if (isEmpty (finalToken)) {
				finalToken = CommonStrings.AND;
			}
			finalToken = simPad (finalToken);
			
			var buffer : Array = [],
				item : String = null,
				separator : String = CommonStrings.COMMA_SPACE,
				i : int = 0,
				numItems : int = source.length;
			
			for (i; i < numItems; i++) {
				item = Strings.trim (source [i]);
				if (!isEmpty(item)) {
					buffer.push ( (item));
					if (i == numItems - 2) {
						separator = finalToken;
					}
					if (i < numItems - 1) {
						buffer.push (separator);
					}
				}
			}
			
			return buffer.join (CommonStrings.EMPTY);
		}
		
		/**
		 * Parses HTML entities from given `text`, and replaces entity with the actual char it stands for, e.g.:
		 * 
		 * 		htmlEntitiesDecode ('&lt;b&gt;Photo &amp; Video&lt;/b&gt;'); // <b>Photo & Video</b>
		 * 
		 * @param text The text to process.
		 * 
		 * @param subset The subset of named HTML etities to look for, as an Array of 
		 * 				 `ro.ciacob.utils.constants.HtmlEntity` instances. Optional, defaults to all values defined
		 * 				 in constants class `ro.ciacob.utils.constants.HtmlEntities`.
		 * 
		 * @param parseUnListed Whether to consider other HTML entities as well. When set to true, all numeric
		 * 						HTML entities found will be parsed as well. Optional, defaults to `true`.
		 * 
		 * @param removeUnKnown Ignored if `parseUnListed` was set to false. If true, removes all named HTML entities
		 * 						that were not included in `subset`. Otherwise, they're left untouched. Optional, 
		 * 						defaults to `true`.
		 */
		public static function htmlEntitiesDecode (
			
			text : String, 
			subset : Array = null, 
			parseUnListed : Boolean = true, 
			removeUnKnown : Boolean = true
			
		) : String {
			
			if (subset == null) {
				subset = HtmlEntities.all;
			}
			
			var knownEntities : Array = subset.concat (),
				entity : HtmlEntity = null,
				proxy : String = null,
				equivalent : String = null,
				pattern : RegExp = null;
			
			// Parse known named entities
			while (knownEntities.length > 0) {
				entity = (knownEntities.shift () as HtmlEntity);
				proxy = CommonStrings.AMPERSAND.concat (entity.name, CommonStrings.SEMICOLON);
				equivalent = String.fromCharCode (entity.number);
				pattern = new RegExp ( escapePattern (proxy), 'gi' );
				text = text.replace (pattern, equivalent);
				
			}
			
			if (parseUnListed) {
				
				// If requested, parse all numerical entities
				text = text.replace (Patterns.NUMERIC_HTML_ENTITY_GLOBAL, _parseNumericHtmlEntity);
				
				// If requested, remove unknown named entities
				text = text.replace (Patterns.GENERIC_HTML_ENTITY_GLOBAL, CommonStrings.EMPTY);
			}
			
			return text;
		}
		
		private static function _parseNumericHtmlEntity (match : String, ...rest : Array) : String {
			var unicodeValue : String = null;
			
			// Attempt to deliver the char coresponding to the entity number
			if (rest != null && rest.length > 2) {
				unicodeValue = trim (rest[0]);
				if (!isEmpty (unicodeValue)) {
					return String.fromCharCode (unicodeValue);
				}
			}
			
			// Fallback
			return match;
		}
		
		/**
		 * Parses a String containing Microsoft C style arguments into an array of Strings,
		 * where each String contains only one argument. The following rules (copied from 
		 * "https://msdn.microsoft.com/en-us/library/a1y7w461.aspx") were implemented and
		 * thoroughly tested using the test cases there provided:
		 * 
		 * Arguments are delimited by white space, which is either a space or a tab.
		 * 
		 * A string surrounded by double quotation marks is interpreted as a single argument,
		 * regardless of white space contained within. A quoted string can be embedded in an
		 * argument. Note that the caret (^) is not recognized as an escape character or
		 * delimiter.
		 * 
		 * A double quotation mark preceded by a backslash, \", is interpreted as a literal
		 * double quotation mark (").
		 * 
		 * Backslashes are interpreted literally, unless they immediately precede a double
		 * quotation mark.
		 * 
		 * If an even number of backslashes is followed by a double quotation mark, then one
		 * backslash (\) is placed in the argv array for every pair of backslashes (\\), and
		 * the double quotation mark (") is interpreted as a string delimiter.
		 * 
		 * If an odd number of backslashes is followed by a double quotation mark, then one
		 * backslash (\) is placed in the argv array for every pair of backslashes (\\) and 
		 * the double quotation mark is interpreted as an escape sequence by the remaining 
		 * backslash, causing a literal double quotation mark (") to be placed in argv.
		 * 
		 * @param argsString
		 * 		A string containing one or more arguments formatted according to the above
		 * 		rules.
		 * 
		 * @param stripLeadingSlash
		 * 		Whether to strip off the first character from EACH of the resulting arguments,
		 * 		if it is a forward slash (/). Will leave the arguments untouched if a forward
		 * 		slash is not present of EVERY resulting argument.
		 * 
		 * @param Individual arguments, as an Array of Strings
		 */
		public static function parseArgsMsCStyle (argsString : String, stripLeadingSlash : Boolean = false) : Array {
			var ret : Array = [];
			var currArgBuffer : Array = [];
			var isInsideQuotedSequence : Boolean = false;
			var numBackSlashes : int = 0;
			for (var i : int = 0; i < argsString.length; i++) {
				var c : String = argsString.charAt(i);
				// A: we have a backslash
				if (c == '\x5c') {
					// If we are not inside of a quoted sequence, we count it as
					// a control char
					numBackSlashes++;
				}
					// B: we have anything else than a backslash
				else {
					// If we previously collected one or more backslashes, we need to handle them
					if (numBackSlashes > 0) {
						// We need to treat the collected backslashes differently, based on whether they
						// are followed by a double quote, or not
						if (c == '\x22') {
							var numBackslashesToInsert : int = 0;
							if (numBackSlashes % 2 == 0) {
								// If we have collected an even number of backslashes
								numBackslashesToInsert = (numBackSlashes / 2);
								numBackSlashes = 0;
							} else {
								// If we have collected an odd number of backslashes
								numBackslashesToInsert = ((numBackSlashes - 1) / 2);
								numBackSlashes = 1;
							}
							while (numBackslashesToInsert > 0) {
								currArgBuffer.push('\x5c');
								numBackslashesToInsert--;
							}
						} else {
							while (numBackSlashes > 0) {
								currArgBuffer.push('\x5c');
								numBackSlashes--;
							}
						}
					}
					// B.1: we have a double quote; we need to watch out for a preceeding backslash
					if (c == '\x22') {
						// If the double quote is not preceeded by a backslash, it will toggle
						// the `isInsideQuotedSequence`flag state
						if (numBackSlashes == 0) {
							isInsideQuotedSequence = !isInsideQuotedSequence;
						}
							// otherwise, it will be includded into the current argument, as are 
							// regular chars
						else {
							currArgBuffer.push(c);
							numBackSlashes = 0;
						}
					}
						// B.2: we have a whitespace; we need to watch out for being inside of a 
						// quoted sequence
					else if (c == '\x20') {
						// If we are not inside of a quoted sequence, we reset counters 
						// and seal and commit the current argument
						if (!isInsideQuotedSequence) {
							numBackSlashes = 0;
							ret.push(currArgBuffer.join(''));
							currArgBuffer.length = 0;
						}
							// otherwise, the whitespace will be includded into the current argument, as are 
							// regular chars
						else {
							currArgBuffer.push(c);
							numBackSlashes = 0;
						}
					} else {
						// B.3: we have any other type of char; just include it into the current argument
						currArgBuffer.push(c);
						numBackSlashes = 0;
					}
				}
			}
			// Salvaging the argument comming after the last space
			if (currArgBuffer.length > 0) {
				ret.push(currArgBuffer.join(''));
			}
			// Stripping off the first char if (1) we were requested to do so, (2) it is a forward slash, and 
			// (3) such a forward slash is found at the beginning of EACH of the resulting arguments
			if (stripLeadingSlash) {
				var strippedArgs : Array = [];
				for (var j:int = 0; j < ret.length; j++) {
					var arg : String = (ret[j] as String);
					var firstChar : String = (arg.charAt(0) as String);
					if (firstChar != '\x2f') {
						strippedArgs = null;
						break;
					}
					strippedArgs.push (arg.substr(1));
				}
				if (strippedArgs) {
					return strippedArgs;
				}
			}
			return ret;
		}
		
		
		
	}
}
