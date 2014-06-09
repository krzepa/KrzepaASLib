package com.krzepa.utils
{

    public final class DateUtils
	{

        private static const _daysInMonth:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        public static const monthsNames:Array = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        public static const monthsShortNames:Array = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

        public function DateUtils()
		{
            super();
        }
		
        public static function isLeapYear(value:uint):Boolean
		{
			if( (value % 4 == 0) && !( value % 100 == 0 ) || ( value % 400 == 0 ) ) {
				return true;
			}
            return false;
        }
		
        public static function getMonthDaysNumber(month:uint, fullYear:Number=NaN):uint
		{
            if (isNaN(fullYear)){
                fullYear = new Date().getFullYear();
            };
            if ( (month == 1) && isLeapYear(fullYear) ){
                return _daysInMonth[month] + 1;
            };
            return _daysInMonth[month];
        }

    }
}
