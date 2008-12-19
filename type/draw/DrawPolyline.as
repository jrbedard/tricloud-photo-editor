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


	public class DrawPolyline extends DrawTag
	{

		private var curvedShape:Boolean = false;

		private var cpIndex:uint = 0; // Shape's CP index

		public var closingCP:ControlPoint = null; // Closing Control Point: the one the last line links to..


		private var fillPass:Boolean = false;
		private var boundRect:Rectangle = null;



		public function DrawPolyline()
		{
			super();
			BuildStyle();
		}

		public override function BuildStyle():void
		{
			super.BuildStyle();

			// smooth joints
			drawStyle.lineCaps = CapsStyle.ROUND;
			drawStyle.lineJoints = JointStyle.MITER;
			drawStyle.lineJointMiterLimit = 2.0;

			if(closingCP)
			{
				// Render Line Graphics
				RenderGraphics(true); // SLOWWW when changing colors
			}
		}


		// Clone DrawPolyline
		public override function clone():DrawTag
		{
			var drawPolyline:DrawPolyline = super.clone() as DrawPolyline;
			if(drawPolyline)
			{
				
			}
			return drawPolyline;
		}

		// Save DrawPolyline XML
		public override function Save():XML
		{
			var drawTagXML:XML = super.Save();
			var drawPolylineXML:XML = new XML("<drawPolyline></drawPolyline>"); // Create drawPolyline XML

			// ...

			drawTagXML.appendChild(drawPolylineXML); // add drawPolylineXML to drawTag XML
			return drawTagXML;
		}

		// Load DrawPolyline XML
		public override function Load(drawTagXML:XML):void
		{
			super.Load(drawTagXML);
			var drawShapeXML:XMLList = drawTagXML..drawPolyline;
			if(drawShapeXML[0])
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
			// not filled while drawing
			drawStyle.filledPolyline = false;


			if(!curCP) // first time only
			{
				super.onMouseDown(mouseEvent); // position the drawTag

				// Initial origin Control Point
				controlPoints[cpIndex] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x,
														  mouseEvent.localY + cloudTagOffset.y); // line's destination
				controlPoints[cpIndex].dragType = ControlPoint.ANY;
			}

			// Activate the Control Points created so far
			ActivateControlPoints();


			++cpIndex; // Increment Index

			// Create New Control Point
			controlPoints[cpIndex] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x,
													  mouseEvent.localY + cloudTagOffset.y); // line's destination
			controlPoints[cpIndex].dragType = ControlPoint.ANY;


			// Set Current control Point
			curCP = controlPoints[cpIndex];


			// CURVE CP
			++cpIndex; // Increment Index

			// Create New Control Point
			controlPoints[cpIndex] = new ControlPoint((controlPoints[cpIndex-1].x - controlPoints[cpIndex-2].x)*0.5,
													  (controlPoints[cpIndex-1].y - controlPoints[cpIndex-2].y)*0.5, true); // line's destination
			controlPoints[cpIndex].dragType = ControlPoint.ANY;
		}



		public override function onMouseMove(mouseEvent:MouseEvent):void
		{
			if(!curCP)
				return;

			// Current Control Point
			curCP.x = mouseEvent.localX + cloudTagOffset.x;
			curCP.y = mouseEvent.localY + cloudTagOffset.y;

			// Compute Curve's CP position
			if(cpIndex > 2)
			{
				controlPoints[cpIndex].x = (curCP.x + controlPoints[cpIndex-3].x + cpOffset)*0.5;
				controlPoints[cpIndex].y = (curCP.y + controlPoints[cpIndex-3].y + cpOffset)*0.5;
			}
			else
			{
				controlPoints[cpIndex].x = (curCP.x + controlPoints[cpIndex-2].x + cpOffset)*0.5;
				controlPoints[cpIndex].y = (curCP.y + controlPoints[cpIndex-2].y + cpOffset)*0.5;
			}

			// Render Line Graphics
			RenderGraphics(true);
		}


		public override function onMouseUp(mouseEvent:MouseEvent):void
		{
			super.onMouseUp(mouseEvent);

		}


		// The shape was closed by clicking on an existing control point
		public function ClosePolyline(cp:ControlPoint):void
		{
			// weld curCP to cp
			closingCP = cp; // assign closing CP to the clicked CP

			// Activate the Control Points created so far
			ActivateControlPoints();
			this.removeChildAt(this.numChildren-2); // Remove the last superflous closing control point

			if(drawStyle.filledPolyline)
			{
				fillPass = true;
			}

			// Draw Filled Shape
			RenderGraphics(true);

			CloudHistory.action("New Shape", DrawCloud(this.parent), true);
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
				return;

			// Local Position are in drawTag space
			curCP.x = mouseEvent.localX - cursorCPOffset.x; // cursorCPOffset to keep cursor offset within CP
			curCP.y = mouseEvent.localY - cursorCPOffset.y;

			// New control point position
			controlPoints[curCP.index] = curCP;

			if(drawStyle.filledPolyline)
			{
				fillPass = true;
			}

			// Render graphics with control Points
			RenderGraphics(true);
		}


		// MouseUp Control Point  
		public override function onMouseUpCP(mouseEvent:MouseEvent):void
		{
			// Recompute cp drawCloud pos
			UpdateDrawCloudPos();

			CloudHistory.action(this.type + " Transform", this, false);
		}


		// Render graphics with control Points
		public override function RenderGraphics(moveCP:Boolean):void
		{
			if(!drawStyle.filledPolyline) // Not filled
			{
				this.graphics.clear(); // Clear surface
			}

			if(drawStyle.filledPolyline && fillPass) // Fill Pass
			{
				this.graphics.clear(); // Clear surface

				// Create a 1-thick lined shape of the closed shape
				this.graphics.lineStyle(1, 0x000000, 1.0,
					true, "normal", drawStyle.lineCaps, drawStyle.lineJoints);

			}
			else
			{
				SetLineStyle(); // Set line style
			}

			// no control points
			if(!controlPoints.length)
				return;

			// origin
			this.graphics.moveTo(controlPoints[0].x + (moveCP?cpOffset:0),  // origin X
								 controlPoints[0].y + (moveCP?cpOffset:0)); // origin Y


			// For each control point
			for(var cp:uint = 1; cp < controlPoints.length; ++cp)
			{
				if(!(cp%2)) // curve control point
				{
					continue;
				}

				if(cp == controlPoints.length-2) // Last control point (the one we are dragging)
				{
					moveCP = false;
					if(closingCP) // If there is the closing CP
					{
						moveCP = true;
						controlPoints[cp] = closingCP;	// last CP is the Closing CP
					}
				}

				if(curvedShape) // curved Shape
				{
					controlPoints[cp+1].visible = true; // Curve CP visible

					// Draw curve
					this.graphics.curveTo(controlPoints[cp+1].x + (moveCP?cpOffset:0), // Curve CP X
										  controlPoints[cp+1].y + (moveCP?cpOffset:0), // Curve CP Y
										  controlPoints[cp].x + (moveCP?cpOffset:0), // dest X
										  controlPoints[cp].y + (moveCP?cpOffset:0)); // dest Y
				}
				else // line
				{
					controlPoints[cp+1].visible = false; // Curve CP invisible

					// Draw straight line from begin to current cursor position - controlPoint offset
					this.graphics.lineTo(controlPoints[cp].x + (moveCP?cpOffset:0),  // dest X
										 controlPoints[cp].y + (moveCP?cpOffset:0)); // dest Y
				}

			}


			if(drawStyle.filledPolyline && fillPass) // Fill Pass
			{
				FillShape(); // Fill the polyline
			}

		}


		// Attempt to fill the shape
		private function FillShape():void
		{
			// Compute closed shape bounding rec
			ComputeBoundRect(false);

			// Hide CPs
			for each(var cp:ControlPoint in controlPoints) // For each child of this cloud
				cp.visible = false;


			// Debug flood fill point
			this.graphics.drawCircle(boundRect.width/2+2, boundRect.height/2+2, 2);

			// Create Bitmap data and Draw on it
			var bmpData:BitmapData = new BitmapData(boundRect.width, boundRect.height, true, 0);
			bmpData.draw(this);

			// Show CPs
			for each(var cp2:ControlPoint in controlPoints) // For each child of this cloud
				cp2.visible = true;

			// Flood fill it
			var argb:uint = 0;
			argb |= (drawStyle.fillAlpha * 255) << 24;
			argb |= (drawStyle.fillColor);
			bmpData.floodFill(boundRect.width/2, boundRect.height/2, argb);

			// Clear graphics
			this.graphics.clear();

			// Draw BitmapData behind shape
			var fillMatrix:Matrix = new Matrix();
			this.graphics.beginBitmapFill(bmpData, fillMatrix, false, true);
			this.graphics.drawRect(boundRect.x, boundRect.y, boundRect.width, boundRect.height);
			this.graphics.endFill();

			// Redraw Shape
			fillPass = false;
			RenderGraphics(true);
		}


		public function ComputeBoundRect(drawCloudSpace:Boolean):Rectangle
		{
			// Find shape's bounding rectangle

			var rec:Rectangle = new Rectangle(0,0,0,0); // cloud's tag bouding rectangle
			rec.left = int.MAX_VALUE;
			rec.top = int.MAX_VALUE;
			rec.right = 0;
			rec.bottom = 0;

			for each(var cp:ControlPoint in this.controlPoints) // For each child of this cloud
			{
				if(drawCloudSpace)
				{
					if(cp.drawCloudPos.x < rec.left)
						rec.left = (isNaN(cp.drawCloudPos.x)? rec.left : cp.drawCloudPos.x);
	
					if(cp.drawCloudPos.y < rec.top)
					rec.top = (isNaN(cp.drawCloudPos.y)? rec.top : cp.drawCloudPos.y);

					if((cp.drawCloudPos.x + cp.width) > rec.right)
						rec.right = (isNaN(cp.drawCloudPos.x + cp.width)? rec.right : (cp.drawCloudPos.x + cp.width));
	
					if((cp.drawCloudPos.y + cp.height) > rec.bottom)
						rec.bottom = (isNaN((cp.drawCloudPos.y + cp.height))? rec.bottom : (cp.drawCloudPos.y + cp.height));
				}
				else
				{
					if(cp.x < rec.left)
						rec.left = (isNaN(cp.x)? rec.left : cp.x);
	
					if(cp.y < rec.top)
					rec.top = (isNaN(cp.y)? rec.top : cp.y);

					if((cp.x + cp.width) > rec.right)
						rec.right = (isNaN(cp.x + cp.width)? rec.right : (cp.x + cp.width));
	
					if((cp.y + cp.height) > rec.bottom)
						rec.bottom = (isNaN((cp.y + cp.height))? rec.bottom : (cp.y + cp.height));
				}
			}

			boundRect = rec;
			return rec;
		}



	}
}