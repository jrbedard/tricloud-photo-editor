package controls.thicknessClasses
{
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import mx.managers.PopUpManager;
	import mx.controls.Button;
	import mx.controls.sliderClasses.SliderThumb;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.controls.HSlider;

	import controls.colorClasses.CloudGradient;
	import controls.ThicknessControl;


	public class ThicknessThumb extends SliderThumb
	{

		// CheckerBoard background
		private var backgroundBmp:Bitmap = Globals.g_assets.backgroundBmp;


		private var _cursorType:String = ThicknessControl.CURSOR_SQUARE; // Shape of Thickness Cursor

		// Thumb Color and Alpha

		private var _cursorColor:uint = 0x000000;
		private var _cursorAlpha:Number = 1.0;

		private var _cursorGradient:CloudGradient = null;
		private var gradientSelected:Boolean = false;
		private var gradientMatrix:Matrix = new Matrix();

		private var _cursorBitmap:Bitmap = new Bitmap();
		private var brushBitmapData:BitmapData = null;
		private var bitmapMatrix:Matrix = new Matrix();

		private var _cursorFont:String = '';

		private var _sliderValue:int = 0;




		// Shape
		public function set cursorType(value:String):void
		{
			_cursorType = value;
			DrawCursor();
		}
		[Bindable]
		public function get cursorType():String
		{
			return _cursorType;
		}


		// Cursor Color
		[Inspectable(defaultValue=0x000000)]
		public function set cursorColor(value:uint):void
		{
			_cursorColor = value;
			gradientSelected = false;
			DrawCursor();
		}
		[Bindable]
		public function get cursorColor():uint
		{
			return _cursorColor;
		}


		// Cursor Alpha
		[Inspectable(defaultValue=1.0)]
		public function set cursorAlpha(value:Number):void
		{
			_cursorAlpha = value;
			DrawCursor();
		}
		[Bindable]
		public function get cursorAlpha():Number
		{
			return _cursorAlpha;
		}


		// Cursor Gradient
		public function set cursorGradient(value:CloudGradient):void
		{
			_cursorGradient = value;
			gradientSelected = true;
			DrawCursor();
		}
		[Bindable]
		public function get cursorGradient():CloudGradient
		{
			return _cursorGradient;
		}
		

		// Cursor Bitmap
		public function set cursorBitmap(value:Bitmap):void
		{
			_cursorBitmap = value;
			DrawCursor();
		}
		[Bindable]
		public function get cursorBitmap():Bitmap
		{
			return _cursorBitmap;
		}


		// Cursor Font
		public function set cursorFont(value:String):void
		{
			_cursorFont = value;
			gradientSelected = false;
			DrawCursor();
		}
		[Bindable]
		public function get cursorFont():String
		{
			return _cursorFont;
		}
		


		// Slider Value
		[Inspectable(defaultValue=0)]
		public function set sliderValue(value:int):void
		{
			_sliderValue = 60 - value;
			DrawCursor();
		}
		[Bindable]
		public function get sliderValue():int
		{
			return _sliderValue;
		}




		public function ThicknessThumb()
		{
			super();

			this.addEventListener("creationComplete", onCreationComplete)
			this.addEventListener("move", onMoveThicknessThumb);

			DrawCursor();
		}


		private function onCreationComplete(event:Event):void
		{
			/*
			var hslider:HSlider = HSlider(this.owner);
			if(hslider)
			{
				sliderValue = hslider.value; // hack to draw the cursor on creation
			}
			*/
		}


		private function onMoveThicknessThumb(event:Event):void
		{
			// doesnt work
			//DrawCursor();
		}


		protected override function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);
		}



		// Draw checkerboard background to notice alpha here
		private function DrawBackground():void
		{
			var halfSize:uint = Math.round(_sliderValue/2);

			this.graphics.clear();

			// button background fill (inside borders)
			drawRoundRect(
				1, 1, width - 2, height - 2, getStyle("cornerRadius") - 1,
				[0xDDDDDD, 0xCCCCCC], 1,
				verticalGradientMatrix(0, 0, width - 2, height - 2));

			// checkerboard background
			this.graphics.beginBitmapFill(backgroundBmp.bitmapData);

			// backgrounds
			if(_cursorType == ThicknessControl.CURSOR_SQUARE) // SQUARE
			{
				this.graphics.drawRect(this.width/2 - halfSize, -halfSize*2,
								   	   halfSize*2, halfSize*2);
			}
			else if(_cursorType == ThicknessControl.CURSOR_CIRCLE) // CIRCLE
			{
				this.graphics.drawCircle(this.width/2, -halfSize, 
										 halfSize);
			}
			else // bitmap, font
			{
				
			}

			this.graphics.endFill();
		}


		// Draw thumb Cursor
		public function DrawCursor():void
		{
			DrawBackground();

			// Position the drawCursor just below the slider's thumb

			var halfSize:uint = Math.round(sliderValue/2);

			this.graphics.lineStyle(0, 0x000000, 0);

			if(gradientSelected && _cursorGradient) // The Line is gradient
			{
				gradientMatrix.createGradientBox(halfSize*2, halfSize*2,
												 _cursorGradient.rotation, 
												 this.width/2 - halfSize,
												 -halfSize*2);

				this.graphics.beginGradientFill(_cursorGradient.gradientType,
												_cursorGradient.colors,
												_cursorGradient.alphas,
												_cursorGradient.ratios,
												gradientMatrix,
												_cursorGradient.spreadMethod,
												_cursorGradient.interpolationMethod,
												_cursorGradient.focalPointRatio);
			}
			else // normal solid color line
			{
				this.graphics.beginFill(_cursorColor, _cursorAlpha);
			}


			// DRAW Cursor
			if(_cursorType == ThicknessControl.CURSOR_SQUARE) // SQUARE
			{
				this.graphics.drawRect(this.width/2 - halfSize, -halfSize*2,
									   halfSize*2, halfSize*2);

			}
			else if(_cursorType == ThicknessControl.CURSOR_CIRCLE) // CIRCLE
			{
				this.graphics.drawCircle(this.width/2, -halfSize, 
										 halfSize);

			}
			else if(_cursorType == ThicknessControl.CURSOR_BITMAP) // BITMAP
			{
				if(_cursorBitmap && _cursorBitmap.bitmapData) // valid bitmap and bitmapData
				{
					// Color Transform
					var colorTransform:ColorTransform = new ColorTransform();
					colorTransform.redOffset = (_cursorColor & 0xFF0000) >> 16;
					colorTransform.greenOffset = (_cursorColor & 0x00FF00) >> 8;
					colorTransform.blueOffset = _cursorColor & 0x0000FF;
					colorTransform.alphaMultiplier = _cursorAlpha;

					// Draw to brush bitmapData
					brushBitmapData = new BitmapData(_cursorBitmap.width, _cursorBitmap.height, true, 0);
					brushBitmapData.draw(_cursorBitmap.bitmapData, null, colorTransform, null, null, true);

					// bitmap matrix for cursor
					bitmapMatrix.createBox((halfSize*2)/_cursorBitmap.width,
										   (halfSize*2)/_cursorBitmap.height,
										   0.0,
										   this.width/2 - halfSize,
										   -halfSize*2);

					// Display bitmap cursor
					this.graphics.beginBitmapFill(brushBitmapData, bitmapMatrix, false, true);
					this.graphics.drawRect(this.width/2 - halfSize, -halfSize*2,
										   halfSize*2, halfSize*2);
				}

			}
			else if(_cursorType == ThicknessControl.CURSOR_FONT) // FONT
			{
				// doesnt work
				/*
				var te:Text = new Text();
				//var label:Label = new Label();
				te.text = "A";
				te.setStyle('fontFamily', 'Ball');
				this.addChild(te);
				*/
			}
			else
			{
				trace('unknown type of thickness shape:' + _cursorType);
			}

			this.graphics.endFill();
		}

		
	}
}