package core
{
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import mx.core.UIComponent;
	import mx.core.Container;
	import mx.containers.Canvas;

	import CloudCursor;



	public class CloudNavCP extends Container
	{
		public static const radius:int = 8;


		public static const NONE:String = "none";
		public static const HORIZONTAL:String = "hori";
		public static const VERTICAL:String = "vert";
		public static const ANY:String = "any";

		public var dragType:String = ANY; // type for cursor (any, horizontal, vertical, etc)

		
		//public var drawCloudPos:Point = new Point(0,0);

		public var index:uint = 0;


		public var _color:uint = 0x00FF00;


		public function set color(value:uint):void
		{
			_color = value;
			DrawCP();
		}
		[Bindable]
		public function get color():uint
		{
			return _color;
		}
		
		
		


		public function CloudNavCP()
		{
			//this.x = posX;
			//this.y = posY;
			//curveCP = curve;

			this.width = radius * 2;
			this.height = radius * 2;

			this.alpha = 0.25;

			//this.blendMode = 'invert'; // on red lines?
			//this.filters.pop(); // No filters on CPs 

			this.clipContent = true;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.doubleClickEnabled = true;

			//this.mouseEnabled = false; // for mouseMove over it, set it to true while mouseUp


/*
			this.setStyle("borderStyle", "solid");
			this.setStyle("borderColor", 0xaa0000);

			this.setStyle("backgroundColor", 0xa40405);
			this.setStyle("backgroundAlpha", 0.25);
*/
			DrawCP();

			//animate this

			// MOUSE EVENTS
			this.addEventListener("rollOver", onRollOver);
			this.addEventListener("rollOut", onRollOut);
			this.addEventListener("click", onClick);
			this.addEventListener("doubleClick", onDoubleClick);
			this.addEventListener("mouseDown", onMouseDown);

			//this.parentApplication.addEventListener("mouseUp", onMouseUpApp);
		}


		private function DrawCP():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x000000, 0.75);
			this.graphics.beginFill(color, 0.75);
			this.graphics.drawCircle(radius, radius, radius);
			this.graphics.endFill();

			//this.graphics.
		}




		private function onRollOver(mouseEvent:MouseEvent):void
		{
			this.alpha = 1.0;

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
			this.alpha = 0.25;

			if(!mouseEvent.buttonDown)
			{
				CloudCursor.SetCursor(CloudCursor.NORMAL);
			}
		}


		private function onClick(mouseEvent:MouseEvent):void
		{
			//this.dispatchEvent(new CPEvent("clickCP", mouseEvent, this));
		}

		private function onDoubleClick(mouseEvent:MouseEvent):void
		{
			//this.dispatchEvent(new CPEvent("doubleClickCP", mouseEvent, this));
		}
		
		private function onMouseDown(mouseEvent:MouseEvent):void
		{
			//this.dispatchEvent(new CPEvent("mouseDownCP", mouseEvent, this));
		}

		private function onMouseUpApp(mouseEvent:MouseEvent):void
		{
			CloudCursor.SetCursor(CloudCursor.NORMAL);
		}

	}
}