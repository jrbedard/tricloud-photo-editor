package controls.effectClasses
{
	import flash.display.Bitmap;

	import share.SharedCloud;


	// Effect
	public class CloudEffect extends SharedCloud
	{
		private static var factoryIndex:uint = 0; // Creation Index



		public function CloudEffect()
		{
			this.localID = factoryIndex++;

			iconBitmap = new Globals.g_assets.Shape00;
		}


		// clone EFFECT
		public function clone():CloudEffect
		{
			var cloudEffect:CloudEffect = new CloudEffect();

			cloudEffect.remoteID = this.remoteID;
			cloudEffect.name = this.name;

			// icon
			// swf

			return cloudEffect;
		}

		// SAVE Effect XML
		public function Save():XML
		{
			var effectXML:XML = new XML("<effect></effect>");

			effectXML.@remoteID = this.remoteID;
			effectXML.@name = this.name;

			// icon
			// swf

			return effectXML;
		}

		// LOAD Effect XML
		public function Load(effectXML:XML):void
		{
			if(!effectXML)
				return;

			this.remoteID = effectXML.@remoteID;
			this.name = effectXML.@name;

			// icon
			// swf
		}
		
		
	}
}