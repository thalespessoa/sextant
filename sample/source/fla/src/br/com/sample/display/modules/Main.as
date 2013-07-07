package br.com.sample.display.modules 
{
	import br.com.sample.display.loaders.InternalLoader;
	import br.com.sample.display.loaders.SiteLoader;
	import br.com.sexframework.api.ISexLoader;
	import br.com.sexframework.core.Sextant;
	import br.com.sexframework.events.SexEvent;
	import br.com.sexframework.view.SexPage;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 */
	public class Main extends SexPage
	{
		private var _base:MovieClip;
		
		public function Main() 
		{
			
		}
		
		override public function init():void 
		{
			var baseClass:Class = ApplicationDomain.currentDomain.getDefinition("BaseMain") as Class;
			_base = new baseClass() as MovieClip;
			addChild( _base );
			
			containerSubPages = _base.container;
			_base.button1.addEventListener( MouseEvent.CLICK, function():void { Sextant.navigateTo("page1"); } );
			_base.button2.addEventListener( MouseEvent.CLICK, function():void { Sextant.navigateTo("page2"); } );
			_base.button3.addEventListener( MouseEvent.CLICK, function():void { Sextant.navigateTo("page3"); } );
			_base.button4.addEventListener( MouseEvent.CLICK, function():void { Sextant.navigateTo("page4"); } );
			
			Sextant.addEventListener( SexEvent.SHOW_START, showPageHandler );
			Sextant.addEventListener( SexEvent.HIDE_START, hidePageHandler );
			
			onInit();
		}
		
		override public function show(param:Object = null):void 
		{
			TweenMax.from( this, 1, { alpha:0 } );
			onShow();
		}	
		
		private function showPageHandler(e:SexEvent):void 
		{
			switch( e.pageInfo.id )
			{
				case "page1":	TweenMax.to( _base.button1, .3, { tint:0xFF0000 } ); break;
				case "page2":	TweenMax.to( _base.button2, .3, { tint:0xFF0000 } ); break;
				case "page3":	TweenMax.to( _base.button3, .3, { tint:0xFF0000 } ); break;
				case "page4":	TweenMax.to( _base.button4, .3, { tint:0xFF0000 } ); break;
			}
		}
		
		private function hidePageHandler(e:SexEvent):void 
		{
			switch( e.pageInfo.id )
			{
				case "page1":	TweenMax.to( _base.button1, .3, { tint:null } ); break;
				case "page2":	TweenMax.to( _base.button2, .3, { tint:null } ); break;
				case "page3":	TweenMax.to( _base.button3, .3, { tint:null } ); break;
				case "page4":	TweenMax.to( _base.button4, .3, { tint:null } ); break;
			}
		}
	}	
}