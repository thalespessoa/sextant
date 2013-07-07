package br.com.sexframework.erros 
{
	
	/**
	 * ...
	 * @author Thales Pessoa | contato@thalespessoa.com.br
	 * @version 0.0.1
	 */
	public class SexError extends Error
	{		
		public function SexError( message:String, id:uint ) 
		{
			super( message, id );
		}
		
		public function toString():String 
		{
			return "[SEXTANT ERROR #" + errorID + "] " + message;
		}
	}	
}