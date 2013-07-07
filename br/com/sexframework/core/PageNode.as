package br.com.sexframework.core
{
	import br.com.sexframework.api.IPageInfo;
	import br.com.sexframework.api.IPageNode;
	import br.com.sexframework.api.ISexLoader;
	import br.com.sexframework.erros.SexError;
	import br.com.sexframework.events.SexEvent;
	import br.com.sexframework.api.ISexPage;
	import br.com.sexframework.events.SexLoaderEvent;
	import br.com.sexframework.vo.AssetInfo;
	import br.com.sexframework.vo.PageInfo;
	import br.com.sexframework.vo.VariableInfo;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.4
	 */
	internal class PageNode implements IPageNode
	{
		static internal const METHOD_OPEN:String = "open";
		static internal const METHOD_CLOSE:String = "close";
		static internal const METHOD_UPDATE:String = "update";
		
		private var _pageInfo:IPageInfo;
		private var _subPages:Tree;
		private var _parentNode:PageNode;
		private var _param:*;
		private var _dispatcher:EventDispatcher;
		
		public function get info():IPageInfo { return _pageInfo; }	
		public function get parent():IPageNode { return _parentNode; }	
		public function get fullHash():String { return info.fullHash; }
		internal function get subPages():Tree { return _subPages; }		
		
		
		/**
		 * 
		 * @param	info
		 * @param	parentNode
		 */
		public function PageNode( info:XML, parentNode:PageNode )
		{
			var assets:Array = [];
			var vars:Object = {};
			
			_parentNode = parentNode;
			_subPages = new Tree();
			_dispatcher = new EventDispatcher();			
			
			var len:uint = info.variable.length();
			
			for ( var j:uint = 0; j < len; j++ )
				vars[info.variable[j].@name] = new VariableInfo(info.variable[j].@name, info.variable[j].@value);
			
			len = info.asset.length();
			for ( j = 0; j < len; j++ )
				assets[j] = new AssetInfo( info.asset[j].@name, info.asset[j].@src, info.asset[j].@type, info.asset[j].@useCache != "false" );
				
			_pageInfo = new PageInfo( info.@id, info.@title, info.@className, info.@hash, assets, vars, this, info.@singleton == "true", info.@remove == "true" );			
			_pageInfo.state = PageInfo.STATE_DESACTIVE;
		}
		
		public function toString():String 
		{
			return "[PageNode id: " + info.id + "]";
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// internal
		//--------------------------------------------------------------------------------------------------------------
		
		internal function open( param:* = null ):void 
		{
			_param = param;
			load();			
			
			if ( _parentNode )
				_parentNode.subPages.currentPage = info;		
		}
		
		internal function close():void 
		{
			info.state = PageInfo.STATE_HIDE;	
			_parentNode.subPages.currentPage = null;
			
			if ( _subPages.currentPage )
			{
				PageNode( _subPages.currentPage.node ).addEventListener( TransitionEvent.HIDDEN, onCloseSubPages );
				PageNode( _subPages.currentPage.node ).close();
			}
			else
			{
				info.containerSubPages = null;
				Sextant.dispatchEvent( new SexEvent( SexEvent.HIDE_START, info ) );
				info.page.hide();
			}
		}
		
		internal function update( param:* = null ):void 
		{
			Sextant.dispatchEvent( new SexEvent( SexEvent.UPDATE_START, info ) );
			trace( "info", info );
			trace( "info.page", info.page );
			info.page.update(param);			
		}
		
		internal function closeLoad():void
		{
			var loader:ISexLoader = info.loader || Sextant.defaultLoader;
			loader.hide();
			Sextant.massLoader.close();
			Sextant.massLoader.removeEventListener( Sextant.massLoader.completeEvent, onLoadPage );
			Sextant.massLoader.removeEventListener( Sextant.massLoader.progressEvent, onProgress );
			
			loader.addEventListener( TransitionEvent.HIDDEN, onHiddenLoaderToClose );
			loader.removeEventListener( SexLoaderEvent.LOAD_COMPLETE, onLoadPage );
		}
		
		internal function addEventListener( type:String, listener:Function ):void
		{
			_dispatcher.addEventListener( type, listener );
		}
		
		internal function dispatchEvent( event:TransitionEvent ):void
		{
			_dispatcher.dispatchEvent(event);
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// private
		//--------------------------------------------------------------------------------------------------------------
		
		private function showPage():void
		{
			Sextant.dispatchEvent( new SexEvent( SexEvent.INIT_START, info ) );
			createPage();
			
			//ADICIONAR ERRO DE TIPO
			
			
			if ( !info.containerSubPages )
				info.containerSubPages = info.page.view as DisplayObjectContainer;				
				
			addEventListener( TransitionEvent.HIDDEN, onHiddenPage );
			addEventListener( TransitionEvent.INITIED, onInitiedPage );
			
			if ( _parentNode && _parentNode.info )
				_parentNode.info.containerSubPages.addChild( info.page.view );
			else
				Sextant.stage.addChild( info.page.view );
				
			info.page.init();
		}
		
		private function createPage():void
		{
			if ( !ApplicationDomain.currentDomain.hasDefinition( info.className ) ) throw new SexError( "A classe '" + info.className + "' não foi importada!", 1 );
			
			var ClassPage:Class = ApplicationDomain.currentDomain.getDefinition( info.className ) as Class;
			var node:PageNode = this;
			
			info.page = new ClassPage() as ISexPage;
			
			if ( !info.page ) throw new SexError( "A classe '" + info.className + "' deve implementar 'br.com.sexframework.api.ISexPage'!", 2 );
			
			info.page.pageInfo = info;
			
			info.page.addEventListener( SexEvent.INIT_COMPLETE, function():void { 
				node.dispatchEvent( new TransitionEvent( TransitionEvent.INITIED ) ); } );
			info.page.addEventListener( SexEvent.SHOW_COMPLETE, function():void { 
				info.state = PageInfo.STATE_ACTIVE;
				Sextant.dispatchEvent( new SexEvent( SexEvent.SHOW_COMPLETE, info ) );
				node.dispatchEvent( new TransitionEvent( TransitionEvent.SHOWED ) );} );
			info.page.addEventListener( SexEvent.UPDATE_COMPLETE, function():void { 
				Sextant.dispatchEvent( new SexEvent( SexEvent.UPDATE_COMPLETE, info ) );
				node.dispatchEvent( new TransitionEvent( TransitionEvent.UPDATED ) );} );
			info.page.addEventListener( SexEvent.HIDE_COMPLETE, function():void { 
				Sextant.dispatchEvent( new SexEvent( SexEvent.HIDE_COMPLETE, info ) );
				node.dispatchEvent( new TransitionEvent( TransitionEvent.HIDDEN ) );} );
		}
		
		private function load():void
		{
			var loader:ISexLoader = info.loader || Sextant.defaultLoader;
			
			if ( !filesAreLoaded() )
				prepareLoad();			
			
			if (loader && Sextant.massLoader.hasQueue)
			{
				Sextant.massLoader.addEventListener( Sextant.massLoader.progressEvent, onProgress );
				Sextant.massLoader.addEventListener( Sextant.massLoader.completeEvent, onLoadPageWithLoader );
			}
			else
			{
				Sextant.massLoader.addEventListener( Sextant.massLoader.completeEvent, onLoadPage );
				Sextant.dispatchEvent( new SexEvent( SexEvent.LOAD_START, info ) );
				Sextant.massLoader.start();
			}
		}
		
		private function prepareLoad():void
		{
			var breadCrumb:Array = Sextant.breadCrumb;
			var pagesToLoad:Array = breadCrumb.slice(breadCrumb.indexOf(this)-1, breadCrumb.length);
			var loader:ISexLoader = info.loader || Sextant.defaultLoader;
			
			info.state = PageInfo.STATE_LOADING;
			addFilesToLoad(Sextant.mainInfo);
			
			var len:uint = pagesToLoad.length;
			for (var i:uint = 0; i < len; i++) 
			{
				addFilesToLoad( pagesToLoad[i] );
			}
			if (loader && Sextant.massLoader.hasQueue)
			{
				loader.currentPage = info;
				loader.addEventListener( SexLoaderEvent.SHOW_COMPLETE, onLoaderShowed );
				loader.show();
			}
		}
		
		private function onLoaderShowed(e:SexLoaderEvent):void 
		{
			e.currentTarget.removeEventListener( SexLoaderEvent.SHOW_COMPLETE, onLoaderShowed );
			Sextant.dispatchEvent( new SexEvent( SexEvent.LOAD_START, info ) );
			Sextant.massLoader.start();
		}
		
		private function addFilesToLoad( page:IPageInfo ):void
		{
			var assets:Array = page.assets;
			var len:uint = assets.length;
			for (var i:uint = 0; i < len; i++)
				if (!Sextant.massLoader.getItem(assets[i].src))
					Sextant.massLoader.addItem( assets[i].src, assets[i].type );
		}
		
		private function filesAreLoaded():Boolean
		{
			var len:uint = info.assets.length;
			for (var i:uint = 0; i < len; i++)
				if (!Sextant.massLoader.getItem(info.assets[i].src))
					return false;
			
			return true;
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// listeners
		//--------------------------------------------------------------------------------------------------------------
		
		private function onCloseSubPages(e:TransitionEvent):void 
		{
			e.target.removeEventListener( TransitionEvent.HIDDEN, onCloseSubPages );
			close();
		}
		
		private function onProgress(e:Event):void 
		{
			var loader:ISexLoader = info.loader || Sextant.defaultLoader;
			
			if ( loader )
				loader.percent = Sextant.massLoader.percent;
		}
		
		private function onLoadPage(e:Event):void 
		{
			info.state = PageInfo.STATE_SHOW;
			
			e.target.removeEventListener( Sextant.massLoader.completeEvent, onLoadPage );
			Sextant.dispatchEvent( new SexEvent( SexEvent.LOAD_COMPLETE, info ) );
			showPage();	
		}
		
		private function onLoadPageWithLoader(e:Event):void 
		{
			var loader:ISexLoader = info.loader || Sextant.defaultLoader;
			info.state = PageInfo.STATE_SHOW;
			
			Sextant.massLoader.removeEventListener( Sextant.massLoader.progressEvent, onProgress );		
			Sextant.massLoader.removeEventListener( Sextant.massLoader.completeEvent, onLoadPageWithLoader );
			Sextant.dispatchEvent( new SexEvent( SexEvent.LOAD_COMPLETE, info ) );
			
			loader.addEventListener( SexLoaderEvent.HIDE_COMPLETE, onHiddenLoaderToOpen );
			loader.hide();
			loader = null;		
		}
		
		private function onInitiedPage(e:TransitionEvent):void 
		{
			Sextant.dispatchEvent( new SexEvent( SexEvent.INIT_COMPLETE, info ) );
			
			Sextant.dispatchEvent( new SexEvent( SexEvent.SHOW_START, info ) );
			info.page.show( _param );			
		}
		
		private function onHiddenPage(e:TransitionEvent):void 
		{
			info.state = PageInfo.STATE_DESACTIVE;
			e.target.removeEventListener( TransitionEvent.HIDDEN, onHiddenPage );
			info.page.parent.removeChild( info.page.view );
			info.page.dispose();
			info.checkAssestsCache();
			info.page = null;
		}		
		
		private function onHiddenLoaderToOpen(e:SexLoaderEvent):void 
		{
			e.target.removeEventListener( SexLoaderEvent.HIDE_COMPLETE, onHiddenLoaderToOpen );
			showPage();
		}
		
		
		private function onHiddenLoaderToClose(e:TransitionEvent):void 
		{
			e.target.removeEventListener( TransitionEvent.HIDDEN, onHiddenLoaderToClose );
			e.target.removeEventListener( TransitionEvent.HIDDEN, onHiddenLoaderToClose );
			dispatchEvent( new TransitionEvent( TransitionEvent.SHOWED ));
			dispatchEvent( new TransitionEvent( TransitionEvent.HIDDEN ));
			info.state = PageInfo.STATE_DESACTIVE;
			info.containerSubPages = null;
		}
	}
}