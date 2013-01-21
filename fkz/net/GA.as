package fkz.net 
{
	import com.google.analytics.GATracker;
	import flash.display.DisplayObject;
	/**
	 * Google Analytics Interface
	 * @author F.Gillet
	 */
	public class GA 
	{
		
		private var _ga 		:GATracker;
		private var inIDE		:Boolean;
		private var debugIDE:Boolean;
		
		public function GA(holder:DisplayObject, idAccount:String, visualDebug:Boolean = false, inIDE:Boolean = false, debugIDE:Boolean = false ) 
		{
			this.debugIDE = debugIDE;
			this.inIDE = inIDE;
			if(!inIDE)
				_ga = new GATracker( holder, idAccount, "Bridge", visualDebug );
		}
		
		public function trackPage(url:String):void
		{
			if(!inIDE)
				_ga.trackPageview(url);
			else if(debugIDE)
				trace('> Google Analytics : trackPage ' + url);
		}
		
		public function trackEvent(category:String, action:String):void
		{
			if(!inIDE)
				_ga.trackEvent(category, action );
			else if(debugIDE)
				trace('> Google Analytics : trackEvent ' + category, action);
		}
	}

}