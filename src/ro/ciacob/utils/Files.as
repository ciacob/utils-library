package ro.ciacob.utils
{
	import flash.filesystem.File;
	
	import ro.ciacob.utils.constants.FileTypes;

	public final class Files
	{

		public static const CMD_EXE:String='cmd.exe';
		public static const FILE_NAME_INPUT_RESTRICT:String='^\\\\/:*?"<>|';
		public static const WSCRIPT_EXE:String='wscript.exe';
		public static const AUTO_RENAME_SCHEME_WITHOUT_EXTENSION:String='%s(%d)';
		public static const AUTO_RENAME_SCHEME_WITH_EXTENSION:String='%s(%d).%s';
		
		private static const SIZE_AUTO:String='sizeAuto';
		private static const SIZE_BYTES:String='sizeBytes';
		private static const SIZE_GIGA:String='sizeGiga';
		private static const SIZE_KILO:String='sizeKilo';
		private static const SIZE_MEGA:String='sizeMega';
		private static const SIZE_PENTA:String='sizePenta'
		private static const SIZE_TERA:String='sizeTera';
		private static const WIN_SYS32_DIR_NODE:String='winSystem32Short';
		private static const WIN_SYS32_DIR_DEFAULT:String='C:\\windows\\system32';
		private static const WIN_INSTALL_DIR_NODE:String='winInstallDirShort';
		private static const WIN_INSTALL_DIR_DEFAULT:String=File.applicationDirectory.nativePath;
		private static const WIN_TMP_ROOT_NODE:String='winTmpRootShort';
		private static const WIN_TMP_ROOT_DEFAULT:String=File.createTempFile().parent.nativePath;

		/**
		 * The only reliable way to retrieve this value is to have a C program
		 * read it, and then store it into the AIR XML descriptor file, at
		 * instalation time. If missing, we fallback to 'C:\windows\system32\'.
		 *
		 * @return	A String pointing to the Windows `System` directory.
		 */
		public static function get WIN_SYS32_PATH():String
		{
			var path:String=Descriptor.read(WIN_SYS32_DIR_NODE);
			if (!Strings.isEmpty(path))
			{
				if (isValidPath(path))
				{
					return path;
				}
			}
			return WIN_SYS32_DIR_DEFAULT;
		}

		/**
		 * The only reliable way to retrieve an 8.3 compliant version of this path is to
		 * have a C program read it, and then store it into the AIR XML descriptor file,
		 * at instalation time. If missing, we fallback to `File.createTempFile().parent`
		 * (which is not 8.3 compliant, but is better than nothing).
		 *
		 * @return	A String pointing to the directory where the current application
		 * 			has been installed.
		 */
		public static function get WIN_INSTALL_PATH():String
		{
			var path:String=Descriptor.read(WIN_INSTALL_DIR_NODE);
			if (!Strings.isEmpty(path))
			{
				if (isValidPath(path))
				{
					return path;
				}
			}
			return WIN_INSTALL_DIR_DEFAULT;
		}

		/**
		 * The only reliable way to retrieve an 8.3 compliant version of this path is to
		 * have a C program read it, and then store it into the AIR XML descriptor file,
		 * at instalation time. If missing, we fallback to `File.applicationDirectory`
		 * (which is not 8.3 compliant, but is better than nothing).
		 *
		 * @return	A String pointing to the Windows `Temp` directory.
		 */
		public static function get WIN_TMP_ROOT_PATH():String
		{
			var path:String=Descriptor.read(WIN_TMP_ROOT_NODE);
			if (!Strings.isEmpty(path))
			{
				if (isValidPath(path))
				{
					return path;
				}
			}
			return WIN_TMP_ROOT_DEFAULT;
		}


		public static function get APP_EXTENSIONS():Array
		{
			return [FileTypes.BAT, FileTypes.CMD, FileTypes.COM, FileTypes.CPL, FileTypes.EXE, FileTypes.HTA, FileTypes.INF, FileTypes.JS, FileTypes.JSE, FileTypes.MDB, FileTypes.MSC, FileTypes.MSI, FileTypes.MSP, FileTypes.OCX, FileTypes.PIF, FileTypes.SCR, FileTypes.SCT, FileTypes.SHS, FileTypes.SYS, FileTypes.VB, FileTypes.VBE, FileTypes.VBS, FileTypes.WSC, FileTypes.WSF, FileTypes.WSH];
		}

		/**
		 * Changes the name of the given file in such a way that no overwriding would occur by
		 * writing data under that name.
		 *
		 * The renaming scheme is:
		 * <original name>(<counter>).<original extension>
		 *
		 * If the original file name was already available, no change occurs.
		 */
		public static function autoRename(file:File):File
		{
			var counter:int=2;
			var newFile:File=file;
			while (newFile.exists)
			{
				var parent:File=file.parent;
				var strippedName:String=getStrippedOffFileName(file);
				var extension:String=file.extension;
				var newName:String;
				if (extension != null)
				{
					newName=AUTO_RENAME_SCHEME_WITH_EXTENSION.replace('%s', strippedName).replace('%d', counter).replace('%s', extension);
				}
				else
				{
					newName=AUTO_RENAME_SCHEME_WITHOUT_EXTENSION.replace('%s', strippedName).replace('%d', counter);
				}
				newFile=parent.resolvePath(newName);
				counter++;
			}
			return newFile;
		}

		/**
		 * Changes a given file's extension for another, provided the file does not already have the respective extension
		 * (or an accepted alternative, such as JPEG instead of JPG).
		 *
		 * @param	file
		 * 			The file to alter.
		 *
		 * @param	extension
		 * 			The extension that is to replace the old one. If the file already has this extension, no change will
		 * 			be made. If the file has NO extension, it will be added.
		 *
		 * @param	acceptedAlternatives
		 * 			A list of other extensions that will be considered as good as the new one; if the file already
		 * 			has any of those extensions, no change will be made. This parameter is optional.
		 *
		 * @param	append
		 * 			If `true`, will append the correct extension to the file name instead of trying to detect and
		 * 			replace a bogus extension. Has the disadvantage of creating file names like "file.gif.jpeg"
		 * 			but has the advantage of always allowing dots in file names. Defaults to `false`.		
		 *  
		 * @return	A new file object, with the new extension. There is no guarantee that this file exists.
		 */
		public static function changeFileExtension(file:File, extension:String, acceptedAlternatives:Array=null, append : Boolean = false):File {
			if (file != null && !file.isDirectory) {
				extension=Strings.trim(extension);
				if (!Strings.isEmpty(extension)) {
					var isCurrentExtensionOk:Boolean=false;
					var currentFileExtension:String=file.extension;
					if (currentFileExtension != null) {
						if (acceptedAlternatives != null) {
							currentFileExtension=currentFileExtension.toLowerCase();
							for (var i:int=0; i < acceptedAlternatives.length; i++) {
								var alternativeExtension:String=Strings.trim(acceptedAlternatives[i]);
								alternativeExtension=alternativeExtension.toLowerCase();
								if (currentFileExtension == alternativeExtension) {
									isCurrentExtensionOk=true;
									break;
								}
							}
						}
					}
					if (!isCurrentExtensionOk) {
						var path:String;
						if (!append && currentFileExtension != null) {
							var pattern:RegExp=new RegExp('\\.' + Strings.escapePattern(file.extension) + '$');
							path=file.nativePath.replace(pattern, '.' + extension);
						} else {
							path=file.nativePath + '.' + extension;
						}
						file=new File(path);
					}
				}
			}
			return file;
		}


		/**
		 * Deletes the directory content, but not the directory itself. Useful
		 * if you need to maintain the directory's properties, such as permissions,
		 * ownership, time stamps, etc.
		 *
		 * @param	directory
		 * 			The directory whose content is to be deleted.
		 */
		public static function emptyDirectory(directory:File):void
		{
			var contents:Array=directory.getDirectoryListing();
			for (var i:uint=0; i < contents.length; i++)
			{
				var file:File=(contents[i] as File);
				if (file.isDirectory)
				{
					file.deleteDirectory(true);
				}
				else
				{
					file.deleteFile();
				}
			}

		}

		/**
		 * Formats a file size given in bytes in a more human readable format.
		 */
		public static function formatFileSize(bytes:Number, units:String=SIZE_AUTO, digits:int=2):String
		{
			var abbreviations:Array=['b', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb'];
			var scale:Array=[SIZE_BYTES, SIZE_KILO, SIZE_MEGA, SIZE_GIGA, SIZE_TERA, SIZE_PENTA];
			var currIndex:int=0;
			var reqIndex:int=(units == SIZE_AUTO) ? scale.length - 1 : scale.indexOf(units);
			var out:String;
			var hasDecimals:Boolean;
			if (reqIndex >= 0)
			{
				while (currIndex < reqIndex)
				{
					if (bytes < 1024)
					{
						break;
					}
					bytes/=1024;
					hasDecimals=true;
					currIndex++;
				}
				if (hasDecimals)
				{
					out=bytes.toFixed(digits);
				}
				else
				{
					out=bytes.toString();
				}
				out=out.concat(' ', abbreviations[currIndex]);
			}
			return out;
		}

		/**
		 * Returns the size of bytes available at the given location/path.
		 */
		public static function getBytesAtLocation(location:String):Number
		{
			if (isValidPath(location))
			{
				var tmp:File=new File(location);
				if (!tmp.isDirectory)
				{
					return tmp.size;
				}
			}
			return 0;
		}

		/**
		 * Returns the name of the file minus trailing dot and extension; if the file is made
		 * up entirely of an extension (e.g., '.settings'), that extension is returned.
		 *
		 * @param	file
		 * 			A file to strip off.
		 *
		 * @return	The stripped off file name.
		 */
		public static function getStrippedOffFileName(file:File):String
		{
			var name:String=file.name;
			return removeFileNameExtension(name);
		}

		/**
		 * Expects a file name, with no path information, such as "myApp.exe". Will return the given name,
		 * without the trailing extension (removes everything after the last dot, includding the dot itself).
		 * Were the outcome of this process an empty string, the original name is returned instead.
		 */
		public static function removeFileNameExtension(name:String):String
		{
			var original:String=name;
			name=name.replace(/\.[^\.]*$/, '');
			name=Strings.trim(name);
			if (Strings.isEmpty(name))
			{
				return original;
			}
			return name;
		}

		/**
		 * Does its best to resolve given `path` on top of provided `root`, by splitting the path, and resolving each path
		 * segment at a time, so that
		 *
		 * bestEffortResolvePath ('existingFolder1/existingFolder2/unexistingFile', existingRoot);
		 *
		 * still returns a File object that points to '/path/to/existingRoot/existingFolder1/existingFolder2/'.
		 *
		 *
		 *
		 *
		 * @param path A relative string to be resolved. Nothing prevents you from providing an absolute path here, but
		 * 			   this will, most likely, get you nowhere. Repeated separators between path segments are automatically
		 * 			   reduced. No other "cleaning" is performed.
		 *
		 * @param root An existing File in the file system to start from. Note that it does not need to be a folder, e.g.:
		 *
		 * 			   bestEffortResolvePath ('../../style.css', existingFile);
		 *
		 * 			   is a valid usage, and could potentially resolve to file 'style.css', provided that it lives two folders
		 * 			   above `existingFile`.
		 *
		 * @param separator The separator to look for between the path's segments. Optional, defaults to path separator on the
		 * 					current operating system.
		 *
		 * @return The resolved File (which would be, at least, the `root` itself) or `null` in case the root does not exist
		 * 		   (or is `null` itself).
		 */
		public static function bestEffortResolvePath(path:String, root:File, separator:String=null):File
		{
			if (root && root.exists)
			{

				path=Strings.trim(path);
				if (Strings.isEmpty(path))
				{
					return root;
				}

				if (separator == null)
				{
					separator=File.separator;
				}

				var repeatedSeparator:RegExp=new RegExp(Strings.escapePattern(separator).concat('{1,}'), 'g');
				path=path.replace(repeatedSeparator, separator)

				var segments:Array=path.split(separator);
				var test:File=null;
				while (segments.length > 0)
				{
					var segment:String=segments.shift();
					test=root.resolvePath(segment);
					if (!test || !test.exists)
					{
						break;
					}
					root=test;
				}

				return root;
			}
			return null;
		}

		/**
		 * Checks whether given path likely points to an application file.
		 */
		public static function isApplication(path:String):Boolean
		{
			return isOfType(path, APP_EXTENSIONS);
		}

		/**
		 * Checks whether given File points to a volume/drive (i.e., the root entry point
		 * in the file system).
		 */
		public static function isDrive(file:File):Boolean
		{
			return (file != null && file.exists && file.parent == null);
		}

		/**
		 * Tries to match the extension of a given File to one of the types in a list. 
		 */
		public static function isFileOfType(file:File, types:Array):Boolean
		{
			var fileExtension:String=file.extension;
			if (fileExtension != null)
			{
				fileExtension=fileExtension.toLowerCase();
				if (types.indexOf(fileExtension) != -1)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * Checks if the given a path or File is of a certain type. 
		 */
		public static function isOfType(object:*, types:Array):Boolean
		{
			if (object is File)
			{
				return isFileOfType(object, types);
			}
			if (object is String)
			{
				return isPathOfType(object, types);
			}
			return false;
		}

		/**
		 * Checks if the given path is of a certain type.
		 */
		public static function isPathOfType(path:String, types:Array, mustExist:Boolean=true):Boolean
		{
			if (isValidPath(path, mustExist))
			{
				var someFile:File=new File(path);
				return isFileOfType(someFile, types);
			}
			return false;
		}

		/**
		 * Checks if the given File is an image (i.e., has one of the allowed image types).
		 */
		public static function isValidImage(image:File, maxFileSize:Number=NaN):Boolean
		{
			var hasLegitType:Boolean=Files.isFileOfType(image, FileTypes.ALLOWED_IMAGE_TYPES);
			var hasLegitSize:Boolean;
			if (isNaN(maxFileSize))
			{
				hasLegitSize=true;
			}
			else
			{
				hasLegitSize=(image.size <= maxFileSize);
			}
			return (hasLegitType && hasLegitSize);
		}

		/**
		 * Finds whether provided string is a valid path to a local file or folder. Both native and
		 * 'app://' path formats are supported.
		 *
		 * @param path
		 * 		A String to validate as a valid path.
		 *
		 * @param mustExist 
		 * 		Whether a factual (rather than formal) check is to be made: that is, not only
		 * 		needs the given String to correctly point to a file or folder, but that file or
		 * 		folder needs to be existing already -- otherwise, the test will fail.
		 * 
		 * @return
		 * 		True if we deal with a valid path, false otherwise. This method does not throw,
		 * 		regardless of how badly formatted the test string is.
		 */
		public static function isValidPath(path:String, mustExist:Boolean=true):Boolean
		{
			var isValid:Boolean=true;
			if (path.indexOf('app://') == 0)
			{
				path=path.replace('app://', File.applicationDirectory.nativePath.concat(File.separator));
			}
			try
			{
				var someFile:File=new File(path);
				if (mustExist && !someFile.exists)
				{
					isValid=false;
				}
			}
			catch (e:Error)
			{
				isValid=false;
			}
			return isValid;
		}

		/**
		 * Checks if a given path is a valid file or folder name under Windows.
		 * Works under macOS too, but imposes more restrictions than actually needed.
		 */
		public static function isValidRelativePath(path:String):Boolean
		{
			path=Strings.trim(path);
			if (Strings.isEmpty(path))
			{
				return false;
			}
			return Patterns.WINDOWS_VALID_FILE_NAME.test(path);
		}

		/**
		 * Checks whether given string is a valid URL.
		 */
		public static function isValidURL(url:String):Boolean
		{
			return Patterns.LEGAL_URL.test(url);
		}

		/**
		 * Checks whether given File is visible (i.e., is a volume/drive or has
		 * the visibility flag turned on).
		 */
		public static function isVisible(file:File):Boolean
		{
			return (file != null && (isDrive(file) || !file.isHidden));
		}


		/*
		* @private
		* Used by `getDirContent()`
		*/
		private static function recursivelyListDirectory(directory:File, storage:Array, includeDirs:Boolean=true, recursionLevels : int = int.MAX_VALUE) : void {
			if (recursionLevels >= 0) {
				if (directory.isDirectory) {
					var files:Array=directory.getDirectoryListing();
					for (var i:int=0; i < files.length; i++) {
						if (files[i].isDirectory) {
							if (includeDirs) {
								storage.push(files[i]);
							}
							recursivelyListDirectory(files[i], storage, includeDirs, recursionLevels - 1);
						}
						else {
							storage.push(files[i]);
						}
					}
				}
			}
		}

		/**
		 * Produces a Vector of File objects by recursivelly iterating over all items in the given directory.
		 *
		 * NOTE: Listing is done synchronously, therefore running this method in the main worker against large
		 * folders can have detrimental effects on the perceived application performance.
		 *
		 * @param directory
		 * 		The directory to list content of. This directory must exist and be readable, or else
		 * 		an error will be thrown.
		 *
		 * @param includeDirs
		 * 		Optional, default true. Whether to include traversed directories in the output. Note that
		 * 		setting this to `false` will still traverse all the subdirectories found: they will just be
		 * 		excludded from the output.
		 * 
		 * @param recursionLevels
		 * 		Optional. How many levels deep to descend into the folders hierarchy. A setting of `0` will only
		 * 		list the given `directory`; a setting of `1` will list the given `directory` and its immediate
		 * 		children, and so on. If this parameter is left unset, it will default to 2^32, which will be more
		 * 		than enough to cover the entire hierarchy of the given `directory`, for any practical situation.
		 *
		 * @return  Vector.<File>
		 *		A (possibly empty) Vector of File Objects.
		 */
		public static function getDirContent(directory:File, includeDirs:Boolean=true, recursionLevels : int = int.MAX_VALUE) : Vector.<File> {
			var storage:Array = [];
			recursivelyListDirectory (directory, storage, includeDirs, recursionLevels);
			return Vector.<File> (storage);
		}
	}
}
