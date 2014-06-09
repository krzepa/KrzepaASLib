package com.krzepa.utils
{

    public final class StrUtils
	{
		public static function trim( value:String ):String
		{
			if(value) {
				return value.replace( /^\s+|\s+$/g , '' );				
			} else {
				return '';
			}
		}
		
		public static function ltrim( value:String ):String
		{
			if(value) {
				return value.replace( /^\s+/g , '' );			
			} else {
				return '';
			}		
		}
		
		public static function rtrim( value:String ):String
		{
			if(value) {
				return value.replace( /\s+$/g , '' );		
			} else {
				return '';
			}			
		}
		
		public static function reduceSpaces( value:String ):String
		{
			return trim(value).replace( /\s{2,}/g , ' ' );
		}
		
        public static function removePL( value:String ):String
		{
            var pl:Array = ["ą", "ż", "ś", "ź", "ę", "ć", "ó", "ł", "ń", "Ą", "Ż", "Ś", "Ź", "Ę", "Ć", "Ó", "Ł", "Ń"];
            var en:Array = ["a", "z", "s", "z", "e", "c", "o", "l", "n", "A", "Z", "S", "Z", "E", "C", "O", "L", "N"];
            var i:uint;
            while( i < pl.length ) {
                value = value.replace( pl[i] , en[i] );
                i++;
            };
            return value;
        }
		
        public static function htmlEntityDecode(value:String):String
		{
            return value.replace( '&amp;' , '&' );
        }
		
        public static function toBoolean(value:*):Boolean
		{
            if ( value is Boolean ){
                return value;
            };
			
            if ( (value === null) || (value === undefined) ){
                return false;
            };
			
            if ( value is String ){
                switch (value.toLowerCase()){
                    case "false":
                    case "":
                    case "undefined":
                    case "null":
                    case "0":
                        return false;
                    default:
                        return true;
                };
            };
			
            if ( value is Number ){
                return Boolean(value);
            };
			
            return true;
        }
		
		public static function removeTags(str:String):String
		{
			var re:RegExp;
			if (!(str)){
				return ('');
			};
			re = new RegExp('<(.|\n)*?>');
			str = str.replace(re, '');
			return str;
		}

		public static function removeTag( str:String, tagName:String ):String
		{
			return replaceTags( str , tagName , '' );
		}		
		
		public static function replaceTags(str:String, fromTag:String, toTag:String ):String
		{
			var re:RegExp;
			if (!(str)){
				return ('');
			};
			re = new RegExp( '<(' + fromTag + ')[^><]*>' , 'gi');
			str = str.replace(re, toTag ? '</' + toTag + '>' : '' );
			re = new RegExp( '<(.' + fromTag + ')[^><]*>' , 'gi');
			str = str.replace(re, toTag ? '</' + toTag + '>' : '' );
			return (str);
		}		
		
        public static function toColor( value:String ):Number
		{
            if ( (value == null) || (value == 'undefined') || (value == '') ){
                return (NaN);
            };
            if ( value.indexOf('#') == 0 ){
                value = '0x' + value.substr(1);
            };
            if ( isNaN(Number(value)) ){
                return NaN;
            };
            return parseInt(value, 16);
        }
		
        public static function toUpperFirst(value:String):String
		{
            return value.charAt(0).toUpperCase() + value.substr(1);
        }
		
        public static function addSlashes(value:String):String
		{
            value = value.replace(/'/g, "\\'");
            value = value.replace(/"/g, "\\\"");
            return value;
        }
		
		public static function addNoCache(value:String):String
		{
			var str:String = new Date().getTime().toString();
			
			if( value.indexOf('?') == value.length ) {
				value += str;
			} else { 
				value += '?' + str;
			}
			
			return value;
		}
		
        public static function camelize( str:String, separator:String=' ' ):String
		{
            var str:* = str;
            var separator:String = separator;
            var reg:* = new RegExp( '(' + separator + '){1,}[a-z]' , 'gmi');
            var repl:* = str.replace(reg, function ( ...args ):String{
                return String(args[0].slice(-1)).toUpperCase();
            });
            return repl;
        }
		
        public static function isSet(value:*):Boolean
		{
            if ( (value === null) || (value === undefined) ){
                return false;
            };
            if (value is String){
                switch (value){
                    case "null":
                    case "undefined":
                    case "":
                        return false;
                    default:
                        return true;
                };
            };
            return true;
        }
		
		/*
			restrict flashvar to letters and digits and . $ -
		*/
		public static function isSafeFlashvar( value:String ):Boolean
		{
			if(value.indexOf('document.cookie')!==-1) return false;
			if(!value.match(/^(\w|[_])+$/)) return false;
				
			return true;		
		}
		
		public static function shorten( value:String, maxLenght:uint, suffix:String = '...'):String
		{
			if( value.length > maxLenght ) {
				return value.substr(0,maxLenght).concat(suffix);
			} else {
				return value;
			}
			
		}		

    }
}