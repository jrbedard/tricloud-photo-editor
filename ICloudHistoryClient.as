package
{
	public interface ICloudHistoryClient
	{

		function Load(xml:XML):void;

		function Save():XML;
	}
}