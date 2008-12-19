package controls.colorClasses
{
	import flash.events.IEventDispatcher;
	

	// SOLID COLOR HUE SATURATION BRIGHTNESS
	public final class SolidHSB
	{

		public var h:uint = 0;    // hue
		public var s:uint = 0;    // saturation
		public var b:uint = 0;    // brightness


		public function SolidHSB(hue:uint = 0, saturation:uint = 0, brightness:uint = 0)
		{
		    h = hue;
		    s = saturation;
		    b = brightness;
		}

		public function to_object():Object
		{
		    return {h:h, s:s, b:b };
		}

		public static function rgb_to_hsb(color:uint):SolidHSB
		{
		    var r:int = (color >> 16) & 0xFF;
		    var g:int = (color >> 8) & 0xFF;
		    var b:int = color & 0xFF;
		
		    var min:int = Math.min(Math.min(r, g), b);
		    var max:int = Math.max(Math.max(r, g), b);
		
		    var delta:int = max - min;
		
		    var brightness:int = max;
		    var saturation:Number = (max == 0) ? 0 : Number(delta) / max;
		
		    var hue:Number = 0;
		    if (saturation != 0) {
		        if (r == brightness) hue = (60 * (g - b)) / delta;
		        else
		        if (g == brightness) hue = 120 + (60 * (b - r)) / delta;
		        else         hue = 240 + (60 * (r - g)) / delta;

		        if (hue < 0) hue += 360;
		    }

		    return new SolidHSB(Math.round(hue), Math.round(saturation * 100), Math.round((brightness / 255) * 100) );
		}

		public static function hsb_to_rgb(hsb:SolidHSB):uint
		{
		    var brightness:Number = hsb.b / 100;
		    if (brightness == 0) return 0;
		    var hue:Number = (hsb.h % 360) / 60;
		    var saturation:Number = hsb.s / 100;
		
		    var i:Number = Math.floor(hue);
		    var p:Number = (1 - saturation);
		    var q:Number = (1 - (saturation * (hue - i)));
		    var t:Number = (1 - (saturation * (1 - (hue - i))));
		
		    var r:Number, g:Number, b:Number;
		    switch (i) {
		        case 0: r = 1; g = t; b = p; break;
		        case 1: r = q; g = 1; b = p; break;
		        case 2: r = p; g = 1; b = t; break;
		        case 3: r = p; g = q; b = 1; break;
		        case 4: r = t; g = p; b = 1; break;
		        case 5: r = 1; g = p; b = q; break;
		    }

		    return ((Math.round(r * 255 * brightness) & 0xFF) << 16) | ((Math.round(g * 255 * brightness) & 0xFF) << 8) | (Math.round(b * 255 * brightness) & 0xFF);
		}
	}
}