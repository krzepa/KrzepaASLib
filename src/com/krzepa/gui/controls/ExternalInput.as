package com.krzepa.gui.controls
{
	import com.krzepa.utils.XLogger;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.ui.*;
	
	public class ExternalInput extends Sprite
	{
		private var _tf:TextField;
		private var _caretPos:int;
		private var _textModifier:Function;
		
		private var _textCursor:Sprite;
		private var _editCursor:Sprite;
		private var _strReg:RegExp;
		private var _focus:Boolean;
		private var _selection:Boolean;
		
		public function ExternalInput( ref:TextField, restrict:RegExp, textModifier:Function )
		{
			_strReg = restrict;
			_textModifier = textModifier;
			
			_tf = ref;
			_tf.type = TextFieldType.DYNAMIC;
			_tf.selectable = false;
				
			_tf.addEventListener( MouseEvent.ROLL_OVER, mouseOverHandler );
			_tf.addEventListener( MouseEvent.ROLL_OUT, mouseOutHandler );
			_tf.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			_tf.doubleClickEnabled = true;
			_tf.addEventListener( MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler );

			_textCursor = new TextCursor();
			_editCursor = new EditCursor();
			//addChild(_editCursor);
			
			replaceOriginal();			
			
			updateCaretPosition(-1);
		}
		
		public function set hasFocus( value:Boolean ):void
		{
			_focus = value;
			setEditCursorVisible(_focus);
			if(!_focus) {
				updateSelection();
			}
			/*
			mouseEnabled = _focus;
			mouseChildren = _focus;
			*/
		}
		
		public function get hasFocus():Boolean
		{
			return _focus;
		}
		
		private function setEditCursorVisible( value:Boolean ):void
		{
			if(value) {
				addChild(_editCursor);
			} else {
				if(contains(_editCursor)) {
					removeChild(_editCursor);
				}
			}			
		}
		
		public function onFocusChange( evt:FocusEvent ):void
		{
			if( evt.type == FocusEvent.FOCUS_IN ) {
				hasFocus = true;
			} else {
				hasFocus = false;
			}
		}
		
		public function onKeyUp( evt:KeyboardEvent ):void
		{
			
			switch( evt.keyCode ) {
				case Keyboard.LEFT:					
					updateCaretPosition(_caretPos-1);
					return;	
				case Keyboard.RIGHT:					
					updateCaretPosition(_caretPos+1);
					return;			
				case Keyboard.DELETE:
					if(_tf.text.length == 0) return;
					if(_selection) {
						if(_caretPos == _tf.text.length-1) return;
						updateCaretPosition(_tf.selectionBeginIndex-1);
						_tf.replaceSelectedText('');
						updateSelection();
					} else {
						_tf.replaceText(_caretPos+1,_caretPos+2,'');
						if(_tf.text.length) updateCaretPosition(_caretPos);
						else updateCaretPosition(-1);						
					}					
					return;				
				case Keyboard.BACKSPACE:
					if((_tf.text.length==0) || (_caretPos<0) ) return;
					if(_selection) {
						updateCaretPosition(_tf.selectionBeginIndex-1);
						_tf.replaceSelectedText('');
						updateSelection();
					} else {
						_tf.replaceText(_caretPos,_caretPos+1,'');
						updateCaretPosition(_caretPos-1);
					}					
					return;
			}			
			
			
			if( _tf.text.length >= _tf.maxChars ) {
				return;
			}
			
			var str:String = getCharFromEvent(evt);
			var i:int = _caretPos + 1;
			
			if( str ) {
				
				if(_selection) {
					str = _tf.text.substr(0,_tf.selectionBeginIndex) + str + _tf.text.substr(_tf.selectionEndIndex);
					i = _tf.selectionBeginIndex;
				} else {
					str = _tf.text.substr(0,_caretPos+1) + str + _tf.text.substr(_caretPos+1);
				}				
				
				var len:int = str.length;
				
				if( _textModifier as Function) str = _textModifier(str);
				_tf.text = str;
				
				len = str.length - len;
				
				updateCaretPosition( i + len );
				updateSelection();
			}
		}
		
		private function getCharFromEvent( evt:KeyboardEvent ):String
		{
			var str:String = String.fromCharCode( evt.charCode );
			
			if( _strReg ) {
				if( str.match(_strReg) ) {
					return str;
				} else {
					return null;
				}				
			} else {
				return str;
			}
		}
		
		private function mouseDownHandler( evt:MouseEvent ):void
		{
			if(!hasFocus) hasFocus = true;
			
			var ci:int = _tf.getCharIndexAtPoint( evt.localX, evt.localY )-1;
			
			if( ci >= 0 ) {
				updateCaretPosition( ci );
			} else {
				if( _tf.text.length ) {
					var r:Rectangle = _tf.getCharBoundaries(0);
					if( evt.localX <= r.x ) {
						updateCaretPosition(-1);
					} else {
						updateCaretPosition(_tf.text.length-1);
					}
				} else {
					updateCaretPosition(-1);
				}
			}
			
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			
			updateSelection();
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );			
		}		
		
		private function mouseMoveHandler( evt:MouseEvent ):void
		{
			var i:int = _tf.getCharIndexAtPoint(evt.localX, evt.localY);
			if( i != -1 ) {
				var selMin:int = Math.min(_caretPos+1, i); 
				var selMax:int = Math.max(_caretPos+1, i);
			} else {
				if(evt.localX >= _tf.textWidth) {
					selMin = _caretPos+1;
					selMax = _tf.length;
				}				
			}
			
			updateSelection(selMin,selMax);	

		}
		
		private function mouseDoubleClickHandler( evt:MouseEvent ):void
		{
			updateSelection(0,_tf.length);
		}
		
		private function mouseOutHandler( evt:MouseEvent ):void
		{
			evt.preventDefault();
			Mouse.show();
			if(contains(_textCursor)) removeChild(_textCursor);
			_textCursor.stopDrag();		
		}
		
		private function mouseOverHandler( evt:MouseEvent ):void
		{
			evt.preventDefault();
			Mouse.hide();
			addChild(_textCursor);
			_textCursor.startDrag(true);
			_textCursor.x = evt.localX;
			_textCursor.y = evt.localY;
		}		
		
		private function inputHandler( evt:Event ):void
		{
			evt.stopImmediatePropagation();
			evt.preventDefault();
		}
		
		private function replaceOriginal():void
		{
			if(_tf.parent) {
				_tf.parent.addChild(this);
				addChild(_tf);
			}
		}
		
		private function updateSelection( bi:int = -1, ei:int = -1 ):void
		{
			_tf.setSelection(bi,ei);
			if( ei-bi>0 ) {
				setEditCursorVisible(false);
				_selection = true;
			} else {
				_selection = false;
				if(hasFocus) setEditCursorVisible(true);
			}
		}
		
		private function updateCaretPosition( index:int ):void
		{
			if( index < -1 ) index = -1;
			if( index > _tf.text.length-1 ) index = _tf.text.length-1;
			
			_caretPos = index;
			var r:Rectangle;
			var o:Point;
			
			if( _caretPos != -1 ) {
				r = _tf.getCharBoundaries( _caretPos );
				o = new Point(r.x,r.y);
				o = _tf.localToGlobal(o);
				o = globalToLocal(o);
				_editCursor.x = o.x + r.width-1;
				_editCursor.y = o.y - 2;				
			} else {
				if(_tf.length == 0 ) {
					_tf.text = ' ';
					r = _tf.getCharBoundaries( 0 );
					_tf.text = '';
					o = new Point(r.x,r.y);
					o = _tf.localToGlobal(o);
					o = globalToLocal(o);
					_editCursor.x = o.x - r.width-1;
					_editCursor.y = o.y - 2;					
				} else {
					r = _tf.getCharBoundaries( 0 );
					o = new Point(r.x,r.y);
					o = _tf.localToGlobal(o);
					o = globalToLocal(o);
					_editCursor.x = o.x - 1;
					_editCursor.y = o.y - 2;					
				}
			}
		}		
	}
}

