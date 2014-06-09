package com.krzepa.utils
{
	import flash.external.*;
	
	public class Cookie
	{
		public static function setCookie( cookieName:String , value:String , days:int = 0 ):void
		{
			var date:Date = new Date();
			date.setDate( date.getDate() + days );
			var expires:String = date.toUTCString();
			try {
				ExternalInterface.call( 'function(){ document.cookie = "'+cookieName+'="+escape("'+value+'")+ "; expires='+expires+'; path=/"; }');
			} catch( err:Error ) {};
		}
		
		public static function getCookie( cookieName:String ):String
		{
			var cookieVal:String;
			
			cookieVal = JS.call( 'function(){ return document.cookie; }');
			
			if( cookieVal ) {
				var cookies:Array = cookieVal.split(';');
				cookieVal = null;
				for( var i:uint = 0 ; i < cookies.length ; ++i ) {
					var a:Array = cookies[i].split('=');
					if( cookieName == StrUtils.trim(a[0]) ) {
						cookieVal = unescape(a[1]);
					}
				}
			}			
			return cookieVal;
		}
		
		public static function deleteCookie( cookieName:String ):void
		{
			setCookie( cookieName , '' , -1 );
		}

	}
}