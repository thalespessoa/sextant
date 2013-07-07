package br.com.sexframework.api 
{
	
	/**
	 * Interface de VariableInfo
	 * @author contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public interface IVariable 
	{
		/**
		 * Nome da variável indicado no xml de configuração
		 */
		function get name():String;
		
		/**
		 * Valor da variável
		 */
		function get value():String;
		function set value( value:String ):void;
	}	
}