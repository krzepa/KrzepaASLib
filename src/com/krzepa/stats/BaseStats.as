package com.krzepa.stats
{
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	public class BaseStats
	{
		private static var _stage:Stage;
		private var _active:Boolean;
		
		protected static var _tracksBuffer:Array;
		
		public function BaseStats()
		{
			construct();
		}
		
		private function construct():void
		{
			if(!_tracksBuffer) {
				_tracksBuffer = new Array();
			}			
		}

		public function set stage( value:Stage ):void
		{
			_stage = value;
		}
		
		public function get stage():Stage
		{
			return _stage;
		}
		
		public function set active( value:Boolean ):void
		{
			_active = value;
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function track( ...args:Array ):void
		{
			if(_active) {
				if (_stage){
					throw (new Error("Stats > stage is not assigned!"));
				};				
				_tracksBuffer.push( {stats:this,trackItem:args} );
				checkTracksBuffer();				
			}
		}
		
		protected function sendTrack( ...args:Array ):void
		{
			throw( new IllegalOperationError('Abstract method called directly!') );				
		}		
		
		protected function onTrackError( evt:StatsEvent ):void
		{
			throw( new IllegalOperationError('Abstract method called directly!') );				
		}
		
		protected function onTrackComplete( evt:StatsEvent ):void
		{
			throw( new IllegalOperationError('Abstract method called directly!') );				
		}
		
		protected static function checkTracksBuffer():void
		{
			if(_tracksBuffer.length) {
				_stage.addEventListener( Event.ENTER_FRAME , enterFrameHandler );
			} else {
				_stage.removeEventListener( Event.ENTER_FRAME , enterFrameHandler );
			}			
		}

		private static function enterFrameHandler( evt:Event ):void
		{
			if( _tracksBuffer.length ) {
				var item:Object = _tracksBuffer.shift();
				item.stats.sendTrack.apply( item.stats , item.stats.trackItem );
			} else {
				_stage.removeEventListener( Event.ENTER_FRAME , enterFrameHandler );
			}			
		}
	}
}