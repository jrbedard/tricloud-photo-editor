package type.draw
{
	import flash.display.JointStyle;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import type.DrawCloudPanel;
	import type.DrawCloud;


	public class DrawLine extends DrawTag
	{

		public function DrawLine()
		{
			super();
			BuildStyle();
		}

		public override function BuildStyle():void
		{
			super.BuildStyle();

			// line's end
			if(drawStyle.roundEndedLine)
			{
				drawStyle.lineCaps = CapsStyle.ROUND;	
			}
			else
			{
				drawStyle.lineCaps = CapsStyle.SQUARE;
			}
		}


		// Clone DrawLine
		public override function clone():DrawTag
		{
			var drawLine:DrawLine = super.clone() as DrawLine;
			if(drawLine)
			{
				
			}
			return drawLine;
		}

		// Save DrawLine XML
		public override function Save():XML
		{
			var drawTagXML:XML = super.Save();
			var drawLineXML:XML = new XML("<drawLine></drawLine>"); // Create drawLine XML

			// ...

			drawTagXML.appendChild(drawLineXML); // add drawLineXML to drawTag XML
			return drawTagXML;
		}

		// Load DrawLine XML
		public override function Load(drawTagXML:XML):void
		{
			super.Load(drawTagXML);
			var drawLineXML:XMLList = drawTagXML..drawLine;
			if(drawLineXML[0])
			{
				
			}
		}


		// MOUSE EVENTS
		// -------------------------------------

		public override function onClick(mouseEvent:MouseEvent):void
		{
			
		}


		// MouseDown on DrawCloud
		public override function onMouseDown(mouseEvent:MouseEvent):void
		{
			super.onMouseDown(mouseEvent);

			// Create Control Points
			// Line Begin
			controlPoints[0] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x, 
												mouseEvent.localY + cloudTagOffset.y); // line's origin
			controlPoints[0].dragType = ControlPoint.ANY;

			// Line End
			controlPoints[1] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x,
												mouseEvent.localY + cloudTagOffset.y); // line's destination
			controlPoints[1].dragType = ControlPoint.ANY;

			// Curve
			controlPoints[2] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x,
												mouseEvent.localY + cloudTagOffset.y, true); // curve
			controlPoints[2].dragType = ControlPoint.ANY;
		}


		// MouseMove on DrawCloud
		public override function onMouseMove(mouseEvent:MouseEvent):void
		{
			controlPoints[1].x = mouseEvent.localX + cloudTagOffset.x;
			controlPoints[1].y = mouseEvent.localY + cloudTagOffset.y;

			// Render Line Graphics
			RenderGraphics(false);
		}


		// MouseUp on DrawCloud
		public override function onMouseUp(mouseEvent:MouseEvent):void
		{
			super.onMouseUp(mouseEvent);

			controlPoints[2].x = (controlPoints[1].x - controlPoints[0].x)*0.5; 
			controlPoints[2].y = (controlPoints[1].y - controlPoints[0].y)*0.5;

			ActivateControlPoints(); // activate the control points

			CloudHistory.action("New Line", DrawCloud(this.parent), true);
		}


		// CONTROL POINT EVENTS
		// ------------------------------

		// MouseDown Control Point
		public override function onMouseDownCP(cpEvent:CPEvent):void
		{
			super.onMouseDownCP(cpEvent);
		}

		// MouseMove Control Point
		public override function onMouseMoveCP(mouseEvent:MouseEvent):void
		{
			if(!curCP)
			{
				trace('onMouseMoveCP Line, no CP');
				return;
			}

			// Local Position are in drawTag space
			curCP.x = mouseEvent.localX - cursorCPOffset.x; // cursorCPOffset to keep cursor offset within CP
			curCP.y = mouseEvent.localY - cursorCPOffset.y;

			// New control point position
			controlPoints[curCP.index] = curCP;

			// Render graphics with control Points
			RenderGraphics(true);
		}


		// MouseUp Control Point
		public override function onMouseUpCP(mouseEvent:MouseEvent):void
		{
			// recompute cp drawCloud pos
			UpdateDrawCloudPos();

			if(!drawStyle.curvedLine) // not curved
			{
				// middle of control points + origin offset
				controlPoints[2].x = (controlPoints[1].x - controlPoints[0].x)*0.5 + controlPoints[0].x; 
				controlPoints[2].y = (controlPoints[1].y - controlPoints[0].y)*0.5 + controlPoints[0].y;
			}

			CloudHistory.action(this.type + " Transform", this, false);
		}




		// Render graphics with control Points
		public override function RenderGraphics(moveCP:Boolean):void
		{
			// Compute tag's dimension
			tagWidth = controlPoints[1].x - controlPoints[0].x;
			tagHeight = controlPoints[1].y - controlPoints[0].y;

			this.graphics.clear(); // Clear surface

			if(drawStyle.isLineGradient) // line gradient
			{
				var rotation:Number = Math.atan2(tagWidth, tagHeight);
				var lineLength:Number = Math.sqrt(Math.pow(tagWidth, 2)+  Math.pow(tagHeight, 2));

				// override rotation
				//drawStyle.lineGradient.rotation = -rotation - Math.PI/2;//rotation;

				drawStyle.lineGradientMatrix.createGradientBox(lineLength, // width
															   drawStyle.lineThickness, // height
															   drawStyle.lineGradient.rotation,
															   controlPoints[0].x + (moveCP?cpOffset:0),
															   controlPoints[0].y + (moveCP?cpOffset:0));
			}
			SetLineStyle(); // Set line style


			// origin
			this.graphics.moveTo(controlPoints[0].x + (moveCP?cpOffset:0),  // origin X
								 controlPoints[0].y + (moveCP?cpOffset:0)); // origin Y


			if(drawStyle.curvedLine) // curve
			{
				controlPoints[2].visible = true;

				// Draw curve
				this.graphics.curveTo(controlPoints[2].x + (moveCP?cpOffset:0), // Curve CP X
									  controlPoints[2].y + (moveCP?cpOffset:0), // Curve CP Y
									  controlPoints[1].x + (moveCP?cpOffset:0), // dest X
									  controlPoints[1].y + (moveCP?cpOffset:0)); // dest Y
			}
			else // line
			{
				controlPoints[2].visible = false;

				// Draw straight line from begin to current cursor position - controlPoint offset
				this.graphics.lineTo(controlPoints[1].x + (moveCP?cpOffset:0), // dest X
									 controlPoints[1].y + (moveCP?cpOffset:0)); // dest Y
			}

			if(drawStyle.isLineGradient)
			{
				this.graphics.endFill();
			}
		}


	}
}