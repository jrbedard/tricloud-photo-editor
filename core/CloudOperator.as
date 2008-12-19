package core
{
	import flash.geom.Point;


	// TODO: Change class name to CloudTransformer
	public class CloudOperator
	{
		
		private var m_target:Object; // Normally its the Cloud


		// Rotation variables
		private var angleFrom:Number = 0; // Initial Cloud rotation

		private var originX:Number;
		private var originY:Number;

		private var centerX:Number;
		private var centerY:Number;

		private var newX:Number;
		private var newY:Number;
	
		private var originalOffsetX:Number;
		private var originalOffsetY:Number;


		// Scaling variables
		private var scaleXFrom:Number = 0; // Initial Cloud scale X
		private var scaleYFrom:Number = 0; // Initial Cloud scale Y

		private var originWidth:int = 0;
		private var originHeight:int = 0;



		// ROTATION
		public function InitRotation(targets:Array):void
		{
			m_target = targets[0]; // TODO: itterate for mulitple targets

			// BEGIN ROTATE, complicated because the center of rotation id (0,0)... 
			// Based on rotateInstance.as

			var radVal:Number = Math.PI * m_target.rotation / 180;
			originX = m_target.width / 2;
			originY = m_target.height / 2;

			centerX = m_target.x +
				  originX * Math.cos(radVal) -
				  originY * Math.sin(radVal);
			centerY = m_target.y +
				  originX * Math.sin(radVal) +
				  originY * Math.cos(radVal);

			angleFrom = m_target.rotation;

			radVal = Math.PI * angleFrom/180;

			originalOffsetX = originX * Math.cos(radVal) - originY * Math.sin(radVal);
			originalOffsetY = originX * Math.sin(radVal) + originY * Math.cos(radVal);

			newX = Number((centerX - originalOffsetX).toFixed(1)); // use a precision of 1
			newY = Number((centerY - originalOffsetY).toFixed(1)); // use a precision of 1

			m_target.x = newX;
			m_target.y = newY;
		}

		// Update Rotation on mouseMove
		public function UpdateRotation(diff:Number):void
		{
			if(isNaN(diff))
				diff = 0;

			if(newX != Number(m_target.x.toFixed(1)))
			{
				centerX = m_target.x + originalOffsetX;
			}

			if(newY != Number(m_target.y.toFixed(1)))
			{
				centerY = m_target.y + originalOffsetY;
			}		


			var rotateValue:Number = Number(angleFrom + diff);
			var radVal:Number = Math.PI * rotateValue / 180;

			m_target.rotation = rotateValue;

			newX = centerX - originX * Math.cos(radVal) + originY * Math.sin(radVal);
			newY = centerY - originX * Math.sin(radVal) - originY * Math.cos(radVal);

			newX = Number(newX.toFixed(1)); // use a precision of 1
			newY = Number(newY.toFixed(1)); // use a precision of 1

			m_target.x = newX;
			m_target.y = newY;
		}


		// SCALING
		// ------------------------------------------
		public function InitScaling(targets:Array):void
		{
			m_target = targets[0];// TODO: itterate for mulitple targets

			scaleXFrom = m_target.scaleX;
			scaleYFrom = m_target.scaleY;

			originX = m_target.x; // position of the cloud within canvas
			originY = m_target.y;

			originWidth = m_target.width;
			originHeight = m_target.height;
		
			var radVal:Number = Math.PI * m_target.rotation / 180;
			scaleRatio.x = Math.cos(radVal) + Math.sin(radVal);
			scaleRatio.y = -Math.sin(radVal) + Math.cos(radVal);
		}

		private var scaleRatio:Point = new Point(0,0);

		// Update scaling on mouseMove
		public function UpdateScaling(diff:Number, hScale:Boolean, vScale:Boolean):void
		{
			if(isNaN(diff))
				diff = 0;

			if(hScale)
				m_target.scaleX = Math.max(0.1, (scaleXFrom + (diff * 0.01)));

			if(vScale)
				m_target.scaleY = Math.max(0.1, (scaleYFrom + (diff * 0.01)));

			// to offset the position of the cloud according to central scaling
			if(hScale)
				m_target.x = originX + scaleRatio.x * ((originWidth * scaleXFrom) - (originWidth * m_target.scaleX))* 0.5;

			if(vScale)
				m_target.y = originY + scaleRatio.y * ((originHeight * scaleYFrom) - (originHeight * m_target.scaleY))* 0.5;
		}


	}
}