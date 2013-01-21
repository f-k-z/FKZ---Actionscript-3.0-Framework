package fkz.ui.form 
{
	/**
	 * Combo box
	 * @author Vincent Fréman/Soleil Noir
	 */
	
	import fkz.events.DataEvent;
	import fkz.ui.button.Button;
	import fkz.ui.SimpleScroll;
	import fkz.ui.UIConst;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public dynamic class ComboBox extends MovieClip implements IForm
	{	
		////////////////////////////////////////
		/////////////// DECLARATIONS
		
		public static const OPEN	:String = 'ComboBox_open';
		public static const CLOSE	:String = 'ComboBox_close';
		
		public var className		:String = 'ComboBox';
		
		public var select_mc		:MovieClip;
		public var scroll_mc		:MovieClip;
		public var masque			:MovieClip;
		public var item_mc			:ComboBoxItem;
		public var opened			:Boolean = false;
		public var visibleItemsNb	:int;
		public var values			:Array;
		public var items_mc			:MovieClip = new MovieClip();
		
		private var _this			:ComboBox;
		private var _defaultValue	:String;
		private var _selected_value	:String;
		private var _select_txt		:TextField;
		
		private var _scroll			:SimpleScroll;
		private var _scroll_active	:Boolean;
		private var _enabled		:Boolean = true;
		
		protected var minScrollSize	: Number = 1;
		
		////////////////////////////////////////
		/////////////// PUBLIC
		
		////// GETTER & SETTER
		
		public function set value(s:String):void {
			_select_txt.text = _defaultValue;
			_selected_value = '';
			
			foreachChildOf(items_mc, function(child) 
			{
				if (/ComboBoxItem/g.test(child.name) == false)	return;
				
				var _item:ComboBoxItem = child as ComboBoxItem;
				if (_item.value == s) {
					_item.selected = true;
					_select_txt.text = _item.label;
					_selected_value = _item.value;
					return;
				}
			});
		}
		
		public function get value():String { 
			return _selected_value;
		}
		
		public function get isEmpty():Boolean {
			return (value == '') ? true : false; 
		}
		
		public function get defaultValue():String { return _defaultValue; }
		public function set defaultValue(value:String):void {
			_select_txt.text = _defaultValue = value;
		}
		
		public override function get enabled():Boolean { return _enabled; }
		public override function set enabled(value:Boolean):void 
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
			if(!_enabled) closeItems();
		}
		
		public function get scroll_active():Boolean { return _scroll_active; }
		
		////// CONSTRUCTOR
		
		public function ComboBox()
		{
			_select_txt = select_mc.select_item_mc.select_txt;
		}
		
		////// METHODS
		
		public function init(pValues:Array, pDefaultValue:String = 'Select a value', pVisibleItemsNb:int = 4)
		{
			////////// PARAMS
			
			values = pValues;
			defaultValue = pDefaultValue;
			visibleItemsNb = pVisibleItemsNb;
			value = '';
			_scroll_active = (pVisibleItemsNb < values.length - 1) ? true : false;
			
			////////// INIT
			
			scroll_mc.visible = false;
			items_mc.visible = false;
			select_mc.select_item_mc.mouseChildren = false;
			
			if(contains(item_mc))
				removeChild(item_mc);
			if (masque)
				removeChild(masque);
			while (items_mc.numChildren)
				items_mc.removeChildAt(0);
			if(contains(items_mc))
				removeChild(items_mc);
			
			////////// ITEMS
			
			var ComboBoxItem_mc:Class = Object(item_mc).constructor;
			var _item:ComboBoxItem;
			for (var i:int = 0; i < values.length; i++)
			{
				_item = new ComboBoxItem_mc();
				if(_item.zone_mc)
					_item.y = i * int(_item.zone_mc.height);
				else
					_item.y = i * int(_item.height);
				_item.name = 'ComboBoxItem' + i;
				_item.init(values[i]);
				_item.item_txt.width = item_mc.item_txt.width;
				_item.addEventListener(Button.CLICK, onItemClick);
				items_mc.addChild(_item);
				
				onItemInit(_item);
			}
			
			////////// EVENTS
			
			select_mc.addEventListener(MouseEvent.MOUSE_DOWN, onSelectDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onFocusOut);
			
			////////// MASQUE
			
			masque = new MovieClip();
			masque.graphics.beginFill(0x00FF00, 0.4);
			masque.graphics.drawRect(0, 0, select_mc.select_item_mc.fond_mc.width, pVisibleItemsNb * item_mc.zone_mc.height);
			masque.graphics.endFill();
			
			if (_item.zone_mc)
			{
				items_mc.zone_mc = new MovieClip();
				items_mc.zone_mc.mouseEnabled = false;
				items_mc.zone_mc.alpha = 0;
				items_mc.zone_mc.graphics.beginFill(0x00FF00, 0.4);
				items_mc.zone_mc.graphics.drawRect(0, 0, item_mc.zone_mc.width, values.length * item_mc.zone_mc.height);
				items_mc.zone_mc.graphics.endFill();
				items_mc.addChild(items_mc.zone_mc);
			}
			
			////////// POSITION on Z
			
			addChild(items_mc);
			swapChildren(items_mc, select_mc);
			addChild(scroll_mc);
			addChild(masque);
			
			////////// POSITION on X & Y
			
			onScrollInit();
			
			////////// SCROLL
			
			var scroll_value:Number = (scroll_mc.bg.height - scroll_mc.btn.height) / (items_mc.numChildren - 1);
			
			_scroll = new SimpleScroll(scroll_mc.btn, items_mc, masque, true, scroll_mc.bg.height - scroll_mc.btn.height, scroll_value);
			_scroll.enabled = false;
		}
		
		public function openItems(e:Event = null):void
		{
			if (enabled)
			{
				items_mc.visible = true;
				scroll_mc.visible = _scroll_active;
				_scroll.enabled = opened = true;
				
				_scroll.reset();
				_scroll.refresh();
				
				select_mc.select_item_mc.gotoAndPlay('over');
				
				dispatchEvent(new Event(ComboBox.OPEN));
			}
		}
		
		public function closeItems(e:Event = null):void
		{
			scroll_mc.visible = items_mc.visible = false;
			_scroll.enabled = opened = false;
			_scroll.refresh();
			
			if(select_mc.select_item_mc.currentLabel == null || select_mc.select_item_mc.currentLabel == 'over')
				select_mc.select_item_mc.gotoAndPlay('out');
			
			dispatchEvent(new Event(ComboBox.CLOSE));
		}
		
		public function setErrorState():void
		{
			select_mc.select_item_mc.gotoAndPlay(UIConst.ERROR_LABEL);
		}
		
		public function foreachChildOf(pContainer:MovieClip, pFunc:Function):void
		{
			for (var i:int = 0; i < pContainer.numChildren; i++)
			{
				pFunc(pContainer.getChildAt(i));
			}
		}
		
		public function onItemInit(pItem:ComboBoxItem):void { }
		
		public function onScrollInit():void 
		{	
			scroll_mc.x = item_mc.zone_mc.width - scroll_mc.width;
			scroll_mc.bg.height = masque.height;
			masque.y = scroll_mc.y = items_mc.y = (select_mc.select_item_mc.zone_mc) ? select_mc.select_item_mc.zone_mc.height : select_mc.select_item_mc.height;
			scroll_mc.btn.y = 0;
			scroll_mc.btn.height = Math.max( minScrollSize, Math.floor(visibleItemsNb / items_mc.numChildren * scroll_mc.bg.height) );
		}
		
		////////////////////////////////////////
		/////////////// PRIVATE METHODS
		
		////////// EVENTS
		
		private function onFocusOut(e:MouseEvent):void 
		{
			if(!stage) return;
			if(!_scroll.spMask.hitTestPoint(stage.mouseX, stage.mouseY) && !select_mc.select_item_mc.fond_mc.hitTestPoint(stage.mouseX, stage.mouseY))
				closeItems();
		}
		
		private function onItemClick(e:Event):void 
		{
			var item:ComboBoxItem = e.currentTarget as ComboBoxItem;
			value = item.value;
			closeItems();
			
			foreachChildOf(items_mc, function(child) 
			{
				if (/ComboBoxItem/g.test(child.name) == false)	return;
				
				var _item:ComboBoxItem = child as ComboBoxItem;
				if (_item != item) _item.selected = false;
			});
		}
		
		private function onSelectDown(e:MouseEvent):void 
		{
			trace(" !!" );
			if (items_mc.visible)
				closeItems();
			else
				openItems();
		}
		
	}
	
}