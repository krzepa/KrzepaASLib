package com.krzepa.gui.loaders
{
	import com.krzepa.utils.XLogger;
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]	
	public class BaseLoader extends MovieClip
	{
		protected var _loader:ILoader;
		protected var _bg:Shape;
		protected var _config:LoaderConfig;
		
		public function BaseLoader( config:LoaderConfig )
		{
			_config = config ? config : new LoaderConfig();
			if(this.loaderInfo) {
				loaderInfo.addEventListener( IOErrorEvent.IO_ERROR, function( evt:IOErrorEvent ):void { XLogger.info('io error: ' + evt) } );
				try {
					loaderInfo['uncaughtErrorEvents'].addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function( evt:IOErrorEvent ):void { XLogger.info('uncaught error: ' + evt) });					
				} catch(err:Error) {};
			}
			addEventListener( Event.ADDED_TO_STAGE , addedToStageHandler );
			opaqueBackground = _config.bgColor;
		};

		protected function addedToStageHandler( evt:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , addedToStageHandler );
			
			if(_config.checkRoot) {
				if( this != root ) {
					return;
				}
			}
			
			stage.frameRate = 24;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageFocusRect = false;			
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			
			if(_config.appName) {
				var it:ContextMenuItem;
				it = new ContextMenuItem( _config.appName , false , false );
				cm.customItems[0] = it;				
				Sprite(stage.getChildAt(0)).contextMenu = cm;				
			}
			
			_bg = new Shape();
			_bg.graphics.beginFill( _config.bgColor );
			_bg.graphics.drawRect(0, 0, 100, 100);
			addChild(_bg);
					
			addEventListener( Event.ENTER_FRAME , oefHandler );			
			stage.addEventListener( Event.RESIZE , stageResizeHandler );	
			
			var LoaderClass:Class = _config.loaderClass ? _config.loaderClass : DotsLoader;
			_loader = new LoaderClass( _config.loaderColor );
			_loader.init();
			addChild(_loader as DisplayObject);
			_loader.setVisibility(true);
			
			stageResizeHandler();
			
			addEventListener( Event.COMPLETE, onComplete );
			addEventListener( ProgressEvent.PROGRESS, onProgress );
		};
		
		protected function stageResizeHandler( evt:Event = null ):void
		{
			if(_loader) _loader.setPosition( Math.round(stage.stageWidth/2),Math.round(stage.stageHeight/2) );
			_bg.width = stage.stageWidth;
			_bg.height = stage.stageHeight;
		};
		
		protected function oefHandler( evt:Event ):void
		{
			dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS,false,false,loaderInfo.bytesLoaded,loaderInfo.bytesTotal) );
			
			if( (loaderInfo.bytesLoaded>123) && (loaderInfo.bytesLoaded == loaderInfo.bytesTotal) ) {
				removeEventListener( Event.ENTER_FRAME , oefHandler );
				dispatchEvent( new Event(Event.COMPLETE) );
			}
		};
		
		protected function onComplete( evt:Event ):void
		{
			this.stop();
			removeLoader();
			addMainClass();
		}
		
		protected function onProgress( evt:ProgressEvent ):void
		{
			_loader.setPercentage( evt.bytesLoaded, evt.bytesTotal );
	
		}
		
		protected function addMainClass():void
		{
			if(!_config.stableBg) {
				stage.removeEventListener( Event.RESIZE , stageResizeHandler );
				removeChild(_bg);
				_bg = null;
			}

			var mainClass:Class = _config.mainClass as Class;
			
			if( !mainClass && _config.mainClass ) {
				try {
					mainClass = Class( getDefinitionByName( _config.mainClass ));
				} catch(err:Error) { trace( err ) };
			} 
			
			if( !mainClass ) {
				try {
					mainClass = Class( getDefinitionByName( getQualifiedClassName(this).replace('.loader','').slice(0,-6)) );
				} catch(err:Error) { trace( err ) };
			}
			
			if(!mainClass) {
				trace( 'Cannot instantiate main class!' );
				return;
			}			
			
			addChild(new mainClass() as DisplayObject);			
		}		
		
		public function removeLoader():void
		{	
			try {
				removeChild(_loader as DisplayObject);
				_loader = null;				
			} catch(err:Error) {};
		}		
		
	}
}