package controls.effectClasses
{	
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import mx.collections.ArrayCollection;


	public class EffectFactory
	{
		public function EffectFactory()
		{
			
		}

		public function Populate(effectList:ArrayCollection):void
		{
			var effect:CloudEffect = new CloudEffect(); // Default Effect?
			effect.name = "Effect00";
			effectList.addItem(effect);

			effect = new CloudEffect();
			effect.name = "Effect01";
			effectList.addItem(effect);

			effect = new CloudEffect();
			effect.name = "Effect02";
			effectList.addItem(effect);
		}

	}
}