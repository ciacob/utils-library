package ro.ciacob.utils {

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.formatters.DateFormatter;

	public class Time {
		public static const COUNTER_FORMAT : String = 'JJ:NN:SS';
		public static const SMALL_COUNTER_FORMAT : String = 'NN:SS';
		public static const DATESTAMP_FORMAT : String = 'YYYY/MM/DD';
		public static const DEFAULT_DELAY_TIME : int = 20;
		public static const DEFAULT_SPLASH_TIME : Number = 3;
		public static const LONG_DURATION : Number = 1400;
		public static const SHORT_DURATION : Number = 550;
		public static const VERY_SHORT_DURATION : Number = 250;
		public static const INSTANTLY : Number = 100;
		public static const TIMESTAMP_DEBUG_HEADER : String = 'YYYY/MM/DD JJ:NN:SS';
		public static const TIMESTAMP_DEBUG_INLINE : String = 'JJ:NN:SS';
		public static const TIMESTAMP_DEFAULT : String = 'D MMM YYYY, J:NN';
		public static const TIMESTAMP_FILENAME : String = 'D.MMM.YYYY J.NN.SS';
		public static const TIMESTAMP_LOCAL : String = 'D MMM YYYY, L:NN A';
		public static const YEAR_FORMAT : String = 'YYYY';
		public static const ONE_SECOND : Number = 1000;

		private static var _dateFormatter : DateFormatter = new DateFormatter;

		public static function advancedDelay (
				action : Function,
				context : Object,
				milliseconds : int = DEFAULT_DELAY_TIME,
				... parameters : Array) : void {
			var timer : Timer = new Timer (milliseconds, 1);
			var tmp : Function = function (event : TimerEvent) : void {
				timer.removeEventListener (TimerEvent.TIMER_COMPLETE, tmp);
				action.apply (context, parameters);
			}
			timer.addEventListener (TimerEvent.TIMER_COMPLETE, tmp);
			timer.start ();
		}

		public static function delay (seconds : Number, action : Function) : void {
			advancedDelay (action, {}, seconds * 1000);
		}

		public static function get now () : Date {
			return (new Date);
		}

		public static function get timestamp () : String {
			_dateFormatter.formatString = TIMESTAMP_DEFAULT;
			return _dateFormatter.format (now);
		}
		
		public static function get shortTimestamp () : String {
			_dateFormatter.formatString = COUNTER_FORMAT;
			return _dateFormatter.format (now);
		}

		public static function toDefaultFormat (time : *) : String {
			if (time is String) {
				time = new Date (time);
			}
			if (time is Number) {
				if (isNaN (time)) {
					time = 0;
				}
				time = new Date (time)
			}
			return _dateFormatter.format (time);
		}

		public static function toFormat (date : Date, format : String, removeLocalOffset : Boolean =
			true) : String {
			if (removeLocalOffset) {
				var offset : Number = date.getTimezoneOffset ();
				date = new Date (date.getTime () + offset * 60000);
			}
			var formatter : DateFormatter = new DateFormatter;
			formatter.formatString = format;
			return formatter.format (date);
		}
		
		/**
		 * Starts repeatedly running given `conditionIsTrue()` function at given `pollingInterval`seconds, until it
		 * returns the Boolean `true`, or the `timeOut` period gets through. If a `true` value is received in due time,
		 * polling is stopped and the `thenProceed` function is called.
		 * 
		 * Useful when you cannot use events, or they don't work (as advertised, or at all).
		 * 
		 * @param conditionIsTrue Function that must be return Boolean `false` for as long as we need to keep polling.
		 * 
		 * @param thenProceed Function to call when we're good to go (`conditionIsTrue` has returned `true`).
		 * 
		 * @param pollingInterval 	Optional. The interval, in milliseconds, between two subsequent tries. Defaults to
		 * 							`1000`, for one second. Any times shorter than 10 ms will be considered 10 ms.
		 * 
		 * @param timeOut 	Optional. The maximum time, in seconds, we are willing to wait for a `true` response.
		 * 					Defaults to `0`, which means "infinite". Timeouts that are shorter than the polling interval 
		 * 					will be silently discarded
		 */
		public static function waitUntil (
			conditionIsTrue : Function, 
			thenProceed : Function, 
			pollingInterval : uint = 1000, 
			timeOut : uint = 0
		) : void {
			
			if (conditionIsTrue != null) {
				
				var numRepeats : uint;
				var t : Timer = null;
				
				var checkIt : Function = function () : void {
					if (conditionIsTrue()) {
						if (t != null) {
							t.stop();
							t.removeEventListener (TimerEvent.TIMER, checkIt);
							t = null;
						}
						thenProceed();
					}
				}
					
				// We try right away, just in case
				checkIt ();
				
				// Nope. Setup polling
				pollingInterval = Math.max (10, pollingInterval);
				numRepeats = (timeOut > 0 && timeOut * 1000 > pollingInterval)? (timeOut * 1000) / pollingInterval : 0;
				t = new Timer (pollingInterval, numRepeats);
				t.addEventListener (TimerEvent.TIMER, checkIt);
				t.start();
			}
		}
	}
}
