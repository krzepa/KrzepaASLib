package com.krzepa.gui.loaders
{
	import flash.display.*;
	import flash.events.*;
	
	public class DotsLoader extends Sprite implements ILoader
	{
		protected var _dotsNum:uint;
		protected var _dotsColor:uint;
		protected var _dotsDiameter:Number;
		protected var _diameter:Number;
		protected var _brightest:uint;
		protected var _con:Sprite;
		
		public function DotsLoader(	dotsColor:uint = 0xFFFFFF ,
									dotsDiameter:Number = 5 ,
									dotsNum:uint = 9 ,
									diameter:Number = 40 )
		{
			_dotsColor = dotsColor;
			_dotsDiameter = dotsDiameter;
			_dotsNum = dotsNum;
			_diameter = diameter;
		};
		
		public function init():void
		{
			_con = new Sprite();
			addChild(_con);
			mouseEnabled = false;
			mouseChildren = false;
			visible = false;
			draw();
		};
		
		public function setVisibility( val:Boolean ):void
		{
			super.visible = val;
			if( val ) {
				_brightest = 0;
				for( var i:uint = 0 ; i < _con.numChildren ; ++i ) {
					var dot:DisplayObject = _con.getChildAt(i);
					dot.alpha = 0;
				}
				addEventListener( Event.ENTER_FRAME , animate );
			} else {
				removeEventListener( Event.ENTER_FRAME , animate );
			}
		};
		
		public function setConfig( config:Object ):void
		{
			
		}
		
		public function setPercentage( bytesLoaded:Number, bytesTotal:Number ):void
		{
			
		}
		
		public function setPosition( valueX:Number, valueY:Number ):void
		{
			x = valueX;
			y = valueY;
		}
		
		private function animate( evt:Event ):void
		{
			_con.rotation += 3;
			
			for( var i:uint = 0 ; i < _con.numChildren ; ++i ) {
				var dot:DisplayObject = _con.getChildAt(i);
				if(_brightest == i) {
					dot.alpha -= (dot.alpha - 1) * .5;
					if(dot.alpha>0.99) {
						_brightest++;
						if(_brightest>=_con.numChildren) _brightest = 0;
					}
				} else {
					if(dot.alpha>0) {
						var a:Number = dot.alpha -dot.alpha * .1;
						if(a<0) a = 0;
						dot.alpha = a;
					}
				}
				
			}			
			
		};
		
		private function draw():void
		{
			var a:Number = 0;
			var da:Number = Math.PI*2/_dotsNum;
			var r:Number = _diameter/2;
			for( var i:uint = 0 ; i < _dotsNum ; ++i ) {
				var dot:Shape = new Shape();
				dot.graphics.beginFill(_dotsColor,1);
				dot.graphics.drawCircle(-_dotsDiameter/2,-_dotsDiameter/2,_dotsDiameter);
				dot.x = Math.cos(a)*r;
				dot.y = Math.sin(a)*r;				
				_con.addChild(dot);
				a += da;
			}
		}
		
		
	}
}