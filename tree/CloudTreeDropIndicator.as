package tree
{

import flash.display.Graphics;
import mx.skins.ProgrammaticSkin;

/**
 *  The skin for the drop indicator of a list-based control.
 */
public class CloudTreeDropIndicator extends ProgrammaticSkin
{
	//include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function CloudTreeDropIndicator()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  direction
	//----------------------------------

	/**
	 *  Should the skin draw a horizontal line or vertical line.
	 *  Default is horizontal.
	 */
	public var direction:String = "horizontal";

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override protected function updateDisplayList(w:Number, h:Number):void
	{
		super.updateDisplayList(w, h);

		var g:Graphics = graphics;

		g.clear();
		g.lineStyle(4, 0x8B838C);

		// Line
		if (direction == "horizontal")
		{
			//g.drawRect(0,0,w,h+10);
		    g.moveTo(-20, 0);
		    g.lineTo(w, 0);
        }
        else
        {
            g.moveTo(0, 0);
            g.lineTo(0, h);
        }
	
	}
}

}
