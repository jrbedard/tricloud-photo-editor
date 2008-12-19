package type.draw
{
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import mx.core.UIComponent;
	import mx.core.Container;
	import mx.containers.Canvas;
	import mx.rpc.events.AbstractEvent;
	import mx.managers.FocusManager;
	import mx.collections.ArrayCollection;

	import type.DrawCloudPanel;


	public class DrawTag extends Container implements ICloudHistoryClient
	{
		public static const BRUSH:String = 'Brush';
		public static const LINE:String = 'Line';
		public static const RECTANGLE:String = 'Rectangle';
		public static const ELLIPSE:String = 'Ellipse';
		public static const POLYLINE:String = 'Polyline';
		public static const SHAPE:String = 'Shape';
		public static const BUCKET:String = 'Bucket';

		protected static const cpOffset:uint = 8; // Control Point HalfSize

		private static var factoryIndex:uint = 0;


		public var localID:uint = 0; // Local drawTag ID (Incremental Creation Index), dont clone as is

		public var remoteID:String = '0';

		public var type:String = ''; // DrawTag type, overriden in children


		// DrawTag Style
		public static var drawStyle:DrawStyle = null;;


		// Control Points
		protected var controlPoints:Array = new Array(); // control points
		protected var curCP:ControlPoint = null; // active control point



		// Offset between drawCloud and tag, set onMouseDown
		public var cloudTagOffset:Point = new Point(0,0);


		// Offset between cursor and ControlPoint set onMouseDownCP, in CP space. No need to clone or Save
		protected var cursorCPOffset:Point = new Point(0,0); 


		// For Gradient Matrix computation
		public var tagWidth:int = 0;
		public var tagHeight:int = 0;


		// Constructor
		public function DrawTag()
		{
			this.clipContent = false; // Dont clip content
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";

			this.setStyle("borderStyle", "none");

			BuildStyle();
			this.focusEnabled = true;
		}

		// DrawTag Factory
		public static function DrawTagFactory(drawTagType:String):DrawTag
		{
			var newDrawTag:DrawTag = null;

			if(drawTagType == DrawTag.BRUSH) // Brush
			{
				newDrawTag = new DrawBrush();
				newDrawTag.type = DrawTag.BRUSH;
			}
			else if(drawTagType == DrawTag.LINE) // Line
			{
				newDrawTag = new DrawLine();
				newDrawTag.type = DrawTag.LINE;
			}
			else if(drawTagType == DrawTag.RECTANGLE) // Rectangle
			{
				newDrawTag = new DrawRectangle();
				newDrawTag.type = DrawTag.RECTANGLE;
			}
			else if(drawTagType == DrawTag.ELLIPSE) // Ellipse
			{
				newDrawTag = new DrawEllipse();
				newDrawTag.type = DrawTag.ELLIPSE;
			}
			else if(drawTagType == DrawTag.POLYLINE) // Polyline
			{
				newDrawTag = new DrawPolyline();
				newDrawTag.type = DrawTag.POLYLINE;
			}
			else if(drawTagType == DrawTag.SHAPE) // Shape
			{
				newDrawTag = new DrawShape();
				newDrawTag.type = DrawTag.SHAPE;
			}
			else if(drawTagType == DrawTag.BUCKET) // Fill Bucket
			{
				// dont create tag for the bucket
				return null;
			}
			else
			{
				trace('DrawTagFactory: unknown draw tag type: ' + drawTagType);
				return null;
			}

			newDrawTag.localID = factoryIndex++; // ID
			newDrawTag.name = newDrawTag.localID.toString(); // to use the getChildByName function in drawcloud load XML

			return newDrawTag;
		}



		// Clone DrawTag
		public virtual function clone():DrawTag
		{
			var drawTag:DrawTag = DrawTagFactory(this.type);
			if(!drawTag)
				return null;

			drawTag.remoteID = this.remoteID;
			drawTag.type = this.type;

			// transforms
			drawTag.x = this.x;
			drawTag.y = this.y;
			drawTag.rotation = this.rotation;

			// Control points
			for each(var cp:ControlPoint in controlPoints) // For each controlPoint
			{
				drawTag.controlPoints.push( cp.clone() ); // add Control Point
			}

			//drawTag.curCP = this.curCP.clone(); // need to clone that?

			// Offset points
			drawTag.cloudTagOffset = this.cloudTagOffset.clone();

			return drawTag;
		}

		// Save DrawTag XML
		public virtual function Save():XML
		{
			var drawTagXML:XML = new XML("<drawTag></drawTag>");

			drawTagXML.@localID = this.localID;
			drawTagXML.@remoteID = this.remoteID;
			drawTagXML.@type = this.type;

			// transforms
			drawTagXML.@x = this.x.toFixed(1);
			drawTagXML.@y = this.y.toFixed(1);
			drawTagXML.@rotation = this.rotation.toFixed(2);

			// controlPoints
			for each(var cp:ControlPoint in controlPoints) // For each controlPoint
			{
				var controlPointXML:XML = cp.Save();
				drawTagXML.appendChild(controlPointXML); // Add controlPoint XML
			}

			//drawTagXML.@curCP = (this.curCP ? this.curCP.Save() : null);

			drawTagXML.@cloudTagOffsetX = this.cloudTagOffset.x.toFixed(1);
			drawTagXML.@cloudTagOffsetY = this.cloudTagOffset.y.toFixed(1);

			return drawTagXML;
		}


		// Load DrawTag XML
		public virtual function Load(drawTagXML:XML):void
		{
			if(!drawTagXML)
				return;

			this.localID = drawTagXML.@localID;
			this.remoteID = drawTagXML.@remoteID;
			this.type = drawTagXML.@type;

			// transforms
			this.x = drawTagXML.@x;
			this.y = drawTagXML.@y;
			this.rotation = drawTagXML.@rotation;

			var c:uint = 0;
			var controlPointsXML:XMLList = drawTagXML..controlPoint; // Retreive ControlPoints
			for each(var cpXML:XML in controlPointsXML) // For each controlPoint
			{
				if(!this.controlPoints[c])
				{
					//trace('controlpoint creation on drawTag XML Load');
					this.controlPoints[c] = new ControlPoint(0,0, false); // TODO: wtf?
				}

				this.controlPoints[c].Load(cpXML);
				++c;
			}

			// curCP ?

			this.cloudTagOffset.x = drawTagXML.@cloudTagOffsetX;
			this.cloudTagOffset.y = drawTagXML.@cloudTagOffsetY;

			// Activate Control Points;
			ActivateControlPoints();

			// Render!
			RenderGraphics(true);
		}


		private var lineAlpha:Number = 1.0;


		// S T Y L E S
		// ---------------------------

		public function BuildStyle():void
		{

			lineAlpha = drawStyle.lineAlpha;
			if(drawStyle.lineThickness == 0) // fake lineThickness 0 by setting the alpha to 0
			{
				lineAlpha = 0.0;
			}

			//CloudHistory.action("Changed " + this.type + " Style");
		}


		protected function SetLineStyle():void
		{
			this.graphics.lineStyle(drawStyle.lineThickness, drawStyle.lineColor, lineAlpha,
				true, "normal", drawStyle.lineCaps, drawStyle.lineJoints, drawStyle.lineJointMiterLimit);

			if(drawStyle.isLineGradient && drawStyle.lineGradient) // gradient line
			{
				// line gradient
				this.graphics.lineGradientStyle(drawStyle.lineGradient.gradientType,
												drawStyle.lineGradient.colors,
												drawStyle.lineGradient.alphas,
												drawStyle.lineGradient.ratios,
												drawStyle.lineGradientMatrix,
												drawStyle.lineGradient.spreadMethod,
												drawStyle.lineGradient.interpolationMethod,
												drawStyle.lineGradient.focalPointRatio);
			}
		}

		

		protected function SetFillStyle():void
		{
			if(drawStyle.isFillGradient && drawStyle.fillGradient) // gradient fill
			{
				// gradient fill
				this.graphics.beginGradientFill(drawStyle.fillGradient.gradientType,
												drawStyle.fillGradient.colors,
												drawStyle.fillGradient.alphas,
												drawStyle.fillGradient.ratios,
												drawStyle.fillGradientMatrix,
												drawStyle.fillGradient.spreadMethod,
												drawStyle.fillGradient.interpolationMethod,
												drawStyle.fillGradient.focalPointRatio);
			}
			else if(drawStyle.filledRect || drawStyle.filledEllipse || drawStyle.filledPolyline || drawStyle.filledShape) // normal fill
			{
				this.graphics.beginFill(drawStyle.fillColor,
										drawStyle.fillAlpha);
			}
		}


		// Compute offset between drawCloud and tag
		public function ComputeDrawCloudTagOffset():void
		{
			cloudTagOffset.x = 0;
			cloudTagOffset.y = 0;
			cloudTagOffset = this.parent.localToGlobal(cloudTagOffset); // Position in drawCloud space to global space
			cloudTagOffset = this.globalToLocal(cloudTagOffset); // Position in global space to drawTag space
		}


		// Activate Control Points
		protected function ActivateControlPoints():void
		{
			var index:uint = 0;

			for each(var cp:ControlPoint in controlPoints) // For each child of this cloud
			{
				cp.index = index++; // CP Index within drawTag

				if(this.contains(cp)) // controlPoint already in drawTag
					continue;

				cp.x -= cpOffset; // Adjust CP to be centered on the the point
				cp.y -= cpOffset;

				this.addChild(cp); // Add Control point in tag
			}

			UpdateDrawCloudPos(); // Compute CPs cloud position
		}


		// Desactivate Control Points
		protected function DesactivateControlPoints():void
		{
			for each(var cp:ControlPoint in controlPoints) // For each child of this cloud
			{
				cp.x += cpOffset; // Adjust CP to be centered on the the point
				cp.y += cpOffset;

				if(this.contains(cp)) // cp contained by drawTag
					this.removeChild(cp);
				else
					trace('error: drawTag remove non-children ControlPoint');
			}
		}


		// Update ControlPoints Position in DrawCloud Space
		public function UpdateDrawCloudPos():void
		{
			if(!this.parent)
			{
				return;
				trace('UpdateDrawCloudPos: no parent')
			}

			for each(var cp:ControlPoint in controlPoints) // For each child of this cloud
			{
				// Compute Position within drawCloud
				var pos:Point = new Point(cp.x, cp.y);
				pos = this.localToGlobal(pos); // Position in drawTag space to global space
				pos = this.parent.globalToLocal(pos); // Position in global space to drawCloud space
				cp.drawCloudPos = pos;
			}
		}






		// Render graphics (overriden)
		public virtual function RenderGraphics(moveCP:Boolean):void
		{
		}




		// DRAW MOUSE EVENTS (Called by DrawController)
		// -------------------------------------

		// To be overiden, called by DrawController
		public function onClick(mouseEvent:MouseEvent):void
		{
		}

		// To be overiden, called by DrawController
		public function onMouseDown(mouseEvent:MouseEvent):void
		{
			//this.rotation = -drawCloudPanel.GetCloud().rotation;

			// Transform offset from canvas space into cloud space
			//var point:Point = new Point(0, 0);
			//point = drawCloudPanel.GetCloud().parent.localToGlobal(point);
			//point = drawCloudPanel.GetCloud().globalToLocal(point);

			this.x = mouseEvent.localX; // position drawTag here
			this.y = mouseEvent.localY;

			this.mouseEnabled = false; // avoid mouseOver on self.

			// Compute offset between drawCloud and tagCloud
			ComputeDrawCloudTagOffset();

			stage.focus = this.parent;
		}

		// To be overiden, called by DrawController
		public function onMouseMove(mouseEvent:MouseEvent):void
		{
			
		}

		// To be overiden, called by DrawController
		public function onMouseUp(mouseEvent:MouseEvent):void
		{
			
		}



		// CONTROL POINT MOUSE EVENTS (Called by DrawController)
		// ---------------------------------------------

		// To be overiden, called by DrawController
		public function onClickCP(cpEvent:CPEvent):void
		{
		}

		// To be overiden, called by DrawController
		public function onDoubleClickCP(cpEvent:CPEvent):void
		{
		}

		// To be overiden, called by DrawController
		public function onMouseDownCP(cpEvent:CPEvent):void
		{
			curCP = cpEvent.m_controlPoint;
			//this.mouseEnabled = false; // avoid mouseOver on self.

			var cpPoint:Point = new Point(cpEvent.localX, cpEvent.localY);
			cpPoint = curCP.parent.localToGlobal(cpPoint);
			cpPoint = curCP.globalToLocal(cpPoint);

			// Cursor position within ControlPoint
			cursorCPOffset.x = cpPoint.x;
			cursorCPOffset.y = cpPoint.y;
		}

		// To be overiden, called by DrawController
		public function onMouseMoveCP(mouseEvent:MouseEvent):void
		{
		}

		// To be overiden, called by DrawController
		public function onMouseUpCP(mouseEvent:MouseEvent):void
		{
		}




		// FORM DRAGGING
		// -------------------------------------

		public function CanDrag(posX:Number, posY:Number):Boolean
		{
			if(type == DrawTag.RECTANGLE  || type == DrawTag.ELLIPSE) // RECTANGLE & ELLIPSE
			{
				// TODO : fudge ellipse to avoid corner click
				
				var x:Number = Math.min(controlPoints[2].drawCloudPos.x, 
										controlPoints[3].drawCloudPos.x);

				var width:Number = Math.max(controlPoints[2].drawCloudPos.x, 
											controlPoints[3].drawCloudPos.x) - x + cpOffset;

				var y:Number = Math.min(controlPoints[0].drawCloudPos.y,
										controlPoints[1].drawCloudPos.y); 

				var height:Number = Math.max(controlPoints[0].drawCloudPos.y,
											 controlPoints[1].drawCloudPos.y) - y + cpOffset;

				var rec:Rectangle = new Rectangle(x,y, width, height);

				return rec.contains(posX, posY);
			}
			/*
			else if(type == DrawTag.SHAPE) // SHAPE
			{
				if(!DrawShape(this).closingCP)
					return false;

				var shapeBound:Rectangle = DrawShape(this).ComputeBoundRect(true);
				return shapeBound.contains(posX, posY);
			}
			*/
			else
			{
				return false;
			}
		}

		// Origin in drawCloud space
		private function GetOrigin():Point
		{
			// Origin of the rectangle or ellipse
			// origin drawCloud Space - offset drawTag space - control point offset
			var x:Number = controlPoints[2].drawCloudPos.x - controlPoints[2].x;
			var y:Number = controlPoints[0].drawCloudPos.y - controlPoints[0].y;

			return new Point(x,y);
		}

		private var dragTagOffset:Point = new Point();

		public function onDragStart(mouseEvent:MouseEvent):void
		{
			var origin:Point = GetOrigin();
			dragTagOffset.x = mouseEvent.localX - origin.x; // mouseDown offset by origin
			dragTagOffset.y = mouseEvent.localY - origin.y;

			CloudCursor.SetCursor(CloudCursor.HAND);
		}

		public function onDragMove(mouseEvent:MouseEvent):void
		{
			// offset by intial mouseDown pos
			this.x = mouseEvent.localX - dragTagOffset.x;
			this.y = mouseEvent.localY - dragTagOffset.y;
		}

		public function onDragStop(mouseEvent:MouseEvent):void
		{
			UpdateDrawCloudPos();

			CloudCursor.SetCursor(CloudCursor.NORMAL);

			CloudHistory.action(this.type + " Translation", this, false);
		}


		// KEYBOARD Handler
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
			if(event)
			{
				
			}
		}

		protected override function keyUpHandler(event:KeyboardEvent):void
		{
            trace("keyUpHandler: " + event.keyCode);
        }


	}
}