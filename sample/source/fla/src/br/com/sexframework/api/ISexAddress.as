package br.com.sexframework.api 
{
	
	/**
	 * Interface para qualquer adaptador de Deeplinking
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public interface ISexAddress 
	{		
		function get path():String
		function get param():Object
		
		function change( path:String, param:Object ):void		
		function init( homeHash:String ):Boolean	
	}	
}