package org.bigbluebutton.core
{
	import flash.events.Event;
	
	public class B3Event extends Event
	{
		public var payload:Object = new Object();
		
		public function B3Event(type:String, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}