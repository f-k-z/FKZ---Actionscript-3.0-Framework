package fkz.ui.form 
{
	/**
	 * Text Input
	 * @author Francois.Gillet/Soleil Noir
	 */
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.FocusEvent;
	import flash.events.Event;
	
	import fkz.ui.UIConst;
	
	public dynamic class TextInput extends MovieClip implements IForm
	{
		public var className		:String = 'TextInput';
		
		public var txt				:MovieClip;
		public var t				:TextField;
		
		public var tField			:TextField;
		
		private var bPassword		:Boolean;
		private var _defaultText 	:String;
		
		public function TextInput() 
		{
			tField = (txt) ? TextField(txt.getChildByName('t')) : t;
			tField.addEventListener(Event.CHANGE, onChange );
			tField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			tField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			//InitAltText.firefoxWmodeFix(tField);
			defaultText = "";
			gotoAndStop(1);
		}
		
		public function set value(s:String):void
		{
			tField.text = s;
		}
		
		public function reset():void
		{
			tField.text = _defaultText;
		}
		
		public function get value():String
		{
			return (tField.text == _defaultText) ? '' : tField.text;
		}
		
		public function set displayAsPassword(b:Boolean):void
		{
			bPassword = b;
		}
		
		public function get displayAsPassword():Boolean
		{
			return bPassword;
		}
		
		public function set maxChars(i:int):void
		{
			tField.maxChars = i;
		}
		
		public function get maxChars():int
		{
			return tField.maxChars;
		}
		
		public override function set tabIndex(i:int):void
		{
			tField.tabIndex = i;
		}
		
		public function set defaultText(s:String):void
		{
			_defaultText = s;
			tField.text = _defaultText;
		}
		
		public function get defaultText():String
		{
			return defaultText;
		}
		
		public override function set enabled(b:Boolean):void
		{
			tField.mouseEnabled = b;
		}
		
		public override function get enabled():Boolean
		{
			return tField.mouseEnabled;
		}
		
		public function get isEmpty():Boolean
		{
			return (tField.text == _defaultText || tField.text == "")
		}
		
		public function setErrorState():void
		{
			gotoAndPlay(UIConst.ERROR_LABEL);
		}
		
		public function removeErrorState():void
		{
			gotoAndPlay(UIConst.OVER_LABEL);
		}
		
		private function onChange(e:Event):void 
		{
			dispatchEvent(e);
		}
		
		protected function onFocusOut(e:FocusEvent):void 
		{
			gotoAndPlay(UIConst.OUT_LABEL);
			dispatchEvent(e);
			
			if (isEmpty)
			{
				if (bPassword)
					tField.displayAsPassword = false;
				tField.text = _defaultText;
			}
		}
		
		protected function onFocusIn(e:FocusEvent):void 
		{
			gotoAndPlay(UIConst.OVER_LABEL);
			dispatchEvent(e);
			
			if (tField.text == _defaultText)
				tField.text = "";
			tField.displayAsPassword = bPassword;
		}
		
	}
}