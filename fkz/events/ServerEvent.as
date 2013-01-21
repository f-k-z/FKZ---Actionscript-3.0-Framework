package fkz.events
{
	/**
	 * Event dispatch after a Server call
	 * @author Francois.Gillet/Soleil Noir
	 */
	
	import flash.events.Event;
	
	public class ServerEvent extends Event
	{
		public static const RESULT :String = 'result';
		public static const ERROR  :String = 'error';
		
		public var result  :Object;
		public var command :String;
		
		public function ServerEvent(type:String, result:Object, command:String = '')
		{
			super(type, true);
			this.result = result;
			this.command = command;
		}
	}
}