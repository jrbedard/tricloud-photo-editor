package type.draw
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import type.draw.ControlPoint;


	public class CPEvent extends MouseEvent
	{
		public var m_controlPoint:ControlPoint = null;

		public function CPEvent(type:String, mouseEvent:MouseEvent, controlPoint:ControlPoint)
		{
			super(type, true);
			super.buttonDown = mouseEvent.buttonDown; // Is this the right way to inherit from MouseEvent??

			// Convert ControlPoint space to DrawTag space
			var pos:Point = new Point(mouseEvent.stageX, mouseEvent.stageY);
			pos = controlPoint.parent.globalToLocal(pos);

			super.localX = pos.x;
			super.localY = pos.y;
				
			m_controlPoint = controlPoint;
		}

		// clone?
	}
}