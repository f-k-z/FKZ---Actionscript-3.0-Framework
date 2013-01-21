package fkz.media.video 
{
	
	import flash.events.NetStatusEvent;
	import fkz.events.VideoEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	/**
	 * VideoContainer with FMS management
	 * @author Francois.Gillet
	 */
	public class FMSVideoContainer extends VideoContainer
	{
		
		public var urlFMS					:String;
		
		protected var startAfterConnect		:Boolean;
		private var itvConnectRtmpt			:uint;
		
		
		public function FMSVideoContainer(urlFMS:String, path:String, bufferTime:Number = 1, loopMode:Boolean = false, startAfterConnect:Boolean = true):void
		{
			this.startAfterConnect = startAfterConnect;
			this.urlFMS = urlFMS;
			super(path, bufferTime, loopMode);
		}
		
		override public function connect():void 
		{
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			nc.proxyType = 'HTTP';
			//itvConnectRtmpt = setTimeout(connectFMS, 3000, true);
			connectFMS(false);
		}
		
		private function connectFMS(bRtmpt:Boolean)
		{
			var url:String = (!bRtmpt) ? urlFMS : urlFMS.replace(/rtmp/g, "rtmpt");
			nc.connect(url);
		}
		
		
		protected function netStatus(e:NetStatusEvent):void 
		{
			switch (e.info.code)
			{
				case 'NetConnection.Connect.Success':
					//clearTimeout(itvConnectRtmpt);
					createStream();
					linkVideo();
					if (startAfterConnect)
						play();
					dispatchEvent(new VideoEvent(VideoEvent.CONNECT));
				break;
				default:
					trace('FMSVideo : no NetConnection');
				break;
			}
		}
		
	}
	
}