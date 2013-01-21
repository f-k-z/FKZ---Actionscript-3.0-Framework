package fkz.ui.button
{
	
	/**
	 * Common Button
	 * @author Francois.Gillet
	 */
	
	import fkz.ui.Zone;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fkz.events.DataEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.events.KeyboardEvent;
	
	public dynamic class Button extends MovieClip
	{
		public var button				:Sprite;
		protected var _data				:Object;
		
		public static const CLICK		:String = 'button_click';
		public static const OVER		:String = 'button_over';
		public static const OUT			:String = 'button_out';
		
		public var destroyOnRemove		:Boolean;
		
		protected var urlLink				:String;
		protected var targetLink			:String;
		protected var keyCode				:uint;
		protected var bKeyHandler			:Boolean;
		
		protected static var instances :Array = [];
		protected  var overAfterEnable :Boolean;
		
		public function Button()
		{
			overAfterEnable = true;
			destroyOnRemove = true;
			if (!getChildByName('button'))
			{
				button = this;
				mouseChildren = false;
			}
			//gotoAndStop(1);
			addListeners();
			button.buttonMode = true;
			instances.push(this);
			addDestroyListener();
		}
		
		public function get data():Object
		{
			if (!_data)
				_data = { };
			return _data;
		}
		
		public function removeDestroyListener():void
		{
			button.removeEventListener(Event.REMOVED_FROM_STAGE, destroyAfterRemove);
		}
		
		public function addDestroyListener():void
		{
			button.addEventListener(Event.REMOVED_FROM_STAGE, destroyAfterRemove);
		}
		
		public function set data(o:Object):void
		{
			_data = o;
		}
		
		public function setKeyHandler(keyCode:uint):void
		{
			if (!stage) return;
			bKeyHandler = true;
			this.keyCode = keyCode;
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		}
		
		protected function keyHandler(e:KeyboardEvent):void 
		{	
			if (e.keyCode == keyCode)
				mouseClick();
		}
		
		protected function destroyAfterRemove(e:Event):void 
		{
			button.removeEventListener(Event.REMOVED_FROM_STAGE, destroyAfterRemove);
			destroyListeners();
		}
		
		public function addListeners():void
		{
			button.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			button.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			button.addEventListener(MouseEvent.CLICK, mouseClick);
			if(bKeyHandler && stage)
				stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		}
		
		public function destroyListeners(e:Event = null):void
		{
			if (destroyOnRemove)
			{
				button.removeEventListener(MouseEvent.ROLL_OVER, mouseOver);
				button.removeEventListener(MouseEvent.ROLL_OUT, mouseOut);
				button.removeEventListener(MouseEvent.CLICK, mouseClick);
				if(bKeyHandler && stage)
					stage.removeEventListener(KeyboardEvent.KEY_UP, keyHandler);
			}
		}
		
		public override function set enabled(b:Boolean):void
		{
			var exButtonMode:Boolean = button.buttonMode;
			button.buttonMode = b;
			if (!b)
				destroyListeners();
			else
				addListeners();
			if (overAfterEnable)
			{
				//do over if the button was enabled and the mouse is on it and if the button is on stage
				if (exButtonMode == false && button.buttonMode == true && stage && currentFrame == 1)
				{
					if (button.hitTestPoint(stage.mouseX, stage.mouseY))
						this.mouseOver();
				}
			}
			super.enabled = b;
		}
		
		public function addLink(url:String, target:String = "_blank"):void
		{
			urlLink = url;
			targetLink = target;
			button.addEventListener(MouseEvent.CLICK, gotoUrl);
		}
		
		private function gotoUrl(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest(urlLink), targetLink);
		}
		
		public function mouseOver(e:MouseEvent = null):void
		{
			dispatchEvent(new DataEvent(OVER, data));
		}
		
		public function mouseOut(e:MouseEvent = null):void
		{
			dispatchEvent(new DataEvent(OUT, data));
		}
		
		public function mouseClick(e:MouseEvent = null):void 
		{
			dispatchEvent(new DataEvent(CLICK, data));
		}
		
		public static function set enabled(val:Boolean):void
		{
			for each(var bt:Button in instances){
				bt.enabled = val;
				if (val)
					bt.addListeners();
				else
					bt.destroyListeners();
			}
		}
	}
}
