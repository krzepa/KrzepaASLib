package com.krzepa.utils
{
	public class ObjectUtils
	{
		public static function getKeyWithMaxValue( o:Object ):Number
		{
			var key:String;
			for( var k:String in o) {
				if(key) {
					if(o[k]>o[key]) key = k;
				} else {
					key = k;						
				}
			}
			return parseFloat(key);
		}
		
		public static function getKeyWithMinValue( o:Object ):Number
		{
			var key:String;
			for( var k:String in o) {
				if(key) {
					if(o[k]<o[key]) key = k;
				} else {
					key = k;						
				}
			}
			return parseFloat(key);
		}
		
		public static function copyProperties( fromRef:Object, toRef:Object ):void
		{
			for( var k:String in fromRef ) {
				try {
					toRef[k] = fromRef[k];					
				} catch( err:Error ) {};
			}
		}
		
		public static function toString( fromRef:Object ):String
		{
			var str:String = '{ ';
			for( var k:String in fromRef ) {
				try {
					str += k+':'+fromRef[k]+', ';					
				} catch( err:Error ) {};
			}
			str = str.slice(-2);
			str += ' }';
			
			return str;
		}		
	}
}