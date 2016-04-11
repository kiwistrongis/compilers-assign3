// std lib imports
import java.util.HashMap;


public class SymbolTable {
	// members
	private HashMap<String, Integer> map;
	private int unique_id = 0;
	private int unique_value = 0;

	// constructor
	public SymbolTable(){
		this.map = new HashMap<String, Integer>();}

	// accessors
	public void set( String id){
		// check if id already defined
		if( this.map.get( id) != null)
			return;
		// define id
		this.map.put( id, new Integer( unique_id++));}

	public int get( String id){
		// get map
		Integer result = this.map.get( id);
		// check for non-definition
		if( result == null)
			throw new RuntimeException(
				String.format( "Error: var %s is undefined", id));
		// return map
		return result.intValue();}

	// generate a unique id
	public String uniq_id(){
		// can't conflict with vars cause
		// it starts with a capital :D
		String result = String.format(
			"X%s", Integer.toString( unique_id++, 16));
		this.set( result);
		return result;}

	// get neccessary stack size maybe?
	public int size(){
		return map.size();}
}