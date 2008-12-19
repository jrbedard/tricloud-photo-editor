package controls.fontClasses
{
	import flash.display.Bitmap;
	import flash.text.FontStyle;
	import flash.text.FontType;
	import flash.text.Font;

	import share.SharedCloud;



	// Meta Font class
	public class CloudFont extends SharedCloud
	{
		private static var factoryIndex:uint = 0; // Creation Index


		public var fontStyle:String = FontStyle.REGULAR;
		public var fontType:String = FontType.EMBEDDED;



		public function CloudFont()
		{
			this.localID = factoryIndex++;

			iconBitmap = null;
		}


		// clone FONT
		public function clone():CloudFont
		{
			var cloudFont:CloudFont = new CloudFont();

			cloudFont.remoteID = this.remoteID;
			cloudFont.name = this.name;

			// icon
			// swf

			cloudFont.fontStyle = this.fontStyle;
			cloudFont.fontType = this.fontType; 

			return cloudFont;
		}

		// SAVE Font XML
		public function Save():XML
		{
			var fontXML:XML = new XML("<font></font>");

			fontXML.@remoteID = this.remoteID;
			fontXML.@name = this.name;

			// icon
			// swf

			fontXML.@fontStyle = this.fontStyle;
			fontXML.@fontType = this.fontType;

			return fontXML;
		}

		// LOAD Font XML
		public function Load(fontXML:XML):void
		{
			if(!fontXML)
				return;

			this.remoteID = fontXML.@remoteID;
			this.name = fontXML.@name;

			// icon
			// swf

			this.fontStyle = fontXML.@fontStyle;
			this.fontType = fontXML.@fontType;
		}
		
		
	}
}