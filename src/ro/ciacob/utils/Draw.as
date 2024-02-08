/**
 *   @author Claudius Tiberiu Iacob <claudius.iacob@gmail.com>
 */
package ro.ciacob.utils
{
	import flash.desktop.Icon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	import org.bytearray.display.ScaleBitmap;

	public class Draw
	{

		public static function arrayToBitmapData(array:Array):BitmapData
		{
			if (array.length >= 4)
			{
				var height:int = array[array.length - 1] as int;
				var width:int = array[array.length - 2] as int;
				var isTransparent:Boolean = ((array[array.length - 3] as int) ==
						1);
				// Verify if stored with and height are acurate
				var surfaceOf:Number = (width * height);
				if (surfaceOf == array.length - 3)
				{
					var vector:Vector.<uint> = new Vector.<uint>;
					for (var i:int = 0; i < array.length - 3; i++)
					{
						vector[i] = (array[i] as uint);
					}
					var bitmapData:BitmapData = new BitmapData(width, height, isTransparent,
							0x00ffffff);
					var fullSpan:Rectangle = new Rectangle(0, 0, width, height);
					bitmapData.setVector(fullSpan, vector);
					return bitmapData;
				}
			}
			trace('`Draw.arrayToBitmapData()`: Cannot read given array into a BitmapData; was the array created by `Draw.bitmapDataToArray()`?');
			return null;
		}

		/**
		 * Creates an untyped array out of a BitmapData.
		 * NOTES:
		 * - each entry in the array is an unsigned integer;
		 * - last three entries in the array have special meanings:
		 *   - the last (n) is the number of rows in the BitmapData (the pixel height);
		 *   - the last but one (n - 1) is the number of columns (the pixel width);
		 *   - the one before it (n - 2) is a flag, that indicates whether the
		 * 	   source BitmapData was transparent (1) or not (0).
		 */
		public static function bitmapDataToArray(bitmapData:BitmapData):Array
		{
			var fullSpan:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.
					height);
			var vector:Vector.<uint> = bitmapData.getVector(fullSpan);
			var array:Array = [];
			for (var i:int = 0; i < vector.length; i++)
			{
				array[i] = vector[i];
			}
			array.push(bitmapData.transparent ? 1 : 0);
			array.push(bitmapData.width);
			array.push(bitmapData.height);
			// A bit of cleanup
			fullSpan = null;
			vector.length = 0;
			vector = null;
			return array;
		}

		public static function cropBitmapData(bitmapData:BitmapData, area:Rectangle,
				horizontalAlignment:Number, verticalAlignment:Number):BitmapData
		{
			var transparent:Boolean = bitmapData.transparent;
			var result:BitmapData = new BitmapData(area.width, area.height, transparent,
					0x00000000);
			var matrix:Matrix = new Matrix();
			var dx:Number = (area.width - bitmapData.width) * horizontalAlignment;
			var dy:Number = (area.height - bitmapData.height) * verticalAlignment;
			matrix.translate(dx, dy);
			result.draw(bitmapData, matrix);
			return result;
		}

		/**
		 * Returns an array with BitmapData objects, that represent the icons the operating system
		 * uses for a specific file. Optionally, bitmaps in the array are sorted by height (otherwise,
		 * their order cannot be guaranteed).
		 *
		 * @param	file
		 * 			The file to retrieve icons for.
		 *
		 * @param	sortByHeight
		 * 			Whether to sort resulting bitmaps by their height (shortest one on first index).
		 *
		 * @return	An array with BitmapData objects, or null on error.
		 */
		public static function getFileIcons(file:File, sortByHeight:Boolean = true):Array
		{
			var icons:Array;
			if (file != null)
			{
				if (file.icon != null)
				{
					icons = Icon(file.icon).bitmaps;
					if (icons.length > 0 && sortByHeight)
					{
						icons.sort(function(a:Object, b:Object):int
							{
								var bmpA:BitmapData = (a as BitmapData);
								var bmpB:BitmapData = (b as BitmapData);
								if (bmpA != null && bmpB != null)
								{
									return (bmpA.height - bmpB.height);
								}
								return 0;
							});
					}
				}
			}
			return icons;
		}

		/**
		 * Creates a bitmap data out of a loadable image file. This is an asynchronous process.
		 */
		public static function imageFileToBitmapData(image:File, successCallback:Function,
				failureCallback:Function = null, callbackContext:Object = null, loader:Loader =
				null):void
		{
			if (callbackContext == null)
			{
				callbackContext = {};
			}
			if (loader == null)
			{
				loader = new Loader;
			}
			var removeListeners:Function = function():void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, internalSuccessCallback);
				loader.contentLoaderInfo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,
						internalFailureCallback);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,
						internalFailureCallback);
				loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.
						SECURITY_ERROR, internalFailureCallback);
			};
			var internalSuccessCallback:Function = function(event:Event):void
			{
				removeListeners();
				if (loader.content != null && (loader.content is Bitmap))
				{
					var bitmapData:BitmapData = Bitmap(loader.content).bitmapData;
					successCallback.apply(callbackContext, [bitmapData]);
				}
			};

			var internalFailureCallback:Function = function(event:Event):void
			{
				removeListeners();
				if (failureCallback != null)
				{
					failureCallback.apply(callbackContext, [event]);
				}
			};

			if (!loader.hasEventListener(Event.COMPLETE))
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, internalSuccessCallback);
			}
			if (!loader.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
			{
				loader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR,
						internalFailureCallback);
			}
			if (!loader.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
						internalFailureCallback);
			}
			if (!loader.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			{
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
						internalFailureCallback);
			}
			var request:URLRequest = new URLRequest(image.url);
			loader.load(request);
		}

		/**
		 * Draws a radial gradient on a given Sprite.
		 */
		public static function radialGradient(canvas:Sprite, radius:Number, colors:Array,
				offset:Point = null, alphas:Array = null, ratios:Array = null):void
		{
			if (offset == null)
			{
				offset = new Point(0, 0);
			}
			if (alphas == null)
			{
				alphas = [1, 1];
			}
			if (ratios == null)
			{
				ratios = [0, 255];
			}
			var matrix:Matrix = new Matrix;
			matrix.createGradientBox(2 * radius, 2 * radius, 0, -radius + offset.
					x, -radius + offset.y);
			canvas.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas,
					ratios, matrix);
			canvas.graphics.drawCircle(0, 0, radius);
			canvas.graphics.endFill();
		}

		/**
		 * Creates a bitmap data out of an embedded image resource. This is a synchronous process.
		 */
		public static function resourceToBitmapData(image:Class):BitmapData
		{
			if (image != null)
			{
				var instance:Object;
				try
				{
					instance = new image;
				}
				catch (e:Error)
				{
					// Ignore
				}
				if (instance != null)
				{
					if (instance is Bitmap)
					{
						return Bitmap(instance).bitmapData;
					}
				}
			}
			return null;
		}

		/**
		 * Creates a scaled version of a given BitmapData.
		 */
		public static function scaleBitmapData(bitmapData:BitmapData, ratio:Number, interpolate:Boolean = false):BitmapData
		{
			ratio = Math.abs(ratio);
			var width:int = (bitmapData.width * ratio) || 1;
			var height:int = (bitmapData.height * ratio) || 1;
			var transparent:Boolean = bitmapData.transparent;
			var result:BitmapData = new BitmapData(width, height, transparent, 0x00000000);
			var matrix:Matrix = new Matrix();
			matrix.scale(ratio, ratio);

			// Using the Flash native renderer to get some (bilinear) interpolation.
			// Credits: http://stackoverflow.com/questions/15406117/actionscript-resizing-bitmapdata-with-smoothing
			if (interpolate)
			{
				var tmpShape:Shape = new Shape();
				var g:Graphics = tmpShape.graphics;
				g.beginBitmapFill(bitmapData, matrix, false, true);
				g.lineStyle(0, 0, 0);
				g.drawRect(0, 0, width, height);
				g.endFill();
				result.draw(tmpShape);
			}
			else
			{
				result.draw(bitmapData, matrix, null, null, null, true);
			}

			matrix = null;
			tmpShape = null;
			g = null;

			return result;
		}

		/**
		 * Scales a BitmapData using a nine-slices grid. DOES NOT automatically
		 * dispose the provided BitmapData object.
		 *
		 * @param	bitmapData
		 * 			The BitmapData to resize using a nine-slice grid.
		 *
		 * @param	width
		 * 			The width to resize the BitmapData to.
		 *
		 * @param 	height
		 * 			The height to resize the BitmapData to.
		 *
		 * @param	grid
		 * 			The inner cell of the nine-slice grid (row 2, column 2);
		 * 			this implicitely describes the grid in it entirety.
		 *
		 * @return	The scaled bitmap.
		 */
		public static function gridScaleBitmap(bitmapData:BitmapData, width:Number,
				height:Number, grid:Rectangle):BitmapData
		{
			var resizer:ScaleBitmap = new ScaleBitmap(bitmapData);
			resizer.scale9Grid = grid;
			resizer.setSize(width, height);
			return resizer.bitmapData;
		}

		/**
		 * Draws stripes. Such a lovely, British, decoration pattern: isn't it?
		 * Credits: adapted from https://github.com/gunderson/pg-lib-as3/blob/master/pg/draw/Stripes.as,
		 * accessed on 2016/03/03
		 *
		 * @param rect The size of the BitmapData to return. Only width and height properties are used.
		 *
		 * @param direction Direction of the stripes. One of "horizontal", "vertical", "right", "left".
		 *
		 * @param gap Pixel width of the gap between stripes.
		 *
		 * @param thickness Pixel width of the stripe. Optional, defaults to one pixel.
		 *
		 * color Color of the stripe. Optional, defaults to white.
		 *
		 * alpha Transparency of the stripe. Optional, defaults to fully opaque.
		 *
		 * @return A Bitmapdata with the decoration in it. It is client's code responsibility to dispose
		 * 		   the BitmapData when not needed anymore.
		 */
		public static function drawStripes(
				rect:Rectangle,
				direction:String,
				gap:int,
				thickness:int = 1,
				color:Number = 0xffffff,
				alpha:Number = 1):BitmapData
		{

			if (!rect.isEmpty())
			{
				var stripeShape:Shape = new Shape;
				var stripeMatrix:Matrix = new Matrix();
				var stripeBMD:BitmapData = new BitmapData(rect.width, rect.height, true, 0);

				stripeShape.graphics.clear();
				var f_height:Number = rect.height;
				switch (direction)
				{
					case "left":
						stripeShape.graphics.beginFill(color, alpha);
						stripeShape.graphics.moveTo(0, f_height);
						stripeShape.graphics.lineTo(thickness, f_height);
						stripeShape.graphics.lineTo(f_height + thickness, 0);
						stripeShape.graphics.lineTo(f_height, 0);
						stripeShape.graphics.lineTo(0, f_height);
						stripeShape.graphics.endFill();
						break;
					case "right":
						stripeShape.graphics.beginFill(color, alpha);
						stripeShape.graphics.moveTo(thickness, 0);
						stripeShape.graphics.lineTo(0, 0);
						stripeShape.graphics.lineTo(f_height, f_height);
						stripeShape.graphics.lineTo(f_height + thickness, f_height);
						stripeShape.graphics.lineTo(thickness, 0);
						stripeShape.graphics.endFill();
						break;
					case "vertical":
						stripeShape.graphics.beginFill(color, alpha);
						stripeShape.graphics.drawRect(0, 0, thickness, f_height);
						stripeShape.graphics.endFill();
						break;
					case "horizontal":
						stripeShape.graphics.beginFill(color, alpha);
						stripeShape.graphics.drawRect(0, 0, rect.width, thickness);
						stripeShape.graphics.endFill();
						break;
				}
				stripeBMD.lock();
				for (var i:int = -stripeBMD.height; i < stripeBMD.width + stripeBMD.height; i += gap + thickness)
				{
					if (direction == "horizontal")
					{
						stripeMatrix.ty = i;
					}
					else
					{
						stripeMatrix.tx = i;
					}
					stripeBMD.draw(stripeShape, stripeMatrix);
				}
				stripeBMD.unlock();

				stripeShape = null;
				stripeMatrix = null;
				return stripeBMD;
			}

			return null;
		}

		/**
		 * Helper function to be used by "computeShapeDimensions()".
		 */
		private static function _updateBoundingBox(minX:Number, minY:Number, maxX:Number, maxY:Number, coordinates:String, currentX:Number, currentY:Number, isRelative:Boolean):Object
		{
			const coords:Array = coordinates.split(/\s*,\s*|\s+/);

			for (var i:int = 0; i < coords.length; i += 2)
			{
				const x:Number = Number(coords[i]);
				const y:Number = Number(coords[i + 1]);

				// Offset x and y only in relative mode
				if (isRelative)
				{
					if (!isNaN(x))
					{
						currentX += x;
					}
					if (!isNaN(y))
					{
						currentY += y;
					}
				}

				// Update bounding box with the adjusted coordinates
				if (!isNaN(x))
				{
					minX = Math.min(currentX, minX);
					maxX = Math.max(currentX, maxX);
				}

				if (!isNaN(y))
				{
					minY = Math.min(currentY, minY);
					maxY = Math.max(currentY, maxY);
				}

				// Update current position for absolute coordinates
				if (!isRelative)
				{
					if (!isNaN(x))
					{
						currentX = x;
					}
					if (!isNaN(y))
					{
						currentY = y;
					}
				}
			}

			return {minX: minX, minY: minY, maxX: maxX, maxY: maxY, currentX: currentX, currentY: currentY};
		}

		/**
		 * Given a string describing an FXG path, this function computes the intrinsic width and height of
		 * that path.
		 * @param	pathData
		 * 			String in the format of the "data" attribute of an FXG shape.
		 *
		 * @return	Object, in the format: {width: Number, height: Number}
		 */
		public static function computeShapeDimensions(pathData:String):Object
		{
			// Regular expression to match command and coordinate pairs in the path data
			const pathRegex:RegExp = /([MLHVCSQTAZmlhvcsqtaz])\s*([^MLHVCSQTAZmlhvcsqtaz]*)/g;

			var minX:Number = Infinity;
			var minY:Number = Infinity;
			var maxX:Number = -Infinity;
			var maxY:Number = -Infinity;
			var currentX:Number = 0;
			var currentY:Number = 0;

			// Extract and process each command and coordinates in the path data
			var match:Object;
			while ((match = pathRegex.exec(pathData)) != null)
			{
				const command:String = match[1];
				const coordinates:String = match[2];

				// Detect if the command is written in lowercase
				const isRelative:Boolean = (command === command.toLowerCase());

				const boundingBox:Object = _updateBoundingBox(minX, minY, maxX, maxY, coordinates, currentX, currentY, isRelative);
				minX = boundingBox.minX;
				minY = boundingBox.minY;
				maxX = boundingBox.maxX;
				maxY = boundingBox.maxY;
				currentX = boundingBox.currentX;
				currentY = boundingBox.currentY;
			}

			// Calculate width and height from the bounding box
			const width:Number = (maxX - minX) || 0;
			const height:Number = (maxY - minY) || 0;

			return {width: width, height: height};
		}
	}

}
