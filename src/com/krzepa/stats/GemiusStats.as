package com.krzepa.stats {
	
	import com.krzepa.utils.*;
	
	final public class GemiusStats extends BaseStats
	{
		private static var _instance:GemiusStats;
		
		public function GemiusStats( ref:SingletonEnforcer )
		{
			if (ref == null){
				throw (new Error('Only one instance of GemiusStats is allowed!'));
			}
			_instance = this;
		}
		
		public static function getInstance():GemiusStats
		{
			if(_instance) {
				return _instance;
			} else {
				return new GemiusStats( new SingletonEnforcer() );
			}
		}
		
		protected override function sendTrack( ...args:Array ):void
		{
			JS.callFunction( 'gemius_hit' , args[0] );
		}

	}

}
class SingletonEnforcer {}
