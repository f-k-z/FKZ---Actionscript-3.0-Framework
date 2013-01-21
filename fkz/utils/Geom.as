package fkz.utils 
{
	import flash.geom.Point;
	/**
	 * Geom Utils
	 * @author Francois.Gillet/Soleil Noir
	 */
	public class Geom
	{
		//get intersection between 2 vectors
		public static function getIntersection(v1P0:Point, v1P2:Point, v2P0:Point, v2P1:Point):Point 
		{
			var ip:Point  = new Point();
			var a1:Number = v1P2.y - v1P0.y;
			var b1:Number = v1P0.x - v1P2.x;
			var c1:Number = v1P2.x*v1P0.y - v1P0.x*v1P2.y;
			var a2:Number = v2P1.y - v2P0.y;
			var b2:Number = v2P0.x - v2P1.x;
			var c2:Number = v2P1.x*v2P0.y - v2P0.x*v2P1.y;
			var denom:Number = a1*b2 - a2*b1;
			//if (denom == 0) 
				//return null;
			ip.x = (b1*c2 - b2*c1)/denom;
			ip.y = (a2*c1 - a1*c2)/denom;
			return ip;
		}
		
	}

}