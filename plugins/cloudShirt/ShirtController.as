package
{
	import mx.binding.utils.BindingUtils;
	import mx.utils.ObjectProxy;

	import product.ProductController;
	import CloudEngine;
	import core.CanvasController;

	import panels.center.CloudShirtPanel;
	import panels.center.ShirtLoader;
	


	public class ShirtController extends ProductController
	{
		private var cloudShirtPanel:CloudShirtPanel = null;

		// Shirt Loader
		private var shirtLoader:ShirtLoader = null;

		// Canvas Controller
		private var canvasController:CanvasController = null;



		public function ShirtController()
		{
			canvasController = CloudEngine.GetInstance().GetCanvasController();

			shirtLoader = new ShirtLoader();

			//BindingUtils.bindSetter( onChangeShirtModel, this, CloudShirt.shirtModel ); // Listener for Shirt Model changed
    		//BindingUtils.bindSetter( onChangeShirtColor, this, CloudShirt.shirtColor ); // Listener for Shirt Model changed
    		//BindingUtils.bindSetter( onChangeShirtSide,  this, CloudShirt.shirtSide ); // Listener for Shirt Side changed
    	}


 		public function SetCloudShirtPanel(_cloudShirtPanel:CloudShirtPanel):void
        {
			// TEMP
			cloudShirtPanel = _cloudShirtPanel;
			canvasController.SetCanvas(cloudShirtPanel.shirtSide ? cloudShirtPanel.shirtFront : cloudShirtPanel.shirtBack);
			LoadShirt();
        }
        public function GetCloudShirtPanel():CloudShirtPanel
        {
        	return cloudShirtPanel;
        }


		// Shirt Model changed
        private function onChangeShirtModel(newShirtModel:int):void
        {
        	LoadShirt();
        }

		// Shirt color changed
		private function onChangeShirtColor(newShirtColor:int):void
		{
			LoadShirt();
		}


		private function LoadShirt():void
		{
			shirtLoader.LoadShirt(cloudShirtPanel); //uGLY
			
		}




		// Displayed Shirt Side changed
        private function onChangeShirtSide(newShirtModel:int):void
        {
			//onChangeShirtModel(newShirtModel);

			// Give the active tag cloud to the tag cloud controller
			//canvasController.SetCanvas(CloudShirt.shirtSide ? shirtPanel.shirtFront : shirtPanel.shirtBack);

			//shirtPanel.shirtFront.visible = CloudShirt.shirtSide;
			//shirtPanel.shirtBack.visible = !CloudShirt.shirtSide;
        }



	}
}