package fkz.events 
{
	
	/**
	 * Event with data Object
	 * @author Francois.Gillet
	 */
	
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		
		public var data:Object;
		
		public function DataEvent(type:String, data:Object = null) 
		{
			super(type, true);
			if(data)
				this.data = data;
		}
		
	}
	
}