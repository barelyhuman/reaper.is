var __defProp = Object.defineProperty;
var __defProps = Object.defineProperties;
var __getOwnPropDescs = Object.getOwnPropertyDescriptors;
var __getOwnPropSymbols = Object.getOwnPropertySymbols;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __propIsEnum = Object.prototype.propertyIsEnumerable;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __spreadValues = (a, b) => {
  for (var prop in b || (b = {}))
    if (__hasOwnProp.call(b, prop))
      __defNormalProp(a, prop, b[prop]);
  if (__getOwnPropSymbols)
    for (var prop of __getOwnPropSymbols(b)) {
      if (__propIsEnum.call(b, prop))
        __defNormalProp(a, prop, b[prop]);
    }
  return a;
};
var __spreadProps = (a, b) => __defProps(a, __getOwnPropDescs(b));
var __publicField = (obj, key, value) => {
  __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
  return value;
};

// src/state.js
var RndrState = class {
  constructor(state) {
    __publicField(this, "listeners", []);
    this.state = state;
  }
  sub(fn) {
    this.listeners.push(fn);
    return () => {
      this.listeners.splice(this.listeners.length - 1, 1);
    };
  }
  set value(val) {
    this.state = val;
    this.listeners.forEach((ln) => ln(this.state));
  }
  get value() {
    return this.state;
  }
  toString() {
    return this.state;
  }
};
function createState(val) {
  return new RndrState(val);
}

// src/core.js
function createFunctionalComp(component, props, ...children) {
  let elm;
  const initProps = {};
  for (let p in props) {
    let propValue = props[p];
    if (propValue instanceof RndrState) {
      propValue.sub((v) => {
        const _next = __spreadProps(__spreadValues({}, props), { [p]: v });
        const _nextNode = component(_next);
        elm.parentNode.replaceChild(_nextNode, elm);
        elm = _nextNode;
      });
      propValue = propValue.value;
    }
    initProps[p] = propValue;
  }
  elm = component(initProps);
  elm.append(
    ...children.flat(2).map((child) => {
      let sigReplace = child;
      if (child instanceof RndrState) {
        sigReplace = new Text(child);
        child.sub((t) => sigReplace.data = t);
      }
      return sigReplace;
    })
  );
  return elm;
}
function createDOMComp(type, props, ...children) {
  let elm = document.createElement(type);
  for (let p in props) {
    let propValue = props[p];
    if (propValue instanceof RndrState) {
      propValue.sub((v) => elm[p] = v);
      propValue = propValue.value;
    }
    elm[p] = propValue;
  }
  elm.append(
    ...children.flat(2).map((child) => {
      let sigReplace = child;
      if (child instanceof RndrState) {
        sigReplace = new Text(child);
        child.sub((t) => sigReplace.data = t);
      }
      return sigReplace;
    })
  );
  return elm;
}
function h(type, props, ...children) {
  let elm;
  if (typeof type === "function") {
    elm = createFunctionalComp(type, props, ...children);
  } else {
    elm = createDOMComp(type, props, ...children);
  }
  return elm;
}
export {
  RndrState,
  createState,
  h
};

