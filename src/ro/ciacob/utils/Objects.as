package ro.ciacob.utils {

    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    public class Objects {
        private static const ARRAY_TYPE:String = 'Array';
        private static const OBJECT_TYPE:String = 'Object';

        private static const KEY_ALREADY_EXISTS:String = 'Provided key already exists in given object.';
        private static const KEY_DOES_NOT_EXISTS:String = 'Required key does not exist in given object.';
        private static const VALUE_NOT_EMPTY:String = 'Value pointed by the given key is not empty.';

        // Counter for generating unique identifiers
        private static var uidCounter:int = 0;

        // Dictionary to store UIDs for objects
        private static var uidMap:Dictionary = new Dictionary(true);

        public static function assertEmpty(key:String, object:Object):void {
            if (object[key] === undefined || object[key] === null) {
                return;
            }
            throw(new Error(VALUE_NOT_EMPTY));
        }

        public static function assertExisting(key:String, object:Object):void {
            if (object[key] === undefined) {
                throw(new Error(KEY_DOES_NOT_EXISTS));
            }
        }

        public static function assertNonExisting(key:String, object:Object):void {
            if (object[key] !== undefined) {
                throw(new Error(KEY_ALREADY_EXISTS));
            }
        }

        /**
         * Returns a (possible empty) Array with all the keys found within the given Object instance.
         *
         * @param object The Object whose keys are to be listed.
         * @param sortAlphabetically Whether to apply a simple (alphabetical) sort to the resulting
         *         Array.
         * @param keysToOmit An Array with keys to omit from the list reported.
         *
         * @return An Array with keys.
         */
        public static function getKeys(object:Object, sortAlphabetically:Boolean = false, keysToOmit:Array = null):Array {
            var ret:Array = [];
            for (var key:String in object) {
                if (keysToOmit == null || keysToOmit.indexOf(key) == -1) {
                    ret.push(key);
                }
            }
            if (sortAlphabetically) {
                ret.sort();
            }
            return ret;
        }

        /**
         * Inspects the provided value and returns true if it is not null AND: - is not a primitive,
         * not an Object and not an Array; - is an Object and one of its non-null properties is not
         * a primitive, not an Object and not an Array; - is an Object that contains nested
         * Objects, and one of the non-null properties of such a nested Object is not a primitive,
         * not an Object and not an Array; The same goes for Arrays. Nesting to any level deep is
         * supported.
         *
         * @param    value The value to inspect.
         * @param    recurse Whether to also inspect the children of `value`, should it have any, and
         *         their children, and so on. Optional, defaults to true.
         * @return True if this is not null, not a primitive, not an Object and not an Array, i.e.,
         *         pass an UIComponent in and you'll have a return value of true; false if this is,
         *         or contains, any of: primitives, Objects or Arrays.
         */
        public static function hasCustomType(value:*, recurse:Boolean = true):Boolean {
            var ret:Boolean = false;
            if (value != null) {
                var valueIsPrimitive:Boolean = (value is Number || value is int || value is uint || value is Boolean || value is String);
                if (!valueIsPrimitive) {
                    var typeOfValue:String = getQualifiedClassName(value);
                    if (typeOfValue != OBJECT_TYPE && typeOfValue != ARRAY_TYPE) {
                        ret = true;
                    } else if (recurse) {
                        for each (var childValue:* in value) {
                            ret = hasCustomType(childValue);
                            if (ret) {
                                break;
                            }
                        }
                    }
                }
            }
            return ret;
        }

        /**
         * Adds values from `source` into `target`.
         *
         * @param    source The source object to add values from.
         *
         * @param    target The target to add values into.
         *
         * @param    overwrite Whether to override overlapping values (true) or skip them (false).
         *         Default is true.
         */
        public static function importInto(source:Object, target:Object, overwrite:Boolean = true):void {
            for (var key:String in source) {
                var value:Object = source[key];
                if (!(key in target) || overwrite) {
                    target[key] = value;
                }
            }
        }

        /**
         * Compares two objects deeply to check for equality.
         * @param   obj1 First object to compare.
         * @param   obj2 Second object to compare.
         * @return  Boolean indicating whether the two objects are deeply equal.
         */
        public static function compareObjects(obj1:Object, obj2:Object):Boolean {
            if (obj1 === obj2) {
                return true; // Identical reference
            }
            if (obj1 == null && obj2 == null) {
                return true; // Both are null
            }
            if (obj1 == null || obj2 == null) {
                return false; // Only one is null
            }
            if (typeof obj1 != typeof obj2) {
                return false; // Different types
            }
            if (obj1 is Array && obj2 is Array) {
                if (obj1.length != obj2.length) {
                    return false; // Arrays of different lengths
                }
                for (var i:int = 0; i < obj1.length; i++) {
                    if (!compareObjects(obj1[i], obj2[i])) {
                        return false;
                    }
                }
                return true;
            }
            if (obj1.constructor != obj2.constructor) {
                return false; // Different constructors
            }
            var key:String;
            for (key in obj1) {
                if (!obj2.hasOwnProperty(key) || !compareObjects(obj1[key], obj2[key])) {
                    return false;
                }
            }
            for (key in obj2) {
                if (!obj1.hasOwnProperty(key)) {
                    return false; // Extra property in obj2
                }
            }
            return true; // All properties match
        }


        /**
         * Describes the content and structure of an object, including nested objects and arrays.
         *
         * @param obj The object to describe.
         * @return A string describing the content and structure of the object.
         */
        public static function describeObject(obj:Object):String {
            // Initialize an empty dictionary to keep track of visited objects
            var visitedObjects:Dictionary = new Dictionary(true);

            // Initialize the result string
            var result:String = "";

            // Initialize a stack to hold tasks
            var stack:Array = [{obj: obj, depth: 0}];

            // Iterate until the stack is empty
            while (stack.length > 0) {
                // Pop the top task from the stack
                var task:Object = stack.pop();
                var currentObj:Object = task.obj;
                var depth:int = task.depth;

                // If the object is null, add 'null' to the result
                if (currentObj == null) {
                    result += "null";
                    continue;
                }

                // If the object has already been visited, add a message indicating a circular reference
                if (visitedObjects[currentObj]) {
                    result += "Circular reference. OBJ#" + getUID(currentObj);
                    continue;
                }

                // Mark the object as visited
                visitedObjects[currentObj] = true;

                // Add the object's class name and opening brace to the result
                var type:String = currentObj.constructor.toString().split(" ")[1];
                var header:String = Strings.remove(type, ']');
                var label:String = (task.label || '');
                if (label) {
                    header += ' [' + task.label + '] ';
                }
                result += (result ? '\n' : '') + (header + " { ");

                // Get all the dynamic properties of the object
                var properties:Array = [];
                for (var key:String in currentObj) {
                    properties.push(key);
                }

                // Iterate over each property
                properties.sort();
                for each (var property:String in properties) {
                    // Get the value of the property
                    var value:* = currentObj[property];

                    // Add the property name and value to the result string
                    result += "\n    " + property + ": ";

                    // If the value is an object or array, add it to the stack for further processing
                    if ((value is Object && value.constructor == Object.prototype.constructor) || value is Array) {
                        stack.push({obj: value,
                                depth: depth + 1,
                                label: (label ? label + '.' : '') + property});
                    }

                    // Add the string representation of the value to the result string
                    result += value.toString();

                    // Add a comma if it's not the last property
                    if (properties.indexOf(property) < properties.length - 1) {
                        result += ",";
                    }
                }

                // Add closing brace to the result
                result += "\n}";
            }

            return result;
        }


        /**
         * Returns `true` if given Object is empty, i.e., it has no keys. Returns `false` if given Object has at
         * least one key.
         */
        public static function isEmpty(object:Object):Boolean {
            for (var key:String in object) {
                return false;
            }
            return true;
        }

        /**
         * Generates a unique identifier for an object.
         *
         * @param obj The object for which to generate the unique identifier.
         * @return A unique identifier string for the object.
         */
        private static function getUID(obj:Object):String {
            if (uidMap[obj] == null) {
                // Increment the counter and assign it as the unique identifier for the object
                uidCounter++;
                uidMap[obj] = "UID#" + uidCounter;
            }
            return uidMap[obj];
        }

    }
}
