package utils;

class Maths {
	public static function circleUnitsToRads(units:Int, ?wholeCircle:Int = 360):Float {
		return ( 2 * Math.PI *  (units % wholeCircle) / wholeCircle);
	}

	public static function circleUnitsToDegrees(units:Int, ?wholeCircle:Int = 360):Float {
		return ( 360 *  (units % wholeCircle) / wholeCircle);
	}

	public static function GCF(a:Int, b:Int):Int {
		var temp;
		while (b != 0) {
			temp = b;
			b = a % b;
			a = temp;
		}
		return Std.int(Math.abs(a));
	}

	public static function fmod(a:Float, b:Float):Float {
		var result = 0.0;
		if (b != 0.0) {
			b = Math.abs(b);
			var dv = Math.floor(a / b);
			result = a - b * dv;
			if (result < 0.0) {
				result += b;
			}
		}
		return result;
	}
}
