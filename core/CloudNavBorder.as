package core
{
    import flash.geom.Rectangle;
    import flash.display.Graphics;
    import flash.display.CapsStyle;
    import mx.graphics.RectangularDropShadow;
	import mx.effects.Tween;
	import mx.effects.TweenEffect;
	import mx.skins.RectangularBorder;


	public class CloudNavBorder extends RectangularBorder
	{

		private var oldBackgroundAlpha:Number = 0.0;
		private var backgroundAlpha:Number = 0.0;
		private var backgroundColor:uint = 0x000000;


		private var usWidth:Number;
		private var usHeight:Number;

		private var alphaTween:Tween = null;
		private var tweenVal:Number = 0.0;

		private const dashLen:uint = 4;
		private var scrollTween:Tween = null;


		private var border:Rectangle = new Rectangle();


		public function CloudNavBorder()
		{
			scrollTween = new Tween(this, -dashLen, dashLen, 500);
		}


	 	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            super.alpha = 1.0;

			usWidth = unscaledWidth;
			usHeight = unscaledHeight;

			border = new Rectangle(32, 32, usWidth-64, usHeight-64);


            //backgroundAlpha = getStyle("backgroundAlpha"); // nice hack to adjust the border's alpha
           // backgroundColor = getStyle("backgroundColor");
/*
           	if(backgroundAlpha != oldBackgroundAlpha)
           	{
           		// start fade-in or fade-out
           		alphaTween = new Tween(this, oldBackgroundAlpha, backgroundAlpha, 100); // TODO: good?
           		//alphaTween.easingFunction = ;
           	}
           	oldBackgroundAlpha = backgroundAlpha;
*/
        	updateCloudBorder();
        }


		public function onTweenUpdate(value:Number):void
		{
			//tweenVal = value;
			updateScrollingBorder(value);
		}

		private var tweenOffset:uint = 0;

	  	public function onTweenEnd(value:Number):void
	    {
	    	//tweenVal = backgroundAlpha;
	    	//updateCloudBorder();

	    	scrollTween = new Tween(this, 0 + tweenOffset, dashLen + tweenOffset, 500);

	    	tweenOffset++;
	    	if(tweenOffset > 5)
	    		tweenOffset = 0;
	    }

		private function updateCloudBorder():void
		{
			
			//this.graphics.lineStyle(2, backgroundColor, 1.0, false, "normal", CapsStyle.ROUND);
			//this.graphics.drawRect(0,0, usWidth,usHeight);

			updateScrollingBorder(0);
		}


		//private var border:Rectangle = new Rectangle(0, 0, usWidth-1, usHeight-1);




		private function updateScrolling(value:Number):void
		{
			
		
		
		}


		private function updateScrollingBorder(value:Number):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x0000FF, 0.75, false, "normal", CapsStyle.SQUARE);

			var x1:int = 0;
			var y1:int = 0;
			var x2:int = 0;
			var y2:int = 0;

			// TOP
			for(x1 = border.left; x1 <= border.right;)
			{
				this.graphics.moveTo(Math.min(x1 + value, border.right), border.top);
				this.graphics.lineTo(Math.min(x1 + value + dashLen, border.right), border.top);
				x1 += dashLen*2;
			}

			// RIGHT 
			for(y1 = border.top; y1 <= border.bottom;)
			{
				this.graphics.moveTo(border.right, Math.min(y1 + value, border.bottom));
				this.graphics.lineTo(border.right, Math.min(y1 + value + dashLen, border.bottom));
				y1 += dashLen*2;
			}

			// BOTTOM
			for(x2 = border.right; x2 >= border.left;)
			{
				this.graphics.moveTo(Math.max(x2 - value, border.left), border.bottom);
				this.graphics.lineTo(Math.max(x2 - value - dashLen, border.left), border.bottom);
				x2 -= dashLen*2;
			}

			// LEFT
			for(y2 = border.bottom; y2 >= border.top;)
			{
				this.graphics.moveTo(border.left, Math.max(y2 - value, border.top));
				this.graphics.lineTo(border.left, Math.max(y2 - value - dashLen, border.top));
				y2 -= dashLen*2;
			}


		}





		public override function set filters(value:Array):void
		{
			//super.filters = this.filters;
		}


/*
		// ALPHA
		public override function set alpha(value:Number):void 
		{
			super.alpha = 1.0; // alpha setter disabled
		}

		// VISIBLE
		public override function set visible(value:Boolean):void 
		{
			super.visible = value; // visible setter enabled
		}

		// BLEND MODE
		public override function set blendMode(value:String):void 
		{
			super.blendMode = "normal"; // blendMode setter disabled
		}

		// FILTERS
		public override function set filters(value:Array):void 
		{
			super.filters = this.filters; //"normal"; // blendMode setter disabled
		}
*/
	}
}