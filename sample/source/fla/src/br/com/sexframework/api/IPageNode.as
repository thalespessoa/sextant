package br.com.sexframework.api 
{
	import flash.events.Event;
	
	/**
	 * Interface para PageNode
	 * @author contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public interface IPageNode 
	{
		/**
		 * Nó representante da página pai
		 */
		function get parent():IPageNode;
		
		/**
		 * Informações da página
		 */
		function get info():IPageInfo;
	}	
}