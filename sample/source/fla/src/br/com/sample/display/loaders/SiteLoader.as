package br.com.sample.display.loaders 
{
	import br.com.sexframework.api.ISexLoader;
	import br.com.sexframework.core.Sextant;
	import br.com.sexframework.vo.PageInfo;
	import br.com.sexframework.view.SexLoader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author contato@thalespessoa.com.br
	 */
	public class SiteLoader extends SexLoader
	{
		private var _stage:Stage;
		override public function set percent( value:Number ):void { TweenMax.to( this, .1, { scaleX:value, onComplete:onShow } ); }
		
		public function SiteLoader( stage:Stage ) 
		{
			_stage = stage;
			create();
		}
		
		private function create():void
		{
			graphics.beginFill( 0x000000 );
			alpha = 0;
			graphics.drawRect( 0, 0, _stage.stageWidth, 3 );
			graphics.endFill();
		}
		
		override public function show():void
		{
			trace("SiteLoader.show");
			scaleX = 0;
			alpha = 1;
			onShow();
			//TweenMax.to( this, .3, { scaleX:0, alpha:1, onComplete:onShow } );
		}
		
		override public function hide():void
		{
			trace("SiteLoader.hide");
			TweenMax.to( this, .3, { alpha:0, onComplete:onHide } );
		}
	}	
}