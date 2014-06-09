package com.krzepa.utils
{

    public final class XMLUtils
	{

        public function XMLUtils()
		{
            super();
        }
		
        public static function isSet(value:*):Boolean
		{
            if ( (value == null) || (value == undefined) ){
                return false;
            };
            return value.toString() != '';
        }
		
        public static function toBoolean(value:Object):Boolean
		{
			if(!value) return false;
			
            var str:String = value.toString();

            if ( !str || (str.toLowerCase() == "false") || (str == "0") ){
                return false;
            };
            return true;
        }

    }
}
