package com.krzepa.utils {
	
    import flash.system.*;
	import flash.external.*;

    public final class FPVersion {

		public var internalBuildNumber:int;
		public var platform:String;
		public var buildNumber:int;
		public var minorVersion:int;
		public var majorVersion:int;		
		public var plugin:String;
		public var isDebugger:Boolean;
		public var playerType:String;
		public var sandbox:String;
		public var objectId:String;
		
        public function FPVersion()
		{
            super();
        }
        
		public static function getVersion():FPVersion
		{
            var v:FPVersion = new FPVersion();
            var a:Array = Capabilities.version.split(' ');
            v.platform = a[0];
            a = a[1].split(',');
            v.majorVersion = parseInt(a[0],10);
            v.buildNumber = parseInt(a[1],10);
            v.minorVersion = parseInt(a[2],10);
            v.internalBuildNumber = parseInt(a[3],10);
			v.playerType = Capabilities.playerType;
			v.isDebugger = Capabilities.isDebugger;
			v.sandbox = Security.sandboxType;
			try {
				v.objectId = ExternalInterface.objectID;
			} catch(err:Error) {};
            return v;
        }
		
		public function isBiggerOrEqual( value:String ):Boolean
		{
			var a:Array = value.split('.');
			if( a.length == 1 ) {
				return majorVersion >= parseInt(a[0],10);
			} else {
				if( majorVersion >= parseInt(a[0],10) ) {
					if( majorVersion > parseInt(a[0],10) ) {
						return true;
					} else if( buildNumber >= parseInt(a[1],10) ) {
						if( buildNumber > parseInt(a[1],10) || a[2] === undefined ) {
							return true
						} else {
							if( minorVersion >= parseInt(a[2],10) ) {
								if( minorVersion > parseInt(a[2],10) || a[3] === undefined ) {
									return true
								} else {
									if( internalBuildNumber >= parseInt(a[3],10)  ) {
										return true;
									}								
								}
							}								
						}
					}
				}					
			}

			return false;
		}
				
		public function toString():String
		{
			var str:String = 'Flash Player version: ' + majorVersion + '.' + buildNumber + '.' + minorVersion + '.' + internalBuildNumber;
			str += '\nSystem: ' + platform + ', player type: ' + playerType + ', objectId: ' + objectId + ', sandbox: ' + sandbox + ', is debugger: ' + (isDebugger?'yes':'no');
			return str;
		}		
		

    }
}
