package com.krzepa.gui.popups
{
	import com.krzepa.utils.XLogger;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	public class BasePopup extends Sprite
	{
		public var priority:int;
		
		protected var _manager:PopupManager;
		
		protected var _width:Number;
		protected var _height:Number;
		protected var _content:Sprite;
		protected var _initParams:PopupInitParams;
		
		public function BasePopup( initParams:PopupInitParams=null )
		{
			priority = 0;
			_manager = PopupManager.getInstance();
			_initParams = initParams ? initParams : new PopupInitParams();		
			
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		protected function addedToStageHandler( evt:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler );
			
			if( _initParams.content ) {
				_content = new _initParams.content();
				addChild(_content);
			}		
		}
		
		protected function removedFromStageHandler( evt:Event ):void
		{	
		}
		
		public function show():void
		{
			_manager.openPopup(this);
		}
		
		public function hide():void
		{
			_manager.closePopup(this);
		}
		
		public function showAnim():void
		{
			onShowComplete();
		}
		
		public function hideAnim():void
		{
			onHideComplete();
		}		
		
		protected function onShowComplete():void
		{
			dispatchEvent( new PopupEvent(PopupEvent.SHOW_COMPLETE));
		}
		
		protected function onHideComplete():void
		{
			dispatchEvent( new PopupEvent(PopupEvent.HIDE_COMPLETE));
		}
		
		public function onStageResize( w:Number, h:Number ):void
		{
			if(_content) {
				var rect:Rectangle = _content.getRect(this);
				if( rect.x!=_content.x || rect.x==0 )
					_content.x = Math.round((w - rect.width)/2) - rect.x;
				if( rect.y!=_content.y || rect.y==0 )
					_content.y = Math.round((h - rect.height)/2) - rect.y;
			}
		}
		
		public static function create( PopupClass:Class, initParams:PopupInitParams ):BasePopup
		{
			if(!PopupClass) PopupClass = BasePopup;
			var popup:BasePopup = new PopupClass(initParams) as BasePopup;
			return popup;
		}
		
		protected function closeClickHandler( evt:MouseEvent ):void
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE_CLICK));
			_manager.closePopup(this);
		}		
		
		protected function cancelClickHandler( evt:MouseEvent ):void
		{
			dispatchEvent(new PopupEvent(PopupEvent.CANCEL_CLICK));
		}
		
		protected function yesClickHandler( evt:MouseEvent ):void
		{
			dispatchEvent(new PopupEvent(PopupEvent.YES_CLICK));
		}
		
		protected function noClickHandler( evt:MouseEvent ):void
		{
			dispatchEvent(new PopupEvent(PopupEvent.NO_CLICK));
		}
		
	}
}