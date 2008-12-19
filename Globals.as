// ActionScript file
package 
{
	import assets.AssetList;
	import flash.geom.Matrix;
	import mx.core.UIComponent;


	public class Globals
	{

	    // Global Constants for runtime loading
 		public static const HOSTNAME:String = "http://localhost:3000/";
		public static const UPLOAD_TEMP_IMAGE:String = HOSTNAME + "file_upload/upload_image";
		public static const UPLOAD_TEMP_FONT:String = HOSTNAME + "file_upload/upload_font";

		public static const UPLOAD_CLOUD_DATA:String = HOSTNAME + "file_upload/upload_cloud_data";
		public static const UPLOAD_CLOUD_ICON:String = HOSTNAME + "file_upload/upload_cloud_icon";



		public static const TEMP_IMAGES_PATH:String = HOSTNAME + "uploads/tempImages/"; 
		public static const TEMP_FONTS_PATH:String = HOSTNAME + "uploads/tempFonts/"; 
	    public static const CLOUD_ICONS_PATH:String = HOSTNAME + "clouds/icons/";



		public static var g_assets:AssetList = null;


		// DEBUG
		public static var g_debug:Boolean = false;


		// Version
		public static var g_version:String = '1.0';


		// EMBEDDED ASSET


		// MISC
		public static function ColorToString(color:uint):String
		{
			return "0x"+ color.toString(16);
		}

		// File Size
		public static function GetFileSize(size:uint):String
		{
			if(size < 1024)
				return size.toString() + ' bytes';
			else if(size > 1024 && size < 1048576)
				return uint(size / 1024).toString() + ' KB';
			else if(size > 1048576)
				return (size / 1048576).toFixed(2).toString() + ' MB';
			else
				return '?';
		}

		// FileName from Path
		// TODO: Bullet proof this
		public static function GetFileName(path:String, withExt:Boolean = true):String
		{
			var lastDash:uint = path.lastIndexOf('/');
			var lastDot:uint = path.lastIndexOf('.');

			var fileName:String = path.substring(lastDash+1, withExt ? path.length : lastDot); // Extract fileName without Path

			if(fileName.length > 64)
				fileName = fileName.substring(0, 64);

			return fileName;
		}


		// TODO
		public static function DataBaseDateToFlex(dateStr:String):Date
		{
			var date:Date = new Date();
			date.setDate(1);
			return date;
		}

		// TODO
		public static function FlexDateToDataBase(date:Date):String
		{
			var dateStr:String = "today";
			return dateStr;
		}


		public static function GetIconMatrix(sourcePanel:UIComponent, destWidth:uint, destHeight:uint):Matrix
		{
			var mat:Matrix = new Matrix;

			if(!sourcePanel || !sourcePanel.width || !sourcePanel.height)
				return mat;

			var ratio:Number = sourcePanel.width / sourcePanel.height;

			if(ratio >= 1.0) // panel wider than tall
			{
				var newHeight:Number = destHeight / ratio;

				mat.scale(destWidth/(sourcePanel.width / sourcePanel.scaleX), 
						  newHeight/(sourcePanel.height / sourcePanel.scaleY)); // scale to fit the cloud image into the icon

				mat.translate(0, (destHeight - newHeight)/2);
			}
			else // panel taller than wide (ratio < 1.0)
			{
				var newWidth:Number = destWidth * ratio;

				mat.scale(newWidth/(sourcePanel.width / sourcePanel.scaleX), 
						  destHeight/(sourcePanel.height / sourcePanel.scaleY)); // scale to fit the cloud image into the icon

				mat.translate((destWidth - newWidth)/2, 0);
			}

			return mat;
		}

	}
}
