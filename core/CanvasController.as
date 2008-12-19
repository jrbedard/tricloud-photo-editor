package core
{
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import mx.managers.PopUpManager;
	import mx.controls.Alert;
	import mx.events.ChildExistenceChangedEvent;

	import events.CloudEvent;
	import events.CanvasEvent;


	// Canvas controller: 1 instance
	// Controls what happens in the clouds contained in this canvas
	public class CanvasController
	{

		[Bindable]
		private var m_canvas:CanvasCloud = null; // active canvas



		public function CanvasController()
		{
			
		}



		// Canvas Accessors
		public function SetCanvas(canvas:CanvasCloud):void
		{
			m_canvas = canvas;

			// Dispatch the event that the selected canvas has changed
			this.dispatchEvent(new CanvasEvent("selectCanvas", m_canvas));

			InitListeners();
		}
		public function GetCanvas():CanvasCloud
		{
			if(!m_canvas)
			{
				CloudAlert.show("Warning, no canvas is loaded", 'Canvas Error');
			}

			return m_canvas;
		}





		private function InitListeners():void
		{
			// CANVAS EVENTS
			m_canvas.addEventListener("click", onClickCanvas);
			m_canvas.addEventListener("doubleClick", onDoubleClickCanvas);
			m_canvas.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutCanvas);

			//m_canvas.addEventListener("childAdd", onAddCloudToCanvas); // auto array actions
			//m_canvas.addEventListener("childRemove", );
			//m_canvas.addEventListener("childIndexChange", TagCloudChanged);
			// TODO : edit child here

			// CLOUD EVENTS
			m_canvas.addEventListener("clickCloud", onClickCloud);
			m_canvas.addEventListener("doubleClickCloud", onDoubleClickCloud);

		}

		private function onClickCanvas(mouseEvent:MouseEvent):void
		{
			if((mouseEvent.currentTarget == mouseEvent.target) && (mouseEvent.target == m_canvas)) // if we click only on thecanvas, not through any cloud
			{
				m_canvas.cloudController.UnSelectCloud(false); // drop selected cloud
			}
		}

		private function onDoubleClickCanvas(mouseEvent:MouseEvent):void
		{
			
		}

		// out of canvas
		private function onMouseOutCanvas(mouseEvent:MouseEvent):void
		{
			//m_canvas.cloudController.DropCloud(); // if a cloud was being translated, drop it

			// UnSelect all clouds on canvas
			//UnSelectAllClouds();
		}






		// A cloud was clicked on the canvas
		private function onClickCloud(cloudEvent:CloudEvent):void
		{
			m_canvas.cloudController.SetCloud(cloudEvent.m_cloud); // Set the control to the clicked cloud	
		}

		private function onDoubleClickCloud(cloudEvent:CloudEvent):void
		{
			
		}



		// unselect all clouds : test
		private function UnSelectAllClouds():void
		{
			// test
			for each(var child:DisplayObject in m_canvas.getChildren())
			{
				var sCloud:Cloud = child as Cloud;
				if(!sCloud) // If child is not a Tag
					continue;

				// temp
				//sCloud.GetShape().alpha = 0;
			}
		}


		// Clear all Canvas and all Clouds (triggered by the 'New' menu button)
		public function ClearAll():void
		{
			
		}

	}
}