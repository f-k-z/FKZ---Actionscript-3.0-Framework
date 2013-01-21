package fkz.ui.form 
{
	import base.ui.BaseUIElement;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fkz.ui.UIConst
	import flash.text.TextField;
	
	/**
	 * Radio Button 
	 * @author Francois.Gillet/Soleil Noir
	 */
	public class RadioButton extends BaseUIElement
	{
		public var tField			:TextField;
		
		private var _selected		:Boolean;
		private var _value			:String;
		
		public function RadioButton() 
		{
			super();
		}
		
		override protected function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override protected function onRemoved(e:Event):void 
		{
			super.onRemoved(e);
			
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(b:Boolean):void
		{
			_selected = b;
			switchCheck();
		}
		
		public function get value():String
		{
			return _value;
		}
		public function set value(s:String):void
		{
			_value = s;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			_selected = (_selected) ? false : true;
			switchCheck();
			dispatchChange();
		}
		
		private function dispatchChange():void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function switchCheck():void
		{
			/*
			if (_selected)
			{
				gotoAndPlay(UIConst.ON_LABEL);
			}
			else if(currentLabel == UIConst.ON_LABEL)
			{
				gotoAndPlay(UIConst.OFF_LABEL);
			}
			*/
			gotoAndPlay(_selected ? UIConst.ON_LABEL : UIConst.OFF_LABEL);
		}
		
		public function setErrorState():void
		{
			gotoAndPlay(UIConst.ERROR_LABEL);
		}
		
	}
	
}