package org.bigbluebutton.core.model
{
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import org.bigbluebutton.core.B3Event;

	public class Connection extends EventDispatcher
	{
		private var nc:NetConnection = null;
		private var name:String = null;
		private var url:String = null;
		private var connected:Boolean = false;
		private var disp:IEventDispatcher;
		private var errorEvent:B3Event;
		
		public function Connection(name:String, url:String)
		{
			this.name = name;
			this.url = url;
			errorEvent = new B3Event("connectionErrorEvent");
			errorEvent.payload['name'] = name;
			errorEvent.payload['url'] = url;
		}
		
		public function getName():String {
			return name;
		}
		
		public function getUrl():String {
			return url;
		}
		
		public function isConnected():Boolean {
			return nc.connected;
		}
		
		public function connect():void {
			nc = new NetConnection();
			nc.client = this;
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			nc.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			nc.connect(url);
		}
		
		public function disconnect():void {
			nc.close();
		}
		
		private function onAsyncError(event:AsyncErrorEvent):void {
			throwError("asyncErrorEvent");
		}
		
		private function throwError(type:String):void {
			errorEvent.payload['type'] = type;
			dispatchEvent(errorEvent);		
		}
		
		private function onIOError(event:NetStatusEvent):void {
			throwError("ioErrorEvent");
		}
		
		private function onSecurityError(event:NetStatusEvent):void{
			throwError("securityErrorEvent");
		}
		
		private function onNetStatus(event:NetStatusEvent):void {
			switch(event.info.code){
				case "NetConnection.Connect.Failed":
					throwError("connectFailedEvent");
					break;
				case "NetConnection.Connect.Success":
					var connEvent:B3Event = new B3Event("connectedEvent");
					connEvent.payload['name'] = name;
					connEvent.payload['url'] = url;
					dispatchEvent(connEvent);
					break;
				case "NetConnection.Connect.Rejected":
					throwError("connectRejectedEvent");
					break;
				case "NetConnection.Connect.Closed":
					throwError("connectionClosedEvent");
					break;
				case "NetConnection.Connect.InvalidApp":
					throwError("invalidAppEvent");
					break;
				case "NetConnection.Connect.AppShutdown":
					throwError("appShutdownEvent");
					break;
			}
		}
	}
}