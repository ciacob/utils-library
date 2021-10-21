package ro.ciacob.utils {
	import flash.net.getClassByAlias;
	import flash.utils.describeType;
	
	/**
	 * Utilities for using with class definitions
	 * @author ciacob
	 */
	public class Classes {
		
		/**
		 * Two classes are equivalent if they have the same fully qualified name,
		 * the same members, they inherit from the same parent class, and they
		 * are located in the same namespace.
		 * 
		 * If you load the same class in two unrelated application domains, Flash
		 * will be unable to cast the class to itself. The only reliable way to know
		 * that you are dealing with the expected type is to use this function.
		 * 
		 * @param	classA
		 * 			The class to compare to.
		 * 
		 * @param	classB
		 * 			The class to compare with.
		 * 
		 * @return	True if the two classes are equivalent, false otherwise. 
		 */
		public static function isEquivalent (classA : Class, classB : Class) : Boolean {
			if (classA == null || classB == null) {
				return false;
			}
			var defA : String = describeType(classA).toXMLString();
			var defB : String = describeType(classB).toXMLString();			
			return (defA == defB);
		}
		
	}	
}