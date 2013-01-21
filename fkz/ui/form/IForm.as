package fkz.ui.form 
{
	
	/**
	 * Common methods for Form components
	 * @author Francois.Gillet
	 */
	public interface IForm 
	{
		function get value()			:String;
		function set value(s:String)	:void
		function get isEmpty()			:Boolean;
		function setErrorState()		:void;
	}
	
}