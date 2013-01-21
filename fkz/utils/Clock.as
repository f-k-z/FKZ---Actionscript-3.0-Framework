package fkz.utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	/**
	 * ...
	 * @author F.Gillet/La Fabrik
	 */
	public class Clock extends EventDispatcher
	{
		static public const TIME_CHANGE:String = "timeChange";
		
		private var startDate:Date;
		
		private var _date:Date;
		private var itvClock:uint;
		
		public function Clock(startDate:Date) 
		{
			this.startDate = _date = startDate;
			itvClock = setInterval(updateClock, 1000);
		}
		
		private function destroy():void 
		{
			clearInterval(itvClock);
		}
		
		private function updateClock():void 
		{
			_date = addSeconds(_date, 1);
			dispatchEvent(new Event(TIME_CHANGE));
		}
		
		public function get date():Date { return _date; }
		
		public static function addWeeks(date:Date, weeks:Number):Date 
		{
			return addDays(date, weeks*7);
		}

		public static function addDays(date:Date, days:Number):Date 
		{
			return addHours(date, days*24);
		}

		public static function addHours(date:Date, hrs:Number):Date 
		{
			return addMinutes(date, hrs*60);
		}

		public static function addMinutes(date:Date, mins:Number):Date 
		{
			return addSeconds(date, mins*60);
		}

		public static function addSeconds(date:Date, secs:Number):Date 
		{
			var mSecs:Number = secs * 1000;
			var sum:Number = mSecs + date.getTime();
			return new Date(sum);
		}
		
	}

}