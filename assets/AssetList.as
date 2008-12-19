// ActionScript file
package assets
{
	import flash.display.Bitmap;


	
	public class AssetList
	{
		
		public function AssetList()
		{
			Globals.g_assets = this;
		}

		// [Bindable] ??????
		// static ????


		// TriCloud, rulers of the world
		[Embed(source='./images/TriCloud16.png')]
		public const TriCloudIcon16:Class;

		[Embed(source='./images/TriCloud32.png')]
		public const TriCloudIcon32:Class;


		[Embed(source='./images/library/comment.png')]
	    public const ShareIcon:Class;
	    


		// CLOUD TYPE ICONS
	 	[Embed(source='./images/cloudTree/addImage.gif')]
		public const ImageIcon:Class;

		[Embed(source='./images/drawCloud/brush.gif')]
	    public const BrushIcon:Class;
	    
		[Embed(source='./images/drawCloud/drawShape.png')]
	    public const ShapeIcon:Class;

		[Embed(source='./images/cloudTree/text.gif')]
	    public const FontIcon:Class;

		[Embed(source='./images/navigator/rotation.gif')]
	    public const FilterIcon:Class;





	    [Embed(source='./flash/selection.swf')]
	    public const Selection:Class;



		// CLOUD 1
	 	[Embed(source='./images/blank48Icon.png')]
		public const Cloud01:Class;


		// CLOUD NAVIGATOR
		[Embed(source='./images/navigator/translation.gif')]
		public const NavTranslationIcon:Class;

		[Embed(source='./images/navigator/rotation.gif')]
		public const NavRotationIcon:Class;

		[Embed(source='./images/navigator/scaling.gif')]
		public const NavScalingIcon:Class;

		//[Embed(source='./images/navigator/translation.png')]
		//public const NavTranslationIcon:Class;




	
		// CATEGORY ADD TAG / VISIBILITY ICONS
	    [Embed(source='./images/cloudTree/addTag.gif')]
	    public const AddTagIcon:Class;

	    [Embed(source='./images/cloudTree/catVisible.gif')]
	    public const CloudVisibleIcon:Class;

	    [Embed(source='./images/cloudTree/catInvisible.gif')]
	    public const CloudInvisibleIcon:Class;


		// CLOUD ACTIONS
 		[Embed(source='./images/cloudTree/addImage.gif')]
	    public const NewImageCloudIcon:Class;

	    [Embed(source='./images/cloudTree/text.gif')]
	    public const NewTextCloudIcon:Class;

	    [Embed(source='./images/cloudTree/paint.gif')]
	    public const NewDrawCloudIcon:Class;

	    [Embed(source='./images/cloudTree/duplicateCloud.gif')]
	    public const DuplicateCloudIcon:Class;

		[Embed(source='./images/cloudTree/mergeCloud.gif')]
	    public const MergeCloudIcon:Class;

  		[Embed(source='./images/cloudTree/deleteCloud.gif')]
	    public const DeleteCloudIcon:Class;

		[Embed(source='./images/cloudTree/moveUpCloud.gif')]
	    public const MoveUpCloudIcon:Class;

		[Embed(source='./images/cloudTree/moveDownCloud.gif')]
	    public const MoveDownCloudIcon:Class;


		// IMAGE IMPORTER
		[Embed(source='./images/imageService/localImageIcon.gif')]
	    public const LocalImageIcon:Class;

	    [Embed(source='./images/imageService/webImageIcon.gif')]
	    public const WebImageIcon:Class;

		[Embed(source='./images/imageService/downArrow.png')]
	    public const DownArrow:Class;

	    [Embed(source='./images/imageService/rightArrow.png')]
	    public const RightArrow:Class;


	    [Embed(source='./images/cloudTree/addTag.gif')]
	    public const FlickrImageIcon:Class;

 		[Embed(source='./images/cloudTree/addTag.gif')]
	    public const FacebookImageIcon:Class;

	    [Embed(source='./images/cloudTree/addTag.gif')]
	    public const MySpaceImageIcon:Class;

		
	



		// IMAGE CLOUD ICONS
		[Embed(source='./images/imageCloud/brightness.png')]
	    public const ImageBrightnessIcon:Class;

		[Embed(source='./images/imageCloud/contrast.png')]
	    public const ImageContrastIcon:Class;


		[Embed(source='./images/imageCloud/cropImage.png')]
	    public const ImageCropIcon:Class;

		[Embed(source='./images/imageCloud/flipHor.png')]
	    public const ImageFlipHorIcon:Class;

	    [Embed(source='./images/imageCloud/flipVert.png')]
	    public const ImageFlipVertIcon:Class;

		[Embed(source='./images/imageCloud/rotate90CW.gif')]
	    public const ImageRotate90CWIcon:Class;

	    [Embed(source='./images/imageCloud/rotate90CCW.gif')]
	    public const ImageRotate90CCWIcon:Class;



		// TEXT CLOUD ICONS
		[Embed(source='./images/textCloud/AlignLeft.gif')]
	    public const AlignLeftIcon:Class;

		[Embed(source='./images/textCloud/AlignCenter.gif')]
	    public const AlignCenterIcon:Class;

		[Embed(source='./images/textCloud/AlignRight.gif')]
	    public const AlignRightIcon:Class;


		// DRAW CLOUD TOOL ICONS
		[Embed(source='./images/drawCloud/brush.gif')]
	    public const DrawBrushIcon:Class;

		// Line
		[Embed(source='./images/drawCloud/drawLine.png')]
	    public const DrawLineIcon:Class;

		[Embed(source='./images/drawCloud/drawCurve.png')]
	    public const DrawCurveIcon:Class;

	    [Embed(source='./images/drawCloud/drawRoundEndedLine.png')]
	    public const DrawRoundEndedLineIcon:Class;

		// Rect
	    [Embed(source='./images/drawCloud/drawRect.png')]
	    public const DrawRectIcon:Class;

		[Embed(source='./images/drawCloud/drawFilledRect.png')]
	    public const DrawFilledRectIcon:Class;

		[Embed(source='./images/drawCloud/drawRoundedRect.png')]
	    public const DrawRoundedRectIcon:Class;

		// Ellipse
	    [Embed(source='./images/drawCloud/drawEllipse.png')]
	    public const DrawEllipseIcon:Class;

 		[Embed(source='./images/drawCloud/drawFilledEllipse.png')]
	    public const DrawFilledEllipseIcon:Class;

		// Shape
		[Embed(source='./images/drawCloud/drawShape.png')]
	    public const DrawShapeIcon:Class;

		[Embed(source='./images/drawCloud/drawShape.png')]
	    public const DrawLineShapeIcon:Class;

		[Embed(source='./images/drawCloud/drawShape.png')]
	    public const DrawCurvedShapeIcon:Class;

		[Embed(source='./images/drawCloud/drawShape.png')]
	    public const DrawFreeFormShapeIcon:Class;

		// Custom Shape
		[Embed(source='./images/drawCloud/drawCustomShape.gif')]
	    public const DrawCustomShapeIcon:Class;


		// Eraser
	    [Embed(source='./images/drawCloud/eraser.gif')]
	    public const DrawEraserIcon:Class;

		// Bucket
		[Embed(source='./images/drawCloud/airbrush.gif')]
	    public const DrawBucketIcon:Class;




		// BRUSHES
		[Embed(source='./images/brushes/brush00.png')]
	    public const Brush00:Class;

		[Embed(source='./images/brushes/brush00S.png')]
	    public const Brush00S:Class;

	    [Embed(source='./images/brushes/brush01.png')]
	    public const Brush01:Class;

		[Embed(source='./images/brushes/brush00S.png')]
	    public const Brush01S:Class;

		[Embed(source='./images/brushes/brush02.png')]
	    public const Brush02:Class;

		[Embed(source='./images/brushes/brush00S.png')]
	    public const Brush02S:Class;

		[Embed(source='./images/brushes/brush03.png')]
	    public const Brush03:Class;

		[Embed(source='./images/brushes/brush04.png')]
	    public const Brush04:Class;


		// COLOR PICKER
		[Embed(source='./images/drawCloud/colorPicker.gif')]
	    public const ColorPickerIcon:Class;



		// SHAPES
		[Embed(source='./images/shapes/shape00.png')]
	    public const Shape00:Class;

	    [Embed(source='./images/shapes/shape01.png')]
	    public const Shape01:Class;



	    // ZOOM MAGNIFY/MINIFY ICONS
	 	[Embed(source='./images/magnify_icon.gif')]
		public const MagnifyIcon:Class;

	 	[Embed(source='./images/minify_icon.gif')]
		public const MinifyIcon:Class;


		// ROTATE ICON
		[Embed(source='./images/rotate.png')]
		public const RotateIcon:Class;


/* Embed TTF-fonts
[Embed(source="verdana.ttf", fontName="_verdana_regular", fontFamily="_verdana")]
public var verdanaClass:Class;
[Embed(source="verdanab.ttf", fontName="_verdana_bold", fontFamily="_verdana")]
public var verdanaBoldClass:Class;
[Embed(source="verdanai.ttf", fontName="_verdana_italic", fontFamily="_verdana")]
public var verdanaItalic:Class;
[Embed(source="verdanaz.ttf", fontName="_verdana_bold_italic", fontFamily="_verdana")]
public var verdanaBoldItalicClass:Class;
*/

		// FONTS
		[Embed(source='./fonts/ball.swf', fontFamily='Ball', fontName='Ball')]
		public const FontBall:Class;

		[Embed(source='./fonts/baveuse3.ttf', fontFamily='baveuse3')]
		public const FontBaveuse:Class;

		[Embed(source='./fonts/KILLERBOOTS.TTF', fontFamily='killerboots')]
		public const FontKillerBoots:Class;
		
		[Embed(source='./fonts/RADIO.TTF', fontFamily='radio')]
		public const FontRadop:Class;

		[Embed(source='./fonts/decadnce.ttf', fontFamily='decadnce')]
		public const FontDecadnce:Class;

		[Embed(source='./fonts/RAPJACK_.TTF', fontFamily='rapjack')]
		public const FontRapJack:Class;



		// CURSORS
		[Embed(source='./cursors/arrow.png')]
		public const CursorArrow:Class;

		// Hand
		[Embed(source='./cursors/hand.png')]
		public const CursorHand:Class;


		// Translation
		[Embed(source='./cursors/translate.png')]
		public const CursorTranslate:Class;

		[Embed(source='./cursors/translateHori.png')]
		public const CursorTranslateHori:Class;

		[Embed(source='./cursors/translateVert.png')]
		public const CursorTranslateVert:Class;

		// Rotate
		[Embed(source='./images/magnify_icon.gif')]
		public const CursorRotate:Class;
		
		[Embed(source='./images/magnify_icon.gif')]
		public const CursorRotateCW:Class;
		
		[Embed(source='./images/magnify_icon.gif')]
		public const CursorRotateCCW:Class;

		// Scale
		[Embed(source='./images/magnify_icon.gif')]
		public const CursorScale:Class;

		[Embed(source='./images/magnify_icon.gif')]
		public const CursorScaleHori:Class;

		[Embed(source='./images/magnify_icon.gif')]
		public const CursorScaleVert:Class;

		

		// DRAW
		[Embed(source='./cursors/drawBrush.png')]
		public const CursorBrush:Class;

		[Embed(source='./cursors/drawBrush.png')]
		public const CursorLine:Class;

		[Embed(source='./cursors/drawBrush.png')]
		public const CursorCurve:Class;

		[Embed(source='./cursors/drawRectangle.png')]
		public const CursorRectangle:Class;

		[Embed(source='./cursors/drawEllipse.png')]
		public const CursorEllipse:Class;

		[Embed(source='./cursors/drawBrush.png')]
		public const CursorShape:Class;
		

	

/*
		[Embed(source='./images/magnify_icon.gif')]
		public const CursorTranslatingCloud:Class;

	 	[Embed(source='./images/minify_icon.gif')]
		public const CursorRotatingCloud:Class;

		[Embed(source='./images/minify_icon.gif')]
		public const CursorScalingCloud:Class;
*/


		// GRADIENT
		[Embed(source='./images/colorControl/newThumb.png')]
		public const newThumbIcon:Class;

		[Embed(source='./images/colorControl/editThumb.png')]
		public const editThumbIcon:Class;

		[Embed(source='./images/colorControl/deleteThumb.png')]
		public const deleteThumbIcon:Class;



		// LIBRARY
 		[Embed(source='./images/library/comment.png')]
	    public const CommentIcon:Class;

	    [Embed(source='./images/library/flag.png')]
	    public const FlagIcon:Class;





		// MISC
  		[Embed(source='./images/blank48Icon.png')]
	    public const Blank48Icon:Class;


		[Embed(source='./images/checkerBoard.png')]
	    public const ColorControlBackground:Class;
	    public const backgroundBmp:Bitmap = new ColorControlBackground as Bitmap;



		// Warp
		[Embed(source='./images/cloudTree/addImage.gif')]
		public const WarpIcon:Class;


		// IMAGE DIALOGS
		[Embed(source='./images/cloudTree/addImage.gif')]
		public const ImageImporter:Class;

		[Embed(source='./images/cloudTree/addImage.gif')]
		public const ImageExporter:Class;

		[Embed(source='./images/cloudTree/addImage.gif')]
		public const ImagePreview:Class;


		[Embed(source='./images/email.gif')]
	    public const EmailIcon:Class;

	    [Embed(source='./images/print.gif')]
	    public const PrintIcon:Class;





		// UNDO / REDO
		[Embed(source='./images/undo.gif')]
	    public const UndoIcon:Class;

	    [Embed(source='./images/redo.gif')]
	    public const RedoIcon:Class;

		[Embed(source='./images/refresh.gif')]
	    public const RefreshIcon:Class;


		// STAR (RATING SYSTEM)
		[Embed(source='./images/noStar.gif')]
		public const NoStarIcon:Class;

	 	[Embed(source='./images/star.gif')]
		public const StarIcon:Class;


		[Embed(source='./images/help.gif')]
	    public const HelpIcon:Class;

	}
}