package fkz.net
{
	/**
	 * Remoting
	 * @author Francois.Gillet/Soleil Noir
	 */
	
	import flash.events.EventDispatcher;
	import fkz.events.ServerEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class Server extends EventDispatcher
	{
		protected var nc 				:NetConnection;
		
		protected var responder 		:Responder;
		protected var eventToDispatch 	:String;
		protected var eventHandler 		:Function;
		
		public function Server(urlGateway:String)
		{
			nc = new NetConnection();
			nc.connect(urlGateway);
			responder = new Responder(onResult, onStatus);
		}
		
		protected function onResult(result:Object):void
		{
			if (eventHandler != null)
				eventHandler.call(
					this, new ServerEvent(eventToDispatch, result)
				);
		}
		
		protected function onStatus(status:Object):void
		{
			throw new Error(
				'\r' +status.code
				+' (' +status.level +')\r'
				+status.description
				+'\ron ' +status.details
				+' (line ' +status.line +')'
			);
		}
		
		protected function call(method:String, eventType:String, ...arguments:Array):void
		{
			eventHandler = arguments.pop() as Function;
			eventToDispatch = eventType;
			
			if (eventHandler != null) 
			{
				removeEventListener(eventType, eventHandler);
				addEventListener(eventType, eventHandler);
			}
			
			nc.call.apply(nc, [method, responder].concat(arguments));
		}
		
	}
}