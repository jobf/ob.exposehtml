package ob.exposehtml;

import js.html.Blob;
import js.html.Element;
import js.html.HTMLDocument;
import js.html.URL;
import js.lib.ArrayBuffer;
import ob.exposehtml.Elements;

class Expose {
	public var container(default, null):Element;

	var document:HTMLDocument;

	public function new(document:HTMLDocument, ?outer:Element) {
		this.document = document;
		var css = ".expose-container
		{
			display: flex;
			justify-content: space-evenly;
			flex-wrap: wrap;
			margin-top:30px;
		}
		.expose-item-label { font-size: x-small; font-family: monospace; height:15px;}
		.expose-item { margin: 5px; padding: 5px; border-radius:5px; background-color: #efefef;}
		";
		var style = this.document.createStyleElement();
		style.textContent = css;
		this.document.head.appendChild(style);
		container = this.document.createDivElement();
		container.classList.add("expose-container");
		if (outer == null) {
			this.document.body.appendChild(container);
		} else {
			outer.appendChild(container);
		}
	}

	function containerOrDefault(?container:Element):Element {
		return container == null ? this.container : container;
	}

	public function Numeric(object:Dynamic, objectField:String, incrementStep:Float, label:String = "", ?container:Element, func:Float->Void = null) {
		new NumericInputElement(object, objectField, incrementStep, document, containerOrDefault(container), label, func);
	}

	public function NumericInt(object:Dynamic, objectField:String, incrementStep:Int, label:String = "", ?container:Element, func:Int->Void = null) {
		new IntElement(object, objectField, incrementStep, document, containerOrDefault(container), label, func);
	}

	public function Checkbox(object:Dynamic, objectField:String, label:String = "", ?container:Element, func:Bool->Void = null) {
		new CheckboxElement(object, objectField, document, containerOrDefault(container), label, func);
	}

	public function Button(buttonText:String = "", label:String = "", ?container:Element, func:Void->Void) {
		new ButtonElement(document, containerOrDefault(container), buttonText, label, func);
	}

	public function Image(?container:Element, imageBytes:haxe.io.Bytes, maxHeightPx:Int = 400):Element {
		var arrayBuffer:ArrayBuffer = imageBytes.getData();
		trace('arrayBuffer length is ${arrayBuffer.byteLength}');
		var blob = new Blob([arrayBuffer]);
		if (container == null) {
			container = document.createDivElement();
			container.style.overflowY = "scroll";
			container.style.maxHeight = '${maxHeightPx}px';
			document.body.append(container);
		}
		var objectUrl = URL.createObjectURL(blob);
		var imageElement = document.createImageElement();
		imageElement.src = objectUrl;
		imageElement.onload = () -> {
			URL.revokeObjectURL(objectUrl);
		}
		container.append(imageElement);
		return container;
	}
}
