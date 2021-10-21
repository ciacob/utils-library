package ro.ciacob.utils {
	import com.fxmarker.FxMarker;
	import com.fxmarker.dataModel.DataModel;
	import com.fxmarker.template.Template;
	import com.fxmarker.writer.Writer;
	
	import flash.filesystem.File;
	
	import ro.ciacob.desktop.io.TextDiskReader;

	public final class Templates {
		private static const FORMATTING_NEW_LINES:RegExp = new RegExp ('[\\s\\n\\r]+(?=<#|</#)', 'g');
		private static const FORMATTING_SPACES:RegExp = new RegExp ('(?<=[\\n\\r])\\s+', 'g');
		
		/**
		 * Storage for cached template content.
		 * @see fillSimpleTemplate()
		 */
		private static var _cachedTemplates : Object = {};

		/**
		 * Fills-in a given template with provided data.
		 * 
		 * @param	templateFile
		 * 			A file on disk to read the template from.
		 * 
		 * @param	templateData
		 * 			A Value Object with data to use for populating the templates. The keys
		 * 			in the `templateData` Object must match the placeholders in the template.
		 * 
		 * @param	stripFormatting
		 * 			Optional, default true. Whether to pre-process the template before filling,
		 * 			in order to remove the newlines and spacings that were only added to make the
		 * 			template more readable (to the developer). 
		 *
		 * @param	useCache
		 * 			Optional, default true. To cache and reuse the template content after initially
		 * 			reading it from disk. Useful to reduce application disk access. 
		 */
		public static function fillSimpleTemplate (
			templateFile : File,
			templateData : Object,
			stripFormatting : Boolean = true,
			useCache : Boolean = true
		) : String {
			var templateSource : String = null;
			var fileUrl : String = templateFile.url;
			if (useCache) {
				if (fileUrl in _cachedTemplates) {
					templateSource = (_cachedTemplates[fileUrl] as String);
				} else {
					templateSource = readTemplate (templateFile);
					if (stripFormatting) {
						templateSource = _discardTemplateCodeFormatting (templateSource);
					}
					_cachedTemplates[fileUrl] = templateSource;
				}
			} else {
				if (fileUrl in _cachedTemplates) {
					delete _cachedTemplates[fileUrl];
				}
				templateSource = readTemplate (templateFile);
				if (stripFormatting) {
					templateSource = _discardTemplateCodeFormatting (templateSource);
				}
			}
			return fillSourceTemplate (templateSource, templateData);
		}

		public static function fillSourceTemplate(src:String, templateData:Object):String {
			var template:Template = FxMarker.instance.getTemplate(src);
			var dataModel:DataModel = new DataModel;
			for (var prop:String in templateData) {
				dataModel.putValue(prop, templateData[prop]);
			}
			var writer:Writer = new Writer;
			template.process(dataModel, writer);
			return writer.writtenData;
		}

		private static function _discardTemplateCodeFormatting(content:String):String {
			var purgedContent:String = content
				.replace(FORMATTING_NEW_LINES, '')
				.replace (FORMATTING_SPACES, '');
			return purgedContent;
		}


		private static function readTemplate(file:File):String {
			file.canonicalize();
			var reader:TextDiskReader = new TextDiskReader;
			var content:String = reader.readContent(file) as String;
			return content;
		}
	}
}
