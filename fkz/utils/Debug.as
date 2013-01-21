package fkz.utils 
{
	import flash.external.ExternalInterface;
	/**
	 * Utils function for debug
	 * @author Francois.Gillet/Soleil Noir
	 */
	public class Debug 
	{
		
		public static function traceObject(o:Object) 
		{
			for (var i:String in o)
				trace(i + ' = ' + o[i]);
		}
		
		public static function jsAlert(s:String)
		{
			ExternalInterface.call("alert", s);
		}
		
	}
	
}