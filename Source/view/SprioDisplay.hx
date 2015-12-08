package view;

import utils.Maths;
import openfl.display.Sprite;
import openfl.geom.Point;

typedef Vertex = {
	vertex: Point,
	?handle1: Point,
	?handle2: Point
}
class SprioDisplay extends Sprite {

	private var size:Float;
	private var numOfTurns:Int;
	private var numOfCycles:Int;
	private var wholeCircle:Int;
	private var angle:Int;
	private var spiroVertexList:Array<Vertex>;
	private var scale:Float;
	private var origin:Point;
	private var turns:Array<Int>;
	private var handleScale:Float = 2.7;
	private var maxTurns:Int = 200;
	private var maxCycles:Int = 100;
	private var minTurns:Int = 3;
	private var minCycles:Int = 2;
	private var center:Point;
	private var rounded:Bool;
	private var regPoint:Point;


	public function init(pSize:Float) {
		rounded = false;
		size = pSize;
		origin = new Point(0,0); //new Point(size / 2, size / 2);
	}

	public function randomSpiro() {
		numOfTurns =  Std.int(Math.random() * (maxTurns - minTurns  + 1) + minTurns - 1);

		wholeCircle = Std.int(Math.random() * (maxCycles - minCycles + 1) + minCycles);

		var ang:Int = Std.int(Math.random() * wholeCircle);
		while ( Maths.GCF( ang, wholeCircle) != 1) {
			ang = (ang + 1) % wholeCircle;
		}
		trace("turn angle:"+ang);
		calcSpiro(numOfTurns, wholeCircle, ang);
	}

	public function calcSpiro(pNumOfTurns:Int, pWholeCircle:Int, ang:Int, randomTurns:Bool = true) {
		wholeCircle = pWholeCircle;
		numOfTurns = pNumOfTurns;
		var theta = 0;
		turns = new Array<Int>();
		var pt = new Point( 0.0,0.0);
		var realAngle:Float;
		realAngle = 0.0;
		var i = 0;
		while ((i < numOfTurns) || (theta == 0)) {
			if (randomTurns) {
				turns[i] = Math.floor(Math.random() * 2) * 2 - 1;
				if (i >= numOfTurns) {
					if (((turns[i] * ang) % wholeCircle) == 0) {
						turns[i] = 1;
					}
				}
			} else {
				turns[i] = 1;
			}
			pt.x += (i+1) * Math.cos(realAngle);
			pt.y += (i+1) * Math.sin(realAngle);
			theta = ((turns[i] * ang) + theta) % wholeCircle;
			realAngle = Maths.circleUnitsToRads(theta, wholeCircle);
			i++;
		}
		numOfTurns = i;
		angle = theta;
		//angle = (turns[numOfTurns-1] * ang) % wholeCircle;
		//realAngle = Maths.circleUnitsToRads(angle);
		trace("cycle angle:"+angle);
		trace("endPt: ("+pt.x+", "+pt.y+")");
		numOfCycles = Std.int(wholeCircle / Maths.GCF(wholeCircle, theta));
		var phi;
		var chi;
		var r;
		var tx = pt.x;
		var ty = pt.y;
		if ( tx == 0.0 ) {
			if (ty < 0.0) {
				phi = - Math.PI / 2;
			} else {
				phi = Math.PI / 2;
			}
		} else if (tx < 0.0) {
			phi = Math.PI + Math.atan( ty / tx );
		} else {
			phi = Math.atan( ty / tx );
		}
		chi = Maths.fmod ( ( Math.PI - realAngle ) / 2, Math.PI );
		r = - Math.sqrt( tx * tx + ty * ty ) / 2 / Math.cos(chi);
		center = new Point(r * Math.cos(phi + chi), r * Math.sin(phi + chi));
		pt = new Point(0.0,0.0); // center; //
		spiroVertexList = new Array<Vertex>();
		//spiroVertexList.push({vertex:new Point(0,0)});
		r = 0.0;
		theta = 0;
		var vert:Vertex;
		var t1;
		var t2;
		var lastTheta = 0;
		var deltaAngle;
		var tAng = 0.0;
		var realAngle = 0.0;
		var temp;
		i = 0;
		while (i < numOfTurns) {
			lastTheta = theta;
			pt.x += (i+1) * Math.cos(realAngle);
			pt.y += (i+1) * Math.sin(realAngle);
			theta = ((turns[i] * ang) + theta) % wholeCircle;
			//trace("turns["+i+"]="+turns[i]+", angle: "+theta+", realAngle: "+realAngle);
			realAngle = Maths.circleUnitsToRads(theta, wholeCircle);
			vert = {vertex:pt.clone()};
			if (rounded) {
				deltaAngle = theta - lastTheta;
				if  (deltaAngle < 0) {
					t1 = lastTheta + Std.int(( deltaAngle) / 2.0 - (wholeCircle / 4.0));
					t2 = lastTheta + Std.int(( deltaAngle) / 2.0 + (wholeCircle / 4.0));
				} else {
					t1 = lastTheta + Std.int(( deltaAngle) / 2.0 + (wholeCircle / 4.0));
					t2 = lastTheta + Std.int(( deltaAngle) / 2.0 - (wholeCircle / 4.0));
				}
				tAng = Maths.circleUnitsToRads(t1, wholeCircle);
				vert.handle1  = new Point(( (i +2) / handleScale) * Math.cos(tAng), ( (i +2) / handleScale) * Math.sin(tAng));
				tAng = Maths.circleUnitsToRads(t2, wholeCircle);
				vert.handle2 = new Point(( (i +1) / handleScale) * Math.cos(tAng), ( (i+1)  / handleScale) * Math.sin(tAng));
			}
			spiroVertexList.push( vert);
			tx = pt.x + center.x;
			ty = pt.y + center.y;
			temp = tx * tx + ty * ty;
			if (temp > r) {
				r = temp;
			}
			i++;
		}
		r = Math.sqrt(r);
		scale = size / r / 2;
		regPoint = new Point(scale * center.x, scale * center.y);
		//graphics.lineStyle(3, 0);
		//graphics.drawCircle(size/2, size/2, r * scale);

	}

