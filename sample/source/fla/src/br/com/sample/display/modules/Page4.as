package br.com.sample.display.modules 
{
	import br.com.sexframework.core.Sextant;
	import br.com.sexframework.view.SexPage;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author contato@thalespessoa.com.br
	 */
	public class Page4 extends SexPage
	{
		private var _text:Sprite;
		
		public function Page4() 
		{
			
		}	
		
		override public function init():void 
		{
			alpha = 0;
			
			var textClass:Class = ApplicationDomain.currentDomain.getDefinition("Page4Text") as Class;
			_text = new textClass() as Sprite;
			addChild( _text );
			configColorMenu();
			
			onInit();
		}
		
		override public function show(param:Object = null):void 
		{
			TweenMax.to( this, .5, { alpha:1, onComplete:onShow } );
			param && param.color ? changeColor( param.color ) : changeColor( null );
		}
		
		override public function update(param:Object):void 
		{
			param && param.color ? changeColor( param.color ) : changeColor( null );
			onUpdate();
		}
		
		override public function hide():void 
		{
			TweenMax.to( this, .5, { alpha:0, onComplete:onHide } );
		}
		
		private function changeColor( color:* ):void
		{
			TweenMax.to( _text, .5, { tint:color } );
		}
		
		private function configColorMenu():void
		{
			var colorMenuClass:Class = ApplicationDomain.currentDomain.getDefinition("ColorMenu") as Class;
			var colorMenu:MovieClip = new colorMenuClass() as MovieClip;
			colorMenu.y = _text.height + 5;
			addChild( colorMenu );
			
			colorMenu.redButton.addEventListener( MouseEvent.CLICK, function():void { Sextant.navigateTo(pageInfo.id, {color:0xFF0000}); } );
			colorMenu.greenButton.addEventListener( MouseEvent.CLICK, function():void { Sextant.navigateTo(pageInfo.id, {color:0x006600}); } );
			colorMenu.blueButton.addEventListener( MouseEvent.CLICK, function():void { Sextant.navigateTo(pageInfo.id, {color:0x0000CC}); } );
		}
	}	
}