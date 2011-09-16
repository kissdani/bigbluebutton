package org.bigbluebutton.core.model
{
	import flash.net.NetStream;

	public class SubscribedStream extends Stream
	{
		private var conn:Connection;
		
		public function SubscribedStream(conn:Connection)
		{
			this.conn = conn;	
		}
	}
}