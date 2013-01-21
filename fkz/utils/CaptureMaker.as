package fkz.utils 
{
	
	/**
	 * Make a capture and send it to the Server
	 * @author Francois.Gillet/Soleil Noir
	 */
	
	import com.adobe.images.JPGEncoder
	import com.dynamicflash.util.Base64;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	
	public class CaptureMaker extends EventDispatcher
	{
		
		public var bmpShoot:BitmapData;
		
		public function CaptureMaker(target:DisplayObject, w:int = 320, h:int = 240) 
		{
			bmpShoot = new BitmapData(w, h, false);
			bmpShoot.draw(target);
		}
		
		public function get capture():BitmapData
		{
			return bmpShoot;
		}
		
		public function send(urlScript:String, extraData:Object = null):void
		{
			var jpg : JPGEncoder = new JPGEncoder( 90 );
			var captureJpg :ByteArray = jpg.encode( bmpShoot );
			var urlRequest : URLRequest = new URLRequest();
			urlRequest.url = urlScript;
			urlRequest.method = URLRequestMethod.POST;
			var vars:URLVariables = new URLVariables;
			vars.image = Base64.encodeByteArray(captureJpg);
			if (extraData)
			{
				for (var name:String in extraData ) 
					vars[name] = extraData[name];
				
			}
			urlRequest.data = vars;
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onCompleteCapture);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onCompleteCapture);
			urlLoader.load(urlRequest);
		}
		
		protected function onCompleteCapture(e:Event):void 
		{
			bmpShoot.dispose();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}