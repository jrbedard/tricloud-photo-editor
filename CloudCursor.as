package
{
	public class CloudCursor
	{
		import mx.collections.ArrayCollection;
		import mx.managers.CursorManager;


		private static var cursors:Array = new Array();
		private static var lastCursorID:int = 0;


		public static var NO_CURSOR:int = -1;

		// Cursors
		public static var NORMAL:int;
		public static var HAND:int;

		// Translate
		public static var TRANSLATE:int;
		public static var TRANSLATE_HORI:int;
		public static var TRANSLATE_VERT:int;

		// Rotate
		public static var ROTATE:int;
		public static var ROTATE_CW:int;
		public static var ROTATE_CCW:int;

		// Scale
		public static var SCALE:int;
		public static var SCALE_HORI:int;
		public static var SCALE_VERT:int;


		// DRAW
		public static var DRAW_BRUSH:int;
		public static var DRAW_LINE:int;
		public static var DRAW_CURVE:int;
		public static var DRAW_RECTANGLE:int;
		public static var DRAW_ELLIPSE:int;
		public static var DRAW_POLYLINE:int;
		public static var DRAW_SHAPE:int;

		// MISC
		

		// TEXT

		// IMAGE
		

		// Navigator Cursors
/*		
		public static var MOUSEOVER_UNSELECTED_CLOUD:int;
		public static var MOUSEOVER_SELECTED_CLOUD:int;

		public static var MOUSEOVER_TRANSLATE_BTN:int;
		public static var MOUSEOVER_ROTATE_BTN:int;
		public static var MOUSEOVER_SCALE_BTN:int;

		public static var MOUSEDOWN_TRANSLATE_BTN:int;
		public static var MOUSEDOWN_ROTATE_BTN:int;
		public static var MOUSEDOWN_SCALE_BTN:int;

		public static var MOUSEMOVE_TRANSLATE_BTN:int;
		public static var MOUSEMOVE_ROTATE_BTN:int;
		public static var MOUSEMOVE_SCALE_BTN:int;

		public static var MOUSEUP_TRANSLATE_BTN:int;
		public static var MOUSEUP_ROTATE_BTN:int;
		public static var MOUSEUP_SCALE_BTN:int;
*/

		// TODO: dynamic image cursor, ajustable scale? for the draw tools


		public function CloudCursor()
		{

			// NORMAL CURSOR
			NORMAL = CursorManager.NO_CURSOR;
			//NORMAL = cursors.push({cusorClass: Globals.g_assets.CursorArrow, priority: 1.0, 
			//					   offsetX: -2, offsetY: -2});

			// HAND CURSOR
			HAND = cursors.push({cusorClass: Globals.g_assets.CursorHand, priority: 1.0, 
								 offsetX: -9, offsetY: -2});



			// TRANSLATE CURSOR
			TRANSLATE = cursors.push({cusorClass: Globals.g_assets.CursorTranslate, priority: 2.0, 
									  offsetX: -16, offsetY: -16});

			TRANSLATE_HORI = cursors.push({cusorClass: Globals.g_assets.CursorTranslateHori, priority: 2.0, 
										   offsetX: -16, offsetY: -16});

			TRANSLATE_VERT = cursors.push({cusorClass: Globals.g_assets.CursorTranslateVert, priority: 2.0, 
										   offsetX: -16, offsetY: -16});


			// DRAW CURSORS
			DRAW_BRUSH = cursors.push({cusorClass: Globals.g_assets.CursorBrush, priority: 1.0, 
								   	   offsetX: 0, offsetY: 0});
 
			DRAW_LINE = cursors.push({cusorClass: Globals.g_assets.CursorLine, priority: 2.0, 
									  offsetX: -7, offsetY: -7});

			DRAW_CURVE = cursors.push({cusorClass: Globals.g_assets.CursorCurve, priority: 2.0, 
									   offsetX: -7, offsetY: -7});

			DRAW_RECTANGLE = cursors.push({cusorClass: Globals.g_assets.CursorRectangle, priority: 2.0, 
										   offsetX: -7, offsetY: -7});

			DRAW_ELLIPSE = cursors.push({cusorClass: Globals.g_assets.CursorEllipse, priority: 2.0, 
										 offsetX: -7, offsetY: -7});

			DRAW_SHAPE = cursors.push({cusorClass: Globals.g_assets.CursorShape, priority: 2.0, 
									   offsetX: -7, offsetY: -7});

/*
			// Rotate
			ROTATE 		= CursorManager.setCursor(Globals.g_assets.CursorRotate, 2.0);
			ROTATE_CW	= CursorManager.setCursor(Globals.g_assets.CursorRotateCW, 2.0);
			ROTATE_CCW	= CursorManager.setCursor(Globals.g_assets.CursorRotateCCW, 2.0);

			// Scale
			SCALE 		= CursorManager.setCursor(Globals.g_assets.CursorScale, 2.0);
			SCALE_HORI	= CursorManager.setCursor(Globals.g_assets.CursorScaleHori, 2.0);
			SCALE_VERT	= CursorManager.setCursor(Globals.g_assets.CursorScaleVert, 2.0);
*/

			// Set normal cursor by default
			SetCursor(NORMAL);
		}


		private static var lastCursorIndex:int = -1;


		public static function SetCursor(cursorID:int):void
		{
			if(cursorID == -1)
			{
				CursorManager.removeAllCursors();
				//CursorManager.setCursor(CursorManager.NO_CURSOR);
			}

			
			if(lastCursorID != cursorID) // changed cursor
			{
				//var lastCursor:Object = cursors[lastCursorID];
				if(lastCursorIndex >= 0)
				{
					CursorManager.removeCursor(lastCursorIndex);
				}

				var cursor:Object = cursors[cursorID-1];
				if(cursor)
				{
					lastCursorIndex = CursorManager.setCursor(cursor.cusorClass, 2.0, cursor.offsetX, cursor.offsetY);
				}
				lastCursorID = cursorID;

			}
		}
	
	}
}