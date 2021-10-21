package ro.ciacob.utils {
import ro.ciacob.math.Fraction;

public class NumberUtil {

		/**
		 * Returns a random integer includded in a given closed interval [A, B], e.g.:
		 * `getRandomInteger (3, 5)` will return 3, 4 or 5.
		 *
		 * @param	limitA
		 * 			One of the two ends of the interval;
		 *
		 * @param	limitB
		 * 			The other of the two ends of the interval;
		 * 
		 * @param	randomFunction
		 * 			Optional, defaults to `Math.random()`.
		 * 			A function that is able to generate random floating point values between
		 * 			`0` and `1`, includding both ends. Provides one the ability to use a 
		 * 			seeded PRNG in lieu of the non-seeded random generator of the Math class.
		 *
		 * @return	An unsigned, random integer.
		 */
		public static function getRandomInteger (limitA : uint, limitB : uint, randomFunction : Function = null) : uint {
			if (randomFunction == null) {
				randomFunction = Math.random;
			}
			var poolLength : uint = (Math.abs (limitA - limitB) as uint) + 1;
			var lowest : uint = Math.min (limitA, limitB);
			return (Math.floor (randomFunction () * poolLength) + lowest) as uint;
		}

		/**
		 * addCommas(number:Number) : String Converts the parameter to a string and formats the number
		 * value correctly with decmals where necessary.
		 *
		 * @usage  var comma_num:String = addCommas(33222111); trace(comma_num); // Outputs 33,222,111
		 *
		 * @prams   number:Number   The number to convert into a string and insert all the commas. The
		 *         function does not directly modify any variables.
		 * 
		 * @return   String The orginal number value, but with all necessary commas.
		 */
		public static function addCommas (number : Number) : String {
			var num : String = String (number);
			if (num.length > 3) {
				var mod : Number = num.length % 3;
				var output : String = num.substr (0, mod);
				for (var i : Number = mod; i < num.length; i += 3) {
					output += ((mod == 0 && i == 0) ? "" : ",") + num.substr (i, 3);
				}
				return output;
			}
			return num;
		}

		/**
		 * distanceBetween : Number Calculates the real distance between 2 points.
		 * @usage
		 * @prams   x1 : Number      The x of the first point.
		 * @prams   y1 : Number      The y of the first point.
		 * @prams   x2 : Number      The x of the second point.
		 * @prams   y2 : Number    	 The y of the second point.
		 *
		 * @return   Number         pixel distance between the two objects
		 */
		public static function distanceBetween (x1 : Number, y1 : Number, x2 : Number, y2 : Number) : Number {
			var xx : Number = x2 - x1;
			var yy : Number = y2 - y1;
			return Math.abs (Math.sqrt ((xx * xx) + (yy * yy)));
		}

		/**
		 * A function that returns n! (factorial) from a positive integer 'n'. This is also the 
		 * maximum number of permutations that can be made inside a set having 'n' elements.
		 * NOTE: "nShriek" is an informal way of saying "nFactorial".
		 *
		 * @usage    trace(factorial(0));    //  outputs 1 
		 * 			 trace(factorial(1000)); //  outputs Infinity 
		 * 			 trace(factorial(4);     //  outputs 24
		 *
		 * @prams    num:Number    The number to analyze.
		 * @return   Number        n! or the amount of combinations possible.
		 */
		public static function factorial (num : Number) : Number {
			var nShriek : Number = num;
			if (num > 0) {
				while (num > 1) {
					num--;
					nShriek *= num;
				}
				return nShriek;
			} else if (!num) {
				return 1;
			}
			return 1;
		}

		/**
		 * A function for approximating the derivative (rate of change) of a function at a point.
		 *
		 * @usage  function f(x) : Number { return Math.pow (x, 2) } 
		 * 		   trace (numDerive (f, 3)); // 6.00000100092757
		 * 		   trace (numDerive (f, 0)); // 1e-6
		 *
		 * @prams   f:Function The function to derivate.
		 * @prams   x:Number   The x point of where to derivate.
		 * @return  Number     The derivative of f at x.
		 *
		 */
		public static function numDerive (f : Function, x : Number) : Number {
			var h : Number = 0.00001;
			return (f (x + h) - f (x)) / h;
		}

		/**
		 * Description: A function that returns the parity of a number. In mathematics, parity refers
		 * to whether a number is odd or even.
		 *
		 * @usage   trace(numParity(89)); // outputs odd
		 * 
		 * @prams   num:Number The number to analyze.
		 * 
		 * @return  String If the number is found odd, "odd" will be returned, otherwise, if the
		 *          number is found even, "even" will be returned.
		 */
		public static function numParity (num : uint) : String {
			var parity : String;
			num % 2 ? parity = "odd" : parity = "even";
			return parity;
		}

		/**
		 * A function for rounding a decimal number to a precision. Note that trailing zeros are not
		 * kept.
		 *
		 * @usage  trace (numRoundTo (0.246, 2)); // 0.25 
		 *         trace (numRoundTo (135, -1));  // 140
		 *
		 * @prams  n:Number   The number to round.
		 * @prams  p:Number   The precision to round to.
		 *
		 * @return Number     The rounded number `n` to `p` decimal places
		 */
		public static function numRoundTo (n : Number, p : Number) : Number {
			return Math.round (Math.pow (10, p) * n) / Math.pow (10, p);
		}

		/**
		 * Reads the number parameter and converts it into an English ordinalised String (ie: 1st, 2nd, 3rd.. 13th, etc..).
		 *
		 * @usage  trace (ordinalise (21));  // Outputs 21st
		 *         trace (ordinalise (102)); // Outputs 102nd
		 *         trace (ordinalise (33));  // Outputs 33rd 
		 *         trace (ordinalise (13));  // Outputs 13th
		 *         trace (ordinalise (11));  // Outputs 102th
		 *         trace (ordinalise (112)); // Outputs 112th
		 *  	   trace (ordinalise (1));   // Outputs 1st
		 *
		 * @prams number : Number The number that you want to be ordinalised.
		 * 
		 * @return String A String value, the ordinalised value of `number`.
		 */
		public static function ordinalise (number : Number) : String {
			var tmp : String = String (number);
			var end : String;
			if (tmp.substr (-2, 2) != "13" && tmp.substr (-2, 2) != "12" && tmp.substr (-2, 2) != "11") {
				if (tmp.substr (-1, 1) == "1") {
					end = "st";
				}
				else if (tmp.substr (-1, 1) == "2") {
					end = "nd";
				}
				else if (tmp.substr (-1, 1) == "3") {
					end = "rd";
				}
			}
			if (!end) {
				end = "th";
			}
			return (tmp + end);
		}

		/**
		 * Computes the number of unique combinations in a set of `n` elements, where each subset (combination) has
		 * `k` elements. This is n!/k!(n-k)!
		 *
		 * @param n The number of elements in the set to extract all unique combinations from.
		 * @param k The number of elements in each unique subset (combination) to be extracted.
		 * @return	The number of possible unique combinations.
		 */
		public static function computeCombinationsNumber (n : Number, k : Number) : Number {
			if (k > n) {
				return 0;
			}
			if (k == n) {
				return 1;
			}
			return (factorial (n) / factorial (k) * factorial (n - k));
		}
		
		
		/**
		 * Computes the Greatest Common Factor (GCF).
		 */
		public static function gcf (a:int, b:int):int {
			if (a % b == 0) {
				return Math.abs (b);
			} else {
				return gcf (b, a % b);
			}
		}
		
		/**
		 * Computes the Lowest Common Multiple (LCM).
		 */
		public static function lcm (a:int, b:int):int {
			return (a / gcf (a, b)) * b;
		}
		
		/**
		 * Determines whether given `value` is a power of `2`.
		 */
		public static function isPowerOfTwo (value : Number) : Boolean {
			return (Math.log (value) / Math.log (2)) % 1 === 0;
		}

		/**
		 * Computes the nth triangular number. The formula is: T[n] = n(n+1)/2
		 */
		public static function getTriangularNumber(n:int):int {
			return (n * (n + 1) / 2);
		}

		/**
		 * Given a factor that increases a given value by a set ammount,
		 * returns a factor that would decrease the same value by the
		 * same ammount. E.g., 1.25 (increases by one fifth) would produce
		 * 0.8 (decreases by one fifth).
		 * @param factor The factor to get the reversed of.
		 * @return The reversed factor.
		 */
		public static function getReversedFactor (factor : Number) : Number {
			var factorFraction:Fraction = Fraction.fromDecimal(factor);
			var reversedFactorScale:Fraction = (factorFraction.reciprocal as Fraction);
			return (reversedFactorScale.numerator / reversedFactorScale.denominator);
		}
	}
}
