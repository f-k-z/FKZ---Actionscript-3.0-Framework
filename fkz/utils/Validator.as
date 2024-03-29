﻿package fkz.utils 
{
	
	/**
	 * Utils function for validate
	 * @author Francois.Gillet/Soleil Noir
	 */
	public class Validator 
	{
		
		public static function validateEmail(str:String):Boolean 
		{
            var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
            var result:Object = pattern.exec(str);
            if(result == null) {
                return false;
            }
            return true;
        }
		
	}
	
}