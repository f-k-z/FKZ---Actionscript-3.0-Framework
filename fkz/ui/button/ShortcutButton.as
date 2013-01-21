package fkz.ui.button 
{
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Francois.Gillet/Soleil Noir
	 */
	public class ShortcutButton extends Button
	{
		
		private var _overFunction		:Function;
		private var _outFunction		:Function;
		private var _clickFunction		:Function;
		
		public function ShortcutButton() 
		{
			super();
		}
		
		public function set overFunction(funct:Function):void
		{
			_overFunction = funct;
		}
		
		public function set outFunction(funct:Function):void
		{
			_outFunction = funct;
		}
		
		public function set clickFunction(funct:Function):void
		{
			_clickFunction = funct;
		}
		
		public function get outFunction():Function { return _outFunction; }
		public function get overFunction():Function { return _overFunction; }
		public function get clickFunction():Function { return _clickFunction; }
		
		public override function mouseOver(e:MouseEvent = null):void 
		{
			if(_overFunction != null)
				_overFunction(e);
			super.mouseOver(e);
		}
		
		public override function mouseOut(e:MouseEvent = null):void 
		{
			if(_outFunction != null)
				_outFunction(e);
			super.mouseOut(e);
		}
		
		public override function mouseClick(e:MouseEvent = null):void 
		{
			if(_clickFunction != null)
				_clickFunction(e);
			super.mouseClick(e);
		}
		
	}
	
}