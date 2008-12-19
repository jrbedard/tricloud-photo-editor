package core
{
	import flash.events.EventDispatcher;
	import flash.filters.*;
	import mx.controls.Alert;
	import mx.collections.ArrayCollection;

	import CloudEngine;



	// Filters applied to this cloud
	public class CloudFilters extends EventDispatcher
	{

		public static const DROPSHADOW:String = "Drop Shadow";
		public static const GLOW:String = "Glow";
		public static const BEVEL:String = "Bevel";
		public static const BLUR:String = "Blur";
		public static const OUTLINE:String = "Outline";
		public static const NOISE:String = "Noise";


		// TODO: is it right to instanciate all of those for each clouds?
		// if we dont, 0 values shows in the disable filter accordions...

		[Bindable]
		public var dropShadowFilter:DropShadowFilter = new DropShadowFilter();

		[Bindable]
		public var glowFilter:GlowFilter = new GlowFilter(); // GradientGlowFilter ?

		[Bindable]
		public var bevelFilter:BevelFilter = new BevelFilter(); // GradientBevelFilter ?

		[Bindable]
		public var blurFilter:BlurFilter = new BlurFilter();

		[Bindable]
		public var outlineFilter:ConvolutionFilter = new ConvolutionFilter();


		// Brightness/Contrast and hue/saturation are in ImageTag in ImageCloud ???


		// Cloud's Filters
		[Bindable]
		public var filters:ArrayCollection = new ArrayCollection();



		public function CloudFilters():void
		{
			CreateOutlineFilter();
		}


		// Clone Cloud Filters
		public function clone():CloudFilters
		{
			var cloudFilters:CloudFilters = new CloudFilters();

			if(dropShadowFilter && IsFilterEnabled(CloudFilters.DROPSHADOW))
			{
				cloudFilters.dropShadowFilter = this.dropShadowFilter.clone() as DropShadowFilter;	
				cloudFilters.EnableFilter(CloudFilters.DROPSHADOW, true);
			}

			if(glowFilter && IsFilterEnabled(CloudFilters.GLOW))
			{
				cloudFilters.glowFilter = this.glowFilter.clone() as GlowFilter;
				cloudFilters.EnableFilter(CloudFilters.GLOW, true);
			}

			if(bevelFilter && IsFilterEnabled(CloudFilters.BEVEL))
			{
				cloudFilters.bevelFilter = this.bevelFilter.clone() as BevelFilter;	
				cloudFilters.EnableFilter(CloudFilters.BEVEL, true);
			}

			if(blurFilter && IsFilterEnabled(CloudFilters.BLUR))
			{
				cloudFilters.blurFilter = this.blurFilter.clone() as BlurFilter;
				cloudFilters.EnableFilter(CloudFilters.BLUR, true);
			}

			if(outlineFilter && IsFilterEnabled(CloudFilters.OUTLINE))
			{
				cloudFilters.outlineFilter = this.outlineFilter.clone() as ConvolutionFilter
				cloudFilters.EnableFilter(CloudFilters.OUTLINE, true);
			}

			return cloudFilters;
		}


		private function CreateOutlineFilter():void
		{
			var matrix:Array = [-30, 30, 0,
                                -30, 30, 0,
                                -30, 30, 0];

			var matrixX:Number = 3;
            var matrixY:Number = 3;
            var divisor:Number = 9;

			outlineFilter.matrix = matrix;
			outlineFilter.matrixX = matrixX;
			outlineFilter.matrixY = matrixY;
			outlineFilter.divisor = divisor;
		}




		private function GetFilter(filterName:String):BitmapFilter
		{
			var filter:BitmapFilter = null;

			if(filterName == CloudFilters.DROPSHADOW)
			{
				filter = dropShadowFilter;
			}
			else if(filterName == CloudFilters.GLOW)
			{
				filter = glowFilter;
			}
			else if(filterName == CloudFilters.BEVEL)
			{
				filter = bevelFilter;
			}
			else if(filterName == CloudFilters.BLUR)
			{
				filter = blurFilter;
			}
			else if(filterName == CloudFilters.OUTLINE)
			{
				filter = outlineFilter;
			}
			else if(filterName == CloudFilters.NOISE)
			{
				filter = outlineFilter;
			}
			
			else
			{
				CloudAlert.show("Unknown filter: " + filterName, 'Filter Error');
			}

			return filter;
		}


		// Is FilterName applied to the current Cloud
		public function IsFilterEnabled(filterName:String):Boolean
		{
			var filter:BitmapFilter = GetFilter(filterName);

			if(filters.contains(filter))
			{
				return true;
			}
			return false;
		}


		public function EnableFilter(filterName:String, enable:Boolean):void
		{
			var filter:BitmapFilter = GetFilter(filterName);

			if(enable) // enable filter
			{
				if(!filters.contains(filter)) // filter not in array yet
				{
					filters.addItem(filter); // Add filter
				}
				else
				{
					//CloudAlert.show("Error: Filter already in array!");
				}
			}
			else // disable filter
			{
				if(filters.contains(filter)) // filter in array
				{
					filters.removeItemAt(filters.getItemIndex(filter)); // Remove filter
				}
				else
				{
					//CloudAlert.show("Error: Filter not in array");
				}
			}
		}



		// Save filters XML
		public function Save(cloudXML:XML):void
		{
			var filtersXML:XML = new XML("<filters></filters>"); // add Filters child

			// TODO: there must be a way to convert an filter object into XML automatically (like in C#)
			if(IsFilterEnabled(CloudFilters.DROPSHADOW)) // Drop Shadow Filter is Enabled
			{
				var dropShadowXML:XML = new XML("<dropShadow></dropShadow>"); // Create Drop Shadow Filter XML
				dropShadowXML.@alpha = dropShadowFilter.alpha;
				dropShadowXML.@angle = dropShadowFilter.angle;
				dropShadowXML.@blurX = dropShadowFilter.blurX;
				dropShadowXML.@blurY = dropShadowFilter.blurY;
				dropShadowXML.@color = dropShadowFilter.color;
				dropShadowXML.@distance = dropShadowFilter.distance;
				dropShadowXML.@hideObject = dropShadowFilter.hideObject;
				dropShadowXML.@inner = dropShadowFilter.inner;
				dropShadowXML.@knockout = dropShadowFilter.knockout;
				dropShadowXML.@quality = dropShadowFilter.quality;
				dropShadowXML.@strength = dropShadowFilter.strength;

				filtersXML.appendChild(dropShadowXML); // add Drop Shadow Filter XML to Filters XML
			}

			if(IsFilterEnabled(CloudFilters.GLOW)) // Glow Filter is Enabled
			{
				var glowXML:XML = new XML("<glow></glow>"); // Create Glow Filter XML
				glowXML.@alpha = glowFilter.alpha;
				glowXML.@blurX = glowFilter.blurX;
				glowXML.@blurY = glowFilter.blurY;
				glowXML.@color = glowFilter.color;
				glowXML.@inner = glowFilter.inner;
				glowXML.@knockout = glowFilter.knockout;
				glowXML.@quality = glowFilter.quality;
				glowXML.@strength = glowFilter.strength;

				filtersXML.appendChild(glowXML); // add Glow Filter XML to Filters XML
			}

			if(IsFilterEnabled(CloudFilters.BEVEL)) // Bevel Filter is Enabled
			{
				var bevelXML:XML = new XML("<bevel></bevel>"); // create Bevel Filter XML
				bevelXML.@angle = bevelFilter.angle;
				bevelXML.@blurX = bevelFilter.blurX;
				bevelXML.@blurY = bevelFilter.blurY;
				bevelXML.@distance = bevelFilter.distance;
				bevelXML.@highlightAlpha = bevelFilter.highlightAlpha;
				bevelXML.@highlightColor = bevelFilter.highlightColor;
				bevelXML.@knockout = bevelFilter.knockout;
				bevelXML.@quality = bevelFilter.quality;
				bevelXML.@shadowAlpha = bevelFilter.shadowAlpha;
				bevelXML.@shadowColor = bevelFilter.shadowColor;
				bevelXML.@strength = bevelFilter.strength;
				bevelXML.@type = bevelFilter.type;

				filtersXML.appendChild(bevelXML); // add Bevel Filter XML to Filters XML
			}

			if(IsFilterEnabled(CloudFilters.BLUR)) // Blur Filter is Enabled
			{
				var blurXML:XML = new XML("<blur></blur>"); // add XML Blur Filter
				blurXML.@blurX = blurFilter.blurX;
				blurXML.@blurY = blurFilter.blurY;
				blurXML.@quality = blurFilter.quality;

				filtersXML.appendChild(blurXML); // add Blur Filter XML to Filters XML
			}


			cloudXML.appendChild(filtersXML); // Add filters XML to Cloud XML
		}


		// Load filters XML
		public function Load(cloudXML:XML):void
		{
			var filtersXML:XMLList = cloudXML..filters; // Retreive Cloud Filters XML

			for each(var filterXML:XML in filtersXML) // For each filter in filters
			{

				var dropShadowXML:XML = (filterXML..dropShadow)[0]; // Drop Shadow filter
				if(dropShadowXML)
				{
					dropShadowFilter.alpha = dropShadowXML.@alpha;
					dropShadowFilter.angle = dropShadowXML.@angle;
					dropShadowFilter.blurX = dropShadowXML.@blurX;
					dropShadowFilter.blurY = dropShadowXML.@blurY;
					dropShadowFilter.color = dropShadowXML.@color;
					dropShadowFilter.distance = dropShadowXML.@distance;
					dropShadowFilter.hideObject = dropShadowXML.@hideObject;
					dropShadowFilter.inner = dropShadowXML.@inner;
					dropShadowFilter.knockout = dropShadowXML.@knockout;
					dropShadowFilter.quality = dropShadowXML.@quality;
					dropShadowFilter.strength = dropShadowXML.@strength;
					EnableFilter(CloudFilters.DROPSHADOW, true);
				}
	
				var glowXML:XML = (filterXML..glow)[0]; // Glow filter
				if(glowXML)
				{
					glowFilter.alpha = glowXML.@alpha;
					glowFilter.blurX = glowXML.@blurX;
					glowFilter.blurY = glowXML.@blurY;
					glowFilter.color = glowXML.@color;
					glowFilter.inner = glowXML.@inner;
					glowFilter.knockout = glowXML.@knockout;
					glowFilter.quality = glowXML.@quality;
					glowFilter.strength = glowXML.@strength;
					EnableFilter(CloudFilters.GLOW, true);
				}
	
				var bevelXML:XML = (filterXML..bevel)[0]; // Bevel filter
				if(bevelXML)
				{
					bevelFilter.angle = bevelXML.@angle;
					bevelFilter.blurX = bevelXML.@blurX;
					bevelFilter.blurY = bevelXML.@blurY;
					bevelFilter.distance = bevelXML.@distance;
					bevelFilter.highlightAlpha = bevelXML.@highlightAlpha;
					bevelFilter.highlightColor = bevelXML.@highlightColor;
					bevelFilter.knockout = bevelXML.@knockout;
					bevelFilter.quality = bevelXML.@quality;
					bevelFilter.shadowAlpha = bevelXML.@shadowAlpha;
					bevelFilter.shadowColor = bevelXML.@shadowColor;
					bevelFilter.strength = bevelXML.@strength;
					bevelFilter.type = bevelXML.@type;
					EnableFilter(CloudFilters.BEVEL, true);
				}
	
				var blurXML:XML = (filterXML..blur)[0]; // Blur filter
				if(blurXML)
				{
					blurFilter.blurX = blurXML.@blurX;
					blurFilter.blurY = blurXML.@blurY;
					blurFilter.quality = blurXML.@quality;
					EnableFilter(CloudFilters.BLUR, true);
				}
			

			}
		}	


	}
}