package controls.brushClasses
{
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;

	import share.SharedCloud;
	import controls.colorClasses.CloudGradient;


	public class CloudBrush extends SharedCloud
	{
		private static var factoryIndex:uint = 0; // Creation Index

// params
		public var isBitmap:Boolean = false; 

		public var defaultSize:uint = 5;

// vars
		[Bindable]
		public var size:uint = 5;

		[Bindable]
		public var alpha:Number = 1.0;

		[Bindable]
		public var flow:Number = 1.0;

		[Bindable]
		public var hardness:Number = 1.0;


		// Line based brush
		public var isGradient:Boolean = false;

		public var gradient:CloudGradient = null;

		//style
		public var lineCaps:String = CapsStyle.ROUND;
		public var lineJoints:String = JointStyle.ROUND;



		// Constructor 
		public function CloudBrush()
		{
			this.localID = factoryIndex++;

			iconBitmap = new Globals.g_assets.Brush00;
		}


		public function clone():CloudBrush
		{
			var cloudBrush:CloudBrush = new CloudBrush();

			cloudBrush.remoteID = this.remoteID;
			cloudBrush.name = this.name;
			cloudBrush.isBitmap = this.isBitmap;

			cloudBrush.iconBitmap = this.iconBitmap; // todo

			cloudBrush.defaultSize = this.defaultSize;
			cloudBrush.size = this.size;
			cloudBrush.alpha = this.alpha;
			cloudBrush.flow = this.flow;
			cloudBrush.hardness = this.hardness;

			cloudBrush.isGradient = this.isGradient;
			if(this.gradient)
			{
				cloudBrush.gradient = this.gradient.clone();
			}

			cloudBrush.lineCaps = this.lineCaps;
			cloudBrush.lineJoints = this.lineJoints;

			return cloudBrush;
		}

		// SAVE Brush XML
		public function Save():XML
		{
			var brushXML:XML = new XML("<brush></brush>");

			//brushXML.@localID = this.localID;
			brushXML.@remoteID = this.remoteID;
			brushXML.@name = this.name;

			brushXML.@isBitmap = this.isBitmap;

			//brushXML.@bitmap = this.bitmap; // todo

			brushXML.@defaultSize = this.defaultSize;
			brushXML.@size = this.size;
			brushXML.@alpha = this.alpha;
			brushXML.@flow = this.flow;
			brushXML.@hardness = this.hardness;

			brushXML.@isGradient = this.isGradient;
			if(this.gradient)
			{
				var gradientXML:XML = this.gradient.Save();
				brushXML.appendChild( gradientXML );
			}

			brushXML.@lineCaps = this.lineCaps;
			brushXML.@lineJoints = this.lineJoints;

			return brushXML;
		}
		

		// LOAD Brush XML
		public function Load(brushXML:XML):void
		{
			if(!brushXML)
				return;
			
			//this.localID = brushXML.@localID;
			this.remoteID = brushXML.@remoteID;
			this.name = brushXML.@name;
		
			this.isBitmap = (brushXML.@isBitmap == 'true');

			//brushXML.@bitmap = this.bitmap; // todo

			this.defaultSize = brushXML.@defaultSize;
			this.size = brushXML.@size;
			this.alpha = brushXML.@alpha;
			this.flow = brushXML.@flow;
			this.hardness = brushXML.@hardness;

			this.isGradient = (brushXML.@isGradient == 'true');
			var gradientXML:XML = (brushXML..drawTag)[0];
			if(gradientXML)
			{
				this.gradient.Load( gradientXML );
			}

			this.lineCaps = brushXML.@lineCaps;
			this.lineJoints = brushXML.@lineJoints;
		}

		
	}
}