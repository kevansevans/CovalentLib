package data;

import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
class Reader 
{

	public static inline var bankRange:Int = 0x3FFF;
	
	public static function getSprite(_bankOffset:Int, _spriteIndex:Int):Array<Array<Int>> {
		
		var data = Main.romData;
		
		var out:Array<Array<Int>> = [];
		
		for (y in 0...8) {
			var cur = [0, 0, 0, 0, 0, 0, 0, 0];
			for (b in 0...2) {
				for (i in 0...8) {
					var mask = 1 << i;
					cur[7 - i] |= ((data[_bankOffset + _spriteIndex * 16 + y * 2 + b] & mask) >> i) << b;
				}
			}
			out.push(cur);
		}
		
		return out;
	}
	
	public static function readBankData(_bankOffset:Int) {
		
		var list:String = '';
		
		var data = Main.romData;
		
		for (byte in _bankOffset...(_bankOffset + bankRange + 1)) {
			
			var item:String = '${data[byte]} : ${StringTools.hex(data[byte])}\n';
			
			list += item;
			
		}
		
		var text = File.write("./bankDump.txt");
		text.writeString(list);
		text.close();
		
	}
	
	public static function readMapData(_mapStart:Int, _mapEnd:Int) {
		
		var data = Main.romData;
		
		return data.slice(_mapStart, _mapEnd);
	}
	
}