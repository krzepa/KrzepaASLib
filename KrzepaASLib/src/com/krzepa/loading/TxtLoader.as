package com.krzepa.loading {
	
    import flash.events.*;
    import flash.net.*;
	import com.krzepa.utils.XLogger;

    public class TxtLoader extends AbstractBaseLoader
	{
        public function TxtLoader()
		{
			construct();
		}
		
		public function construct():void
		{
            _loader = new URLLoader();
            _loader.dataFormat = URLLoaderDataFormat.TEXT;
            _loader.addEventListener( Event.COMPLETE, completeHandler );
            _loader.addEventListener( Event.OPEN, openHandler );
            _loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
            _loader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            _loader.addEventListener( ProgressEvent.PROGRESS, progressHandler );
            _loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
        }

		public override function load( url:Object ):void
		{
			if(!url) {
				dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE,null,new Error(URL_ERROR) ) );
				return;
			}
			if(!_loader) {
				return;
			}
			
			var req:URLRequest;
			
			if( url is URLRequest ) {
				req = url as URLRequest;
				_url = req.url;
			} else {
				req = new URLRequest(url as String);
				_url = url as String;
			}
			
			try {
				_loader.load( req );
			} catch( err:Error ) {
				dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE,null,new Error(URL_ERROR) ) );				
				
				XLogger.error( URL_ERROR + ' > ' + _url);
			};
		}
		
		public override function close():void
		{
			try {
				if(_loader) {
					_loader.close();
					if (_loader.bytesTotal){
						_loader.data = null;
					};
					_loader = null;					
				}
			} catch( err:Error ) {};
		}
		
		protected override function completeHandler( evt:Event ):void
		{
			data = evt.currentTarget.data;
			dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE, data ) );
		}			
    }
}