	private function scaleAndOffset(x:Float, y:Float):Point {
		return new Point((x + center.x)*scale+origin.x, (y + center.y)*scale+origin.y);
	}

	private function drawCycle(sp:Sprite, ?color:UInt = 0, ?lineThickness:Int = 1) {
		var i = 0;
		var pt:Point;
		sp.graphics.lineStyle(lineThickness, color);
		sp.graphics.moveTo(0, 0);
		while (i < numOfTurns) {
			pt = spiroVertexList[i].vertex;
			//trace("pt["+i+"]= ("+pt.x+", "+pt.y+")");
			sp.graphics.lineTo(pt.x * scale, pt.y * scale);
			i++;
		}
	}

	public function drawSpiro() {
		resetSpiro();
		var colors = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0x00ffff, 0xff00ff, 0xff8000, 0x00ff80, 0xff0080, 0x80ff00, 0x0080ff, 0x8000ff, 0xffff80, 0x80ffff, 0xff80ff];
		var numColors = colors.length;
		var theta = 0;
		var sp:Sprite;
		var pt:Point;
		var realAngle;
		var m:openfl.geom.Matrix;
		pt = spiroVertexList[numOfTurns-1].vertex;
		var endPt:Point = new Point(pt.x * scale, pt.y * scale);
		pt = scaleAndOffset(0, 0);
		var i = 0;
		while (i < numOfCycles) {
			sp = new Sprite();
			sp.x = pt.x;
			sp.y = pt.y;
			drawCycle(sp, colors[i % numColors]);
			realAngle = Maths.circleUnitsToRads(theta, wholeCircle);
			sp.rotation = 180 * realAngle / Math.PI;
			//trace("sp.rotation: "+sp.rotation+", circle units: "+theta);
			addChild(sp);
			m = new openfl.geom.Matrix(0,0,0,0,endPt.x,endPt.y);
			m.rotate(realAngle);
			pt.x += m.tx;
			pt.y += m.ty;
			// draw single cycle shape at loc, theta
			// update theta based on angle between cycles (calc in calcSpiro)
			theta = (theta + angle) % wholeCircle;
			i++;
		}

		// cycle colors ???
	}
	public function resetSpiro() {
		this.removeChildren();
	}


}