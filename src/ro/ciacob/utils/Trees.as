package ro.ciacob.utils {
	import mx.controls.Tree;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.ListEvent;

	/**
	 *
	 * @author ClaudiusI
	 */
	public final class Trees {

		private static var _mustAbortRecursion:Boolean;

		/**
		 * Recursively searches for an item within a tree.
		 *
		 * @param	search
		 * 			Some (unique) value of the item to find. Each tree item should have a certain property
		 * 			(by default `uid`) that should hold a value, which should be globally unique. If
		 * 			that is not the case, the first match will be considered, and the rest will be ignored.
		 *
		 * @param	parentObj
		 * 			The tree structure to search.
		 *
		 * @param	searchName
		 * 			Optional. The name of the property to inspect. Defaults to `uid`.
		 *
		 * @return 	The first match item, if found, null otherwise.
		 */
		public static function findTreeItem(search:Object, parentObj:Object, searchName:String =
			'uid'):Object {
			if (parentObj != null) {
				if (parentObj[searchName] == search) {
					return parentObj;
				}
				if (parentObj['children'] != null && parentObj['children'] is Array && (parentObj['children'] as
					Array).length > 0) {
					for (var i:int = 0; i < (parentObj['children'] as Array).length; i++) {
						var childObj:Object = (parentObj['children'] as Array)[i];
						var matchingChild:Object = findTreeItem(search, childObj, searchName);
						if (matchingChild != null) {
							return matchingChild;
						}
					}

				}
			}
			return null;
		}

		/**
		 * Attempts to select a tree item.
		 *
		 * This is in fact a problematic task, due to complicated architecture of IListItemRenderers involved.
		 * Selecting an item is especially likely to fail if the item has just been created;  hooking to the
		 * Tree`s UPDATE_COMPLETE event is not less prone to failure either.
		 *
		 * This function attempt to circumvent the issues by delaying the task. Gives best results when invoked
		 * from an UPDATE_COMPLETE event listener too.
		 *
		 * @param	tree
		 * 			The Tree that is to be selected an item.
		 *
		 * @param	item
		 * 			The item to be selected. Must be an item of the tree or an error will occur.
		 *
		 * @param	delay
		 * 			The time, in SECONDS (floating point values are acceptable) to delay the operation with.
		 *
		 * @param	callback
		 * 			Optional. A function to be executed after the delayed attempt to select the item took
		 * 			place. This does NOT, however, ensure you that the item is actually selected.
		 * @param	callbackContext
		 * 			Optional. A context to run the callback in, if that was provided. Defaults to an
		 * 			anonymous, empty object.
		 */
		public static function highlightTreeItem(tree:Tree, item:Object, delay:Number = 0.5, callback:Function =
			null, callbackContext:Object = null):void {
			Time.delay(delay, function():void {
				try {
					tree.selectedItem = item;
					if (item != null) {
						tree.scrollToIndex (tree.selectedIndex);
					}
					if (callback != null) {
						if (callbackContext == null) {
							callbackContext = {};
						}
						callback.apply(callbackContext);
					}
				} catch (e : Error) {
					trace ('Trees.highlightTreeItem crash: ' + e.message);
				}
			});
		}
		
		/**
		 * Convenience method to remove the current highlight from a tree
		 */
		public static function clearHighlight (tree : Tree) : void {
			tree.selectedItem = null;
		}

		/**
		 * Toggles the expanded state of a tree item.
		 *
		 * This is in fact a problematic task, due to complicated architecture of IListItemRenderers involved.
		 * Toggling an item is especially likely to fail if the item has just been created;  hooking to the
		 * Tree`s UPDATE_COMPLETE event is not less prone to failure either.
		 *
		 * This function attempt to circumvent the issues by delaying the task. Gives best results when invoked
		 * from an UPDATE_COMPLETE event listener too.
		 *
		 * @param	tree
		 * 			The Tree that is to be toggled an item.
		 *
		 * @param	item
		 * 			The item to be toggled. Must be an item of the tree or an error will occur.
		 *
		 * @param	open
		 * 			Whether to toggle the item open (true) or closed (false).
		 *
		 * @param	withChildren
		 * 			Whether to toggle the item's children the same way as the item itself (i.e., open a branch and all
		 * 			of its children). Descendants will not be touched. Optional, defaults to false.
		 *
		 * @param	makeVisible
		 * 			Whether to recursively toggle open all ancestors in order to let the opened item show.
		 *
		 * @param	delay
		 * 			The time, in SECONDS (floating point values are acceptable) to delay the operation with.
		 *
		 * @param	callback
		 * 			Optional. A function to be executed after the delayed attempt to toggle the item took
		 * 			place. This does NOT, however, ensure you that the item is actually toggled.
		 * 
		 * @param	callbackContext
		 * 			Optional. A context to run the callback in, if that was provided. Defaults to an
		 * 			anonymous, empty object.
		 */
		public static function toggleTreeItem(tree:Tree, item:Object, open:Boolean, withChildren:Boolean =
			false, makeVisible:Boolean = false, delay:Number = 0.5, callback:Function = null,
			callbackContext:Object = null):void {
			if (item != null) {
				Time.delay(delay, function():void {
					tree.expandItem(item, open);
					// Toggle children too.
					if (withChildren) {
						tree.expandChildrenOf(item, open);
					}
					// EXPAND the path to this item
					if (makeVisible) {
						while (item != null && _getItemParent(item) != null) {
							item = _getItemParent(item);
							tree.expandItem(item, true);
						}
					}
					if (callback != null) {
						if (callbackContext == null) {
							callbackContext = {};
						}
						callback.apply(callbackContext);
					}
				});
			}
		}


		/**
		 * Recursivelly executes a callback function on each of a tree items. The function receives the current
		 * item as its first parameter.
		 *
		 * @param	parentObj
		 * 			The tree structure to walk.
		 *
		 * @param	callback
		 * 			A function to be executed on each item of the tree. Will receive the
		 * 			item as its first parameter. If this function returns the boolean
		 * 			FALSE, walking the tree stops.
		 *
		 * @param	callbackContext
		 * 			Optional. A context to run the callback in. Defaults to an anonymous,
		 * 			empty object.
		 *
		 * @param	... rest
		 * 			For optimisation purposes, the function takes an arbitrary number of
		 * 			arguments. These arguments are passed-in internally when needed to
		 * 			save computational power. You should only set at most the first three
		 * 			arguments of this function.
		 */
		public static function walkTree(parentObj:Object, callback:Function, callbackContext:Object =
			null, ... rest):void {
			if (parentObj != null) {

				var isFirstRun:Boolean = (rest.length == 0);
				if (isFirstRun) {
					_mustAbortRecursion = false;
				}

				if (_mustAbortRecursion) {
					return;
				}

				if (callbackContext == null) {
					callbackContext = {};
				}
				var result:Object = callback.apply(callbackContext, [parentObj]);
				if (result === false) {
					_mustAbortRecursion = true;
					return;
				}

				if (parentObj['children'] != null && parentObj['children'] is Array && (parentObj['children'] as
					Array).length > 0) {
					for (var i:int = 0; i < (parentObj['children'] as Array).length; i++) {
						var childObj:Object = (parentObj['children'] as Array)[i];
						walkTree(childObj, callback, callbackContext, null);
					}
				}
			}
		}

		private static function _getItemParent(item:Object):Object {
			// Object
			if (item.hasOwnProperty('parent')) {
				return item['parent'];
			}
			return null;
		}
	}
}
