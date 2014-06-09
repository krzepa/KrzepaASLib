package com.krzepa.loading {
	
    import com.krzepa.utils.XLogger;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class GfxLoader extends AbstractBaseLoader {

        public function GfxLoader()
		{
            construct();
		}
		
		private function construct():void
		{
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener( Event.COMPLETE, completeHandler );
            _loader.contentLoaderInfo.addEventListener( Event.OPEN, openHandler );
            _loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
            _loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            _loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progressHandler );
            _loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
        }

        public override function load( url:Object ):void
		{
			if(!url) {
				dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE,null,new Error(URL_ERROR) ) );
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
            } catch(e:Error) {
				dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE,null,new Error(URL_ERROR) ) );				
				
				XLogger.error( URL_ERROR , _url);
            };
        }

        public override function close():void
		{
            try {
                _loader.close();
                if (_loader.contentLoaderInfo.bytesTotal){
                    _loader.unload();
                };
            } catch(err:Error) { };
        }
		
		protected override function completeHandler( evt:Event ):void
		{
			try {
				data = LoaderInfo(evt.currentTarget).loader.content;
			}catch(err:Error) {
				data = LoaderInfo(evt.currentTarget).loader;
			} finally {
				dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE, data) );				
			}
		};	

    }
}
