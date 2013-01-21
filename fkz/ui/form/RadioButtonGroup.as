package fkz.ui.form
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Radio Button Group
	 * @author Francois.Gillet/Soleil Noir
	 */
	
	public class RadioButtonGroup extends EventDispatcher implements IForm
	{
		
		private var _value		:String;
		
		private var items		:Array; //contains Array with {bt:RadioButton, value:"value"}
		private var aBt			:Array;
		private var aValue		:Array;
		
		public function RadioButtonGroup(items:Array):void
		{
			aBt = [];
			aValue = [];
			this.items = items;
			for (var i:int = 0; i < items.length; i++) 
			{
				var bt:RadioButton = RadioButton(items[i].bt);
				aValue.push(items[i].value);
				bt.value = items[i].value;
				bt.selected = (items[i].bt.selected) ? true : false;
				aBt.push(bt);
				bt.addEventListener(Event.CHANGE, onChangeBt);
			}
		}
		
		/**
		 * Clear from memory
		 */
		public function dispose():void
		{
			var len:int = items.length;
			for (var i:int = 0; i < len; i++) 
			{
				var bt:RadioButton = items[i].bt;
				bt.removeEventListener(Event.CHANGE, onChangeBt);
			}
			
			aBt = [];
			aValue = [];
			items = [];
		}
		
		public function get value():String
		{
			return _value;
		}
		
		public function set value(s:String):void
		{
			if (aValue.indexOf(s) < 0) return;
			for (var i:int = 0; i < items.length; i++) 
			{
				if (items[i].value == s)
				{
					RadioButton(items[i].bt).selected = true;
					break;
				}
			}
			_value = s;
		}
		
		public function get isEmpty():Boolean
		{
			return (_value == null);
		}
		
		public function setErrorState():void
		{
			for (var i:int = 0; i < aBt.length; i++) 
				RadioButton(aBt[i]).setErrorState();
		}
		
		private function onChangeBt(e:Event):void 
		{
			var currentBt:RadioButton = RadioButton(e.currentTarget);
			
			if (currentBt.value != null && currentBt.selected)
			{
				value = currentBt.value;
				
				dispatchEvent(new Event(Event.CHANGE));
				
				for (var i:int = 0; i < aBt.length; i++) 
				{
					if(RadioButton(aBt[i]) != currentBt)
						RadioButton(aBt[i]).selected = false;
				}
			}
			else
				_value = null;
		}
		
	}
	
}