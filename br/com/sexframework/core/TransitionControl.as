package br.com.sexframework.core
{
	import br.com.sexframework.api.IPageInfo;
	import br.com.sexframework.api.IPageNode;
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	internal class TransitionControl 
	{
		static private var _transitions:Array = [];
		static private var _param:Object;
		static private var _currentTransition:DataTransition;
		static private var _lastTransition:DataTransition;
		
		
		static internal function reset():void
		{
			_transitions = [];
		}
		
		static internal function executeNext():void
		{
			if ( hasNext )
			{
				trace(" --------------: "+_transitions);
				_currentTransition = _transitions.shift();
				
				switch( _currentTransition.method )
				{
					case PageNode.METHOD_OPEN:
					{
						_currentTransition.pageNode.addEventListener( TransitionEvent.SHOWED , onCompleteTransition );	
						break;
					}
					case PageNode.METHOD_CLOSE:
					{
						_currentTransition.pageNode.addEventListener( TransitionEvent.HIDDEN , onCompleteTransition );	
						break;
					}
					case PageNode.METHOD_UPDATE:
					{		
						_currentTransition.pageNode.addEventListener( TransitionEvent.UPDATED , onCompleteTransition );
						break;
					}
				}
				
				_currentTransition.param ? 
					_currentTransition.pageNode[ _currentTransition.method ]( _currentTransition.param ): 
					_currentTransition.pageNode[ _currentTransition.method ]();
			}
		}
		
		static internal function push( pageInfo:IPageInfo, method:String ):void
		{
			if (!_lastTransition || _lastTransition.pageNode != pageInfo.node || _lastTransition.method != method || _lastTransition.method == PageNode.METHOD_UPDATE)
			{
				_lastTransition = new DataTransition( PageNode( pageInfo.node ), method );
				_transitions.push( _lastTransition );
			}
		}
		
		static private function onCompleteTransition( e:TransitionEvent ):void 
		{
			e.target.removeEventListener( e.type , onCompleteTransition );
			_currentTransition = null;
			executeNext();
		}
		
		static private function get hasNext():Boolean
		{
			return _transitions.length > 0;
		}
		
		static internal function get currentTransition():Object { return _currentTransition; }
		
		static 	internal function get param():Object { return _param; }		
		static internal function set param( value:Object ):void 
		{
			_param = value;
			
			if ( !hasNext && !_currentTransition )
			{
				var node:IPageNode = (_lastTransition.method == PageNode.METHOD_CLOSE) ? _lastTransition.pageNode.parent : _lastTransition.pageNode;
				_transitions.push( new DataTransition( PageNode(node), PageNode.METHOD_UPDATE, value ) );
				executeNext();
			}
			else if ( ( !hasNext ) )
			{
				_transitions.push( new DataTransition( _currentTransition.pageNode, PageNode.METHOD_UPDATE, value ) );
			}
			else
			{
				_lastTransition.method == "open" ? 
					_lastTransition.param = value :
					_transitions.push( new DataTransition( PageNode(_lastTransition.pageNode.parent), PageNode.METHOD_UPDATE, value ) );
			}
		}
	}
	
}