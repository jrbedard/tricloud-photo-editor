package type.text
{
	import flash.text.*;
	import controls.warpClasses.CloudWarp;


	public class TextStyle
	{
		// colors & alphas		
		[Bindable]
		public var color:uint = 0x000000;
		[Bindable]
		public var alpha:Number = 1.0;
		[Bindable]
		public var backgroundColor:uint = 0xFFFFFF;
		[Bindable]
		public var backgroundAlpha:Number = 0.0;


		// TEXT
		[Bindable]
		public var textAlign:String = TextFormatAlign.CENTER;
		[Bindable]
		public var textIndent:uint = 0;
		[Bindable]
		public var leading:uint = 0;
		[Bindable]
		public var textDecoration:String = "none";


		// FONT
		[Bindable]
		public var fontFamily:String = "Ball";
		[Bindable]
		public var fontSize:uint = 25;
		[Bindable]
		public var fontWeight:String = "normal";
		[Bindable]
		public var fontStyle:String = "normal";


		// constants...
		[Bindable]
		public var fontAntiAliasType:String = AntiAliasType.ADVANCED;
		[Bindable]
		public var fontThickness:uint = 0;
		[Bindable]
		public var fontSharpness:uint = 0;
		[Bindable]
		public var fontGridFitType:String = GridFitType.PIXEL;


		// Warp
		[Bindable]
		public var selectedWarp:CloudWarp = new CloudWarp();



	
		public function TextStyle()
		{
		
		}


		// Clone textStyle
		public function clone():TextStyle
		{
			var textStyle:TextStyle = new TextStyle();

			textStyle.color = this.color;
			textStyle.alpha = this.alpha;
			textStyle.backgroundColor = this.backgroundColor;
			textStyle.backgroundAlpha = this.backgroundAlpha;

			textStyle.textAlign = this.textAlign;
			textStyle.textIndent = this.textIndent;
			textStyle.leading = this.leading;
			textStyle.textDecoration = this.textDecoration;

			textStyle.fontFamily = this.fontFamily;
			textStyle.fontSize = this.fontSize;
			textStyle.fontWeight = this.fontWeight;
			textStyle.fontStyle = this.fontStyle;

			textStyle.fontAntiAliasType = this.fontAntiAliasType;
			textStyle.fontThickness = this.fontThickness;
			textStyle.fontSharpness = this.fontSharpness;
			textStyle.fontGridFitType = this.fontGridFitType;

			textStyle.selectedWarp = this.selectedWarp.clone();

			return textStyle;
		}


		// Save textStyle XML
		public function Save():XML
		{
			var textStyleXML:XML = new XML("<textStyle></textStyle>"); // Create textStyle XML

			textStyleXML.@color = this.color;
			textStyleXML.@alpha = this.alpha;
			textStyleXML.@backgroundColor = this.backgroundColor;
			textStyleXML.@backgroundAlpha = this.backgroundAlpha;

			textStyleXML.@textAlign = this.textAlign;
			textStyleXML.@textIndent = this.textIndent;
			textStyleXML.@leading = this.leading;
			textStyleXML.@textDecoration = this.textDecoration;

			textStyleXML.@fontFamily = this.fontFamily;	
			textStyleXML.@fontSize = this.fontSize;
			textStyleXML.@fontWeight = this.fontWeight;
			textStyleXML.@fontStyle = this.fontStyle;

			textStyleXML.@fontAntiAliasType = this.fontAntiAliasType;
			textStyleXML.@fontThickness = this.fontThickness;
			textStyleXML.@fontSharpness = this.fontSharpness;
			textStyleXML.@fontGridFitType = this.fontGridFitType;

			//textStyle.selectedWarp = this.selectedWarp.clone();

			return textStyleXML;
		}

		// Load textStyle XML
		public function Load(textCloudXML:XML):void
		{
			var textStyleXML:XML = (textCloudXML..textStyle)[0]; // textStyle
			if(!textStyleXML)
				return;

			this.color = textStyleXML.@color;
			this.alpha = textStyleXML.@alpha;
			this.backgroundColor = textStyleXML.@backgroundColor;
			this.backgroundAlpha = textStyleXML.@backgroundAlpha;

			this.textAlign = textStyleXML.@textAlign;
			this.textIndent = textStyleXML.@textIndent;
			this.leading = textStyleXML.@leading;
			this.textDecoration = textStyleXML.@textDecoration;

			this.fontFamily = textStyleXML.@fontFamily;
			this.fontSize = textStyleXML.@fontSize;
			this.fontWeight = textStyleXML.@fontWeight;
			this.fontStyle = textStyleXML.@fontStyle;

			this.fontAntiAliasType = textStyleXML.@fontAntiAliasType;
			this.fontThickness = textStyleXML.@fontThickness;
			this.fontSharpness = textStyleXML.@fontSharpness;
			this.fontGridFitType = textStyleXML.@fontGridFitType;

			//textStyle.selectedWarp = this.selectedWarp.clone();
		}
	}
}