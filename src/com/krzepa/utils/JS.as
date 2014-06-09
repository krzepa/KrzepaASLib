package com.krzepa.utils
{
	
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.system.Capabilities;
	
	public class JS
	{
		
		public static function getURL( val:String , ... args ):void
		{
			
			var target:String = '_self';
			
			if( args[0] as String ) {
				target = args[0];
			}
			
			if( Capabilities.playerType == 'External' ) {
				trace( '>>> Calling getURL: ' + val + ' , target: ' + target );				
				return;
			}			
			
			if( Capabilities.playerType == 'PlugIn' ) {
				
				navigateToURL( new URLRequest( val ) , target );
			
			} else if( Capabilities.playerType == 'ActiveX' ) {
				
				var simpleURL:Boolean = false;
				var str:String = val;
				var i:Number = str.indexOf(':');
				var i2:Number;
				
				if( i != -1 ) {
					
					if( (str.indexOf('http:') == 0) || (str.indexOf('file:') == 0) || (str.indexOf('https:') == 0) ) {
						simpleURL = true;
					}
					
					if( ( i2 = str.indexOf('/') ) != -1 ) {
						if( i2 < i ) {
							simpleURL = true;
						}
					}
					
				} else {
					
					simpleURL = true;
					
				}
				
							
				if( simpleURL ) {					
					navigateToURL( new URLRequest( val ) , target );					
				} else {					
					ExternalInterface.call( 'swfUtils_callNoHttpProtocol', val );					
				}
				
			}			

		}
		
		public static function checkCallbackFunction(callbackFunc:String=''):String 
		{
			var match:* = callbackFunc.match(/^[a-zA-Z][a-zA-Z0-9_]+?$/);
			if (match == null)
			{
				callbackFunc = '';
				trace("Check callbackFuncect name!");
				throw new ArgumentError("Illegal callback object!");
				return;
			}
			return callbackFunc;
		}		
		
		
		public static function call( expression:String ):*
		{
			var returnVal:* = null;
			try {
				returnVal = ExternalInterface.call( expression );
			} catch( err:Error ) { XLogger.error('JS calling error',err) };
			return returnVal;
		}
		
		public static function callFunction( funcName:String, ...args ):void
		{

			if( Capabilities.playerType == 'External' ) {
				trace( '>>> Calling js function: ' + funcName + ' , args: ' + args );				
				return;
			}
			
			if( args[0] as Array ) {
				args = args[0];
			}
			
			try {
				if( ExternalInterface.available ) {
					ExternalInterface.call.apply( ExternalInterface , [funcName].concat(args) );
				} else {
					throw new Error('ExternalInterface not available');
				}				
			} catch( err:Error ) {
				for( var i:uint=0 ; i < args.length ; ++i ) {
					if( !(args[i] as Number) ) {
						args[i] = "\"" + StrUtils.addSlashes( String(args[i]) ) + "\"";
					}
				}				
				getURL('javascript:' + funcName + '(' + args.join(',') + ');' );				
			}
			
		}
	}
	
}