package fkz.utils 
{
	/**
	 * ...
	 * @author F.Gillet/La Fabrik
	 */
	public class DateDiff 
	{
		/**
		dateDiff(datePart:String, date1:Date, date2:Date):Number<BR>
		returns the difference between 2 dates<BR>
		valid dateParts:<BR>
		s: Seconds<BR>
		n: Minutes<BR>
		h: Hours<BR>
		d: Days<BR>
		m: Months<BR>
		y: Years<BR>
		*/
		
		public static function dateDiff(datePart:String, date1:Date, date2:Date):Number
		{
			return getDatePartHashMap()[datePart.toLowerCase()](date1,date2);
		}
		
		public static function fullDateDiff(date1:Date, date2:Date):Object
		{
			var diffDays:Number = dateDiff('d', date1, date2);
			var diffHours:Number = dateDiff('h', date1, date2) - diffDays * 24;
			var diffMinutes:Number = dateDiff('n', date1, date2) - ((diffDays * 24) * 60) - (diffHours * 60);
			var diffSeconds:Number = dateDiff('s', date1, date2) - ((diffDays * 24) * 60 * 60) - (diffHours * 60 * 60) - diffMinutes * 60;
			return { days:diffDays, hours:diffHours, minutes:diffMinutes, seconds:diffSeconds };
		}
		
		private static function getDatePartHashMap():Object
		{
			var dpHashMap:Object = new Object();
			dpHashMap["s"] = getSeconds;
			dpHashMap["n"] = getMinutes;
			dpHashMap["h"] = getHours;
			dpHashMap["d"] = getDays;
			dpHashMap["m"] = getMonths;
			dpHashMap["y"] = getYears;
			return dpHashMap;
		}
		
		private static function compareDates(date1:Date, date2:Date):Number
		{
			return Math.max(0 , date1.getTime() - date2.getTime());
		}
		
		private static function getSeconds(date1:Date, date2:Date):Number
		{
			return Math.floor(compareDates(date1,date2)/1000);
		}
		
		private static function getMinutes(date1:Date, date2:Date):Number
		{
			return Math.floor(getSeconds(date1,date2)/60);
		}
		
		private static function getHours(date1:Date, date2:Date):Number
		{
			return Math.floor(getMinutes(date1,date2)/60);
		}
		
		private static function getDays(date1:Date, date2:Date):Number
		{
			return Math.floor(getHours(date1,date2)/24);
		}
		
		private static function getMonths(date1:Date, date2:Date):Number
		{
			var yearDiff:Number = getYears(date1,date2);
			var monthDiff:Number = date1.getMonth() - date2.getMonth();
			if(monthDiff < 0)
				monthDiff += 12;
			if(date1.getDate()< date2.getDate())
				monthDiff -=1;
			return 12 *yearDiff + monthDiff;
		}
		
		private static function getYears(date1:Date,date2:Date):Number{
			return Math.floor(getDays(date1,date2)/365);
		}
		
	}

}