
package com.krzepa.utils {
	
	public class GemiusStats {
		
		private static var active:Boolean = false;
	
		public static function setActive( val:* ):void {
			
			active = Boolean( parseInt( val ) );
			
		}

		public static function track( code:String ):void {

			trace( '>>> GemiusStats.track: ' + code + ' , stats active: ' + active );
			
			if( active ) {
				JS.callFunction( 'gemius_hit' , code );
			}
			
		}		

	}

}
