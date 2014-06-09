package com.krzepa.gui.popups
{
	import com.krzepa.utils.XLogger;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	public class PopupManager
	{
		public static var blockerColor:uint = 0x000000;
		public static var blockerOpacity:Number = 0.7;
		
		private static var _instance:PopupManager;

		private var _popups:Array = new Array();
		private var _stage:Stage;
		private var _con:Sprite;
		private var _blockerClass:Class;
		private var _blocker:Sprite;
		private var _rect:Rectangle;

		public function PopupManager( value:SingletonEnforcer )
		{
			if(!value) throw new Error( 'Only one Singleton instance should be instantiated' );		
			_instance = this;
		}
		
		public static function getInstance():PopupManager
		{
			if(_instance) {
				return _instance;
			} else {
				return new PopupManager( new SingletonEnforcer() );
			}
		}
		
		public function openPopup( ref:BasePopup ):void
		{
			if(_popups.indexOf(ref)!=-1) {
				return;
			}
			
			if(!_con.contains(_blocker)) {
				_con.addChildAt(_blocker,0);
			}
			
			var index:int = -1;
			var p:BasePopup;
			var d:uint = _con.numChildren;
			
			for( var i:uint = 0; i < _popups.length; ++i ) {
				p = _popups[i];
				if(ref.priority > p.priority) {
					index = i;
					break;
				}
			}

			if(index!=-1) {
				p = _popups[index];
				d = _con.getChildIndex(p);
				_popups.splice(index,0,ref);
			} else {
				_popups.push(ref);
			}

			_con.addChildAt( ref, d );
			
			
			if(_rect) {
				ref.onStageResize(_rect.width-_rect.x, _rect.height-_rect.y);
			} else {
				ref.onStageResize(_stage.stageWidth, _stage.stageHeight);
			}
			ref.showAnim();			
		}
		
		public function closePopup( ref:BasePopup ):void
		{
			var i:int = _popups.indexOf(ref);
			if(i!=-1) {
				_popups.splice(i,1);
			} else {
				return;
			}
			
			if(_con.contains(_blocker) && !_popups.length ) {
				_con.removeChild(_blocker);
			}
			ref.addEventListener( PopupEvent.HIDE_COMPLETE, hideCompleteHandler);
			ref.hideAnim();
		}
		
		public function closeAll():void
		{
			var p:BasePopup;
			for( var i:uint = 0 ; i < _popups.length ; ++i ) {
				p = _popups[i];
				closePopup(p);
			}
			_popups.splice(0);
		}
		
		private function hideCompleteHandler( evt:PopupEvent ):void
		{
			var p:BasePopup = evt.currentTarget as BasePopup;
			if(_con.contains(p)) {
				_con.removeChild(p);
			}
		}
		
		public function init( stage:Stage, constraints:Rectangle = null, blockerClass:Class = null ):void
		{
			_stage = stage;
			_stage.addEventListener( Event.RESIZE, stageResizeHandler );
			_rect = constraints;
			_blockerClass = blockerClass;
			
			_con = new Sprite();
			_stage.addChild(_con);
			if(_rect) {
				_con.x = _rect.x;
				_con.y = _rect.y;
			}
			
			drawBlocker();
		}
		
		private function drawBlocker():void
		{
			if(_blockerClass) {
				_blocker = new _blockerClass();
			} else {
				_blocker = new Sprite();
				_blocker.graphics.beginFill( blockerColor, blockerOpacity );
				_blocker.graphics.drawRect( 0, 0, 100, 100 );
			}
			stageResizeHandler();
		}
		
		private function stageResizeHandler( evt:Event = null ):void
		{
			_blocker.width = _stage.stageWidth;
			_blocker.height = _stage.stageHeight;
		}	
	}
}
class SingletonEnforcer {}