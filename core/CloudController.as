package core
{
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.filters.*;

	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.StateChangeEvent;

	import type.*;
	import events.CloudEvent;




	public class CloudController
	{

		[Bindable]
		private var m_cloud:Cloud = null; // Selected/active cloud

		private var cloudFactoryIndex:int = 0;


		[Bindable]
		public var cloudNavigator:CloudNavigator = null; // one and only cloud Navigator, passed by the designview



		// Constructor
		public function CloudController()
		{
			
		}


		// Cloud Factory
		public function NewCloud(cloudName:String, cloudType:String, bitmapData:BitmapData =null):Cloud
		{
			var newCloud:Cloud = Cloud.CloudFactory(cloudType);
			if(!newCloud)
				return null;

			if(cloudType == CloudType.IMAGE && bitmapData) // Imported IMAGE
			{
				newCloud.SetBitmapData(bitmapData);
				bitmapData = null;
			}
			else if(cloudType == CloudType.DRAW) // DRAW Cloud
			{
				if(bitmapData) // Conversion Image -> Draw
				{
					newCloud.SetBitmapData(bitmapData);
					bitmapData = null;
				}
				else // Draw Cloud Creation
				{
					// Create a DrawCloud surface
					var bmpData:BitmapData = new BitmapData(300, 300, true, 0);
					newCloud.SetBitmapData(bmpData);
				}
			}
			else if(cloudType == CloudType.TEXT) // TEXT
			{
				
			}
			else
			{
				CloudAlert.show("Invalid Cloud Creation", "Cloud Controller")
				return null;
			}

			if(cloudName)
			{
				newCloud.name = cloudName;
			}

			SetCloud(newCloud);

			InitListeners();

			return newCloud;
		}


		// Duplicate Cloud
		public function DuplicateCloud(srcCloud:Cloud):Cloud
		{
			var dupCloud:Cloud = m_cloud.clone();

			SetCloud(dupCloud);

			InitListeners();

			return dupCloud;
		}


		// Convert Cloud in another type of clouds, the possibilities are:
		// DrawCloud -> ImageCloud
		// ImageCloud -> DrawCloud
		// TextCloud -> ImageCloud
		public function ConvertCloud(srcCloud:Cloud, destType:String):Cloud
		{
			if(!srcCloud)
				return null;

			var destCloud:Cloud = null;

			//AddNewCloud

			if(destType == "Image") // Draw or Text -> Image
			{
				destCloud = NewCloud(srcCloud.name, destType, srcCloud.GetBitmapData());
			}
			else if(destType == "Draw") // Image or Text -> Draw
			{
				destCloud = NewCloud(srcCloud.name, destType, srcCloud.GetBitmapData());
			}
			else
			{
				CloudAlert.show("Invalid Cloud Type", "Cloud Controller")
			}

			// Remove source Cloud

			return destCloud;
		}



		// Set selected cloud
		public function SetCloud(_cloud:Cloud):void
		{
			//if(m_cloud && m_cloud == _cloud) // Cloud alredy selected
			//	return;

			if(m_cloud && m_cloud != _cloud) // If there was a selected cloud that is not the new currently selected cloud
			{
				// Change state of the old cloud to unSelected
				UnSelectCloud(true);
				_cloud.setCurrentState("selected"); // Select the new cloud if its not the first time on canvas
			}

			m_cloud = _cloud;

			// CloudNavigator
			cloudNavigator.SetCloud(m_cloud);

			// Dispatch the event that the selected cloud has changed
			this.dispatchEvent(new CloudEvent("selectCloud", m_cloud));

			// Disable Mouse on every clouds behind/overlap this cloud
			CloudOcclusionMouseDisable();

			// Update icon Bitmap
			m_cloud.UpdateIconBitmap();

		}
		public function GetCloud():Cloud
		{
			if(!m_cloud)
			{
				//CloudAlert.show("Warning, no cloud is selected");
			}
			return m_cloud;
		}


		// UNSELECT Clouds
		public function UnSelectCloud(switching:Boolean):void
		{
			if(m_cloud)
			{
				m_cloud.setCurrentState("unSelected"); // could also be mouseOver
	
				// Lose focus on the cloud
				m_cloud.onLoseFocus();

				// re-Give mouse event to all clouds...
				CloudOcclusionMouseEnable();
			}

			// Dispatch the event that no cloud is selected
			if(!switching)
			{
				this.dispatchEvent(new CloudEvent("unSelectClouds", null));
			}
			cloudNavigator.SetCloud(null);
		}


		// Initialize the listeners on the tag cloud
		private function InitListeners():void
		{
			// CLOUD EVENTS
			m_cloud.addEventListener("childAdd", onCloudChildrenChanged); // auto array actions
			m_cloud.addEventListener("childRemove", onCloudChildrenChanged);

			// Cloud Navigator mouseDown events for transformations
			m_cloud.addEventListener(MouseEvent.CLICK, onClickCloud);
			m_cloud.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onCloudStateChange);
		}

		private function KillListeners():void
		{
			// CLOUD EVENTS
			m_cloud.removeEventListener("childAdd", onCloudChildrenChanged); // auto array actions
			m_cloud.removeEventListener("childRemove", onCloudChildrenChanged);

			// Cloud Navigator mouseDown events for transformations
			m_cloud.removeEventListener(MouseEvent.CLICK, onClickCloud);
			m_cloud.removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onCloudStateChange);
		}



    	private function onCloudChildrenChanged(event:Event):void
    	{
    		
    	}

		// On click cloud
		private function onClickCloud(mouseEvent:MouseEvent):void
		{
			
		}

		private function onCloudStateChange(stateEvent:StateChangeEvent):void
		{
			if(stateEvent.oldState == "unSelected" && stateEvent.newState == "selected") // cloud is externally selected
			{
				//cloudNavigator.setCurrentState("selected");
			}

			if(stateEvent.oldState == "mouseOver" && stateEvent.newState == "selected") // User clicked on the cloud on canvas
			{
				cloudNavigator.setCurrentState("locked");
			}
		}



		// Disable Mouse on every clouds behind this cloud
		private function CloudOcclusionMouseDisable():void
		{
			var canvas:CanvasCloud = CanvasCloud(m_cloud.parent); // Get the canvas that contain the cloud
			if(!canvas)
				return;
/*
			for each(var child:DisplayObject in canvas.getChildren())
			{
				var sCloud:Cloud = child as Cloud;
				if(m_cloud && sCloud && m_cloud != sCloud)
				{
					if(m_cloud.hitTestObject(sCloud)) // TODO: wrong way... because we want to click a 'container' cloud
					{
						sCloud.mouseEnabled = false; // Disable mouse
						sCloud.mouseChildren = false;
					}
				}
			}
*/
		}


		// re-Give mouse event to all clouds...
		private function CloudOcclusionMouseEnable():void
		{
			var canvas:CanvasCloud = CanvasCloud(m_cloud.parent); // Get the canvas that contain the cloud
			if(!canvas)
				return;
/*
			for each(var child:DisplayObject in canvas.getChildren())
			{
				var sCloud:Cloud = child as Cloud;
				if(sCloud)
				{
					sCloud.mouseEnabled = true; // ReEnable mouse
					sCloud.mouseChildren = true;
				}
			}
*/
		}


	}
}
