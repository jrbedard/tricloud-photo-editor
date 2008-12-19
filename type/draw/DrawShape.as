package type.draw
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	import type.DrawCloud;
	import type.DrawCloudPanel;
	import controls.shapeClasses.CloudShape;


	public class DrawShape extends DrawTag
	{
		
		private var shape:CloudShape = null;	


		public function DrawShape()
		{
			super();
			BuildStyle();
		}


		public override function BuildStyle():void
		{
			super.BuildStyle();

			shape = drawStyle.selectedShape;
		}


		// Clone DrawCustomShape
		public override function clone():DrawTag
		{
			var drawShape:DrawShape = super.clone() as DrawShape;
			if(drawShape)
			{
				
			}
			return drawShape;
		}

		// Save DrawCustomShape XML
		public override function Save():XML
		{
			var drawTagXML:XML = super.Save();
			var drawShapeXML:XML = new XML("<drawShape></drawShape>"); // Create drawShape XML

			// ...

			drawTagXML.appendChild(drawShapeXML); // add drawCustomShape XML to drawTag XML
			return drawTagXML;
		}

		// Load DrawCustomShape XML
		public override function Load(drawTagXML:XML):void
		{
			super.Load(drawTagXML);
			var drawShapeXML:XML = drawTagXML..drawShape;
			if(drawShapeXML)
			{
				
			}
		}



		// MOUSE EVENTS
		// -------------------------------------

		public override function onClick(mouseEvent:MouseEvent):void
		{
			
		}

		public override function onMouseDown(mouseEvent:MouseEvent):void
		{
			
		}

		public override function onMouseMove(mouseEvent:MouseEvent):void
		{
			
		}

		public override function onMouseUp(mouseEvent:MouseEvent):void
		{
			super.onMouseUp(mouseEvent);

			CloudHistory.action("New Custom Shape?", DrawCloud(this.parent), true);
		}


		// CONTROL POINT EVENTS
		// ------------------------------

		// MouseDown Control Point
		public override function onMouseDownCP(cpEvent:CPEvent):void
		{
			
		}

		// MouseMove Control Point
		public override function onMouseMoveCP(mouseEvent:MouseEvent):void
		{
			
		}

		// MouseUp Control Point  
		public override function onMouseUpCP(mouseEvent:MouseEvent):void
		{
			CloudHistory.action(this.type + " Transform", this, false);
		}


		// Render graphics with control Points
		public override function RenderGraphics(moveCP:Boolean):void
		{
				
		}
	}
}