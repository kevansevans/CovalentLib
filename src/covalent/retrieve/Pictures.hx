package retrieve;

/**
 * ...
 * @author Kaelan
 */
class Pictures 
{

	public static function getPointers(_location:Int):Array<Int>
	{
		var items:Array<Int> = [];
		
		var rom = Main.rom;
		var pos:Int = _location;
		var item:Int = 0;
		var count:Int = 0;
		
		while (item < Main.bankRange) {
			trace(count, StringTools.hex(rom.get(pos) << 8 | rom.get(pos + 1)));
			pos += 2;
			item += 2;
			++count;
		}
		
		return items;
	}
	
}