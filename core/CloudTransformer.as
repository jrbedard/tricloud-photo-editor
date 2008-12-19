package core
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.UIComponent;
	import mx.effects.*;



	// Cloud transformer (translation, rotation, scaling and even Cropping!)
	public class CloudTransformer extends EventDispatcher
	{

		private var cloudOperator:CloudOperator = new CloudOperator();


		[Bindable]
		private var m_cloud:Cloud = null;


		// For Cloud translation, scaling, rotation...
		private var initCursorPos:Point = new Point(); // initial cursor position on mouse down in canvas space
		private var cursorCloudOffset:Point = new Point(); // initial offset between cursor and cloud in canvas space
		private var cursorCanvasPos:Point = new Point(); // cursor position within canvas


		[Bindable]
		public var rotation:Number = 0; // Bindable cloud rotation

		public var rotationOffset:Point = new Point();

		// scale modes
		private var hScale:Boolean = false;
		private var vScale:Boolean = false;

		
		// crop modes
		private var cropSide:String = "";

		private var cropBitmapData:BitmapData = null;
		private var preCropWidth:Number = 0;
		private var preCropHeight:Number = 0;



		// Constructor
		public function CloudTransformer()
		{
			
		}


		// Use event instead, one day...
		public function SetCloud(_cloud:Cloud):void
		{
			m_cloud = _cloud;	
		}


		// Initialize on mouse down
		private function InitNavMouseDown(mouseEvent:MouseEvent):void
		{
			if(!m_cloud || !m_cloud.parent)
				return;

			// reset cloud state?

			// position
			var pos:Point = new Point(mouseEvent.stageX, mouseEvent.stageY);
			pos = (m_cloud.parent).globalToLocal(pos); // Compute initial cursor position whithin canvas

			initCursorPos.x = pos.x; // initial cursor position on mouse down in canvas space
			initCursorPos.y = pos.y;

			cursorCloudOffset.x = m_cloud.x - pos.x;  // Compute offset between cursor and cloud in Canvas space
			cursorCloudOffset.y = m_cloud.y - pos.y;

			m_cloud.parentApplication.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveApp); // listen for mousemove anywhere
			m_cloud.parentApplication.addEventListener(MouseEvent.MOUSE_UP, onMouseUpApp); // listen for mouseup anywhere
		}



		// MouseDown to Translate
		public function onMouseDownTranslateBtn(mouseEvent:MouseEvent):void
		{
			InitNavMouseDown(mouseEvent);

			m_cloud.setCurrentState("translating");
		}


		// MouseDown to Rotate
		public function onMouseDownRotateBtn(mouseEvent:MouseEvent):void
		{
			InitNavMouseDown(mouseEvent);
			m_cloud.setCurrentState("rotating");

			cloudOperator.InitRotation([m_cloud]); // init ROTATION

			this.rotation = m_cloud.rotation;
		}


		// MouseDown to Scale
		public function onMouseDownScaleBtn(mouseEvent:MouseEvent, hScale:Boolean, vScale:Boolean):void
		{
			InitNavMouseDown(mouseEvent);
			m_cloud.setCurrentState("scaling");

			this.hScale = hScale;
			this.vScale = vScale;

			cloudOperator.InitScaling([m_cloud]); // init SCALING
		}


		// MouseDown to crop
		public function onMouseDownCropBtn(mouseEvent:MouseEvent, cropSide:String):void
		{
			InitNavMouseDown(mouseEvent);
			m_cloud.setCurrentState("cropping");

			this.cropSide = cropSide;

			// TODO: optimize: Do this only once at the begening of crop mode

			var bmpData:BitmapData = m_cloud.GetBitmapData();

			this.cropBitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0);
			this.cropBitmapData.draw(bmpData); // Copy Bitmap

			this.preCropWidth = bmpData.width;
			this.preCropHeight = bmpData.height;
		}




		// MouseMove within application to translate, rotate and scale the cloud
		private function onMouseMoveApp(mouseEvent:MouseEvent):void
		{
			if(!m_cloud || !mouseEvent.buttonDown)
				return;

			cursorCanvasPos.x = mouseEvent.stageX;
			cursorCanvasPos.y = mouseEvent.stageY;
        	cursorCanvasPos = (m_cloud.parent).globalToLocal(cursorCanvasPos); // Compute cursor position within canvas


			// TRANSLATING mouseMove
			if(m_cloud.currentState == "translating") // we are in dragging state, and mouse button is down
			{				
				m_cloud.x = cursorCanvasPos.x + cursorCloudOffset.x; // Set cloud position to folow the cursor
				m_cloud.y = cursorCanvasPos.y + cursorCloudOffset.y;
			}


			// ROTATING mouseMove
			else if(m_cloud.currentState == "rotating") // we are in dragging state, and mouse button is down
			{
				var posDiff:Number = cursorCanvasPos.y - initCursorPos.y; // Cursor Y Distance

				cloudOperator.UpdateRotation(posDiff); // Update ROTATION

				this.rotation = m_cloud.rotation;
			}


			// SCALING mouseMove
			else if(m_cloud.currentState == "scaling") // we are in dragging state, and mouse button is down
			{
				var scaleDiff:Number = 0;
				if(hScale && !vScale) // horizontal scale
				{
					scaleDiff = cursorCanvasPos.x - initCursorPos.x; // Cursor Y Distance
				}
				else if(!hScale && vScale) // vertical scale
				{
					scaleDiff = cursorCanvasPos.y - initCursorPos.y; // Cursor Y Distance
				}
				else if(hScale && vScale) // diagonal scale 
				{
					scaleDiff = (cursorCanvasPos.x - initCursorPos.x)/2 +
								(cursorCanvasPos.y - initCursorPos.y)/2;
				}

				cloudOperator.UpdateScaling(scaleDiff, hScale, vScale); // Update SCALING
			}


			// CROPPING mouseMove
			else if(m_cloud.currentState == "cropping")
			{
				var cropMatrix:Matrix = new Matrix();

				var widthDiff:Number = 0;
				var heightDiff:Number = 0;

				if(cropSide == 'left') // left
				{
					widthDiff = initCursorPos.x - cursorCanvasPos.x; // Cursor X Distance
					m_cloud.x = cursorCanvasPos.x + cursorCloudOffset.x; // Set cloud position to folow the cursor
					cropMatrix.translate(widthDiff, 0);
				}
				else if (cropSide == 'top') // top
				{
					heightDiff = initCursorPos.y - cursorCanvasPos.y; // Cursor X Distance
					m_cloud.y = cursorCanvasPos.y + cursorCloudOffset.y;
					cropMatrix.translate(0, heightDiff);
				}
				else if(cropSide == 'right') // right
				{
					widthDiff = cursorCanvasPos.x - initCursorPos.x; // Cursor X Distance
				}
				else if(cropSide == 'bottom') // bottom
				{ 
					heightDiff = cursorCanvasPos.y - initCursorPos.y; // Cursor Y Distance
				}


				if((preCropWidth + widthDiff) <= 0 ||
				   (preCropHeight + heightDiff) <= 0)
				{
					return; // Invalid cropping region
				}

				var newBmpData:BitmapData = new BitmapData(preCropWidth + widthDiff, 
														   preCropHeight + heightDiff,
														   true, 0);

				newBmpData.draw(cropBitmapData, cropMatrix); // Copy BitmapData
				m_cloud.SetBitmapData(newBmpData);
			}


			// TODO: Compute if cloud bounding box is out of the canvas
		}


		// TODO: BUG call this on mouse get out of browser's content
		// MouseUP, finished translating, rotating or scaling
		private function onMouseUpApp(event:MouseEvent):void
		{
			cropBitmapData = null; // free memory

			m_cloud.setCurrentState("selected");

			m_cloud.parentApplication.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveApp);
			m_cloud.parentApplication.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpApp);
		}


		

	}
}
