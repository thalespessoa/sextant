package br.com.sexframework.api 
{
	import br.com.sexframework.vo.PageInfo;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * Interface para todas páginas do site
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public interface ISexPage 
	{
		/**
		 * Informações da página
		 */
		function get pageInfo():IPageInfo;
		function set pageInfo( value:IPageInfo ):void;
		
		function get parent():DisplayObjectContainer;
		
		function get view():DisplayObject;
		
		/**
		 * Este método deve conter ações de iniciação da página. No final deve ser disparado o evento SexEvent.INIT_COMPLETE, com o pageInfo da página como parametro.
		 * Este método é chamado pelo Sextant automaticamente, antes da página ser adicionada no stage
		 * @param	param	Parametros enviados via Query string
		 */
		function init():void;
		
		/**
		 * Este método deve conter a animação de entrada da página. No final deve ser disparado o evento SexEvent.SHOW_COMPLETE, com o pageInfo da página como parametro.
		 * Este método é chamado pelo Sextant automaticamente, depois da página ser adicionada no stage
		 * @param	param	Parametros enviados via Query string
		 */
		function show( param:Object = null ):void;
		
		/**
		 * Este método é chamado quando o valor da Query string é modificado. No final deve ser disparado o evento SexEvent.UPDATE_COMPLETE, com o pageInfo da página como parametro.
		 * Este método é chamado pelo Sextant automaticamente
		 * @param	param	Parametros enviados via Query string
		 */
		function update( param:Object ):void;
		
		/**
		 * Este método deve conter a animação de saida da página. No final deve ser disparado o evento SexEvent.HIDE_COMPLETE, com o pageInfo da página como parametro.
		 * Este método é chamado pelo Sextant automaticamente, antes da página ser removida do stage
		 * @param	param	Parametros enviados via Query string
		 */
		function hide():void;
		
		/**
		 * Este método deve conter ações de 'dispose' da página.
		 * Este método é chamado pelo Sextant automaticamente, depois da página ser removida do stage
		 * @param	param	Parametros enviados via Query string
		 */
		function dispose():void;
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void;
	}	
}