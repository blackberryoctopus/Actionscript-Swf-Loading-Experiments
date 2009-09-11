package
{
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.text.TextField;
	
	
	public class ExperimentTwo extends Sprite
	{
		private var stream 				: URLStream;
	
		private var atypicalLoaderArea 	: Sprite;
		private var typicalLoaderArea 	: Sprite;
		private var typicalLoadComplete	: Boolean = false;
		private var atypicalLoadComplete: Boolean = false;
		
		private var typicalLoader 		: Loader;
		private var atypicalLoader		: Loader;
		
		function ExperimentTwo() 
		{
		
			log("Experiment One")
			setupLayout();
			loadViaTypicalLoader();
			loadViaUrlStream();
			
			
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
			log("ExperimentTwo.drawBounding()")
			
			s.graphics.lineStyle( 3, 0x0 );
			s.graphics.beginFill( 0,0);
			s.graphics.drawRect(0,0,400,300);
			s.graphics.endFill();
		}
		
		private function loadViaTypicalLoader() : void
		{
			log("ExperimentTwo.loadViaTypicalLoader()")
			
			typicalLoader = new Loader();
			
			typicalLoaderArea.addChild(typicalLoader);
			typicalLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, typicalcompleteHandler)
			typicalLoader.load( new URLRequest("http://extralongfingers.com/swf/versionByteManipulation/ExperimentOne/ExperimentOne_Version8_BlueCircle.swf"))
			
		}
		
		
		private function loadViaUrlStream():void
		{
			log("ExperimentTwo.loadViaUrlStream()")
			
			stream = new URLStream();
			stream.addEventListener(Event.COMPLETE, completeHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			stream.load( new URLRequest("http://extralongfingers.com/swf/versionByteManipulation/ExperimentOne/ExperimentOne_Version8_BlueCircle.swf"))
		
		}
		private function typicalcompleteHandler(e : Event):void
		{
			log("ExperimentTwo.typicalCompleteHandler()")
			
			typicalLoadComplete = true;
			if( typicalLoadComplete && atypicalLoadComplete) discernResults();
		}
		
		private function completeHandler(e : Event):void
		{
			log("ExperimentTwo.completeHandler()")
			
			var swfBytes : ByteArray = new ByteArray();
			stream.readBytes(swfBytes);
			stream.close();
			swfBytes.endian = Endian.LITTLE_ENDIAN;
			
	
			
			updateVersion( swfBytes, 14 );
			atypicalLoader = new Loader();
			atypicalLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, atypicalcompleteHandler)
			
			atypicalLoader.loadBytes( swfBytes);
			atypicalLoaderArea.addChild(atypicalLoader);
			
			
		}
		
		private function atypicalcompleteHandler( e : Event):void
		{
			atypicalLoadComplete = true;
			if( typicalLoadComplete && atypicalLoadComplete) discernResults();
			
			
		}
		private function discernResults():void
		{
			log("ExperimentTwo.discernResults()")
			var typicalLoaderInfo : LoaderInfo = typicalLoader.contentLoaderInfo;
			var atypicalLoaderInfo : LoaderInfo = atypicalLoader.contentLoaderInfo;
			trace( "typical load : SWF Version : "+String(typicalLoaderInfo.swfVersion));
			trace( "atypical load : SWF Version : "+atypicalLoaderInfo.swfVersion);
			
			addSwfVersionInfoText("<font size=\"18\">Swf Version contentLoaderInfo.swfVersion=<p>"+String(typicalLoaderInfo.swfVersion)+"</font>", typicalLoaderArea )
			addSwfVersionInfoText("<font size=\"18\">Swf Version contentLoaderInfo.swfVersion=<p>"+String(atypicalLoaderInfo.swfVersion)+"</font>", atypicalLoaderArea )
			
		}
		private function addSwfVersionInfoText( version : String, s : Sprite):void
		{
				var t : TextField = new TextField();
				t.htmlText = version;
				t.width = 400;
				t.height = 200;
				t.y = s.height;
				t.x = s.x;
				addChild( t);
				
			
		}
		private function updateVersion( b : ByteArray, version : uint ):void
		{
			b[3] = version;
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