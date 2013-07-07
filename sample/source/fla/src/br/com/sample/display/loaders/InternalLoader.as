package br.com.sample.display.loaders 
{
	import br.com.sexframework.view.SexLoader;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author contato@thalespessoa.com.br
	 */
	public class InternalLoader extends SexLoader
	{
		override public function set percent( value:Number ):void { TweenMax.to( this, .1, { scaleX:value, onComplete:onShow } ); }
		
		public function InternalLoader() 
		{
			create();
		}
		
		private function create():void
		{
			graphics.beginFill( 0x000000 );
			x = 200;
			y = 5;
			alpha = 0;
			graphics.drawRect( 0, 0, 100, 10 );
			graphics.endFill();
		}
		
		override public function show():void
		{
			trace("InternalLoader.show");
			TweenMax.to( this, .3, { scaleX:0, alpha:1, onComplete:onShow } );
		}
		
		override public function hide():void
		{
			trace("InternalLoader.hide");
			TweenMax.to( this, .3, { alpha:0, onComplete:onHide } );
		}
	}	
}