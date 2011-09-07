////////////////////////////////////////////////////////////////////////////////
//
//  SECRET SIGNAL
//  VERSION: 1.1
//  DATE: 2011-09-07
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package lt.joncys.keyboard
{
    import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	/**
	 * SecretSignal is a class, that listens for keyboard input and fires
	 * a callback function when it detects, that a secret (or not really)
	 * code has been entered by the user.
	 * 
	 * @author Simonas Jončys
	 *         http://www.joncys.lt/
	 * @edited Paulius Uza
	 * 		   http://www.uza.lt
	 * 
	 * @version 1.1
	 */
	
	public class SecretSignal extends EventDispatcher
	{
		
		private var _stage:Stage;
		private var _triggers:Dictionary;
		private var _currentString:String;
		
		/**
		 * Creates the SecretSignal Object to listen for the signal input.
		 * 
		 * @param  stageReference    Reference to the global stage (for keyboard event listening).
		 * @param  target    		 Parent IEventDispatcher.
		 */
		
		public function SecretSignal(stageReference:Stage, target:IEventDispatcher=null)
		{
			super(target);
			reset();
			_triggers = new Dictionary(true);
			_stage = stageReference;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyboardKeyDown);
		}
		
		/**
		 * Listen for the signal input.
		 * 
		 * @param  value             Value (String expresion) of the signal that needs to be entered.
		 * @param  callback          Callback function to call when the signal is completed.
		 */
		
		public function addTrigger(value:String, callback:Function = null):void
		{
			if(callback == null) {
				callback = this._void;
			}
			_triggers[value] = callback;
		}
		
		/**
		 * Remove signal input.
		 * 
		 * @param  value             Value (String expresion) of the signal that needs to be entered.
		 */
		
		public function removeTrigger(value:String):void {
			_triggers[value] == null;
		}
		
		/**
		 * Resets the current string
		 * @private
		 */
		
		public function reset():void {
			_currentString = '';
		}
		
		/**
		 * Default empty function.
		 * @private
		 */
		
		public function _void():void {
			// leave empty or extend
		}
		
		/**
		 * Keyboard event handler.
		 * @private
		 */
		protected function _keyboardKeyDown(event:KeyboardEvent):void
		{            
			
			// IGNORE A SHIFT PLEASE.
			if (event.keyCode == Keyboard.SHIFT)
				return;
			
			// ADD CHAR TO STRING
			var typedChar:String = String.fromCharCode(event.charCode);
			_currentString += typedChar;
			
			// CHECK IF WE FOUND A STRING
			for (var k:String in _triggers) {
				var fn:Function=_triggers[k];
				if(_currentString == k) {
					if(fn != null) {
						dispatchEvent(new SecretSignalEvent(SecretSignalEvent.TRIGGER, _currentString));
						fn();
						reset();
					}
					break;
				}
			}
		}
	}
}

import flash.events.Event;

class SecretSignalEvent extends Event
{
	
	public static const TRIGGER:String = 'trigger';
	private var _trigger:String = '';
	
	public function SecretSignalEvent(type:String, trigger:String, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		_trigger = trigger;
		super(type, bubbles, cancelable);
	}
	
	public function trigger():String {
		return _trigger;
	}
}