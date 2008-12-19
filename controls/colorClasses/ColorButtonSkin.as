package controls.colorClasses
{
	import flash.display.GradientType;
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.skins.Border;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;


	public class ColorButtonSkin extends Border
	{
		
		//include "../../core/Version.as";
	
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
	

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function ColorButtonSkin()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
	
		//----------------------------------
		//  measuredWidth
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get measuredWidth():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
		}
		
		//----------------------------------
		//  measuredHeight
		//----------------------------------
	
		/**
		 *  @private
		 */
		override public function get measuredHeight():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
		}
	
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		

		// COLOR BUTTON for TriCloud, the filling is handled by ColorButton
		// So, just handle borders here
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);

			// User-defined styles.
			var borderColor:uint = getStyle("borderColor");
			var cornerRadius:Number = getStyle("cornerRadius");		
			var themeColor:uint = getStyle("themeColor");

			var borderColorDrk1:Number =
				ColorUtil.adjustBrightness2(borderColor, -50);

			var themeColorDrk1:Number =
				ColorUtil.adjustBrightness2(themeColor, -25);
				
			var cr:Number = Math.max(0, cornerRadius);


			graphics.clear();

			switch (name)
			{			
				case "selectedUpSkin":
				case "selectedOverSkin":
				{
					// button border/edge
					drawRoundRect(
						0, 0, w, h, cr,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w , h )); 
			
					break;
				}

				case "upSkin":
				{
					// button border/edge
					drawRoundRect(
						0, 0, w, h, cr,
						[ borderColor, borderColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 }); 

					break;
					
				}
	
				case "overSkin":
				{		
					// button border/edge
					drawRoundRect(
						0, 0, w, h, cr,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w , h),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 }); 

					break;
				}
						
				case "downSkin":
				case "selectedDownSkin":
				{
					// button border/edge
					drawRoundRect(
						0, 0, w, h, cr,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w , h),
						GradientType.LINEAR, null,
						{ x: 4, y: 4, w: w - 8, h: h - 8, r: 0 }); 

					break;
				}
							
				case "disabledSkin":
				case "selectedDisabledSkin":
				{
					// button border/edge
					drawRoundRect(
						0, 0, w, h, cr,
						[ borderColor, borderColorDrk1 ], 0.5,
						verticalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 });

					break;
				}
			}
		}
	}
}