package fkz.utils 
{
	/**
	 * ...
	 * @author Francois.Gillet/Soleil Noir
	 */
	public class ArrayUtils
	{
		
		public static function removeInArray(item:*, a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) 
			{
				if(a[i] == item)
					a.splice(i, 1);
			}
		}
		
	}

}