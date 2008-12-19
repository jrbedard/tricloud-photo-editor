package type.draw
{
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import mx.core.UIComponent;
	import mx.core.Container;
	import mx.containers.Canvas;

	import CloudCursor;



	public class ControlPoint extends Container implements ICloudHistoryClient
	{
		public static const NONE:String = "none";
		public static const HORIZONTAL:String = "hori";
		public static const VERTICAL:String = "vert";
		public static const ANY:String = "any";

		public var dragType:String = ANY; // type for cursor (any, horizontal, vertical, etc)


		// Position in drawCloud space, has to exist to connect line to CP because from different drawTag		
		public var drawCloudPos:Point = new Point(0,0);

		public var curveCP:Boolean = false; // Curve control point

		public var index:uint = 0; // self-contained index within DrawTag


		// Constructor
		public function ControlPoint(posX:Number, posY:Number, curve:Boolean=false)
		{
			this.x = posX;
			this.y = posY;
			curveCP = curve;

			this.width = 16;
			this.height = 16;

			this.scaleX = 1.0;
			this.scaleY = 1.0;

			//this.blendMode = 'invert'; // on red lines?
			//this.filters.pop(); // No filters on CPs 

			this.clipContent = true;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.doubleClickEnabled = true;

			// Set CP Style
			SetCPStyle(false);

			//animate this

			// MOUSE EVENTS
			this.addEventListener("rollOver", onRollOver);
			this.addEventListener("rollOut", onRollOut);
			this.addEventListener("click", onClick);
			this.addEventListener("doubleClick", onDoubleClick);
			this.addEventListener("mouseDown", onMouseDown);
		}


		private function SetCPStyle(selected:Boolean):void
		{
			this.setStyle("borderStyle", "solid");

			if(!curveCP) // Anchor style
			{
				this.setStyle("borderColor", 0xaa0000);
				this.setStyle("backgroundColor", (selected ? 0xFF0202 : 0xa40405));
				this.setStyle("backgroundAlpha", (selected ? 0.55 : 0.25));
			}
			else // Curve style
			{
				this.setStyle("borderColor", 0x00af74);
				this.setStyle("backgroundColor", (selected ? 0x04FF35 : 0x04A475));
				this.setStyle("backgroundAlpha", (selected ? 0.55 : 0.25));
			}
		}



		// Clone ControlPoint
		public virtual function clone():ControlPoint
		{
			var controlPoint:ControlPoint = new ControlPoint(this.x, this.y, this.curveCP);

			controlPoint.dragType = this.dragType;
			controlPoint.drawCloudPos = this.drawCloudPos.clone();
			controlPoint.curveCP = this.curveCP;
			controlPoint.index = this.index;

			return controlPoint;
		}

		// Save ControlPoint XML
		public virtual function Save():XML
		{
			var controlPointXML:XML = new XML("<controlPoint></controlPoint>"); // Create controlPoint XML

			controlPointXML.@x = this.x.toFixed(1);
			controlPointXML.@y = this.y.toFixed(1);

			controlPointXML.@dragType = this.dragType;
			controlPointXML.@drawCloudPosX = this.drawCloudPos.x.toFixed(1);
			controlPointXML.@drawCloudPosY = this.drawCloudPos.y.toFixed(1);
			controlPointXML.@curveCP = this.curveCP;
			controlPointXML.@index = this.index;

			return controlPointXML;
		}

		// Load ControlPoint XML
		public virtual function Load(controlPointXML:XML):void
		{
			if(!controlPointXML)
				return;

			this.x = controlPointXML.@x;
			this.y = controlPointXML.@y;

			this.dragType = controlPointXML.@dragType;
			this.drawCloudPos.x = controlPointXML.@drawCloudPosX;
			this.drawCloudPos.y = controlPointXML.@drawCloudPosY;
			this.curveCP = (controlPointXML.@curveCP == 'true');
			this.index = controlPointXML.@index;
		}




		private function onRollOver(mouseEvent:MouseEvent):void
		{
			if(dragType == ANY)
			{
				CloudCursor.SetCursor(CloudCursor.TRANSLATE);
			}
			else if(dragType == HORIZONTAL)
			{
				CloudCursor.SetCursor(CloudCursor.TRANSLATE_HORI);
			}
			else if(dragType == VERTICAL)
			{
				CloudCursor.SetCursor(CloudCursor.TRANSLATE_VERT);
			}
		}

		private function onRollOut(mouseEvent:MouseEvent):void
		{
			if(!mouseEvent.buttonDown)
			{
				CloudCursor.SetCursor(CloudCursor.NORMAL);
			}
		}


		private function onClick(mouseEvent:MouseEvent):void
		{
			this.dispatchEvent(new CPEvent("clickCP", mouseEvent, this));
		}

		private function onDoubleClick(mouseEvent:MouseEvent):void
		{
			this.dispatchEvent(new CPEvent("doubleClickCP", mouseEvent, this));
		}
		
		private function onMouseDown(mouseEvent:MouseEvent):void
		{
			this.dispatchEvent(new CPEvent("mouseDownCP", mouseEvent, this));
			this.parentApplication.addEventListener("mouseUp", onMouseUpApp);
			SetCPStyle(true);
		}

		private function onMouseUpApp(mouseEvent:MouseEvent):void
		{
			this.parentApplication.removeEventListener("mouseUp", onMouseUpApp);
			SetCPStyle(false);
			CloudCursor.SetCursor(CloudCursor.NORMAL);
		}


		// RENDERER
        // ***********************************
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
/*        	
        	//unscaledWidth = 16;
        	//unscaledHeight = 16;
            width = 16;
            height = 16;
            scaleX = 16 / unscaledWidth;
            scaleX = 16 / unscaledHeight;
*/            
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }

	}
}