// ActionScript file
package
{
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.ui.ContextMenuBuiltInItems;
    import flash.display.Sprite;
    import flash.text.TextField;

    public class RightClickMenu extends Sprite
    {
        public var triCloudContextMenu:ContextMenu;


        public function RightClickMenu(appName:String)
        {
            triCloudContextMenu = new ContextMenu();
            removeDefaultItems();
            addCustomMenuItems(appName);
        }

        private function removeDefaultItems():void
        {
            triCloudContextMenu.hideBuiltInItems();

            var defaultItems:ContextMenuBuiltInItems = triCloudContextMenu.builtInItems;
            defaultItems.print = false;
        }

        private function addCustomMenuItems(appName:String):void
        {
            var item:ContextMenuItem = new ContextMenuItem(appName);
            triCloudContextMenu.customItems.push(item);
            // TODO: Add icon!
        }

    }
}