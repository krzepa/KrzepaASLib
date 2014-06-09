package com.krzepa.stats
{
	import flash.events.Event;
	
	public class StatsEvent extends Event
	{
		public static const TRACK_ERROR:String = 'com.krzepa.stats.StatsEvent.TRACK_ERROR';
		public static const TRACK_COMPLETE:String = 'com.krzepa.stats.StatsEvent.TRACK_COMPLETE';
		
		public var trackItem:Object;
		
		public function StatsEvent(type:String, trackItem:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.trackItem = trackItem;
		}
		
		public override function clone():Event
		{
			return new StatsEvent(type,trackItem,bubbles,cancelable);
		}
		
	}
}