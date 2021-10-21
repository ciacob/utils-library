package ro.ciacob.utils {
	import flash.desktop.NativeApplication;

	public class Descriptor {

		public static const DEFAULT_VERSION_DELIMITER:String = '.';
		public static const DEFAULT_VERSION_SEGMENTS_NUMBER:int = 3;

		public static function getAppCopyright (withCopyChar : Boolean = true):String {
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespace();
			var appCopy:String = descriptor.ns::copyright;
			return (withCopyChar? ('© ' + appCopy) : appCopy);
		}

		public static function getAppSignature(withVersion:Boolean = false, withCopyright:Boolean = false):String {
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespace();
			var appName:String = descriptor.ns::name;
			var ret:String = appName;
			if (withVersion) {
				ret = ret.concat(' ', getAppVersion(false));
			}
			if (withCopyright) {
				ret = ret.concat(' ', getAppCopyright());
			}
			return ret;
		}

		public static function getAppVersion(withBugFixVersion:Boolean = true):String {
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespace();
			var version:String = descriptor.ns::versionNumber;
			if (!withBugFixVersion) {
				var segments:Array = version.split(DEFAULT_VERSION_DELIMITER);
				if (segments.length >= DEFAULT_VERSION_SEGMENTS_NUMBER) {
					segments.pop();
				}
				version = segments.join('.');
			}
			return version;
		}

		public static function read(descriptorKey:String):String {
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespace();
			var descriptorValue:String = descriptor.ns::[descriptorKey][0];
			return Strings.trim(descriptorValue);
		}

		/**
		 * Compares two given multi-part numeric strings, whatever the format, e.g., "1.5.47" and "-1_0_16_0"
		 * are both accepted (the former compares "greater than" the later). Also, the two string operands
		 * need not use the same format either.
		 * 
		 * NOTES: This method is meant to effectivelly replace `Descriptor.compareThreePartVersions()`, which
		 * 		  might be kept around as a alias.
		 * 		  This method is meant to be used as an argument for the Array.sort() method.
		 *
		 * @param a
		 * 		  First multi-part numeric string to compare.
		 *
		 * @param b
		 * 		  Second multi-part numeric string to compare.
		 *
		 * @return
		 * 		  Positive integer if the `a` multi-part compares "greater than" the `b` multi-part;
		 * 		  negative integer if `a` compares "less than" `b`; and 0 if they compare "equal".
		 */
		public static function multiPartComparison (a:String, b: String) : int {
			var integers : RegExp = /(\-?\d{1,})/g;
			
			// Prepare A
			var aSegments : Array = a.match(integers);
			if (aSegments == null) {
				return 0;
			}
			var numASegments : uint = aSegments.length;
			if (numASegments == 0) {
				return 0;
			}
			
			// Prepare B
			var bSegments : Array = b.match(integers);
			if (bSegments == null) {
				return 0;
			}
			var numBSegments : uint = bSegments.length;
			if (numBSegments == 0) {
				return 0;
			}
			
			// Compare
			var maxLength : uint = Math.max (numASegments, numBSegments);
			var i:int = 0;
			
			for (i; i < maxLength; i++) {
				var rawASegment : String = (aSegments[i] as String);
				var rawBSegment : String = (bSegments[i] as String);
				var aSegment : int = (parseInt (rawASegment) as int);
				var bSegment : int = (parseInt (rawBSegment) as int);
				var delta : int = (aSegment - bSegment);
				if (delta != 0) {
					return delta;
				}
			}
			
			// Fallback to longest operand if nothing else helps, or else, the above code 
			// sees `-1_0` and `-1_0_0` as "equal".
			var rawASegmentLen : int = (rawASegment? rawASegment.length : 0);
			var rawBSegmentLen : int = (rawBSegment? rawBSegment.length : 0);
			return (rawASegmentLen - rawBSegmentLen);
		}
	}
}
