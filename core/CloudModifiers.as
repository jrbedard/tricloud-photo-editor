package core
{
	import flash.events.EventDispatcher;
	import flash.filters.*;
	import mx.controls.Alert;
	import mx.collections.ArrayCollection;

	import CloudEngine;



	// Cloud Modifiers
	public class CloudModifiers
	{
		public static const REPEAT:String = "Repeat";
		public static const WARP:String = "Warp";


		// Cloud's Mofifiers
		[Bindable]
		public var modifiers:ArrayCollection = new ArrayCollection();


		public function CloudModifiers()
		{
			
		}

		// Clone Cloud Modifiers
		public function clone():CloudModifiers
		{
			var cloudModifiers:CloudModifiers = new CloudModifiers();

			return cloudModifiers;
		}

		// SAVE Cloud Modifier XML
		public function Save(cloudXML:XML):void
		{
			
		}


		// LOAD Cloud Modifier XML
		public function Load(cloudXML:XML):void
		{
			
		}

/*
			var warpXML:XML = filtersXML..warp; // Warp filter
			if(warpXML)
			{
				warpFilter.alpha = warpXML.@alpha;
				warpFilter.color = warpXML.@color;
				warpFilter.componentX = warpXML.@componentX;
				warpFilter.componentY = warpXML.@componentY;
				//warpXML.@mapBitmap = warpFilter.mapBitmap // TODO
				warpFilter.mapPoint = warpXML.@mapPoint; // TODO
				warpFilter.mode = warpXML.@mode;
				warpFilter.scaleX = warpXML.@scaleX;
				warpFilter.scaleY = warpXML.@scaleY;
				EnableFilter(CloudFilters.WARP, true);
			}
			

			if(IsFilterEnabled(CloudFilters.WARP)) // Warp Filter is Enabled
			{
				var warpXML:XML = new XML("<warp></warp>"); // add XML Warp Filter
				warpXML.@alpha = warpFilter.alpha;
				warpXML.@color = warpFilter.color;
				warpXML.@componentX = warpFilter.componentX;
				warpXML.@componentY = warpFilter.componentY;
				//warpXML.@mapBitmap = warpFilter.mapBitmap // TODO
				warpXML.@mapPoint = warpFilter.mapPoint; // TODO
				warpXML.@mode = warpFilter.mode;
				warpXML.@scaleX = warpFilter.scaleX;
				warpXML.@scaleY = warpFilter.scaleY;

				filtersXML.appendChild(warpXML); // add Warp Filter XML to Filters XML
			}
*/


		private function GetModifier(ModierName:String):BitmapFilter
		{
			return new BitmapFilter();
		}

		// Is FilterName applied to the current Cloud
		public function IsModifierEnabled(modifierName:String):Boolean
		{
			return false;
		}


			
		
	}
}