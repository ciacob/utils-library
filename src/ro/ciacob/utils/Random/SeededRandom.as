/**
 * Rndm by Grant Skinner. Jan 15, 2008
 * Visit www.gskinner.com/blog for documentation, updates and more free code.
 *
 * Incorporates implementation of the Park Miller (1988) "minimal standard" linear
 * congruential pseudo-random number generator by Michael Baczynski, www.polygonal.de.
 * (seed * 16807) % 2147483647
 *
 *
 *
 * Copyright (c) 2008 Grant Skinner
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * Renamed to `SeededRandom` and curated by ciacob, 2017/01/08
 */

package ro.ciacob.utils.Random {

    /**
     * Provides common random functions using a seeded random system.
     * Can be used through static interface or via instantiation.
     */
    public class SeededRandom {

        protected static var _instance:SeededRandom;

        public static function get instance():SeededRandom {
            if (_instance == null) {
                _instance = new SeededRandom();
            }
            return _instance;
        }

        public static function get seed():uint {
            return instance.$seed;
        }

        public static function set seed(value:uint):void {
            instance.$seed = value;
        }

        public static function get currentSeed():uint {
            return instance.currentSeed;
        }

        public static function random():Number {
            return instance.random();
        }

        public static function float(min:Number, max:Number = NaN):Number {
            return instance.float(min, max);
        }

        public static function boolean(chance:Number = 0.5):Boolean {
            return instance.boolean(chance);
        }

        public static function sign(chance:Number = 0.5):int {
            return instance.sign(chance);
        }

        public static function bit(chance:Number = 0.5):int {
            return instance.bit(chance);
        }

        public static function integer(min:Number, max:Number = NaN):int {
            return instance.integer(min, max);
        }

        public static function reset():void {
            instance.reset();
        }

        protected var _seed:uint = 0;
        protected var _currentSeed:uint = 0;

        public function SeededRandom(seed:uint = 1) {
            _seed = _currentSeed = seed;
        }

        public function get $seed():uint {
            return _seed;
        }

        public function set $seed(value:uint):void {
            _seed = _currentSeed = value;
        }

        /**
         * Gets the current seed
         */
        public function get currentSeed():uint {
            return _currentSeed;
        }

        /**
         * Returns a number between 0-1 exclusive.
         */
        public function random():Number {
            return (_currentSeed = (_currentSeed * 16807) % 2147483647) / 0x7FFFFFFF + 0.000000000233;
        }

        /**
         * float (50); // returns a number between 0-50 exclusive
         * float (20,50); // returns a number between 20-50 exclusive
         */
        public function float(min:Number, max:Number = NaN):Number {
            if (isNaN(max)) {
                max = min;
                min = 0;
            }
            return random() * (max - min) + min;
        }

        /**
         * boolean(); // returns true or false (50% chance of true)
         * boolean(0.8); // returns true or false (80% chance of true)
         */
        public function boolean(chance:Number = 0.5):Boolean {
            return (random() < chance);
        }

        /**
         * sign(); // returns 1 or -1 (50% chance of 1)
         * sign (0.8); // returns 1 or -1 (80% chance of 1)
         */
        public function sign(chance:Number = 0.5):int {
            return (random() < chance) ? 1 : -1;
        }

        /**
         * bit(); // returns 1 or 0 (50% chance of 1)
         * bit(0.8); // returns 1 or 0 (80% chance of 1)
         */
        public function bit(chance:Number = 0.5):int {
            return (random() < chance) ? 1 : 0;
        }

        /**
         * integer(50); // returns an integer between 0-49 inclusive
         * integer(20,50); // returns an integer between 20-49 inclusive
         */
        public function integer(min:Number, max:Number = NaN):int {
            if (isNaN(max)) {
                max = min;
                min = 0;
            }
            // Need to use floor instead of bit shift to work properly with negative values:
            return Math.floor(float(min, max));
        }

        /**
         * Resets the number series, retaining the same seed.
         */
        public function reset():void {
            _seed = _currentSeed;
        }
    }
}
