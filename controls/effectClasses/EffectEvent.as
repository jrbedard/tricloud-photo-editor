package controls.effectClasses
{
	import flash.events.Event;

	public class EffectEvent extends Event
	{
		public var effect:CloudEffect = null;

		public function EffectEvent(type:String, effect:CloudEffect)
		{
			super(type, true);
			this.effect = effect;
		}
	}
}