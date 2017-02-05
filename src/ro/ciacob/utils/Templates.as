package ro.ciacob.utils {
	import com.fxmarker.FxMarker;
	import com.fxmarker.dataModel.DataModel;
	import com.fxmarker.template.Template;
	import com.fxmarker.writer.Writer;
	
	import flash.filesystem.File;
	
	import ro.ciacob.desktop.io.TextDiskReader;

	public final class Templates {
		private static const FORMATTING_NEW_LINES:RegExp = new RegExp('[\\s\\n\\r]+(?=<#|</#)',
			'g');
		private static const FORMATTING_SPACES:RegExp = new RegExp('(?<=[\\n\\r])\\s+',
			'g');

		public static function fillSimpleTemplate(templateFile:File, templateData:Object, stripFormatting : Boolean = true):String {
			var templateSource:String = readTemplate(templateFile);
			if (stripFormatting) {
				templateSource = _discardTemplateCodeFormatting(templateSource);
			}
			return fillSourceTemplate(templateSource, templateData);
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
			var purgedContent:String = content.replace(FORMATTING_NEW_LINES, '').
				replace(FORMATTING_SPACES, '');
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
