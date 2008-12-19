package
{
	public class CloudType
	{
	    // Cloud Types
	    public static const IMAGE:String = "Image";
		public static const TEXT:String = "Text";
		public static const DRAW:String = "Draw";

		// Cloud subTypes
		public static const ST_IMAGE:String = "Image";
		public static const ST_FONT:String = "Font";
		public static const ST_BRUSH:String = "Brush";
		public static const ST_SHAPE:String = "Shape";
		public static const ST_EFFECT:String = "Effect";
		public static const ST_GRADIENT:String = "Gradient";



		// CLOUD TYPE ICONS
		public static function Icon(type:String):Class
		{
			switch(type)
			{
				case ST_IMAGE:
					return Globals.g_assets.ImageIcon;
				break;

				case ST_FONT:
					return Globals.g_assets.NewTextCloudIcon;
				break;

				case ST_BRUSH:
					return Globals.g_assets.BrushIcon;
				break;

				case ST_SHAPE:
					return Globals.g_assets.ShapeIcon;
				break;

				case ST_EFFECT:
					return Globals.g_assets.FilterIcon;
				break;
			}

			return Globals.g_assets.AddTagIcon;
		}

		
		public static function GetIndex(type:String):uint
		{
			switch(type)
			{
				case ST_IMAGE:
					return 0;
				break;

				case ST_FONT:
					return 1;
				break;

				case ST_BRUSH:
					return 2;
				break;

				case ST_SHAPE:
					return 3;
				break;

				case ST_EFFECT:
					return 4;
				break;

				case ST_GRADIENT:
					return 4;
				break;
			}
			return 0;
		}
	
	}
}