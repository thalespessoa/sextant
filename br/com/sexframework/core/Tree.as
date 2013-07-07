package br.com.sexframework.core
{
	import br.com.sexframework.api.IPageInfo;
	import br.com.sexframework.vo.PageInfo;
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	internal class Tree
	{		
		private var _nodes:Array;
		private var _currentPage:IPageInfo;
		
		public function Tree() 
		{
			_nodes = [];
		}
		
		internal function create( nodes:XMLList, parentNode:PageNode ):void
		{
			var pageNode:PageNode;
			var len:uint = nodes.length();
			for (var i:uint = 0; i < len; i++) 
			{
				pageNode = new PageNode( nodes[i], parentNode );
				Sextant.pageList.push( pageNode.info );
				_nodes.push( pageNode );
				
				if ( nodes[i].page )
					pageNode.subPages.create( nodes[i].page, pageNode );
			}
		}
		
		internal function getPageByHash( hash:Array ):Array
		{
			var r:Array = [];
			var len:uint = _nodes.length;
			for (var i:uint = 0; i < len; i++) 
			{
				if ( _nodes[i].info.hash == hash[1] )
				{
					r.push( _nodes[i].info );
					hash.shift();
					r = r.concat( PageNode( _nodes[i] ).subPages.getPageByHash( hash ) );
					break;
				}
			}
			return r;
		}
		
		internal function addChildPages( parentId:String, pages:XMLList ):void
		{
		       var parentNode:PageNode = getPageNodeById( parentId );
		       if ( parentNode ) create( pages, parentNode );
		}	
		
		internal function createStackTransition( breadCrumb:Array ):void
		{			
			TransitionControl.reset();
			if ( !(Sextant.mainInfo.state == PageInfo.STATE_ACTIVE || Sextant.mainInfo.state == PageInfo.STATE_SHOW) )
				TransitionControl.push( Sextant.mainInfo, PageNode.METHOD_OPEN );
				
			switch ( true )
			{
				case Boolean( _currentPage && _currentPage == breadCrumb[0] ):
				{
					breadCrumb.shift();
					if ( !_currentPage.state == PageInfo.STATE_ACTIVE ) 
						TransitionControl.push( _currentPage , PageNode.METHOD_OPEN );
						
					PageNode( _currentPage.node ).subPages.createStackTransition( breadCrumb );
					
					break;
				}
				case Boolean(_currentPage && _currentPage.state < 3):
				{
					if ( _currentPage.state == PageInfo.STATE_LOADING )
						PageNode( _currentPage.node ).closeLoad();
					else
						TransitionControl.push( _currentPage, PageNode.METHOD_CLOSE );
				}
				case Boolean( !_currentPage || ( _currentPage && !_currentPage.state == PageInfo.STATE_ACTIVE) ):
				{
					var len:uint = breadCrumb.length;
					for ( var i:uint = 0; i < len; i++) 
						TransitionControl.push( breadCrumb[i] , PageNode.METHOD_OPEN  );
					break;
				}
			}
		}
		
		private function getPageNodeById( id:String ):PageNode
		{
		       var ret:PageNode;
		       var len:uint = _nodes.length;
		       for (var i:uint = 0; i < len; i++)
		               if ( _nodes[i].info.id == id ) ret = _nodes[i];
		
		       return ret;
		}
		
		internal function get currentPage():IPageInfo { return _currentPage; }
		internal function set currentPage(value:IPageInfo):void 
		{
			_currentPage = value;
		}
	}
}