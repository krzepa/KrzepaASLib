package com.krzepa.utils
{
	
    import flash.display.*;
    import flash.events.*;

    public class EFDelay
	{
		public static var maxFrames:uint = 100;
		private static var _currentFrame:uint;
		
        public static var stage:Stage;
		
        private static var _actions:Array = [];		
		private static var _flashvarsCallback:Function;
		private static var _flashvars:Object;
		private static var _flashvarsNames:Array;

        public function EFDelay()
		{
            super();
        }
		
		public static function waitForFlashVars( flashvars:Object, requiredFlashVarsNames:Array, flashvarsReadyCallback:Function  ):void
		{
			_flashvarsCallback = flashvarsReadyCallback;
			_flashvarsNames = requiredFlashVarsNames;
			_flashvars = flashvars;
			stage.addEventListener( Event.ENTER_FRAME, checkFlashvars );
			_currentFrame = 0;
		}
		
		/*
			sprawdza flashvary bez wzgledu na wielkosc liter
		*/
		private static function checkFlashvars( evt:Event ):void
		{
			if(++_currentFrame > maxFrames) {
				stage.removeEventListener( Event.ENTER_FRAME, checkFlashvars );
				_flashvarsCallback(null);
				return;
			}			
			for( var i:uint = 0 ; i < _flashvarsNames.length ; ++i ) {
				if( !StrUtils.isSet(_flashvars[_flashvarsNames[i]]) && !StrUtils.isSet(_flashvars[String(_flashvarsNames[i]).toLowerCase()]) ) {
					return;
				}
			}
			stage.removeEventListener( Event.ENTER_FRAME, checkFlashvars );
			_flashvarsCallback(_flashvars);
		}
		
        public static function removeMethod( closureFunction:Function ):void
		{
            var action:Action;
            var i:uint;
            while (i < _actions.length) {
                action = (_actions[i] as Action);
                if (action.func == closureFunction){
                    _actions.splice(i, 1);
                };
                i++;
            };
        }
		
        private static function executeMethods( evt:Event ):void
		{
            var i:uint;
            var item:Object;
            if (_actions.length){
                i = 0;
                while (i < _actions.length) {
                    item = _actions[i];
                    if (--item.frames <= 0){
                    	if( item.args && item.args.length ) {
                        	item.func.call(null, item.args);
                     	} else {
                     		item.func.call(null);
                     	}
                        _actions.splice(i, 1);
                    } else {
                        i++;
                    };
                };
            } else {
                stage.removeEventListener(Event.ENTER_FRAME, executeMethods );
            };
        }
		
        public static function callMethod(closureFunction:Function, args:Array=null, framesDelay:uint=1):void
		{
            if (!stage){
                throw (new Error("EFDealy > stage is not assigned!"));
            };
            _actions.push(new Action(closureFunction, args, framesDelay));
            stage.addEventListener( Event.ENTER_FRAME, executeMethods );
        }

    }
}

class Action {

    public var func:Function;
    public var frames:uint;
    public var args:Array;

    function Action(func:Function, args:Array, frames:uint){
        this.func = func;
        this.args = args;
        this.frames = frames;
    }
}
