package
{
	import mx.core.BitmapAsset;
	import product.CloudProduct;


	public class CloudShirt extends CloudProduct
	{
		// This is the model and the view
		[Bindable]
		public var model:String = ""; 

		[Bindable]
		public var color:String = "";


		private var bmpAsset:BitmapAsset = null; // temp Product Icon image
		


		public function CloudShirt()
		{
			type = "Cloud Shirt";
			bmpAsset = new Globals.g_assets.tn_shirt00;
			iconBitmap.bitmapData = bmpAsset.bitmapData;
		}


		public override function Load(cloudProductXML:XML):void
		{
			super.Load(cloudProductXML);
		}

		public override function Save():XML
		{
			var cloudProductXML:XML = super.Save();

			var cloudShirtXML:XML = new XML("<cloudShirt></cloudShirt>");
			cloudShirtXML.@model = this.model;
			cloudShirtXML.@color = this.color;

			cloudProductXML.appendChild(cloudShirtXML); // Add cloudShirt XML to cloudProduct XML

			return cloudProductXML;
		}

	}
}