package fkz.ui.button 
{
	import flash.events.MouseEvent;
	import fkz.ui.UIConst;
	
	/**
	 * MovieClip Button with 'over' and 'out' labels
	 * @author Francois.Gillet/Soleil Noir
	 */
	public class AnimatedButton extends Button
	{
		
		public function AnimatedButton() 
		{
			super();
		}
		
		public override function mouseOver(e:MouseEvent = null):void 
		{
			if (currentLabel != UIConst.OVER_LABEL)
			{
				gotoAndPlay(UIConst.OVER_LABEL);
				super.mouseOver(e);
			}
		}
		
		public override function mouseOut(e:MouseEvent = null):void 
		{
			if (currentLabel != UIConst.OUT_LABEL)
			{
				gotoAndPlay(UIConst.OUT_LABEL);
				super.mouseOut(e);
			}
		}
		
	}
	
}