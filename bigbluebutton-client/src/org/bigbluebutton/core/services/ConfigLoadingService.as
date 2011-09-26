package org.bigbluebutton.core.services
{
	import org.bigbluebutton.common.LogUtil;
	import org.bigbluebutton.main.events.BBBEvent;
	
	public class ConfigLoadingService
	{
		private var loader:URLLoader;
		private var dispatcher:IEventDispatcher;
		
		public ConfigLoadingService(dispatcher:IEventDispatcher) {
			this.dispatcher = dispatcher;	
		}
		
		public function loadConfig():void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var date:Date = new Date();
			loader.load(new URLRequest("conf/config.xml" + "?a=" + date.time));			
		}		
		
		private function handleComplete(e:Event):void{
			var configEvent:BBBEvent = new BBBEvent("ConfigLoadedEvent", true);
			configEvent.payload = new Config(new XML(e.target.data));
			dispatcher.dispatchEvent(configEvent);	
		}
		
		private function errorHandler(e:Event):void {
			LogUtil.error("Failed to load configuration.");
		}
		

	}
}