package controls.colorClasses
{
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import mx.managers.PopUpManager;
	import mx.controls.Button;
	import mx.controls.sliderClasses.SliderThumb;


	// Thumb on the gradient slider, actually contain a solid color, the class name is a bit misleading...
	public class GradientThumb extends SliderThumb
	{

		private const colorSwatchSize:uint = 20;

		private var colorDialog:ColorDialog = new ColorDialog();
		private var colorDialogVisible:Boolean = false; // panel open		

		// CheckerBoard background
		private var backgroundBmp:Bitmap = new Globals.g_assets.ColorControlBackground as Bitmap;
		private var backgroundMatrix:Matrix = new Matrix();

		// Thumb Color and Alpha
		private var _selectedColor:uint = 0x000000;
		private var _selectedAlpha:Number = 1.0;

		// Thumb that is seleted (for edit, delete thumb)
		private var _curSelected:Boolean = false;



		[Inspectable(defaultValue=0x000000)]
		public function set selectedColor(value:uint):void
		{
			_selectedColor = value;
			colorDialog.selectedColor = _selectedColor;
			DrawColorSwatch();
		}

		[Bindable]
		public function get selectedColor():uint
		{
			return _selectedColor;
		}


		[Inspectable(defaultValue=1.0)]
		public function set selectedAlpha(value:Number):void
		{
			_selectedAlpha = value;
			colorDialog.selectedAlpha= _selectedAlpha;
			DrawColorSwatch();
		}

		[Bindable]
		public function get selectedAlpha():Number
		{
			return _selectedAlpha;
		}



		public function set curSelected(value:Boolean):void
		{
			_curSelected = value;
			DrawColorSwatch();
		}

		[Bindable]
		public function get curSelected():Boolean
		{
			return _curSelected;
		}
		
		


		public function GradientThumb()
		{
			super();

			this.width = colorSwatchSize;
			this.height = colorSwatchSize;

			this.useHandCursor = true;
			this.toolTip = "Slide to change Ratio.\nDouble-Click to change Color and Opacity";

			this.doubleClickEnabled = true;
			this.addEventListener("doubleClick", onDoubleClickThumb);

			colorDialog.setCurrentState('solid'); // No gradient in this dialog

			// listeners
			colorDialog.addEventListener("colorChange", onChangeColor);
			colorDialog.addEventListener("alphaChange", onChangeAlpha);
			colorDialog.addEventListener("close", onCloseColorDialog);

			DrawColorSwatch();
		}


		// On solid Color Changed
		private function onChangeColor(event:ColorEvent):void
		{
			_selectedColor = event.color;
			DrawColorSwatch();

			this.dispatchEvent(new ColorEvent("gradientThumbChange", _selectedColor, _selectedAlpha));
		}

		// On solid Alpha Changed
		private function onChangeAlpha(event:ColorEvent):void
		{
			_selectedAlpha = event.alpha;
			DrawColorSwatch();

			this.dispatchEvent(new ColorEvent("gradientThumbChange", _selectedColor, _selectedAlpha));
		}



		private function DrawColorSwatch():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x555555, 1.0);

			// Background
			this.graphics.beginBitmapFill(backgroundBmp.bitmapData, backgroundMatrix, true, false);
			this.graphics.drawRect(0, colorSwatchSize-1, colorSwatchSize, colorSwatchSize);
			this.graphics.endFill();

			// Color and Alpha
			this.graphics.beginFill(_selectedColor, _selectedAlpha);
			this.graphics.drawRect(0, colorSwatchSize-1, colorSwatchSize, colorSwatchSize);
			this.graphics.endFill();


			if(curSelected) // selected
			{
				this.graphics.beginFill(0x00FFFF, 1.0);
				this.graphics.drawCircle(colorSwatchSize/2, -2, 4);
				this.graphics.endFill();
			}
			else // not selected
			{
				
			}
		}





		protected override function mouseDownHandler(event:MouseEvent):void
		{
			super.mouseDownHandler(event);
		}

		protected override function clickHandler(event:MouseEvent):void
		{
			/*
			// if user clicked on the color swatch
			if(event.localX >= 0 && event.localX <= colorSwatchSize &&
			   event.localY >= colorSwatchSize-1 && event.localY <= colorSwatchSize + colorSwatchSize)
			{
				// call color swatch
				return;
			}
			else // user clicked on the thumb
			{
				
			}
			*/
			super.clickHandler(event);
		}



		public function onDoubleClickThumb(event:MouseEvent):void
		{
			OpenColorDialog();
		}


		public function OpenColorDialog():void
		{
			if(!colorDialogVisible)
			{
				var globalPos:Point = this.localToGlobal(new Point(this.x, this.y));

				//colorDialog = PopUpManager.createPopUp(this, colorDialog, false) as colorDialog;
				PopUpManager.addPopUp(colorDialog, this, false); // more optimal?

				colorDialog.x = Math.max(0, this.parentDocument.x + this.parentDocument.width);
				colorDialog.y = Math.max(0, globalPos.y - colorDialog.height - 10);
				// TODO: handle every panel placement...

				colorDialogVisible = true;
				this.doubleClickEnabled = false; // disable until close, still let the user drag it

				// HACK?
				colorDialog.selectedColor = _selectedColor;
				colorDialog.selectedAlpha = _selectedAlpha;
			}
		}


		// Close color-alpha dialog
		private function onCloseColorDialog(event:Event):void
		{
			PopUpManager.removePopUp(colorDialog);
			colorDialogVisible = false;
			this.doubleClickEnabled = true; // re-enable double click
		}


	}


}