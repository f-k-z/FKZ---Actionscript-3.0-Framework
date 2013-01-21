package fkz.load 
{
	
	/**
	 * Document Class : Load main fla with frame system
	 * @author Francois.Gillet
	 */
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.system.Capabilities;
	
	public class CommonInit extends MovieClip
	{
		
		public static var instance		: CommonInit;
		public static var debugMode		: Boolean;
		public static var flashvars		: Object = { };
		
		public var flashvarsStructure	: Array;
		public var preloader			: MovieClip;
		public var percentLoad			: Number;
		public var closed				: Boolean;
		public var configXML			: XML;
		public var configLoader			: URLLoader;
		
		protected var myMenu			: ContextMenu;
		
		public function CommonInit():void
		{
			stop();
			instance = this;
			debugMode = (Capabilities.playerType == 'External');
			initDefaultFlashVars();
			initMenu();
			percentLoad = 0;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function initDefaultFlashVars():void 
		{
			flashvarsStructure = [{name:'basepath', defaultValue:''}];
		}
		
		protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stop();
			getFlashvars();
			loadXMLConfig()
			initLoader();
			initStage();
		}
		
		protected function getFlashvars():void
		{
			for (var i:int = 0; i < flashvarsStructure.length; i++) 
			{
				var item:Object = flashvarsStructure[i];
				flashvars[item.name] = loaderInfo.parameters[item.name]
				if(!flashvars[item.name]) flashvars[item.name] =  item.defaultValue;
			}
		}
		
		protected function initMenu():void 
		{
			initContextMenu();
		}
		
		protected function loadXMLConfig():void
		{
			configLoader = new URLLoader(new URLRequest(flashvars.basepath+'xml/config.xml'));
			configLoader.addEventListener(Event.COMPLETE, startCheckClassesLoaded);
		}
		
		protected function startCheckClassesLoaded(e:Event = null):void 
		{
			configLoader.removeEventListener(Event.COMPLETE, startCheckClassesLoaded);
			configXML = XML(e.currentTarget.data);
			addEventListener(Event.ENTER_FRAME, checkClassesLoaded);
		}

		protected function checkClassesLoaded(e:Event):void
		{
			if(framesLoaded > currentLabels[1].frame)
			{
				removeEventListener(Event.ENTER_FRAME, checkClassesLoaded);
				onEndClassLoad();
			}
		}
		
		protected function onEndClassLoad():void 
		{
			gotoAndStop("load");
		}
		
		protected function initLoader():void
		{
			root.loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		}
		
		protected function onLoadComplete(e:Event):void 
		{
			removeLoaderListeners();
			percentLoad = 1;
		}
		
		protected function removeLoaderListeners():void
		{
			root.loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		}
		
		protected function onLoadProgress(e:ProgressEvent):void
		{
			percentLoad = (e.bytesLoaded / e.bytesTotal) * 1;
		}
		
		protected function initContextMenu(sBrand:String = "FKZ"):void
		{
			var date:Date = new Date();
			myMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("© " + sBrand + " " + date.getFullYear() + ".", false, false);
			myMenu.customItems.push(item);
			myMenu.hideBuiltInItems();
			contextMenu = myMenu;
		}
		
		protected function initStage():void
		{
			stage.stageFocusRect = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
		}
		
		public function gotoMain():void
		{
			gotoAndStop("main");
		}
	}
	
	
}