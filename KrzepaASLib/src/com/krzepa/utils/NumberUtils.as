package com.krzepa.utils
{

    public final class NumberUtils
	{
		public static function toFixed( value:Number, digitsAfterDot:uint = 2 ):Number
		{
			var p:Number = Math.pow(10,digitsAfterDot);
			return Math.round( value * p) / p;
		}
		
		public static function format( value:Number, precision:uint=0, separator:String=' ', decimal:String=',' ):String
		{
				var str:String = String(value);
				var decIndex:int = str.indexOf( '.', 0);
				var decNum:String = '.';
				var num:String = '';
				var newNum:String ='';
				
				if ( decIndex != -1) {
					decNum = str.substring(decIndex, str.length);
				} else {
					decIndex = str.length;
				}
				
				num = str.substring(0, decIndex);
				

				for (var i:int = num.length-1; i>=0; i--) {
					newNum = newNum + num.charAt(num.length-1-i);
					if ((i%3 == 0) && (i != 0)) {
						newNum = newNum + separator;
					}
				}
				
				decNum = decNum.substring(1, decNum.length);
				if (!(decNum.length == precision)) {
					if ((decNum == '0') || (decNum.length)) {
						return newNum+decimal+decNum;
					} else {
						return newNum;
					}
				}
				return newNum;
		}
		
		public static function numberToHexString( value:Number ):String
		{
			return '#' + value.toString(16);
		}
		
        public static function getArrayOfNumbers(fromNum:Number, toNum:Number):Array
		{
            var i:uint;
            var a:Array = new Array();
            if (fromNum <= toNum){
                i = fromNum;
                while (i <= toNum) {
                    a.push(i);
                    i++;
                };
            } else {
                i = fromNum;
                while (i >= toNum) {
                    a.push(i);
                    i--;
                };
            };
            return a;
        }

    }
}