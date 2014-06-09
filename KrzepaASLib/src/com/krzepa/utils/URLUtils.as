package com.krzepa.utils
{
	public class URLUtils
	{
		public static function getQueryParam( url:String, paramName:String ):String
		{
			var s:String;
			if( /\?/.test(url) ) {
				s = url.split('?')[1];
				var pairs:Array = s.split('&');
				for( var i:uint = 0 ; i < pairs.length ; ++i ) {
					var a:Array = pairs[i].split('=');
					if(a[0]==paramName) return a[1];
				}
			}
			return null;
		}
		
		public static function setQueryParam( url:String , paramName:String , paramValue:String ):String
		{
			var temp:Array = new RegExp('(\\?|&)('+paramName+'=[^&]+)','g').exec(url);
			if(temp && temp.length==3) {
				return url.replace( temp[2] , paramName+'='+paramValue );
			} else {
				if( url.indexOf('?')!=-1 ) {
					return url+'&'+paramName+'='+paramValue;
				} else {
					return url+'?'+paramName+'='+paramValue;
				}
			}
		}
	}
}