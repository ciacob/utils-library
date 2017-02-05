package ro.ciacob.utils {
	import flash.display.Screen;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Screen {
		
		public static const SCREEN_TOP : String = 'screenTop';
		public static const SCREEN_RIGHT : String = 'screenRight'; 
		public static const SCREEN_BOTTOM : String = 'screenBottom';
		public static const SCREEN_LEFT : String = 'screenLeft';
		public static const NOT_FOUND : String = 'screenNotFound';
		


		public static function adjustSystemTrayBounds (bounds : Rectangle, keepInVisibleArea : Boolean) : Rectangle {
			switch (taskBarPosition) {
				case SCREEN_TOP:
					//UPPER RIGHT
					bounds.x -= bounds.width;
					break;
				case SCREEN_RIGHT:
				case SCREEN_BOTTOM:
					// LOWER RIGHT
					bounds.x -= bounds.width;
					bounds.y -= bounds.height;
					break;
				case SCREEN_LEFT:
					// LOWER LEFT
					bounds.y -= bounds.height;
					break;
			}
			if (keepInVisibleArea) {
				var screenVisible : Rectangle = flash.display.Screen.mainScreen.visibleBounds;
				if (!screenVisible.containsRect(bounds)) {
					if (bounds.x < screenVisible.x) {
						bounds.x =  screenVisible.x;
					}
					if (bounds.y < screenVisible.y) {
						bounds.y =  screenVisible.y;
					}
					if (bounds.right > screenVisible.right) {
						bounds.x -= (bounds.right - screenVisible.right);
					}
					if (bounds.bottom > screenVisible.bottom) {
						bounds.y -= (bounds.bottom - screenVisible.bottom); 
					}
				}
			}
			return bounds;
		}
		
		public static function get taskBarPosition () : String {
			var screenFull : Rectangle = flash.display.Screen.mainScreen.bounds;
			var screenVisible : Rectangle = flash.display.Screen.mainScreen.visibleBounds;
			if (screenVisible.top > screenFull.top) {
				return SCREEN_TOP;
			}
			if (screenVisible.right < screenFull.right) {
				return SCREEN_RIGHT;
			}
			if (screenVisible.bottom < screenFull.bottom) {
				return SCREEN_BOTTOM;
			}
			if (screenVisible.left > screenFull.left) {
				return SCREEN_LEFT;
			}
			return NOT_FOUND;
		}
		
		public static function getScreenForPoint (point : Point) : flash.display.Screen {
			var screen : flash.display.Screen = null;
			var screenBounds : Rectangle = null;
			var screens : Array = flash.display.Screen.screens;
			for each (screen in screens) {
				screenBounds = screen.bounds;
				if (screenBounds.contains (point.x, point.y)) {
					return screen;
				}
			}
			return null;
		}
		
		public static function get mainScreenAvailableHeight () : Number {
			return flash.display.Screen.mainScreen.visibleBounds.height;
		}
		
	}
}
