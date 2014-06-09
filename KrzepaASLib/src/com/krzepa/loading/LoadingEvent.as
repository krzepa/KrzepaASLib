package com.krzepa.loading
{
	import flash.events.Event;
	
	public class LoadingEvent extends Event
	{
		public static const COMPLETE:String = 'com.krzepa.loading.LoaderEvent.COMPLETE';
		
		public var data:Object;
		public var error:Error;
		
		public function LoadingEvent(type:String, data:Object = null , error:Error = null , bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.error = error;
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new LoadingEvent(type,data,error,bubbles,cancelable);
		}
		
	}
}