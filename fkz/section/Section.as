package fkz.section 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * Animated Section : label open and close  
	 * @author Francois.Gillet
	 */
	public class Section extends MovieClip
	{
		
		public function Section() 
		{
			//trace(this);
		}
		
		public function open():void
		{
			
		}
		
		public function close():void
		{
			gotoAndPlay("close");
		}
		
		public function onOpen():void
		{
			dispatchEvent(new Event(Event.OPEN));
		}
		
		public function onClose():void
		{
			stop();
			dispatchEvent(new Event(Event.CLOSE));
		}
		
	}
	
}