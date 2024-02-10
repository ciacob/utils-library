package ro.ciacob.utils {
import com.adobe.crypto.MD5;

import flash.display.DisplayObject;
import flash.display.Screen;
import flash.geom.Point;
import flash.geom.Rectangle;

public class ScreenUtils {

    public static const SCREEN_TOP:String = 'screenTop';
    public static const SCREEN_RIGHT:String = 'screenRight';
    public static const SCREEN_BOTTOM:String = 'screenBottom';
    public static const SCREEN_LEFT:String = 'screenLeft';
    public static const NOT_FOUND:String = 'screenNotFound';


    public static function adjustSystemTrayBounds(bounds:Rectangle, keepInVisibleArea:Boolean):Rectangle {
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
            var screenVisible:Rectangle = flash.display.Screen.mainScreen.visibleBounds;
            if (!screenVisible.containsRect(bounds)) {
                if (bounds.x < screenVisible.x) {
                    bounds.x = screenVisible.x;
                }
                if (bounds.y < screenVisible.y) {
                    bounds.y = screenVisible.y;
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

    public static function get taskBarPosition():String {
        var screenFull:Rectangle = flash.display.Screen.mainScreen.bounds;
        var screenVisible:Rectangle = flash.display.Screen.mainScreen.visibleBounds;
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

    public static function getScreenForPoint(point:Point):flash.display.Screen {
        var screen:flash.display.Screen = null;
        var screenBounds:Rectangle = null;
        var screens:Array = flash.display.Screen.screens;
        for each (screen in screens) {
            screenBounds = screen.bounds;
            if (screenBounds.contains(point.x, point.y)) {
                return screen;
            }
        }
        return null;
    }

    public static function get mainScreenAvailableHeight():Number {
        return flash.display.Screen.mainScreen.visibleBounds.height;
    }

    /**
     * Gets the current flash.display.Screen based on the bounds of given DisplayObject,
     * then returns its available bounds. If `compensateScalingFactor` is true, adjusts
     * these bounds to represent the same area as on a non scaled screen (has no detrimental
     * effects if screen is not scaled).
     * Note that you would NOT want to turn `compensateScalingFactor` on, unless
     * "requestedDisplayResolution" is set to "high" in the application's XML descriptor.
     *
     * @param    elementOnStage
     *            A DisplayObject that is currently on stage. This method
     *            will return `null` if the object is not on stage yet.
     *
     * @param    compensateScalingFactor
     *            Whether to compensate (usually shrink) the obtained bounds
     *            so that the returned area would be the same on scaled up
     *            screens, as it is on non scaled-up screens. Default false.
     *
     * @param     elBounds
     *            Precalculated element bounds. If not given, they will be inferred
     *            from given "elementOnStage", via DisplayObject's "getBounds()" method.
     *            Useful for the situation where "getBounds()" yelds unreliable results.
     *
     * @return    The available area of the Screen the given `elementOnStage`
     *            is currently on. Returns `null` if the element is itself null, or
     *            is not (yet) on the Stage. Also returns `null` if the element is
     *            completely offscreen.
     */
    public static function getAvailableScreenBoundsFor(elementOnStage:DisplayObject,
                                                       compensateScalingFactor:Boolean = false,
                                                       elBounds:Rectangle = null):Rectangle {

        if (!elementOnStage || !elementOnStage.stage) {
            return null;
        }
        if (!elBounds) {
            elBounds = elementOnStage.getBounds(elementOnStage.stage);
        }
        var match:Object = {elScreen: null};

        // Try element's top-left, center, and bottom-right, in this order; return first found screen.
        var localTl:Point = new Point(elBounds.x, elBounds.y);
        var localCenter:Point = new Point(elBounds.x + elBounds.width / 2, elBounds.y + elBounds.height / 2);
        var localBr:Point = new Point(elBounds.right, elBounds.bottom);
        ([localTl, localCenter, localBr]).forEach(function (point:Point, ...rest):void {
            if (!match.elScreen) {
                var elGlobalPoint:Point = elementOnStage.localToGlobal(point);
                match.elScreen = getScreenForPoint(elGlobalPoint);
            }
        });
        if (!match.elScreen) {
            return null;
        }
        var screenBounds:Rectangle = (match.elScreen as flash.display.Screen).visibleBounds;
        if (compensateScalingFactor) {
            var screenScaleFactor:Number = elementOnStage.stage.contentsScaleFactor;
            if (screenScaleFactor != 1) {
                var reversedFactor:Number = NumberUtil.getReversedFactor(screenScaleFactor);
                screenBounds.x *= reversedFactor;
                screenBounds.y *= reversedFactor;
                screenBounds.width *= reversedFactor;
                screenBounds.height *= reversedFactor;
            }
        }
        return screenBounds;
    }

    /**
     * Retrieves information about all available screens connected to the system.
     *
     * This function iterates over all screens detected by the AIR runtime and gathers
     * essential properties such as screen dimensions, position, and whether it's the
     * main display.
     *
     * Each screen's information is hashed to generate a unique identifier (UID) which
     * aids in distinguishing between screens, especially in multi-monitor setups.
     *
     * @return An array of objects, each representing a screen. The objects contain the
     * following keys:
     * - uid: A unique identifier for the screen, generated by hashing screen properties.
     * - isMain: A Boolean indicating whether the screen is the primary display.
     * - x: The x-coordinate of the screen's available area, accounting for system UI elements.
     * - y: The y-coordinate of the screen's available area.
     * - width: The width of the screen's available area.
     * - height: The height of the screen's available area.
     * - toString: A function that returns a string representation of the screen, including
     *   its dimensions, position, and UID.
     *
     *   Note: if not empty, the returned Array is guaranteed to have the main display at index `0`.
     */
    public static function getScreensInfo():Array {
        var mainScreen:Screen = Screen.mainScreen;
        var mainScreenBounds:Rectangle = mainScreen.bounds;
        var screens:Array = Screen.screens;
        var screensInfo:Array = [];
        for each (var screen:Screen in screens) {

            // There is a bug in the runtime: (screen === Screen.mainScreen) returns `false` .
            var isMainScreen:Boolean = (screen.bounds.equals(mainScreenBounds));
            var bounds:Rectangle = screen.visibleBounds;
            var x:Number = bounds.x;
            var y:Number = bounds.y;
            var w:Number = bounds.width;
            var h:Number = bounds.height;
            var uid:String = MD5.hash((isMainScreen ? 'm' : '') + 'w' + w + 'h' + h + 'x' + x + 'y' + y)
                    .substr(-7);
            var info:Object = {
                "uid": uid,
                "isMain": isMainScreen,
                "x": x,
                "y": y,
                "width": w,
                "height": h,
                "toString": function ():String {
                    return (
                        (this.isMain ? '[Main] ' : '') +
                        this.width + 'x' + this.height + ' @ ' +
                        this.x + ':' + this.y + " | " + this.uid
                    );
                }
            };
            if (isMainScreen) {
                screensInfo.unshift(info);
            } else {
                screensInfo.push(info);
            }
        }
        return screensInfo;
    }

}
}
