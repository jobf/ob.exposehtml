package ob.exposehtml;

import js.html.Element;
import js.html.HTMLDocument;
import js.html.InputElement;

class OuterElement {
	var outer:Element;
	var document:HTMLDocument;
	var container:Element;

	function new(document:HTMLDocument, ?outer:Element, labelText:String = "") {
		this.outer = outer == null ? document.body : outer;
		container = document.createDivElement();
		container.classList.add("expose-item");
		this.document = document;
		var label = document.createDivElement();
		label.classList.add("expose-item-label");
		label.textContent = labelText;
		container.appendChild(label);
		this.outer.appendChild(container);
	}
}

class ValueBoundElement<T> extends OuterElement {
	var object:Dynamic;
	var objectField:String;
	var value:T;

	public function new(object:Dynamic, objectField:String, document:HTMLDocument, ?outer:Element, label:String = "") {
		super(document, outer, label);
		this.object = object;
		this.objectField = objectField;
		if ((objectField != null) && (Reflect.getProperty(object, objectField) != null)) {
			value = Reflect.getProperty(object, objectField);
		}
	}
}

class InputBoundElement<T> extends ValueBoundElement<T> {
	var input:InputElement;
	var func:T->Void;

	public function new(object:Dynamic, objectField:String, document:HTMLDocument, ?outer:Element, label:String = "", func:T->Void) {
		var labelText = label.length > 0 ? label : objectField;
		var objectClass = Type.getClass(object);
		if(objectClass!=null){
			var className = Type.getClassName(objectClass);
			labelText = '[${className}.${objectField}] ${label}';
		}
		super(object, objectField, document, outer, '${labelText}');
		input = document.createInputElement();
		this.func = func;
		input.onchange = inputOnChange;
		container.appendChild(input);
		updateInputValue();
	}

	function updateInputValue() {
		input.value = Std.string(value);
	}

	function inputOnChange() {
		if (func != null) {
			func(value);
		}
	}

	function updateValue():Void {
		if ((objectField != null) && (Reflect.getProperty(object, objectField) != null)) {
			trace('set ${objectField}');
			Reflect.setProperty(object, objectField, value);
		}
		var nextInputValue = Std.string(value);
		if (input.value != nextInputValue) {
			input.value = nextInputValue;
		}
	}
}

class IntElement extends InputBoundElement<Int> {
	var incrementStep:Float;

	public function new(object:Dynamic, objectField:String, incrementStep:Int, document:HTMLDocument, ?outer:Element, ?label:String, func:Int->Void) {
		super(object, objectField, document, outer, label, func);
		input.type = "number";
		this.incrementStep = incrementStep;
		input.step = Std.string(incrementStep);
	}

	override function inputOnChange() {
		var nextValue = Std.parseInt(input.value);
		if (Math.isNaN(nextValue)) {
			return;
		}
		if (nextValue != value) {
			value = nextValue;
			updateValue();
			super.inputOnChange();
		}
	}
}

class NumericInputElement extends InputBoundElement<Float> {
	var incrementStep:Float;

	public function new(object:Dynamic, objectField:String, incrementStep:Float, document:HTMLDocument, ?outer:Element, ?label:String, func:Float->Void) {
		super(object, objectField, document, outer, label, func);
		input.type = "number";
		this.incrementStep = incrementStep;
		input.step = Std.string(incrementStep);
	}

	override function inputOnChange() {
		var nextValue = Std.parseFloat(input.value);
		if (Math.isNaN(nextValue)) {
			return;
		}
		if (nextValue != value) {
			value = nextValue;
			updateValue();
			super.inputOnChange();
		}
	}
}

class FunctionBoundElement extends OuterElement {
	var func:Void->Void;

	public function new(func:Void->Void, document:HTMLDocument, ?outer:Element, label:String = "") {
		super(document, outer, label);
		this.func = func;
	}
}

class ButtonElement extends FunctionBoundElement {
	var button:js.html.ButtonElement;

	public function new(document:HTMLDocument, ?outer:Element, buttonText:String, label:String = "", func:Void->Void) {
		super(func, document, outer, label);
		button = this.document.createButtonElement();
		button.textContent = buttonText;
		button.onclick = () -> this.func();
		container.append(button);
	}
}

class CheckboxElement extends InputBoundElement<Bool> {
	public function new(object:Dynamic, objectField:String, document:HTMLDocument, ?outer:Element, ?label:String, func:Bool->Void) {
		super(object, objectField, document, outer, label, func);
		input.type = "checkbox";
	}

	override function updateInputValue() {
		input.checked = value;
	}

	override function inputOnChange() {
		var nextValue = input.checked;
		if (nextValue == null) {
			return;
		}
		if (nextValue != value) {
			value = nextValue;
			updateValue();
			super.inputOnChange();
		}
	}
}
