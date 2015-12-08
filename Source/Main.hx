package;


import openfl.display.Sprite;
import view.SprioDisplay;
import flash.events.MouseEvent;
import flash.events.Event;


class Main extends Sprite {
	var spiro:SprioDisplay;
	var animating:Bool = false;
	var animCount:Int;
	var animSteps:Int = 5;

	public function new () {
		super ();
		init();
	}

	private function init() {
		this.stage.frameRate = 24;
		this.stage.color = 0x000000;
		spiro = new SprioDisplay();
		var size:Float = Math.min(stage.stageHeight, stage.stageWidth) - 10;
		spiro.init(size);
		spiro.x = size/2;
		spiro.y = size/2;
		spiro.mouseChildren = false;
		spiro.mouseEnabled = false;
		draw();
		stage.addEventListener(MouseEvent.CLICK, doClick);
		//spiro.calcSpiro(3, 4, 1, false);
//		graphics.beginFill(0xFF0000);
//		graphics.drawCircle(100, 100, 50);
//		graphics.endFill();
	}

	private function doClick(?event:MouseEvent = null) {
		if (animating) {
			animating = false;
			this.removeEventListener("enterFrame", animate);
			draw();
		} else {
			animating = true;
			this.addEventListener("enterFrame", animate);
			animate();
		}
	}

	private function draw() {
		animCount = animSteps;
		spiro.randomSpiro();
		spiro.drawSpiro();
		addChild(spiro);
	}

	private function animate(?event:Event) {
		//animCount--;
		//while (true) {
			spiro.rotation += 5;
		//}
	}

}