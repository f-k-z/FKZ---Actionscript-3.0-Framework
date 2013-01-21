package fkz.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	import caurina.transitions.Tweener;

	public class CircularLoader extends MovieClip
	{
		
		public var mLeft :Sprite;
		public var mRight :Sprite;
		public var tinyRight :Sprite;
		public var tinyLeft :Sprite;
		public var cLeft :Sprite;
		public var cRight :Sprite;
		
		private var _percentLoad :Number;
		
		public function CircularLoader() 
		{
			cLeft.mask = mLeft;
			cRight.mask = mRight;
			percentLoad = 0;
		}
		
		public function setColor(color:uint):void
		{
			var myColorLeft:ColorTransform = cLeft.transform.colorTransform;
			var myColorRight:ColorTransform = cRight.transform.colorTransform;
			myColorLeft.color = myColorRight.color = color;
			cLeft.transform.colorTransform = myColorLeft;
			cRight.transform.colorTransform = myColorRight;
		}
		
		public function set percentLoad(n:Number):void
		{
			_percentLoad = n;
			if(n <= 1)
			{
				if(n <= .5)
					tinyLeft.rotation = mRight.rotation = (n/.5) * 180;
				else
				{
					mRight.rotation = 180; 
					tinyLeft.rotation = mLeft.rotation = 180 + (((n - .5)/.5) * 180);
				}
			}
			else
			{
				var transitPercent:Number = percentLoad - 1;
				tinyRight.rotation = transitPercent * 360;
				if (transitPercent <= .5)
				{
					
					mRight.rotation = 180 + (transitPercent / .5) * 180;
				}
				else
				{
					mRight.rotation = 360; 
					mLeft.rotation = ((transitPercent - .5)/.5) * 180;
				}
			}
		}
		
		public function get percentLoad():Number { return _percentLoad; }
		
		public function close():void
		{
			Tweener.addTween(this, {percentLoad:2, time:.5, transition:"easeOutCubic", onComplete:dispatchClose});
		}
		
		private function dispatchClose():void 
		{
			mRight.rotation = 0;
			mLeft.rotation = 180;
			dispatchEvent(new Event(Event.CLOSE));
		}
		
	}

}