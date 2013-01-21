package fkz.events 
{
	import flash.events.Event;
	
	/**
	 * Event for video streaming
	 * @author Francois.Gillet
	 */
	public class VideoEvent extends DataEvent
	{
		
		public static const BUFFERING	:String = "buffering";
		public static const READY		:String = "ready";
		public static const END			:String = "end";
		public static const PROGRESS	:String = "progress";
		public static const PRELOADED	:String = "preloaded";
		public static const CUEPOINT	:String = "cuepoint";
		public static const CONNECT		:String = Event.CONNECT;
		public static const SEEK		:String = "seek";
		
		public function VideoEvent(type:String, data:Object = null) 
		{
			super(type, data);
		}
		
	}
	
}