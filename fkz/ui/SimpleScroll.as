/**
 * @author François Gillet/FKZ
 * @agence Soleil Noir
 * @date 2008/07/01
 * @description scroll content with or without easing
 */
 
 package fkz.ui
 {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import com.earthbrowser.ebutils.MacMouseWheelHandler;
	
	public class SimpleScroll {
		
		public var enabled:Boolean = true;
		public var spMask:Sprite;
		
		private var stage:Stage;
		private var mcMain:MovieClip;
		private var mcScroll:MovieClip;
		private var mcContainer:MovieClip; 
		private var mcTop:MovieClip;
		private var mcDown:MovieClip;
		private var crtMcDownTop:MovieClip;
		
		private var bEasing:Boolean;
		private var nMaxY:Number;
		private var nbIn:Number;
		private var nbOut:Number;
		private var nLimite:Number;
		private var nInc:Number;
		private var nLgScroll:Number;
		private var nKeyValue:Number;
		private var rectLimit:Rectangle;
		
		private var twScroll:Tween;
		
		/** CONSTRUCT
		*	- mc_scroll : mc for scroll
		* 	- mc_container : mc to scroll
		* 	- mc_mask : mc mask
		* 	- easing : true or false
		* 	- lgScroll : length of the scrollBar, position top of the scroll is his _y and of his bottom is his _y+lgScroll
		* 	- keyValue : value incremented on key down
		*/
		
		public function SimpleScroll(mc_scroll:MovieClip, mc_container:MovieClip, mc_mask:MovieClip, easing:Boolean, lgScroll:Number, keyValue:Number = 0):void
		{
			mcScroll = mc_scroll;
			mcContainer = mc_container; 
			mcMain = mcContainer.parent as MovieClip;
			spMask = mc_mask as Sprite;
			bEasing = easing;
			nLgScroll = lgScroll;
			nKeyValue = keyValue;
			stage = mcMain.stage;
			_init();
			mcContainer.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			if (nKeyValue > 0)	stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyAction);
			
			MacMouseWheelHandler.init( stage );
		}
		
		public function set lgScroll(i:int):void
		{
			nLgScroll = i;
			reset();
			calculateParams();
			refresh();
		}
		
		public function get lgScroll():int
		{
			return nLgScroll;
		}
		
		public function reset():void
		{
			mcContainer.y = nLimite;
			mcScroll.y = nbIn;
		}
		
		private function removedFromStage(e:Event):void 
		{
			mcContainer.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyAction);
			
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelScroll);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragScroll);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopUpDownScroll);
			
			mcMain.removeEventListener(Event.ENTER_FRAME, displaceContent);
			mcMain.removeEventListener(Event.ENTER_FRAME, upDownInc);
			
			if(mcTop)		mcTop.removeEventListener(MouseEvent.MOUSE_DOWN, upDownScroll);
			if(mcDown)		mcDown.removeEventListener(MouseEvent.MOUSE_DOWN, upDownScroll);
			if (mcScroll)	mcScroll.removeEventListener(MouseEvent.MOUSE_DOWN, dragScroll);
		}
		
		public function set mouseWheel(b:Boolean):void
		{
			if (b)
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelScroll);
			else
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelScroll);
		}
		
		private function onKeyAction(e:KeyboardEvent):void 
		{
			if (enabled) {
				if (e.keyCode == 38) { // UP
					createTween();
					incScroll(nKeyValue);
				}else if (e.keyCode == 40) { // DOWN
					createTween();
					incScroll(-nKeyValue);
				}
			}
		}
		
		/** INIT **/
		
		private function _init():void
		{
			refresh();
			setMask();
			calculateParams();
			initScroll();
		}
		
		
		/** METHODS
		*/
		
		/** PUBLIC **/
		
		/**
		* @usage refresh the scroll (when the height of the container or the mask are changing)  
		*/
		public function refresh():void
		{
			var cHeight = (mcContainer.zone_mc) ? mcContainer.zone_mc.height : mcContainer.height;
			nMaxY = Math.max(0, (cHeight - spMask.height));
		}
		
		/**
		* @usage set scroll button : top & down
		*  - mc_top : mc to scroll up
		*  - mc_down : mc to scroll down	
		*  - incValue : incrementation value
		*/
		public function setBtScroll(mc_top:MovieClip, mc_down:MovieClip, incValue:Number)
		{
			mcTop = mc_top;
			mcDown = mc_down;
			nInc = incValue;
			initBtScroll();
		}
		
		/** PRIVATE **/
		private function setMask():void
		{
			//spMask.cacheAsBitmap = true;
			//mcContainer.cacheAsBitmap = true;
			mcContainer.mask = spMask;
		}
		
		private function calculateParams():void
		{
			nLimite = mcContainer.y;
			nbIn = mcScroll.y;
			nbOut =  mcScroll.y+nLgScroll;
			rectLimit = new Rectangle(mcScroll.x, nbIn, 0, nLgScroll);
		}
		
		private function initScroll():void
		{
			mcScroll.addEventListener(MouseEvent.MOUSE_DOWN, dragScroll);
			mcScroll.buttonMode = mcScroll.useHandCursor = true;
			mouseWheel = true;
		}
		
		private function initBtScroll():void 
		{
			mcTop.buttonMode = mcDown.buttonMode = true;
			mcTop.addEventListener(MouseEvent.MOUSE_DOWN, upDownScroll);
			mcDown.addEventListener(MouseEvent.MOUSE_DOWN, upDownScroll);
		}
		
		private function dragScroll(event:MouseEvent):void
		{
			event.target.startDrag(false, rectLimit);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragScroll);
			createTween();
			mcMain.addEventListener(Event.ENTER_FRAME, displaceContent);
		}
		
		private function upDownScroll(event:MouseEvent):void
		{
			crtMcDownTop = event.target as MovieClip;
			createTween();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopUpDownScroll);
			trace(crtMcDownTop.name);
			mcMain.addEventListener(Event.ENTER_FRAME, upDownInc);
		}
		
		private function upDownInc(event:Event)
		{
			var value:Number = (crtMcDownTop == mcTop) ? nInc : -nInc;
			//trace("gn "+value + " | " + (crtMcDownTop == mcTop));
			incScroll((nKeyValue) ? nKeyValue : value, event);
		}
		
		private function stopUpDownScroll(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopUpDownScroll);
			mcMain.removeEventListener(Event.ENTER_FRAME, upDownInc);
		}
		
		private function wheelScroll(event:MouseEvent)
		{
			createTween();
			incScroll((nKeyValue) ? nKeyValue * event.delta : event.delta, event);
		}
		
		public function incScroll(value:Number, event:Event = null):void 
		{
			mcScroll.y = Math.max(nbIn, Math.min(nbOut, mcScroll.y+(-value)));
			displaceContent(event);
		}
		
		private function createTween()
		{
			twScroll = new Tween(mcContainer, "y", Strong.easeOut, mcContainer.y, mcContainer.y, 0, true);
		}
		
		private function stopDragScroll(event:MouseEvent):void
		{
			mcScroll.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragScroll);
			mcMain.removeEventListener(Event.ENTER_FRAME, displaceContent);
		}
		
		private function displaceContent(event:Event = null):void
		{
			var posiScroll:Number = mcScroll.y;
			var pourc:Number = 100-Math.round((posiScroll-nbOut)/(nbIn-nbOut)*100);
			var nextY:Number = Math.round(nLimite - (nMaxY * (pourc / 100)));
			if(bEasing)
			{
				twScroll.continueTo(nextY, 0.6);
			}
			else
				mcContainer.y = nextY;
		}
		
	}
 }