import flash.display.*;

class TextCursor extends Sprite {
	
	private var _s:Shape;
	
	function TextCursor()
	{
		mouseEnabled = false;
		mouseChildren = false;
		
		_s = new Shape();
		addChild(_s);
		
		var g:Graphics = _s.graphics;
		g.lineStyle( 0, 0x000000, 1 );
		g.lineTo( 2, 0 );
		g.moveTo( 3, 0 );
		g.lineTo( 5, 0 );
		
		g.moveTo( 2.4, 1 );
		g.lineTo( 2.4, 15 );
		
		g.moveTo( 0, 15 );		
		g.lineTo( 2, 15 );
		g.moveTo( 3, 15 );
		g.lineTo( 5, 15);
		
		_s.y = -_s.height/2;
		_s.x = -_s.width/2;
	}
}

import flash.events.*;
import flash.utils.*;

class EditCursor extends Sprite {

	private var _s:Shape;
	private var _timId:uint;
	
	function EditCursor()
	{

		mouseEnabled = false;
		mouseChildren = false;
		
		_s = new Shape();
		addChild(_s);		
		
		var g:Graphics = graphics;
		g.lineStyle( 0, 0x000000, 1 );
		g.lineTo( 0, 15 );
		
		addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler );
	}
	
	private function blink():void
	{
		visible = !visible;
	}
	
	private function addedToStageHandler( evt:Event ):void
	{
		clearTimeout( _timId );
		_timId = setInterval( blink , 500 );
	}
	
	private function removedFromStageHandler( evt:Event ):void
	{
		clearInterval( _timId );		
	}
	
}
