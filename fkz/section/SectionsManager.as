package fkz.section 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import caurina.transitions.Tweener;
	
	/**
	 * Manage sections
	 * @author Francois.Gillet
	 */
	public class SectionsManager extends MovieClip
	{
		
		public var mcBlock 				:Sprite;
		
		public var sectionName 			:String; 
		public var section 				:MovieClip; 
		public var sectionContainer 	:Sprite; 
		
		protected var suffixClass		:String;
		
		public function SectionsManager() 
		{
			suffixClass = "";
			if(mcBlock)
				initBlock();
		}
		
		public function get currentSectionName():String 
		{ 
			return sectionName; 
		}
		
		public function get currentSection():MovieClip 
		{ 
			return section; 
		}
		
		
		public function openSection(name:String):void
		{
			block();
			sectionName = name;
			if (section)
				closeCurrentSection();
			else
				continueOpening();
		}
		
		protected function closeCurrentSection():void
		{
			section.close();
			section.addEventListener(Event.CLOSE, continueOpening);
		}
		
		public function continueOpening(e:Event = null):void
		{
			if (section)
				disposeCurrentSection();
			dispatchEvent(new Event(Event.CHANGE));
			unblock();
			addCurrentSection();
		}
		
		protected function disposeCurrentSection():void 
		{
			section.removeEventListener(Event.CLOSE, continueOpening);
			sectionContainer.removeChild(section);
		}
		
		protected function addCurrentSection():void
		{
			var SectionClass:Class = getDefinitionByName(suffixClass+sectionName+'Section') as Class;
			section = new SectionClass();
			sectionContainer.addChild(section);
		}
		
		protected function initBlock():void
		{
			mcBlock.useHandCursor = false;
			mcBlock.addEventListener(MouseEvent.CLICK, doNothing);
			mcBlock.visible = false;
		}
		
		protected function doNothing(e:MouseEvent):void 
		{
			//no action
		}
		
		public function block(e:Event = null):void
		{
			mcBlock.visible = true;
		}
		
		public function unblock(e:Event = null):void
		{
			mcBlock.visible = false;
		}
		
	}
	
}