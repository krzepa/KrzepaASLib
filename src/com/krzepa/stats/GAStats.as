package com.krzepa.stats {
	
	import com.krzepa.utils.*;
	
	final public class GAStats extends BaseStats
	{
		private static var _instance:GAStats;
		
		public function GAStats( ref:SingletonEnforcer )
		{
			if (ref == null){
				throw (new Error('Only one instance of GAStats is allowed!'));
			}
			_instance = this;
		}
		
		public static function getInstance():GAStats
		{
			if(_instance) {
				return _instance;
			} else {
				return new GAStats( new SingletonEnforcer() );
			}
		}
		
		public function trackEvent( ):void
		{
			sendTrack( 'trackEvent' );
		}
		
		public function trackPageview():void
		{
			sendTrack( 'trackPageview' );
		}
		
		protected override function sendTrack( ...args:Array ):void
		{
			JS.callFunction( args[0] , args.slice(1) );			
		}

	}

}
class SingletonEnforcer {}
