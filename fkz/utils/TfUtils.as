package fkz.utils 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * textfields utils
	 * @author Francois.Gillet/Soleil Noir
	 */
	public class TfUtils
	{
		
		public static const LEFT:String = "left";
		public static const TOP_LEFT:String = "top_left";
		public static const RIGHT:String = "right";
		public static const CENTER:String= "center";
		
		public static function setResizableTf(t:TextField, alignStyle:String):void
		{
			switch(alignStyle)
			{
				case LEFT:
					t.autoSize = TextFieldAutoSize.LEFT;
					t.wordWrap = false;
				break;
				case TOP_LEFT:
					t.autoSize = TextFieldAutoSize.LEFT;
					t.wordWrap = true;
				break;
				case RIGHT:
					t.autoSize = TextFieldAutoSize.RIGHT;
					t.wordWrap = false;
				break;
				case CENTER:
					t.autoSize = TextFieldAutoSize.CENTER;
					t.wordWrap = false;
				break;
				default :
					trace("TextField Utils >> : "+alignStyle+" align style is not register");
				break;
			}
		}
		
	}

}