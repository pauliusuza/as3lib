////////////////////////////////////////////////////////////////////////////////
//
//  SECRET SIGNAL
//  VERSION: 1.0
//  DATE: 2011-07-17
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
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    /**
    * SecretSignal is a class, that listens for keyboard input and fires
    * a callback function when it detects, that a secret (or not really)
    * code has been entered by the user.
    * 
    * @author Simonas Jončys
    *         http://www.joncys.lt/
    * 
    * @version 1.0
    */
    public class SecretSignal extends EventDispatcher
    {
        
        private var _stage:Stage;
        private var _signalValue:String;
        private var _callbackFunction:Function;
        private var _currentCharacter:uint;
        
        /**
        * Creates the SecretSignal Object to listen for the signal input.
        * 
        * @param  value             Value (String expresion) of the signal that needs to be entered.
        * @param  callback          Callback function to call when the signal is completed.
        * @param  stageReference    Reference to the global stage (for keyboard event listening).
        */
        public function SecretSignal(value:String, callback:Function, stageReference:Stage)
        {
            _stage = stageReference;
            _signalValue = value;
            _callbackFunction = callback;
            _currentCharacter = 0;
            
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyboardKeyDown);
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
            
            var typedChar:String = String.fromCharCode(event.charCode);
            
            if (typedChar == _signalValue.charAt(_currentCharacter))
                _currentCharacter ++;
            else
                _currentCharacter = 0;
            
            if (_currentCharacter == _signalValue.length)
                _signalReceived();
        }
        
        /**
        * Called when the signal is fully entered.
        * @private
        */
        private function _signalReceived():void
        {
            // DISPOSE OF THE EVIDENCE
            _stage.removeEventListener(KeyboardEvent.KEY_DOWN, _keyboardKeyDown);
            
            _stage = null;
            _signalValue = null;
            _currentCharacter = 0;
            
            // EXECUTE CALLBACK
            _callbackFunction();
        }
    }
}