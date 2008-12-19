package type.draw
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Matrix;

	import type.DrawCloud;



	public class DrawEllipse extends DrawTag
	{

		public function DrawEllipse()
		{
			super();
			BuildStyle();
		}

		public override function BuildStyle():void
		{
			super.BuildStyle();

			//filled = drawStyle.filled; // filled ellipse
		}


		// Clone DrawEllipse
		public override function clone():DrawTag
		{
			var drawEllipse:DrawEllipse = super.clone() as DrawEllipse;
			if(drawEllipse)
			{
				
			}
			return drawEllipse;
		}

		// Save DrawEllipse XML
		public override function Save():XML
		{
			var drawTagXML:XML = super.Save();
			var drawEllipseXML:XML = new XML("<drawEllipse></drawEllipse>"); // Create drawEllipse XML

			// ...

			drawTagXML.appendChild(drawEllipseXML); // add drawEllipseXML to drawTag XML
			return drawTagXML;
		}

		// Load DrawEllipse XML
		public override function Load(drawTagXML:XML):void
		{
			super.Load(drawTagXML);
			var drawEllipseXML:XMLList = drawTagXML..drawEllipse;
			if(drawEllipseXML[0]) // 1 ellipse
			{
				
			}
		}


		public override function onClick(mouseEvent:MouseEvent):void
		{
			
		}


		public override function onMouseDown(mouseEvent:MouseEvent):void
		{
			super.onMouseDown(mouseEvent);

			// Create Control Points
			// Y
			controlPoints[0] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x, 
												mouseEvent.localY + cloudTagOffset.y); // bottom or top, origin horizontal
			controlPoints[0].dragType = ControlPoint.VERTICAL;

			controlPoints[1] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x,
												mouseEvent.localY + cloudTagOffset.y);  // bottom or top, depending on origin
			controlPoints[1].dragType = ControlPoint.VERTICAL;

			// X
			controlPoints[2] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x,
												mouseEvent.localY + cloudTagOffset.y); // left of right, origin vertical
			controlPoints[2].dragType = ControlPoint.HORIZONTAL;

			controlPoints[3] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x,
												mouseEvent.localY + cloudTagOffset.y); // left of right, width horizontal
			controlPoints[3].dragType = ControlPoint.HORIZONTAL;
		}


		public override function onMouseMove(mouseEvent:MouseEvent):void
		{
			// compute widht and height of the rectangle
			controlPoints[3].x = mouseEvent.localX + cloudTagOffset.x;
			controlPoints[1].y = mouseEvent.localY + cloudTagOffset.y;

			RenderGraphics(false);
		}


		public override function onMouseUp(mouseEvent:MouseEvent):void
		{
			super.onMouseUp(mouseEvent);

			// Compute remaining Control Points for them to be in the middle of each sides
			controlPoints[2].y = (controlPoints[1].y + controlPoints[0].y)*0.5;
			controlPoints[3].y = (controlPoints[1].y + controlPoints[0].y)*0.5;

			controlPoints[0].x = (controlPoints[3].x + controlPoints[2].x)*0.5;
			controlPoints[1].x = (controlPoints[3].x + controlPoints[2].x)*0.5;

			ActivateControlPoints(); // activate the control points

			CloudHistory.action("New Ellipse", DrawCloud(this.parent), true);
		}


		// MouseDown Control Point
		public override function onMouseDownCP(cpEvent:CPEvent):void
		{
			super.onMouseDownCP(cpEvent);
		}

		// MouseMove Control Point
		public override function onMouseMoveCP(mouseEvent:MouseEvent):void
		{
			if(!curCP)
				return;
			
			// Local Position are in drawTag space
			if(curCP.index == 0 || curCP.index == 1) // vertical resizing
			{
				curCP.y = mouseEvent.localY - cursorCPOffset.y; // cursorCPOffset to keep cursor offset within CP
				controlPoints[curCP.index] = curCP;

				controlPoints[2].y = (controlPoints[1].y + controlPoints[0].y)*0.5;
				controlPoints[3].y = (controlPoints[1].y + controlPoints[0].y)*0.5;
			}
			else // horizontal resizing
			{
				curCP.x = mouseEvent.localX - cursorCPOffset.x;
				controlPoints[curCP.index] = curCP;

				controlPoints[0].x = (controlPoints[3].x + controlPoints[2].x)*0.5;
				controlPoints[1].x = (controlPoints[3].x + controlPoints[2].x)*0.5;
			}

			// Render graphics with control Points
			RenderGraphics(true);
		}


		// MouseUp Control Point
		public override function onMouseUpCP(mouseEvent:MouseEvent):void
		{
			// recompute cp drawCloud pos
			UpdateDrawCloudPos();

			CloudHistory.action(this.type + " Scaling", this, false);
		}


		// Render graphics with control Points
		public override function RenderGraphics(moveCP:Boolean):void
		{
			// Compute tag's dimension
			tagWidth = controlPoints[3].x - controlPoints[2].x;
			tagHeight = controlPoints[1].y - controlPoints[0].y;


			this.graphics.clear(); // Clear surface

			if(drawStyle.isLineGradient) // line gradient
			{
				drawStyle.lineGradientMatrix.createGradientBox(tagWidth, // width
															   tagHeight, // height
															   drawStyle.lineGradient.rotation,
															   controlPoints[2].x + (moveCP?cpOffset:0),
															   controlPoints[0].y + (moveCP?cpOffset:0));
			}
			SetLineStyle();


			if(drawStyle.filledEllipse) // filled ellispse
			{
				if(drawStyle.isFillGradient) // gradient fill
				{
					drawStyle.fillGradientMatrix.createGradientBox(tagWidth, // width
																   tagHeight, // height
																   drawStyle.fillGradient.rotation,
																   controlPoints[2].x + (moveCP?cpOffset:0), // tx
																   controlPoints[0].y + (moveCP?cpOffset:0)); // ty
				}
				SetFillStyle();	
			}

			this.graphics.drawEllipse(controlPoints[2].x + (moveCP?cpOffset:0), // origin X
									  controlPoints[0].y + (moveCP?cpOffset:0), // origin Y
									  tagWidth, // width 
									  tagHeight);// height

			if(drawStyle.filledEllipse) // filled ellipse
			{
				this.graphics.endFill(); // Finish filling
			}
		}

	}
}