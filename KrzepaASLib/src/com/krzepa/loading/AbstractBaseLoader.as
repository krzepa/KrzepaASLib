package com.krzepa.loading
{
	import com.krzepa.utils.XLogger;
	
	import flash.errors.*;
	import flash.events.*;
	import flash.system.LoaderContext;
	
	public class AbstractBaseLoader extends EventDispatcher implements IBasicLoader
	{
		public static const URL_ERROR:String = 'URL_ERROR';
		public static const SECURITY_ERROR:String = 'SECURITY_ERROR';
		public static const IO_ERROR:String = 'IO_ERROR';
		
		public var data:*;
		
		protected var _url:String;
		protected var _loader:Object;
		
		public function AbstractBaseLoader()
		{
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function get loader():Object
		{
			return _loader;
		}		
		
		public function load( url:Object ):void
		{
			throw( new IllegalOperationError('Abstract method called directly!') );
		}
		
		public function close():void
		{
			throw( new IllegalOperationError('Abstract method called directly!') );				
		}

		protected function completeHandler( evt:Event ):void
		{
			dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE) );
		}
		
		protected function securityErrorHandler( err:SecurityErrorEvent ):void
		{
			dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE, null, new Error(err.text) ) );
			
			XLogger.error( SECURITY_ERROR, err.text, _url);
		}
		
		protected function httpStatusHandler( evt:HTTPStatusEvent ):void
		{
			
		}
		
		protected function openHandler( evt:Event ):void
		{
			
		}
		
		protected function ioErrorHandler( err:IOErrorEvent ):void
		{
			dispatchEvent( new LoadingEvent(LoadingEvent.COMPLETE, null, new Error(err.text) ) );
			
			XLogger.error( IO_ERROR, err.text );
		}

		protected function progressHandler( evt:ProgressEvent ):void
		{
			dispatchEvent( evt );
		}		
		
	}
}