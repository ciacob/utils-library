package ro.ciacob.utils {
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import ro.ciacob.utils.constants.CommonStrings;
	public final class ColorUtils {

		private static const NUM_COLOR_CHARS:uint=6;

		/**
		 * Converts Hue, Saturation, Value to Red, Green, Blue
		 * @h Angle between 0-360
		 * @s percent between 0-100
		 * @v percent between 0-100
		 */
		public static function HSVtoRGB(h:Number, s:Number, v:Number):Array {
			var r:Number=0;
			var g:Number=0;
			var b:Number=0;
			var rgb:Array=[];

			var tempS:Number=s / 100;
			var tempV:Number=v / 100;

			var hi:int=Math.floor(h / 60) % 6;
			var f:Number=h / 60 - Math.floor(h / 60);
			var p:Number=(tempV * (1 - tempS));
			var q:Number=(tempV * (1 - f * tempS));
			var t:Number=(tempV * (1 - (1 - f) * tempS));

			switch (hi) {
				case 0:
					r=tempV;
					g=t;
					b=p;
					break;
				case 1:
					r=q;
					g=tempV;
					b=p;
					break;
				case 2:
					r=p;
					g=tempV;
					b=t;
					break;
				case 3:
					r=p;
					g=q;
					b=tempV;
					break;
				case 4:
					r=t;
					g=p;
					b=tempV;
					break;
				case 5:
					r=tempV;
					g=p;
					b=q;
					break;
			}

			rgb=[Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
			return rgb;
		}

		public static function HexToDeci(hex:String):uint {
			if (hex.substr(0, 2) != "0x") {
				hex="0x" + hex;
			}
			return new uint(hex);
		}

		public static function HexToRGB(hex:uint):Array {
			var rgb:Array=[];

			var r:uint=hex >> 16 & 0xFF;
			var g:uint=hex >> 8 & 0xFF;
			var b:uint=hex & 0xFF;

			rgb.push(r, g, b);
			return rgb;
		}

		public static function RGBToHex(r:uint, g:uint, b:uint):uint {
			var hex:uint=(r << 16 | g << 8 | b);
			return hex;
		}

		/**
		 * Converts Red, Green, Blue to Hue, Saturation, Value
		 * @r channel between 0-255
		 * @s channel between 0-255
		 * @v channel between 0-255
		 */
		public static function RGBtoHSV(r:uint, g:uint, b:uint):Array {
			var max:uint=Math.max(r, g, b);
			var min:uint=Math.min(r, g, b);

			var hue:Number=0;
			var saturation:Number=0;
			var value:Number=0;

			var hsv:Array=[];

			//get Hue
			if (max == min) {
				hue=0;
			} else if (max == r) {
				hue=(60 * (g - b) / (max - min) + 360) % 360;
			} else if (max == g) {
				hue=(60 * (b - r) / (max - min) + 120);
			} else if (max == b) {
				hue=(60 * (r - g) / (max - min) + 240);
			}

			//get Value
			value=max;

			//get Saturation
			if (max == 0) {
				saturation=0;
			} else {
				saturation=(max - min) / max;
			}

			hsv=[Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
			return hsv;
		}

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
		 * Something like a poor man's solution for darkening the overall color of a
		 * given Sprite. Works by tinting with black, which also desaturates the target.
		 *
		 * @param sprite
		 * 		A Sprite (subclass) instance to be darkened.
		 *
		 * @param ColorUtils.
		 * 		Optional, a number between 0 and 1 to factor in the lightening ammount. Defaults to
		 * 		`0.25` (one quarter lightening).
		 */
		public static function darkenSprite(sprite:Sprite, multiplier:Number=0.25):void {
			tintSprite(0x000000, sprite, multiplier);
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
		public static function generateRandomColor(

			pool:Array=null, lowerLimit:uint=0, higherLimit:uint=0xff, redLowerLimit:uint=0, redHigherLimit:uint=0, greenLowerLimit:uint=0, greenHigherLimit:uint=0, blueLowerLimit:uint=0, blueHigherLimit:uint=0

			):uint {

			lowerLimit=Math.max(lowerLimit, 0);
			redLowerLimit=Math.max(lowerLimit, 0);
			greenLowerLimit=Math.max(lowerLimit, 0);
			blueLowerLimit=Math.max(lowerLimit, 0);

			higherLimit=Math.min(higherLimit, 0xff);
			redHigherLimit=Math.min(higherLimit, 0xff);
			greenHigherLimit=Math.min(higherLimit, 0xff);
			blueHigherLimit=Math.min(higherLimit, 0xff);

			var do_generate:Function=function(

				lower_limit:uint=0, higher_limit:uint=0xff, red_lower_limit:uint=0, red_higher_limit:uint=0, green_lower_limit:uint=0, green_higher_limit:uint=0, blue_lower_limit:uint=0, blue_higher_limit:uint=0

					):uint {
						var r:uint=NumberUtil.getRandomInteger(red_lower_limit || lower_limit, red_higher_limit || higher_limit);
						var g:int=NumberUtil.getRandomInteger(green_lower_limit || lower_limit, green_higher_limit || higher_limit);
						var b:int=NumberUtil.getRandomInteger(blue_lower_limit || lower_limit, blue_higher_limit || higher_limit);
						return combineRGB(r, g, b);
			}

			var color:uint=do_generate(

				lowerLimit, higherLimit, redLowerLimit, redHigherLimit, greenLowerLimit, greenHigherLimit, blueLowerLimit, blueHigherLimit

				);

			if (pool != null) {
				while (pool.indexOf(color) >= 0) {
					color=do_generate();
				}
				pool.push(color);
			}

			return color;
		}

		public static function hexToHsv(color:uint):Array {
			var colors:Array=HexToRGB(color);
			return RGBtoHSV(colors[0], colors[1], colors[2]);
		}

		public static function hsvToHex(h:Number, s:Number, v:Number):uint {
			var colors:Array=HSVtoRGB(h, s, v);
			return RGBToHex(colors[0], colors[1], colors[2]);
		}

		/**
		 * Something like a poor man's solution for lightening up the overall color of a
		 * given Sprite. Works by tinting with white, which also desaturates the target.
		 *
		 * @param sprite
		 * 		A Sprite (subclass) instance to be lightened.
		 *
		 * @param ColorUtils.
		 * 		Optional, a number between 0 and 1 to factor in the lightening ammount. Defaults to
		 * 		`0.25` (one quarter lightening).
		 */
		public static function lightenSprite(sprite:Sprite, multiplier:Number=0.25):void {
			tintSprite(0xffffff, sprite, multiplier);
		}

		/**
		 * Adds a (fully opaque) alpha channel to a (24 bits) image.
		 * This is a shortcut for `setAlpha(0xff, colorVal)`.
		 */
		public static function rgbToArgb(colorVal:uint):uint {
			return setAlpha(0xff, colorVal);
		}

		/**
		 * Sets given alpha channel value into given (32 bits) color value.
		 */
		public static function setAlpha(alpha:uint, colorVal:uint):uint {
			var R:uint=extractRed(colorVal);
			var G:uint=extractGreen(colorVal);
			var B:uint=extractBlue(colorVal);
			return combineARGB(alpha, R, G, B);
		}

		/**
		 * Combines given blue channel value into given color value.
		 */
		public static function setBlue(blue:uint, colorVal:uint, useARGB:Boolean=false):uint {
			var R:uint=extractRed(colorVal);
			var G:uint=extractGreen(colorVal);
			if (useARGB) {
				var A:uint=extractAlpha(colorVal);
				return combineARGB(A, R, G, blue);
			}
			return combineRGB(R, G, blue);
		}

		/**
		 * Sets given green channel value into given color value.
		 */
		public static function setGreen(green:uint, colorVal:uint, useARGB:Boolean=false):uint {
			var R:uint=extractRed(colorVal);
			var B:uint=extractBlue(colorVal);
			if (useARGB) {
				var A:uint=extractAlpha(colorVal);
				return combineARGB(A, R, green, B);
			}
			return combineRGB(R, green, B);
		}

		/**
		 * Sets given red channel value into given color value.
		 */
		public static function setRed(red:uint, colorVal:uint, useARGB:Boolean=false):uint {
			var G:uint=extractGreen(colorVal);
			var B:uint=extractBlue(colorVal);
			if (useARGB) {
				var A:uint=extractAlpha(colorVal);
				return combineARGB(A, red, G, B);
			}
			return combineRGB(red, G, B);
		}

		/**
		 * Tints given Sprite with given color.  Tinting is done using ColorTransform.
		 *
		 * @param color
		 * 		The color to tint with.
		 *
		 * @param sprite
		 * 		A Sprite (subclass) instance to be tinted.
		 *
		 * @param ColorUtils.
		 * 		Optional, a number between 0 and 1 to factor in the tinting ammount. Defaults to
		 * 		`1` (the tint is fully opaque).
		 */
		public static function tintSprite(color:uint, sprite:Sprite, multiplier:Number=1):void {
			var ctMul:Number=(1 - multiplier);
			var ctRedOff:Number=Math.round(multiplier * extractRed(color));
			var ctGreenOff:Number=Math.round(multiplier * extractGreen(color));
			var ctBlueOff:Number=Math.round(multiplier * extractBlue(color));
			var ct:ColorTransform=new ColorTransform(ctMul, ctMul, ctMul, 1, ctRedOff, ctGreenOff, ctBlueOff, 0);
			sprite.transform.colorTransform=ct;
		}

		/**
		 * Converts given color value (expressed as an unsigned integer) to a RRGGBB string.
		 */
		public static function toHexNotation(colorVal:uint, useARGB:Boolean=false, includeHash : Boolean = false):String {
			var redValue : uint = extractRed (colorVal);
			var greenValue : uint = extractGreen (colorVal);
			var blueValue : uint = extractBlue (colorVal);
			var output : Array = [
				Strings.padLeft (redValue.toString (16), CommonStrings.ZERO, 2),
				Strings.padLeft (greenValue.toString (16), CommonStrings.ZERO, 2),
				Strings.padLeft (blueValue.toString (16), CommonStrings.ZERO, 2)
			];
			if (useARGB) {
				var alphaValue : uint = extractAlpha (colorVal);
				output.unshift (Strings.padLeft (alphaValue.toString (16), CommonStrings.ZERO, 2));
			}
			if (includeHash) {
				output.unshift (CommonStrings.HASH);
			}
			return output.join (CommonStrings.EMPTY);
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
		public static function toPostscriptRgb(color:uint, precision:uint=4):String {
			var r:uint=ColorUtils.extractRed(color);
			var rVal:String=(r / 0xff).toPrecision(precision);
			var g:uint=ColorUtils.extractGreen(color);
			var gVal:String=(g / 0xff).toPrecision(precision);
			var b:uint=ColorUtils.extractBlue(color);
			var bVal:String=(b / 0xff).toPrecision(precision);
			var ps:String=([rVal, gVal, bVal]).join(CommonStrings.SPACE);
			return ps;
		}
	}
}
