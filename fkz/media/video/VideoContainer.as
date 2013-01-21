package fkz.media.video
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	
	import fkz.events.VideoEvent;
	
	/**
	 * Common Video container : manage FLV stream
	 * @author Francois.Gillet
	 */
	public class VideoContainer extends Sprite
	{
		
		public var video				:Video;
		public var preloaded			:Boolean;
		public var buffering			:Boolean;
		public var loopMode				:Boolean;
		public var metadata				:Object; //contains metadata propreties
		public var path					:String;
		
		private var _volume				:Number;
		
		protected var seekFlag			:Boolean;
		protected var inited			:Boolean;
		protected var preloadProcess	:Boolean;
		protected var bufferTime		:Number;
		
		protected var nc				:NetConnection;
		public var ns				:NetStream;
		
		public function VideoContainer(path:String, bufferTime:Number = 1, loopMode:Boolean = false):void
		{
			this.bufferTime = bufferTime;
			this.loopMode = loopMode;
			this.path = path;
			soundTransform = new SoundTransform(1);
			nc = new NetConnection();
			nc.client = this;
			createVideo();
			connect();
			_volume = 1;
		}
		
		public function connect():void
		{
			nc.connect(null);
			createStream();
			linkVideo();
		}
		
		public function enableCheckStreamTime():void
		{
			addEventListener(Event.ENTER_FRAME, oefCheckStreamTime);
		}
		
		public function disableCheckStreamTime():void
		{
			removeEventListener(Event.ENTER_FRAME, oefCheckStreamTime);
		}
		
		public function get time():Number
		{
			return ns.time;
		}
		
		public function get loadedPercent():Number
		{
			return ns.bytesLoaded / ns.bytesTotal;
		}
		
		public function set volume(n:Number):void
		{
			_volume = n;
			if (!ns) return;
			if (Capabilities.hasAudio)
				ns.soundTransform = new SoundTransform(n);
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set smoothing(b:Boolean):void
		{
			video.smoothing = b;
		}
		
		public function get smoothing():Boolean
		{
			return video.smoothing;
		}
		
		public function get durationPercent():Number
		{
			return  ns.time / metadata.duration;
		}
		
		public function set durationPercent(percent:Number):void
		{
			if (percent > 1 || percent < 0) return;
			ns.seek(metadata.duration * percent);
		}
		
		public function seek(n:Number):void
		{
			ns.seek(n);
		}
		
		public function pause():void
		{
			ns.pause();
		}
		
		public function resume():void
		{
			ns.resume();
		}
		
		public function close():void
		{
			if(ns)
				ns.close();
		}
		
		public function play():void
		{
			if (preloadProcess)
				trace("VideoContainer : use playAfterPreload() after preloadStream");
			else
			{
				ns.play(path);
			}
		}
		
		public function playAfterPreload():void
		{
			ns.resume();
			preloadProcess = false;
			addEventListener(Event.ENTER_FRAME, oefCheckStreamTime);
		}
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, oefCheckFirstFrame);
			removeEventListener(Event.ENTER_FRAME, oefCheckStreamTime);
			ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		}
		
		protected function createStream():void
		{
			ns = new NetStream(nc);
			ns.client = this;
			ns.bufferTime = bufferTime;
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		}
		
		protected function createVideo():void
		{
			if (video != null) return;
			video = new Video();
			addChild(video);
		}
		
		protected function linkVideo():void
		{
			video.attachNetStream(ns);
		}
		
		public function preloadStream(bufferLoaded:Number):void
		{
			preloadProcess = true;
			ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			ns.soundTransform = new SoundTransform(0);
			ns.bufferTime = bufferLoaded;
			ns.play(path);
			onBuffer(true);
			addEventListener(Event.ENTER_FRAME, oefCheckFirstFrame);
		}
		
		protected function oefCheckFirstFrame(e:Event):void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, Math.min(ns.bufferLength, ns.bufferTime), ns.bufferTime));
			if (ns.time > 0)
			{
				preloaded = true;
				ns.bufferTime = bufferTime;
				ns.pause();
				ns.seek(0);
				ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				removeEventListener(Event.ENTER_FRAME, oefCheckFirstFrame);
				ns.soundTransform = new SoundTransform(_volume);
			}
		}
		
		protected function oefCheckStreamTime(e:Event = null):void
		{
			if (ns.bufferTime == ns.bufferLength)
				ns.bufferTime = 2;
			else
				ns.bufferTime = 1;
				
				
			
			//dispatchEvent(new VideoEvent("progress", {time:ns.time}));
			dispatchEvent(new VideoEvent(VideoEvent.PROGRESS, {time:ns.time}));
			if (Math.round(ns.time*10) >= (metadata.duration*10) - 1)
			{
				if (!loopMode)
				{
					
					//dispatchEvent(new VideoEvent("end"));
					dispatchEvent(new VideoEvent(VideoEvent.END));
				}
				else
				{
					ns.seek(0);
				}
			}
		}
		
		//buffer
		protected function netStatusHandler(event:NetStatusEvent):void 
		{
            switch (event.info.code) 
			{
                case "NetStream.Play.StreamNotFound":
                    trace("VideoContainer : Unable to locate video: ");
                break;
				case "NetStream.Play.Start":
					onBuffer(false);
                break;
				case "NetStream.Play.Stop":
					onBuffer(false);
                break;
				case 'NetStream.Buffer.Empty':
					onBuffer(true);
				break;
				case 'NetStream.Buffer.Full':
					onBuffer(false);
				break;
				case 'NetStream.Seek.Notify':
					if (preloaded && !seekFlag)
					{
						seekFlag = true;
						
						
						//dispatchEvent(new VideoEvent("preloaded"));
						dispatchEvent(new VideoEvent(VideoEvent.PRELOADED));
					}
					
					//dispatchEvent(new VideoEvent("seek"));
					dispatchEvent(new VideoEvent(VideoEvent.SEEK));
				break;
            }
        }
        
		protected function asyncErrorHandler(event:AsyncErrorEvent):void 
		{
            trace("VIDEO CONTAINER - asyncError : " + event);
        }
		
		protected function onBuffer(b:Boolean):void
		{
			buffering = b;
			
			
			//dispatchEvent(new VideoEvent("buffering", {buffering:buffering}));
			dispatchEvent(new VideoEvent(VideoEvent.BUFFERING, {buffering:buffering}));
		}
		
		public function onMetaData(meta:Object):void
		{
			if (!inited)
			{
				inited = true;
				metadata = meta;
				video.width = metadata.width;
				video.height = metadata.height;
				if (!preloadProcess)
					addEventListener(Event.ENTER_FRAME, oefCheckStreamTime);
					
				//dispatchEvent(new VideoEvent("ready", meta));
				dispatchEvent(new VideoEvent(VideoEvent.READY, meta));
			}
			else
			{
				if (meta.cuePoints && metadata.cuePoints == null){
					metadata.cuePoints = meta.cuePoints;
					trace('meta.cuePoints');
				}
			}
		}
		
		public function onXMPData(meta:Object):void { onMetaData(meta);  }
		public function onBWDone(...args):void{}
		public function onPlayStatus(...args):void{}
		
		public function onCuePoint(cuepoint:Object):void
		{
			
			//dispatchEvent(new VideoEvent("cuepoint", cuepoint));
			dispatchEvent(new VideoEvent(VideoEvent.CUEPOINT, cuepoint));
		}
		
	}
	
}