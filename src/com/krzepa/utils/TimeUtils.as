package com.krzepa.utils
{

    public final class TimeUtils
	{

        public function TimeUtils()
		{
            super();
        }
		
        public static function parseTimeToString( value:Number ):String
		{
            var time:String;
            if ( isNaN(value) || (Math.abs(value) == Infinity) ){
                value = 0;
            };
			
            var hours:String = Math.floor((value / 3600)).toString(10);
            var minutes:String = Math.floor(((value % 3600) / 60)).toString(10);
            var seconds:String = Math.floor(((value % 3600) % 60)).toString(10);
			
            if ( seconds.length == 1 ){
                seconds = '0' + seconds;
            };
            if ( minutes.length == 1 ){
                minutes = '0' + minutes;
            };
            if ( hours != '0' ){
                time = hours + ':' + minutes + ':' + seconds;
            } else {
                time = minutes + ':' + seconds;
            };
            return time;
        }
		
        public static function parseTimeToNumber( value:String ):Number
		{
            var a:Array = value.split( ':' );
            var hours:Number = parseInt(a[0], 10);
            var minutes:Number = parseInt(a[1], 10);
            var seconds:Number = parseInt(a[2], 10);
            var time:Number = (seconds + (minutes * 60)) + (hours * 3600);
            return time;
        }

    }
}
