package ro.ciacob.utils {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Geometry {

		/**
		 * This is different than the "inflatePoint()" method in the Rectangle class —
		 * which is futile, IMHO — and does what one would expect to, from a method having
		 * this name: if the given point lies outside the rectangle, the rectangle will
		 * change its x, y, width or height (whichever is needed) to contain that point.
		 * Unless the point is already part of the rectangle, the rectangle width and/or
		 * height WILL CHANGE.
		 *
		 * Transformations are applied on the existing rectangle, nothing is returned.
		 *
		 * @param	rectangle
		 * 			The rectangle to modify
		 *
		 * @param	point
		 * 			A point the rectangle must include.
		 */
		public static function inflateRectToPoint(rectangle:Rectangle, point:Point):void {
			if (rectangle.containsPoint(point)) {
				return;
			}
			// HORIZONTAL TESTS.
			// We discard the cases where the point can lie in-between the "left" and 
			// "right" of the rectangle, without actually being conained in it (this 
			// could happen if the point was beneath or above the rectangle). 
			var hTestPoint : Point = point.clone();
			hTestPoint.y = rectangle.y;
			if (!rectangle.containsPoint(hTestPoint)) {
				var deltaX:Number = (rectangle.x - hTestPoint.x);
				// "hTestPoint" is to the right of rectangle
				if (deltaX < 0) {
					rectangle.right = hTestPoint.x;
				}
				// "hTestPoint" is to the left of rectangle
				else if (deltaX > 0) {
					rectangle.left = hTestPoint.x;
					rectangle.width += deltaX;
				}
			
			}

			// VERTICAL TESTS.
			// We discard the cases where the point can lie in-between the "top" and
			// "bottom" of the rectangle, without actually being contained in it (this
			// could happen if the point was to the left or to the right of the 
			// rectangle).
			var vTestPoint : Point = point.clone();
			vTestPoint.x = rectangle.x;
			if (!rectangle.containsPoint(vTestPoint)) {
				var deltaY:Number = (rectangle.y - vTestPoint.y);
				// "vTestPoint" is below (to the south of) the rectangle
				if (deltaY < 0) {
					rectangle.bottom = vTestPoint.y;
				}
				// "vTestPoint" is above (to the north of) the rectangle
				else if (deltaY > 0) {
					rectangle.top = vTestPoint.y;
					rectangle.height += deltaY;
				}			
			}
		}

		/**
		 * Given an object with `x`, `y`, `width` and `height` properties, returns a matching Rectangle.
		 */
		public static function objectToRectangle(obj:Object):Rectangle {
			if (obj != null) {
				var x:Number;
				var y:Number;
				var width:Number;
				var height:Number;
				if (!('x' in obj) || isNaN(x = parseInt(obj['x']))) {
					throw(new ArgumentError('Geometry - Numeric property `x` missing from input Object.'));
				}
				if (!('y' in obj) || isNaN(y = parseInt(obj['y']))) {
					throw(new ArgumentError('Geometry - Numeric property `y` missing from input Object.'));
				}
				if (!('width' in obj) || isNaN(width = parseInt(obj['width']))) {
					throw(new ArgumentError('Geometry - Numeric property `width` missing from input Object.'));
				}
				if (!('height' in obj) || isNaN(height = parseInt(obj['height']))) {
					throw(new ArgumentError('Geometry - Numeric property `height` missing from input Object.'));
				}
				return new Rectangle(x, y, width, height);
			}
			return null;
		}

		/**
		 * Does the opposite of `objectToRectangle`, producing a simple Object with given Rectangles's
		 * `x`, `y`, `width` and `height` properties.
		 */
		public static function rectangleToObject(rect:Rectangle):Object {
			if (rect != null) {
				return {'x': rect.x, 'y': rect.y, 'width': rect.width, 'height': rect.height};
			}
			return null;
		}
	}
}
