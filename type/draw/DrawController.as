package type.draw
{
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import mx.utils.ObjectUtil;

	import core.Cloud;
    import type.DrawCloud;


	public class DrawController extends EventDispatcher
	{

		[Bindable]
		private var m_drawCloud:DrawCloud = null; // Draw Cloud

		[Bindable]
		public var drawTag:DrawTag = null; // Current Draw Item

		private var oldDrawTag:DrawTag = null; // old Draw Item


		[Bindable]
		public var drawStyle:DrawStyle = null; // Draw Style



		
		public function DrawController()
		{
			
		}



		// Block the first click or mouseDown if the cloud is not new, so you dont draw junk when selecting cloud
		public var blockFirstClick:Boolean = false;



		public function SetCloud(drawCloud:DrawCloud):void
		{
			if(!drawCloud)
				return;

			if(m_drawCloud && m_drawCloud != drawCloud) // Kill listeners on old drawCloud
			{
				KillListeners();
			}

			m_drawCloud = drawCloud;

			drawStyle = m_drawCloud.drawStyle;

			if(m_drawCloud && m_drawCloud.numChildren > 1) // more than 1 child (the image) means that the DrawCloud was cloned with an active DrawTag child
			{
				// Dont do that for now
			}

			// if the cloud is not new : Block first click
			blockFirstClick = true;

			InitListeners();
		}




		private function InitListeners():void
		{
			m_drawCloud.addEventListener("click", onClick);
			m_drawCloud.addEventListener("mouseDown", onMouseDown);

			// Listen for control Points events on canvas
			m_drawCloud.addEventListener("clickCP", onClickCP);
			m_drawCloud.addEventListener("doubleClickCP", onDoubleClickCP);
			m_drawCloud.addEventListener("mouseDownCP", onMouseDownCP);

			m_drawCloud.addEventListener('loadDrawTag', onLoadDrawTag); // DrawTag Loaded via XML
			m_drawCloud.addEventListener('deleteDrawTag', onDeleteDrawTag); // DrawTag Deleted via XML
		}

		private function KillListeners():void
		{
			m_drawCloud.removeEventListener("click", onClick);
			m_drawCloud.removeEventListener("mouseDown", onMouseDown);
			m_drawCloud.removeEventListener("mouseMove", onMouseMove);
			m_drawCloud.parentApplication.removeEventListener("mouseUp", onMouseUp);
			//m_drawCloud.removeEventListener("rollOut", onMouseUp);

			// remove control Points events on canvas
			m_drawCloud.removeEventListener("clickCP", onClickCP);
			m_drawCloud.removeEventListener("mouseDownCP", onMouseDownCP);

			m_drawCloud.removeEventListener('loadDrawTag', onLoadDrawTag);
			m_drawCloud.removeEventListener('deleteDrawTag', onDeleteDrawTag); // DrawTag Deleted via XML
		}



		// Draw Tag Factory
		private function NewDrawTag(toolName:String):DrawTag
		{
			if(drawStyle.polylineDrawing)
				return drawTag;

			DrawTag.drawStyle = m_drawCloud.drawStyle; // Reffer drawStyle

			var newDrawTag:DrawTag = DrawTag.DrawTagFactory(toolName); // New DrawTag
			if(!newDrawTag)
				return null;

			// add draw item to the cloud
			m_drawCloud.AddTag(newDrawTag); // add drawTag to the drawCloud

			return newDrawTag;
		}



		// DrawTag was created by Loading DrawCloud XML
		private function onLoadDrawTag(event:DrawTagEvent):void
		{
			drawTag = event.drawTag;

			// oldDrawTag ?
		}

		// Zombie DrawTag was deleted by Loading DrawCloud XML
		private function onDeleteDrawTag(event:DrawTagEvent):void
		{
			if(event.drawTag == drawTag)
			{
				drawTag = null;
			}
		}



		// On DrawCloudPanel Changed... Redraw the current Tag
		public function onParamChanged(changedDrawTool:Boolean):void
		{
			if(!m_drawCloud || !drawTag)
				return;

			if(!changedDrawTool) // Changed style
			{
				drawTag.BuildStyle();
				drawTag.RenderGraphics(true);

				// Update Cloud Icon
				m_drawCloud.UpdateIconBitmap();
			}

			if(changedDrawTool) // Changed Draw tool : Drop Current Tag!
			{
				oldDrawTag = drawTag; // Save old drawTag
				DropOldDrawTag(); // Drop old Draw Tag
				drawTag = null; // free draw Tag
			}
		}



		// MOUSE EVENTS
		// --------------------------------

		// Click
		private function onClick(mouseEvent:MouseEvent):void
		{
			if(blockFirstClick) // Block first click (cloud select click)
			{
				//blockFirstClick = false;
				//return;
			}

			// test
			if(drawStyle.selectedTool == DrawTag.BUCKET) // PAINT BUCKET
			{
				var argb:uint = 0;
				argb |= (drawStyle.fillAlpha * 255) << 24;
				argb |= (drawStyle.fillColor);

				var dstBitmap:Bitmap = Bitmap(m_drawCloud.drawImage.content);
				dstBitmap.bitmapData.floodFill(mouseEvent.localX, mouseEvent.localY, argb);
				// TODO: smooth edges

				CloudHistory.action("Bucket Fill", m_drawCloud, true);

				m_drawCloud.UpdateIconBitmap();
				return;
			}

			if(!drawTag)
				return;

			// Called at the end of a brush stroke?

			// Click
			drawTag.onClick(mouseEvent);

			// Update Cloud Icon
			m_drawCloud.UpdateIconBitmap();
		}


		// Mouse Down on DrawCloud
		private function onMouseDown(mouseEvent:MouseEvent):void
		{
			if(blockFirstClick) // Block first click (cloud select click)
			{
				//blockFirstClick = false;
				//return;
			}

			oldDrawTag = drawTag; // Save old drawTag


			 // MouseDown on a CP
			if(mouseEvent.target is ControlPoint)
			{
				if(drawStyle.polylineDrawing) // drawing a polyline
				{
					DrawPolyline(drawTag).ClosePolyline(ControlPoint(mouseEvent.target)); // Close the plyline
					drawStyle.polylineDrawing = false; // not drawing a polyline anymore
					m_drawCloud.parentApplication.removeEventListener("mouseUp", onMouseUp);
					m_drawCloud.removeEventListener("mouseMove", onMouseMove);
					return; // End of polyline
				}
				else
				{
					return;	// avoid CP
				}
			}

			// MouseDown in the middle of the Tag
			if(drawTag &&
			   drawTag.CanDrag(mouseEvent.localX, mouseEvent.localY)) // If mouse down on the active tag, move it
			{
				drawStyle.draggingTag = true; // Now dragging the Tag
				drawTag.onDragStart(mouseEvent);
				m_drawCloud.addEventListener("mouseMove", onMouseMove);
				m_drawCloud.parentApplication.addEventListener("mouseUp", onMouseUp);
				return;
			}
			else
			{
				drawStyle.draggingTag = false;
			}


			// Drawing a shape
			if(drawStyle.selectedTool == DrawTag.POLYLINE)
			{
				if(!drawStyle.polylineDrawing)
				{
					drawTag = NewDrawTag(drawStyle.selectedTool); // New Polyline
					drawStyle.polylineDrawing = true; // the NewDrawTag below will always return the drawTag just created
					DropOldDrawTag(); // Drop old tag
				}
			}


			drawTag = NewDrawTag(drawStyle.selectedTool);
			if(!drawTag)
				return; // ignore mouseDown

			drawTag.onMouseDown(mouseEvent);

			m_drawCloud.addEventListener("mouseMove", onMouseMove);
			m_drawCloud.parentApplication.addEventListener("mouseUp", onMouseUp);
			//m_drawCloud.addEventListener("rollOut", onMouseUp);
		}


		// Mouse Move on DrawCloud
		private function onMouseMove(mouseEvent:MouseEvent):void
		{
			if(!m_drawCloud || !drawTag || (!mouseEvent.buttonDown && !drawStyle.polylineDrawing)) // If no drawTag or (LeftButton not pressd and not in polyline mode)
				return;

			// If mouse is not over DrawCloud, discard (ex: over drawTag)
			if(mouseEvent.currentTarget != m_drawCloud)
				return;

			// MouseMove over a CP
			if(mouseEvent.target is ControlPoint)
			{
				if(drawStyle.draggingTag)
					return;

				// Retreive ControlPoint
				var cp:ControlPoint = ControlPoint(mouseEvent.target);
				if(cp)
				{
					// Make the line's end Snap into the ControlPoint
					mouseEvent.localX = cp.drawCloudPos.x + cp.width*0.5;
					mouseEvent.localY = cp.drawCloudPos.y + cp.height*0.5;
				}
			}

			// If Dragging Tag
			if(drawStyle.draggingTag)
			{
				drawTag.onDragMove(mouseEvent); //  Drag Move
				return;
			}

			drawTag.onMouseMove(mouseEvent);
		}


		// Mouse Up on DrawCloud
		private function onMouseUp(mouseEvent:MouseEvent):void
		{
			if(!m_drawCloud)
				return;

			// if Shape Drawing
			if(drawStyle.polylineDrawing)
			{
				if(!drawTag)
					return;

				drawTag.onMouseUp(mouseEvent);
				m_drawCloud.UpdateIconBitmap(); // Update Cloud Icon
				return; // Continue the Shape
			}

			// remove listeners
			m_drawCloud.removeEventListener("mouseMove", onMouseMove);
			m_drawCloud.parentApplication.removeEventListener("mouseUp", onMouseUp);

			// If Dragging Tag
			if(drawStyle.draggingTag)
			{
				drawStyle.draggingTag = false; // Not dragging tag anymore
				drawTag.onDragStop(mouseEvent);
				return;
			}

			if(!drawTag) // no drawTag
				return;


			if((drawTag.type == DrawTag.LINE || drawTag.type == DrawTag.RECTANGLE || 
				drawTag.type == DrawTag.ELLIPSE || drawTag.type == DrawTag.POLYLINE) &&
			    Math.abs(drawTag.tagWidth) < 5 && Math.abs(drawTag.tagHeight) < 5) // accident
			{
				// Remove DrawTag from DrawCloud
				m_drawCloud.RemoveTag(drawTag);
			}
			else
			{
				drawTag.onMouseUp(mouseEvent); // new drawTag
			}

			// Drop old drawTag on Canvas, since the new is done
			DropOldDrawTag();

			// Update Cloud Icon
			m_drawCloud.UpdateIconBitmap();
		}


		// DROP drawTag
		private function DropOldDrawTag():void
		{
			if(!oldDrawTag || !m_drawCloud) // no drawTag
			{
				trace('DropOldDrawTag: No oldDrawTag or drawCloud');
				return;
			}

			if(!m_drawCloud.contains(oldDrawTag)) // if the tags doesnt belongs to the current drawCloud
			{
				trace('DropOldDrawTag: drawCloud doesnt not contain oldDrawTag');
				return;
			}

			//CloudHistory.action('Drop Tag', DrawCloud(oldDrawTag.parent))

			oldDrawTag.removeAllChildren(); // Remove all Control Points

			// Draw OldDrawTag on the DrawCloud's drawImage
			var oldDrawTagMat:Matrix = new Matrix();
			oldDrawTagMat.translate(oldDrawTag.x, oldDrawTag.y); // Translate
			var radVal:Number = oldDrawTag.rotation / 180.0 * Math.PI;
			oldDrawTagMat.rotate(radVal); // Rotate according to tag's rotation

			var dstBitmapData:BitmapData = m_drawCloud.GetBitmapData();
			if(dstBitmapData)
			{
				dstBitmapData.draw(oldDrawTag, oldDrawTagMat, null, null, null, true); // Smooth draw
			}

			// Remove DrawTag from DrawCloud
			m_drawCloud.RemoveTag(oldDrawTag);

			oldDrawTag = null; // free memory
		}





		// CONTROL POINT EVENTS
		// ---------------------------------------

		// Click on ControlPoint
		private function onClickCP(cpEvent:CPEvent):void
		{
			if(!drawTag) // no drawTag
				return;

			drawTag.onClickCP(cpEvent);
		}

		// Double Click on ControlPoint
		private function onDoubleClickCP(cpEvent:CPEvent):void
		{
			if(!drawTag) // no drawTag
				return;

			drawTag.onDoubleClickCP(cpEvent);
		}

		// MouseDown on ControlPoint
		private function onMouseDownCP(cpEvent:CPEvent):void
		{
			if(!drawTag) // no drawTag
				return;

			drawTag.onMouseDownCP(cpEvent);

			m_drawCloud.addEventListener("mouseMove", onMouseMoveCP);
			m_drawCloud.parentApplication.addEventListener("mouseUp", onMouseUpCP);
		}


		// MouseMove on DrawCloud, dragging a ControlPoint
		private function onMouseMoveCP(mouseEvent:MouseEvent):void
		{
			if(!m_drawCloud || !drawTag || !mouseEvent.buttonDown) // no drawTag or button not down
				return;

			// If mouse is not over DrawCloud, discard (ex: over drawTag)
			if(mouseEvent.currentTarget != m_drawCloud)
				return;

			// Convert mouse position in drawTag space
			var pos:Point = new Point(mouseEvent.localX, mouseEvent.localY);

			// SLOW: TODO: optimize this!
			if(mouseEvent.target is ControlPoint) // MouseMove over a CP
			{
				// Retreive ControlPoint
				var cp:ControlPoint = ControlPoint(mouseEvent.target);
				if(cp)
				{
					// Convert mouse position in controlPoint space to drawTag space
					pos = cp.localToGlobal(pos); // MousePos in controlPoint space to global space
					pos = drawTag.globalToLocal(pos); // MousePos in global space to drawTag space, BUG after redo
				}
			}
			else
			{
				// Convert mouse position in drawCloud space to drawTag space
				pos = m_drawCloud.localToGlobal(pos); // MousePos in drawCloud space to global space
				pos = drawTag.globalToLocal(pos); // MousePos in global space to drawTag space
			}

			// Change Mouse position in DrawTag space
			mouseEvent.localX = pos.x;
			mouseEvent.localY = pos.y;

			drawTag.onMouseMoveCP(mouseEvent);
		}


		// MouseUp on DrawCloud, dragging a controlPoint
		private function onMouseUpCP(mouseEvent:MouseEvent):void
		{
			if(!m_drawCloud)
				return;
			
			// remove listeners
			m_drawCloud.removeEventListener("mouseMove", onMouseMoveCP);
			m_drawCloud.parentApplication.removeEventListener("mouseUp", onMouseUpCP);

			if(!drawTag) // no drawTag
				return;

			drawTag.onMouseUpCP(mouseEvent);

			// Update Cloud Icon
			m_drawCloud.UpdateIconBitmap();
		}

	}
}