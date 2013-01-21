package fkz.ui.form 
{
	/**
	 * Combo box
	 * @author Vincent Fréman/Soleil Noir
	 */
	
	import fkz.ui.button.Button;
	import fkz.ui.button.AnimatedButton;
	import fkz.ui.UIConst;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public dynamic class ComboBoxItem extends AnimatedButton
	{
		////////////////////////////////////////
		/////////////// DECLARATIONS
		
		public var item_txt			:TextField;
		public var zone_mc			:MovieClip;
		
		private var _selected		:Boolean = false;
		private var _defaultText 	:String = '';
		
		private var _label			:String = '';
		private var _value			:String = '';
		
		////////////////////////////////////////
		/////////////// PUBLIC
		
		////// GETTER & SETTER
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void { 
			_selected = value;
			enabled = !selected;
			if (!selected) super.mouseOut();
		}
		
		public function get label():String { return _label; }
		
		public function get value():String { return _value; }
		public function set value(s:String):void { 
			_value = s; 
		}
		
		public function get isEmpty():Boolean {
			return (item_txt.text == '') ? true : false;
		}
		
		////// CONSTRUCTOR
		
		public function ComboBoxItem() 
		{
			mouseChildren = false;
		}
		
		////// METHODS
		
		public function init(pData:Object):void
		{
			if (!pData.label && !pData.value)
				return;
			item_txt.text = _label = pData.label;
			_value = pData.value;
			
			this.addEventListener(Button.CLICK, onClickAction);
		}
		
		private function onClickAction(e:Event):void 
		{
			selected = !selected;
		}
		
		public function setErrorState():void
		{
			gotoAndPlay(UIConst.ERROR_LABEL);
		}
		
	}
	
}