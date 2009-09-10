package
{
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.text.TextField;
	
	
	public class ExperimentOne extends Sprite
	{
		private var stream 				: URLStream;
		private var _loader				: Loader;
		private var atypicalLoaderArea 	: Sprite;
		private var typicalLoaderArea 	: Sprite;
		private var typicalLoadComplete	: Boolean = false;
		private var atypicalLoadComplete: Boolean = false;
		function ExperimentOne() 
		{
		
			log("Experiment One")
			setupLayout();
			loadViaUrlStream();
			loadViaTypicalLoader();
			
		}
		
		private function setupLayout():void
		{
			log("Experiment One.setupLayout()")
			
			typicalLoaderArea = new Sprite();
			typicalLoaderArea.x = 0;
			atypicalLoaderArea = new Sprite();
			atypicalLoaderArea.x = 400;
		
			
			drawBounding( typicalLoaderArea );
			drawBounding( atypicalLoaderArea );
			addTextField( "<font size=\"18\">Typical :Loader load</font>", typicalLoaderArea );
			addTextField( "<font size=\"18\">Atypical :URLStream load</font>", atypicalLoaderArea);
			
			addChild(typicalLoaderArea);
			addChild(atypicalLoaderArea);
			
			
			
			
		}
		
		private function addTextField( s : String, spr : Sprite ) : void
		{
			var t : TextField = new TextField();
			t.htmlText = s;
			t.width = 200;
			spr.addChild(t);
			
		}
		
		private function drawBounding( s : Sprite):void
		{
			s.graphics.lineStyle( 3, 0x0 );
			s.graphics.beginFill( 0,0);
			s.graphics.drawRect(0,0,400,300);
			s.graphics.endFill();
		}
		
		private function loadViaTypicalLoader() : void
		{
			var loader :Loader = new Loader(Event.COMPLETE, typicalcompleteHandler);
			typicalLoaderArea.addChild(loader);
			loader.addEventListener( )
			loader.load( new URLRequest("http://extralongfingers.com/swf/versionByteManipulation/ExperimentOne/ExperimentOne_Version8_BlueCircle.swf"))
			
		}
		
		
		private function loadViaUrlStream():void
		{
			stream = new URLStream();
			stream.addEventListener(Event.COMPLETE, completeHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			stream.load( new URLRequest("http://extralongfingers.com/swf/versionByteManipulation/ExperimentOne/ExperimentOne_Version8_BlueCircle.swf"))
		
		}
		private function typicalcompleteHandler(e : Event):void
		{
			typicalLoadComplete = true;
			if( typicalLoadComplete && atypicalLoadComplete) discernResults();
		}
		
		private function completeHandler(e : Event):void
		{
			atypicalLoadComplete = true;
			var swfBytes : ByteArray = new ByteArray();
			stream.readBytes(swfBytes);
			stream.close();
			swfBytes.endian = Endian.LITTLE_ENDIAN;
			
			if( isCompressed( swfBytes ) ) uncompress( swfBytes );
			
			updateVersion( swfBytes, 9 );
			_loader = new Loader();
			_loader.loadBytes( swfBytes);
			atypicalLoaderArea.addChild(_loader);
			if( typicalLoadComplete && atypicalLoadComplete) discernResults();
			
			
		}
		private function discernResults():void
		{
			
		}
		
		private function updateVersion( b : ByteArray, version : uint ):void
		{
			b[3] = version;
		}
		
		private function isCompressed(bytes:ByteArray):Boolean
		{
			log("ExperimentOne.isCompressed()");

			return bytes[0] == 0x43;
		}
		
		private function uncompress(bytes:ByteArray):void
		{
			log("ExperimentOne.uncompress()");
			var cBytes : ByteArray = new ByteArray();
			cBytes.writeBytes(bytes, 8);
			bytes.length = 8;
			bytes.position = 8;
			cBytes.uncompress();
			bytes.writeBytes(cBytes);
			bytes[0] = 0x46;
			cBytes.length = 0;
		}
		
		private function ioErrorHandler( e : IOErrorEvent):void
		{
			log( e.toString());
		}
		
		private function securityErrorHandler( e : SecurityErrorEvent):void
		{
			log( e.toString());
		}
		
		
		
		
		
		
		private function log(s : String ) : void
		{
			trace( s );
			
		}
	}
}