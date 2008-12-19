package type.draw
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import mx.utils.ObjectUtil;

	import type.DrawCloud;
	import controls.brushClasses.CloudBrush;



	public class DrawBrush extends DrawTag
	{

		private var eraser:Boolean = false;
		private var useControlPoints:Boolean = false;

		public var brush:CloudBrush = null;

		// Bitmap brush
		private var brushBitmapData:BitmapData = null;
		private var brushMatrix:Matrix = new Matrix(); // for brush bitmap
		private var bitmapScale:Number = 1.0;

		// Gradient brush
		private var brushGradientMatrix:Matrix = new Matrix(); // for gradient line brush


		private var oldMousePos:Point = new Point();
		private var newMousePos:Point = new Point();



		public function DrawBrush()
		{
			super();
			BuildStyle();
		}


		public override function BuildStyle():void
		{
			super.BuildStyle();

			eraser = (drawStyle.selectedTool == "eraser");
			brush = drawStyle.selectedBrush; // Selected Brush


			if(brush.isBitmap)
			{
				// Color Transform
				var colorTransform:ColorTransform = new ColorTransform();
				colorTransform.redOffset =   (drawStyle.lineColor & 0xFF0000) >> 16;
				colorTransform.greenOffset = (drawStyle.lineColor & 0x00FF00) >> 8;
				colorTransform.blueOffset =   drawStyle.lineColor & 0x0000FF;
				colorTransform.alphaMultiplier = drawStyle.lineAlpha;

				// Draw to brushBitmapData
				brushBitmapData = new BitmapData(brush.iconBitmap.width, brush.iconBitmap.height, true, 0);
				brushBitmapData.draw(brush.iconBitmap.bitmapData, null, colorTransform, null, null, true);

				// Pre compute scaling
				bitmapScale = drawStyle.lineThickness / brush.iconBitmap.width;
			}

			useControlPoints = drawStyle.drawBrushCP;
			if(controlPoints.length == 2) // the control points are already created
			{
				if(useControlPoints)
				{
					ActivateControlPoints(); // activate the control points
				}
				else
				{
					DesactivateControlPoints();
				}
			}
		}


		// Clone DrawBrush
		public override function clone():DrawTag
		{
			var drawBrush:DrawBrush = super.clone() as DrawBrush;
			if(drawBrush)
			{
				
			}
			return drawBrush;
		}

		// Save DrawBrush XML
		public override function Save():XML
		{
			var drawTagXML:XML = super.Save();
			var drawBrushXML:XML = new XML("<drawBrush></drawBrush>"); // Create drawBrush XML

			// ...

			drawTagXML.appendChild(drawBrushXML); // add drawBrush XML to drawTag XML
			return drawTagXML;
		}

		// Load DrawBrush XML
		public override function Load(drawTagXML:XML):void
		{
			super.Load(drawTagXML);
			var drawBrushXML:XMLList = drawTagXML..drawBrush;
			if(drawBrushXML[0])
			{
				
			}
		}



		// MOUSE EVENTS
		// -------------------------------------

		// Mouse Click
		public override function onClick(mouseEvent:MouseEvent):void
		{
			if(!brush)
				return;

			if(brush.isBitmap && brushBitmapData) // BITMAP brush
			{
				brushMatrix.createBox(bitmapScale, bitmapScale, 
									  0,
									  newMousePos.x - drawStyle.lineThickness/2, 
									  newMousePos.y - drawStyle.lineThickness/2);

				this.graphics.beginBitmapFill(brushBitmapData, brushMatrix, false, true);
				this.graphics.drawRect(newMousePos.x - drawStyle.lineThickness/2, 
									   newMousePos.y - drawStyle.lineThickness/2,
									   drawStyle.lineThickness,
									   drawStyle.lineThickness);
				this.graphics.endFill();

			}
			else // LINE brush
			{
				/*
				this.graphics.clear();
				this.graphics.lineStyle(0, 0, 0.0, false, "normal", brush.lineCaps); // here
				this.graphics.beginFill(lineColor, lineAlpha);
				this.graphics.drawCircle(mouseEvent.localX, mouseEvent.localY, lineThickness*0.5);
				this.graphics.endFill();				
				*/
			}
		}


		// Mouse Down
		public override function onMouseDown(mouseEvent:MouseEvent):void
		{
			super.onMouseDown(mouseEvent);


			// Create Control Points
			controlPoints[0] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x, 
												mouseEvent.localY + cloudTagOffset.y); // line's origin
			controlPoints[0].dragType = "any";

			controlPoints[1] = new ControlPoint(mouseEvent.localX + cloudTagOffset.x,
												mouseEvent.localY + cloudTagOffset.y); // line's destination
			controlPoints[1].dragType = "any";


			if(!brush)
				return;

			this.graphics.clear();

			if(brush.isBitmap) // BITMAP brush
			{
				
			}
			else // LINE brush
			{
				this.graphics.lineStyle(drawStyle.lineThickness, drawStyle.lineColor, drawStyle.lineAlpha,
					true, "normal", brush.lineCaps, brush.lineJoints, 8); // here

				if(brush.isGradient && brush.gradient) // gradient line
				{
					brush.gradient.colors = [drawStyle.lineColor, drawStyle.lineColor];
					brush.gradient.alphas = [drawStyle.lineAlpha, 0.0];

					brushGradientMatrix.createGradientBox(1/this.parent.width, 1/this.parent.height ,0, mouseEvent.localX, mouseEvent.localY);
					this.graphics.lineGradientStyle(brush.gradient.gradientType,
													brush.gradient.colors,
													brush.gradient.alphas,
													brush.gradient.ratios,
													brushGradientMatrix,
													brush.gradient.spreadMethod,
													brush.gradient.interpolationMethod,
													brush.gradient.focalPointRatio);
				}
			}

			oldMousePos.x = mouseEvent.localX + cloudTagOffset.x;
			oldMousePos.y = mouseEvent.localY + cloudTagOffset.y;
			this.graphics.moveTo(oldMousePos.x, oldMousePos.y); // Set brush start to initial position
		}



		// Mouse Move
		public override function onMouseMove(mouseEvent:MouseEvent):void
		{
			if(!brush)
				return;

			newMousePos.x = mouseEvent.localX + cloudTagOffset.x;
			newMousePos.y = mouseEvent.localY + cloudTagOffset.y;

			if(eraser) // eraser
			{
				
			}

			if(brush.isBitmap && brushBitmapData) // BITMAP based brush
			{
				brushMatrix.createBox(bitmapScale, bitmapScale, 
									  0,
									  newMousePos.x - drawStyle.lineThickness/2,
									  newMousePos.y - drawStyle.lineThickness/2);

				this.graphics.beginBitmapFill(brushBitmapData, brushMatrix, false, true);
				this.graphics.drawRect(newMousePos.x - drawStyle.lineThickness/2, 
									   newMousePos.y - drawStyle.lineThickness/2,
									   drawStyle.lineThickness,
									   drawStyle.lineThickness);
				this.graphics.endFill();

			}
			else if(brush.isGradient && brush.gradient) // GRADIENT based brush
			{
				var dx:Number = Number(newMousePos.x - oldMousePos.x);
				var dy:Number = Number(newMousePos.y - oldMousePos.y);
				var rotation:Number = Math.atan2(dy, dx);

				brushGradientMatrix.createBox(dx, 
											  dy, 
											  rotation,
											  newMousePos.x, newMousePos.y);

				this.graphics.lineGradientStyle(brush.gradient.gradientType,
												brush.gradient.colors,
												brush.gradient.alphas,
												brush.gradient.ratios,
												brushGradientMatrix,
												brush.gradient.spreadMethod,
												brush.gradient.interpolationMethod,
												brush.gradient.focalPointRatio);

				this.graphics.lineTo(newMousePos.x, newMousePos.y);
				oldMousePos.x = newMousePos.x;
				oldMousePos.y = newMousePos.y;

			}
			else // line based brush
			{
				this.graphics.lineTo(newMousePos.x, newMousePos.y);
			}

			if(brush.isGradient) // line gradient
			{
				this.graphics.endFill(); // Finish line gradient
			}
		}


		// Mouse Up
		public override function onMouseUp(mouseEvent:MouseEvent):void
		{
			super.onMouseUp(mouseEvent);

			// MouseUp on a CP
			if(mouseEvent.target is ControlPoint)
			{
				// Retreive ControlPoint
				var cp:ControlPoint = ControlPoint(mouseEvent.target);
				if(cp)
				{
					// Make the line's end Snap into the ControlPoint
					mouseEvent.localX = cp.drawCloudPos.x + cp.width*0.5;
					mouseEvent.localY = cp.drawCloudPos.y + cp.height*0.5;
				}
			}

			controlPoints[1].x = mouseEvent.localX + cloudTagOffset.x;
			controlPoints[1].y = mouseEvent.localY + cloudTagOffset.y;

			if(useControlPoints)
			{
				ActivateControlPoints(); // activate the control points
			}

			CloudHistory.action("New Brush Stroke", DrawCloud(this.parent), true);
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
		}

		// MouseUp Control Point
		public override function onMouseUpCP(mouseEvent:MouseEvent):void
		{
			CloudHistory.action(this.type + " Transform", this, false);
		}

	
	}
}