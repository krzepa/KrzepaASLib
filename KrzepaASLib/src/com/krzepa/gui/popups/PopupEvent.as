package com.krzepa.gui.popups
{
	import flash.events.Event;
	
	public class PopupEvent extends Event
	{
		public static const CLOSE_CLICK:String = 'gg.gui.popups.PopupEvent.CLOSE_CLICK';
		public static const CANCEL_CLICK:String = 'gg.gui.popups.PopupEvent.CANCEL_CLICK';
		public static const YES_CLICK:String = 'gg.gui.popups.PopupEvent.YES_CLICK';
		public static const NO_CLICK:String = 'gg.gui.popups.PopupEvent.NO_CLICK';
		
		public static const SHOW_COMPLETE:String = 'gg.gui.popups.PopupEvent.SHOW_COMPLETE';
		public static const HIDE_COMPLETE:String = 'gg.gui.popups.PopupEvent.HIDE_COMPLETE';
		
		public var data:Object;
		
		public function PopupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new PopupEvent( type , bubbles , cancelable , data );
		}
	}
}