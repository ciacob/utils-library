package ro.ciacob.utils {
	import ro.ciacob.utils.constants.CommonStrings;

	public final class ColorUtils {

		/**
		 * Combines individual values of the alpha, red, green and blue channels
		 * into a 32 bits color value.
		 */
		public static function combineARGB(alpha:uint, red:uint, green:uint, blue:uint):uint {
			return ((alpha << 24) | (red << 16) | (green << 8) | blue);
		}

		/**
		 * Combines individual values of the red, green and blue channels
		 * into a 24 bits color value.
		 */
		public static function combineRGB(red:uint, green:uint, blue:uint):uint {
			return ((red << 16) | (green << 8) | blue);
		}

		/**
		 * Extracts the value of the alpha channel out of the given (32 bits)
		 * color value.
		 */
		public static function extractAlpha(colorVal:uint):uint {
			return (colorVal >> 24) & 0xFF;
		}

		/**
		 * Extracts the value of the blue channel out of the given
		 * color value.
		 */
		public static function extractBlue(colorVal:uint):uint {
			return colorVal & 0xFF;
		}

		/**
		 * Extracts the value of the green channel out of the given
		 * color value.
		 */
		public static function extractGreen(colorVal:uint):uint {
			return (colorVal >> 8) & 0xFF;
		}

		/**
		 * Extracts the value of the red channel out of the given
		 * color value.
		 */
		public static function extractRed(colorVal:uint):uint {
			return colorVal >> 16 & 0xFF;
		}

		/**
		 * Generates a random, unique 24 bit color (alpha channel not includded).
		 *
		 * @param	pool
		 * 			Optional; a spare Array to populate with colors already generated, in order
		 * 			to avoid repeating colors. If missing/set to `null`, nothing is done to 
		 * 			ensure generated colors' unicity.
		 *
		 * @param	lowerLimit
		 * 			Optional; if provided, neither of the red, green and blue
		 * 			channels can take values smaller than this limit.
		 *
		 * @param	higherLimit
		 * 			Optional; if provided, neither of the red, green and blue
		 * 			channels can take values greater than this limit.
		 * 
		 * @param	redLowerLimit
		 * 			Optional; same as "lowerLimit", but for the red channel. Takes precedence over 
		 * 			"lowerLimit", which is generic.
		 * 
		 * @param	redHigherLimit
		 * 		 	Optional; same as "higherLimit", but for the red channel. Takes precedence over 
		 * 			"higherLimit", which is generic.
		 * 
		 * @param	greenLowerLimit
		 * 			Optional; same as "lowerLimit", but for the green channel. Takes precedence over 
		 * 			"lowerLimit", which is generic.
		 * 
		 * @param	greenHigherLimit
		 * 		 	Optional; same as "higherLimit", but for the green channel. Takes precedence over 
		 * 			"higherLimit", which is generic.
		 *
		 * @param	blueLowerLimit
		 * 			Optional; same as "lowerLimit", but for the blue channel. Takes precedence over 
		 * 			"lowerLimit", which is generic.
		 * 
		 * @param	blueHigherLimit
		 * 		 	Optional; same as "higherLimit", but for the blue channel. Takes precedence over 
		 * 			"higherLimit", which is generic.
		 *  
		 * @return	The generated color as an unsigned integer.
		 */
		public static function generateRandomColor (
			
				pool:Array = null,
				lowerLimit:uint = 0,
				higherLimit:uint = 0xff,
				redLowerLimit:uint = 0,
				redHigherLimit:uint = 0,
				greenLowerLimit:uint = 0,
				greenHigherLimit:uint = 0,
				blueLowerLimit:uint = 0,
				blueHigherLimit:uint = 0
				
		) : uint {
			
			lowerLimit = Math.max(lowerLimit, 0);
			redLowerLimit = Math.max(lowerLimit, 0);
			greenLowerLimit = Math.max(lowerLimit, 0);
			blueLowerLimit = Math.max(lowerLimit, 0);
				
			higherLimit = Math.min(higherLimit, 0xff);
			redHigherLimit = Math.min(higherLimit, 0xff);
			greenHigherLimit = Math.min(higherLimit, 0xff);
			blueHigherLimit = Math.min(higherLimit, 0xff);

			var do_generate:Function = function (
				
				lower_limit:uint = 0,
				higher_limit:uint = 0xff,
				red_lower_limit:uint = 0,
				red_higher_limit:uint = 0,
				green_lower_limit:uint = 0,
				green_higher_limit:uint = 0,
				blue_lower_limit:uint = 0,
				blue_higher_limit:uint = 0
				
			) : uint {
				var r:uint = NumberUtil.getRandomInteger (red_lower_limit || lower_limit, red_higher_limit || higher_limit);
				var g:int = NumberUtil.getRandomInteger (green_lower_limit || lower_limit, green_higher_limit || higher_limit);
				var b:int = NumberUtil.getRandomInteger (blue_lower_limit || lower_limit, blue_higher_limit || higher_limit);
				return combineRGB (r, g, b);
			}

			var color:uint = do_generate (
				
				lowerLimit,
				higherLimit,
				redLowerLimit,
				redHigherLimit,
				greenLowerLimit,
				greenHigherLimit,
				blueLowerLimit,
				blueHigherLimit
			
			);
			
			if (pool != null) {
				while (pool.indexOf (color) >= 0) {
					color = do_generate();
				}
				pool.push (color);
			}
			
			return color;
		}

		/**
		 * Sets given alpha channel value into given (32 bits) color value.
		 */
		public static function setAlpha(alpha:uint, colorVal:uint):uint {
			var R:uint = extractRed(colorVal);
			var G:uint = extractGreen(colorVal);
			var B:uint = extractBlue(colorVal);
			return combineARGB(alpha, R, G, B);
		}

		/**
		 * Adds a (fully opaque) alpha channel to a (24 bits) image.
		 * This is a shortcut for `setAlpha(0xff, colorVal)`.
		 */
		public static function rgbToArgb(colorVal:uint):uint {
			return setAlpha(0xff, colorVal);
		}

		/**
		 * Combines given blue channel value into given color value.
		 */
		public static function setBlue(blue:uint, colorVal:uint, useARGB:Boolean =
			false):uint {
			var R:uint = extractRed(colorVal);
			var G:uint = extractGreen(colorVal);
			if (useARGB) {
				var A:uint = extractAlpha(colorVal);
				return combineARGB(A, R, G, blue);
			}
			return combineRGB(R, G, blue);
		}

		/**
		 * Sets given green channel value into given color value.
		 */
		public static function setGreen(green:uint, colorVal:uint, useARGB:Boolean =
			false):uint {
			var R:uint = extractRed(colorVal);
			var B:uint = extractBlue(colorVal);
			if (useARGB) {
				var A:uint = extractAlpha(colorVal);
				return combineARGB(A, R, green, B);
			}
			return combineRGB(R, green, B);
		}

		/**
		 * Sets given red channel value into given color value.
		 */
		public static function setRed(red:uint, colorVal:uint, useARGB:Boolean =
			false):uint {
			var G:uint = extractGreen(colorVal);
			var B:uint = extractBlue(colorVal);
			if (useARGB) {
				var A:uint = extractAlpha(colorVal);
				return combineARGB(A, red, G, B);
			}
			return combineRGB(red, G, B);
		}

		/**
		 * Converts given color value (expressed as an unsigned integer) to a RRGGBB string.
		 */
		public static function toHexNotation(colorVal:uint, useARGB:Boolean = false):String {
			var r:String = extractRed(colorVal).toString(16);
			r = Strings.padLeft(r, '0', 2);
			var g:String = extractGreen(colorVal).toString(16);
			g = Strings.padLeft(g, '0', 2);
			var b:String = extractBlue(colorVal).toString(16);
			b = Strings.padLeft(b, '0', 2);
			if (useARGB) {
				var a:String = extractAlpha(colorVal).toString(16);
				a = Strings.padLeft(a, '0', 2);
				return a.concat(r, g, b);
			}
			return r.concat(g, b);
		}



		/**
		 * Converts a color (given as an unsigned integer) into the postscript RGB
		 * format, were each chanel is represented as a number from 0 to 1 (with `1`
		 * meaning e.g., "full red").
		 *
		 * Example: `toPostscriptRgb (0xff6300)` // returns "1 0.25 0"
		 *
		 * @param	color
		 * 			The color to convert.
		 * 
		 * @param	precision
		 * 			Optional. The precision of the decimal used for each chanel value, 
		 * 			i.e. `4` will give `0.2315`.
		 * 			Defaults to `4`.
		 *
		 * @return	The converted color.
		 */
		public static function toPostscriptRgb(color:uint, precision:uint = 4):String {
			var r:uint = ColorUtils.extractRed(color);
			var rVal:String = (r / 0xff).toPrecision(precision);
			var g:uint = ColorUtils.extractGreen(color);
			var gVal:String = (g / 0xff).toPrecision(precision);
			var b:uint = ColorUtils.extractBlue(color);
			var bVal:String = (b / 0xff).toPrecision(precision);
			var ps:String = ([rVal, gVal, bVal]).join(CommonStrings.SPACE);
			return ps;
		}
	}
}
