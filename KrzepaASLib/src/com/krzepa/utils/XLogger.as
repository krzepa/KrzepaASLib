package com.krzepa.utils
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.*;
	
	import org.osflash.thunderbolt.Logger;
	
	public class XLogger
	{
		public static const OUTPUT_TXTFIELD:String = 'text field';
		public static const OUTPUT_CONSOLE:String = 'console log';
		public static const OUTPUT_JS:String = 'javascript log';
		
		private static var _enabled:Boolean = true;
		private static var _txtoutput:TextField;
		private static var _jsoutput:String;
		private static var _prefix:String = '';
		private static var _outputType:String = OUTPUT_CONSOLE;
		
		private static var _btn:MovieClip;
		private static var _con:MovieClip;
		private static var _stage:Stage;
		private static var _width:Number = 200;
		private static var _height:Number = 100;
		private static var _tf:TextFormat;
		
		public static function get output():TextField
		{
			if(!_txtoutput) {
				if(!_tf) _tf = new TextFormat('_sans',10,0x00ff00);
				_txtoutput = new TextField();
				_txtoutput.background = true;
				_txtoutput.backgroundColor = 0x000000;
				//_txtoutput.autoSize = TextFieldAutoSize.LEFT;
				_txtoutput.wordWrap = true;
				_txtoutput.multiline = true;
				_txtoutput.width = _width;
				_txtoutput.height = _height;
				_txtoutput.defaultTextFormat = _tf;
			}			
			return _txtoutput;
		}
		
		public static function set jsoutput( value:String ):void
		{
			_jsoutput = value;
		}
		
		public static function set prefix( value:String ):void
		{
			_prefix = value;
		}
		
		public static function set visible( value:Boolean ):void
		{
			if(_con) _con.visible = value;
		}
		
		public static function set enabled( value:Boolean ):void
		{
			_enabled = value;
			if(_con) _con.visible = value;
		}
		
		public static function init( stage:Stage, width:Number=200, height:Number=100, tf:TextFormat=null ):void
		{
			_stage = stage;
			if(!isNaN(width)) _width = width;
			if(!isNaN(height)) _height = height;
			_tf = tf;
							
			_con = new MovieClip();
			_stage.addChild(_con);
			
			_btn = new MovieClip();
			_btn.graphics.beginFill(0x000000,1);
			_btn.graphics.drawRect( 0, 0, 20, 20);
			_btn.graphics.endFill();
			_btn.graphics.lineStyle( 1, 0x00FF00, 1, true, 'none', 'square', 'miter');
			_btn.graphics.moveTo( 4, 4 );
			_btn.graphics.lineTo( 14, 14);
			_btn.graphics.lineTo( 14, 8 );
			_btn.graphics.moveTo( 14, 14);			
			_btn.graphics.lineTo( 8, 14);
			
			_btn.buttonMode = true;
			_btn.addEventListener( MouseEvent.CLICK, mouseClickHandler );
			output.y = 0;
			
			_con.addChild(_btn);
			output.x = _btn.width;			
			
			_stage.addEventListener( Event.ADDED, addedHandler );
		}
		
		public static function switchVisibility():void
		{
			mouseClickHandler(null);			
		}
		
		private static function addedHandler( evt:Event ):void
		{
			var index:int = _stage.getChildIndex(_con);
			if(index<_stage.numChildren-1) {
				_stage.addChild(_con);
			}
		}
		
		private static function mouseClickHandler( evt:MouseEvent=null ):void
		{
			if(_con.contains(output)) {
				_con.removeChild(output);
				_btn.scaleX = _btn.scaleY = 0.6;
				_btn.x = _btn.y = 0;
			} else {
				_con.addChild(output);
				_btn.scaleX = _btn.scaleY = -0.6;
				_btn.x = _btn.y = _btn.height;
			}
		}
		
		public static function set outputType( value:String ):void
		{
			_outputType = value;
			
			if( _outputType == OUTPUT_TXTFIELD ) {
				try {
					ExternalInterface.addCallback("_outputScrollDown", function():void { output.scrollV-- } );
					ExternalInterface.addCallback("_outputScrollUp", function():void { output.scrollV++ } );
					ExternalInterface.addCallback("_outputVisibility", function():void { switchVisibility() } );
					ExternalInterface.addCallback("_outputGetLog", function():String { return _txtoutput.text } );
				} catch (err:Error) {};
			}
			
		}
		
		public static function config( value:Object ):void
		{
			for( var k:String in value ) {
				Logger[k] = value[k];
			}
			if(value.enabled!=undefined) {
				enabled = value.enabled;
			}
			if(value.prefix!=undefined) {
				_prefix = value.prefix;
			}			
		}
		
		public static function error(...args):void
		{
			if(!_enabled) return;			
			args[0] = _prefix + args[0];
			
			switch( _outputType ) {
				case OUTPUT_TXTFIELD:
					displayError.apply(null,args);
					break;
				case OUTPUT_CONSOLE:
					try {
						Logger.error.apply(Logger,args);
					} catch( err:Error ) {
						trace.apply(null,args);
					}					
					break;
			}
		}
		
		public static function info(...args):void
		{
			if(!_enabled) return;
			args[0] = _prefix + args[0];

			switch( _outputType ) {
				case OUTPUT_JS:
					try {
						ExternalInterface.call( _jsoutput, args );
					} catch( err:Error ) {
						trace.apply(null,args);
					} 
					break;
				case OUTPUT_TXTFIELD:
					displayInfo.apply(null,args);
					break;
				case OUTPUT_CONSOLE:
				try {
					Logger.info.apply(Logger,args);
				} catch( err:Error ) {
					trace.apply(null,args);
				}					
				break;
			}			

		}
		
		public static function displayError(...args ):void
		{
			var str:String = '';
			for( var i:uint = 0 ; i < args.length ; ++i ) {
				str += args[i] + '\n';
			}
			output.appendText(str);
			output.scrollV = output.maxScrollV;
		}
		
		public static function displayInfo( ...args ):void
		{
			var str:String = '';
			for( var i:uint = 0 ; i < args.length ; ++i ) {
				str += args[i] + '\n';
			}
			output.appendText(str);
			output.scrollV = output.maxScrollV;
		}
		
		public static function memorySnapshot():String
		{
			return Logger.memorySnapshot();
		}
		
		
	}
}