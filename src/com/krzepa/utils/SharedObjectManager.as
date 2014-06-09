package com.krzepa.utils
{
    import flash.events.*;
    import flash.net.*;

    public final class SharedObjectManager
	{
        private var soData:Object;
        private var so:Object;
		private static var _instance:SharedObjectManager = null;
		
        public static var SO_NAME:String = 'settings';

        public function SharedObjectManager(ref:SingletonEnforcer)
		{
            super();
            if (ref == null){
                throw (new Error('Only one instance of SharedObjectManager is allowed!'));
            };
			
			_instance = this;
            
			try {				
				so = SharedObject.getLocal(SO_NAME, "/");
				so.addEventListener( NetStatusEvent.NET_STATUS, errorHandler );
				so.addEventListener( AsyncErrorEvent.ASYNC_ERROR, errorHandler );
				soData = so.data;
			} catch(err:Error) {
				XLogger.error( 'SharedObject not working <create>');
				so = { data:{} };
			};            
            
        }
		
		
		public static function getInstance():SharedObjectManager
		{
			if (_instance){
				return _instance;
			} else {
				return (new SharedObjectManager(new SingletonEnforcer()));				
			}			
		}		
		
        public function deleteProperty(propertyName:String):void
		{
            delete soData[propertyName];
           	update();
        }
		
        public function getProperty(propertyName:String):*
		{
            return soData[propertyName];
        }
		
        public function setProperty(propertyName:String, value:*):void
		{
            if (soData[propertyName] !== value){
                soData[propertyName] = value;
				update();
            };
        }
		
        public function clear():void
		{
            so.clear();
        }
		
        public function isSet(propertyName:String):Boolean
		{
            return ( !(soData[propertyName] === undefined) && !(soData[propertyName] === null) );
        }
		
		private function errorHandler( evt:Event ):void
		{
			XLogger.error( 'SharedObject error ' + evt );
		}
		
		private function update():void
		{
			try {
				so.flush();
			} catch( err:Error ) {
				XLogger.error( 'SharedObject not working <flush>');
			};			
		}
		
    }
}
class SingletonEnforcer {}
