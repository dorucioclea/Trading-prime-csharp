CNWTEPRGs��
s ��Ϫ��ͻ��s s s s s            <                                                                                                s���s �ú���λ��s s s s s         ����                                              ���������API_DEMO.   ���������API_DEMO
@��ע:
���������API_DEMO   ��ҹ QQ519271175                        R   ���������API_DEMO����ӭʹ�ã��������ʻ�ӭ��ϵ����QQ519271175 ��ѯ��˵�����⼴�ɣ�                                               s�,s �����Э��s s s s s          �]w�N                                              R�� ����	   _��������   �ڳ����������Զ����뱾����   C    �    k   �   K  �  +  �  g                           � �2   2   �   D                                                         l                         ��ť6  �.�    �   P                                                              l                         ��ť5  P/�    �   P                                                              l                         ��ť4  ��    �   P                                                              l                         ��ť3  @�    h   P                                                              l                         ��ť2  ��    @   P                                                              l                         ��ť1  ��       P                                                                 K  2>�@�@
A�`      �  +  X     sha256 sha256 �  var CryptoJS = CryptoJS ||
function(h, i) {
	var e = {},
	f = e.lib = {},
	l = f.Base = function() {
		function a() {}
		return {
			extend: function(j) {
				a.prototype = this;
				var d = new a;
				j && d.mixIn(j);
				d.$super = this;
				return d
			},
			create: function() {
				var a = this.extend();
				a.init.apply(a, arguments);
				return a
			},
			init: function() {},
			mixIn: function(a) {
				for (var d in a) a.hasOwnProperty(d) && (this[d] = a[d]);
				a.hasOwnProperty("toString") && (this.toString = a.toString)
			},
			clone: function() {
				return this.$super.extend(this)
			}
		}
	} (),
	k = f.WordArray = l.extend({
		init: function(a, j) {
			a = this.words = a || [];
			this.sigBytes = j != i ? j: 4 * a.length
		},
		toString: function(a) {
			return (a || m).stringify(this)
		},
		concat: function(a) {
			var j = this.words,
			d = a.words,
			c = this.sigBytes,
			a = a.sigBytes;
			this.clamp();
			if (c % 4) for (var b = 0; b < a; b++) j[c + b >>> 2] |= (d[b >>> 2] >>> 24 - 8 * (b % 4) & 255) << 24 - 8 * ((c + b) % 4);
			else if (65535 < d.length) for (b = 0; b < a; b += 4) j[c + b >>> 2] = d[b >>> 2];
			else j.push.apply(j, d);
			this.sigBytes += a;
			return this
		},
		clamp: function() {
			var a = this.words,
			b = this.sigBytes;
			a[b >>> 2] &= 4294967295 << 32 - 8 * (b % 4);
			a.length = h.ceil(b / 4)
		},
		clone: function() {
			var a = l.clone.call(this);
			a.words = this.words.slice(0);
			return a
		},
		random: function(a) {
			for (var b = [], d = 0; d < a; d += 4) b.push(4294967296 * h.random() | 0);
			return k.create(b, a)
		}
	}),
	o = e.enc = {},
	m = o.Hex = {
		stringify: function(a) {
			for (var b = a.words, a = a.sigBytes, d = [], c = 0; c < a; c++) {
				var e = b[c >>> 2] >>> 24 - 8 * (c % 4) & 255;
				d.push((e >>> 4).toString(16));
				d.push((e & 15).toString(16))
			}
			return d.join("")
		},
		parse: function(a) {
			for (var b = a.length, d = [], c = 0; c < b; c += 2) d[c >>> 3] |= parseInt(a.substr(c, 2), 16) << 24 - 4 * (c % 8);
			return k.create(d, b / 2)
		}
	},
	q = o.Latin1 = {
		stringify: function(a) {
			for (var b = a.words, a = a.sigBytes, d = [], c = 0; c < a; c++) d.push(String.fromCharCode(b[c >>> 2] >>> 24 - 8 * (c % 4) & 255));
			return d.join("")
		},
		parse: function(a) {
			for (var b = a.length, d = [], c = 0; c < b; c++) d[c >>> 2] |= (a.charCodeAt(c) & 255) << 24 - 8 * (c % 4);
			return k.create(d, b)
		}
	},
	r = o.Utf8 = {
		stringify: function(a) {
			try {
				return decodeURIComponent(escape(q.stringify(a)))
			} catch(b) {
				throw Error("Malformed UTF-8 data");
			}
		},
		parse: function(a) {
			return q.parse(unescape(encodeURIComponent(a)))
		}
	},
	b = f.BufferedBlockAlgorithm = l.extend({
		reset: function() {
			this._data = k.create();
			this._nDataBytes = 0
		},
		_append: function(a) {
			"string" == typeof a && (a = r.parse(a));
			this._data.concat(a);
			this._nDataBytes += a.sigBytes
		},
		_process: function(a) {
			var b = this._data,
			d = b.words,
			c = b.sigBytes,
			e = this.blockSize,
			g = c / (4 * e),
			g = a ? h.ceil(g) : h.max((g | 0) - this._minBufferSize, 0),
			a = g * e,
			c = h.min(4 * a, c);
			if (a) {
				for (var f = 0; f < a; f += e) this._doProcessBlock(d, f);
				f = d.splice(0, a);
				b.sigBytes -= c
			}
			return k.create(f, c)
		},
		clone: function() {
			var a = l.clone.call(this);
			a._data = this._data.clone();
			return a
		},
		_minBufferSize: 0
	});
	f.Hasher = b.extend({
		init: function() {
			this.reset()
		},
		reset: function() {
			b.reset.call(this);
			this._doReset()
		},
		update: function(a) {
			this._append(a);
			this._process();
			return this
		},
		finalize: function(a) {
			a && this._append(a);
			this._doFinalize();
			return this._hash
		},
		clone: function() {
			var a = b.clone.call(this);
			a._hash = this._hash.clone();
			return a
		},
		blockSize: 16,
		_createHelper: function(a) {
			return function(b, d) {
				return a.create(d).finalize(b)
			}
		},
		_createHmacHelper: function(a) {
			return function(b, d) {
				return g.HMAC.create(a, d).finalize(b)
			}
		}
	});
	var g = e.algo = {};
	return e
} (Math); (function(h) {
	var i = CryptoJS,
	e = i.lib,
	f = e.WordArray,
	e = e.Hasher,
	l = i.algo,
	k = [],
	o = []; (function() {
		function e(a) {
			for (var b = h.sqrt(a), d = 2; d <= b; d++) if (! (a % d)) return ! 1;
			return ! 0
		}
		function f(a) {
			return 4294967296 * (a - (a | 0)) | 0
		}
		for (var b = 2, g = 0; 64 > g;) e(b) && (8 > g && (k[g] = f(h.pow(b, 0.5))), o[g] = f(h.pow(b, 1 / 3)), g++),
		b++
	})();
	var m = [],
	l = l.SHA256 = e.extend({
		_doReset: function() {
			this._hash = f.create(k.slice(0))
		},
		_doProcessBlock: function(e, f) {
			for (var b = this._hash.words, g = b[0], a = b[1], j = b[2], d = b[3], c = b[4], h = b[5], l = b[6], k = b[7], n = 0; 64 > n; n++) {
				if (16 > n) m[n] = e[f + n] | 0;
				else {
					var i = m[n - 15],
					p = m[n - 2];
					m[n] = ((i << 25 | i >>> 7) ^ (i << 14 | i >>> 18) ^ i >>> 3) + m[n - 7] + ((p << 15 | p >>> 17) ^ (p << 13 | p >>> 19) ^ p >>> 10) + m[n - 16]
				}
				i = k + ((c << 26 | c >>> 6) ^ (c << 21 | c >>> 11) ^ (c << 7 | c >>> 25)) + (c & h ^ ~c & l) + o[n] + m[n];
				p = ((g << 30 | g >>> 2) ^ (g << 19 | g >>> 13) ^ (g << 10 | g >>> 22)) + (g & a ^ g & j ^ a & j);
				k = l;
				l = h;
				h = c;
				c = d + i | 0;
				d = j;
				j = a;
				a = g;
				g = i + p | 0
			}
			b[0] = b[0] + g | 0;
			b[1] = b[1] + a | 0;
			b[2] = b[2] + j | 0;
			b[3] = b[3] + d | 0;
			b[4] = b[4] + c | 0;
			b[5] = b[5] + h | 0;
			b[6] = b[6] + l | 0;
			b[7] = b[7] + k | 0
		},
		_doFinalize: function() {
			var e = this._data,
			f = e.words,
			b = 8 * this._nDataBytes,
			g = 8 * e.sigBytes;
			f[g >>> 5] |= 128 << 24 - g % 32;
			f[(g + 64 >>> 9 << 4) + 15] = b;
			e.sigBytes = 4 * f.length;
			this._process()
		}
	});
	i.SHA256 = e._createHelper(l);
	i.HmacSHA256 = e._createHmacHelper(l)
})(Math); (function() {
	var h = CryptoJS,
	i = h.enc.Utf8;
	h.algo.HMAC = h.lib.Base.extend({
		init: function(e, f) {
			e = this._hasher = e.create();
			"string" == typeof f && (f = i.parse(f));
			var h = e.blockSize,
			k = 4 * h;
			f.sigBytes > k && (f = e.finalize(f));
			for (var o = this._oKey = f.clone(), m = this._iKey = f.clone(), q = o.words, r = m.words, b = 0; b < h; b++) q[b] ^= 1549556828,
			r[b] ^= 909522486;
			o.sigBytes = m.sigBytes = k;
			this.reset()
		},
		reset: function() {
			var e = this._hasher;
			e.reset();
			e.update(this._iKey)
		},
		update: function(e) {
			this._hasher.update(e);
			return this
		},
		finalize: function(e) {
			var f = this._hasher,
			e = f.finalize(e);
			f.reset();
			return f.finalize(this._oKey.clone().concat(e))
		}
	})
})();

function HMAC(test, hmacKey)
 {
var anEncryptedKey = CryptoJS.HmacSHA256(test, hmacKey);
	return anEncryptedKey;
} �    ��������json_���۸�  |   {"account-id": [account-id], "amount": [amount], "symbol": "[symbol]", "type": "[type]", "source": "api", "price": [price]} �    ��������json_�޼۸�  j   {"account-id": [account-id], "amount": [amount], "symbol": "[symbol]", "type": "[type]", "source": "api"} )    ִ�ж���     {"order-id":[order-id]} �-   js2  �-  function get__count(c){
	var i=-2;
	for (v in c) i++;
	return i;
}

if (typeof JSON !== 'object') {
    JSON = {};
}

(function () {
    'use strict';

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function (key) {

            return isFinite(this.valueOf()) ?
                this.getUTCFullYear()     + '-' +
                f(this.getUTCMonth() + 1) + '-' +
                f(this.getUTCDate())      + 'T' +
                f(this.getUTCHours())     + ':' +
                f(this.getUTCMinutes())   + ':' +
                f(this.getUTCSeconds())   + 'Z' : null;
        };

        String.prototype.toJSON      =
            Number.prototype.toJSON  =
            Boolean.prototype.toJSON = function (key) {
                return this.valueOf();
            };
    }

    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        gap,
        indent,
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {

// If the string contains no control characters, no quote characters, and no
// backslash characters, then we can safely slap some quotes around it.
// Otherwise we must also replace the offending characters with safe escape
// sequences.

        escapable.lastIndex = 0;
        return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
            var c = meta[a];
            return typeof c === 'string' ? c :
                '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + string + '"';
    }


    function str(key, holder) {

// Produce a string from holder[key].

        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

// If the value has a toJSON method, call it to obtain a replacement value.

        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

// If we were called with a replacer function, then call the replacer to
// obtain a replacement value.

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

// What happens next depends on the value's type.

        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':

// JSON numbers must be finite. Encode non-finite numbers as null.

            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':

// If the value is a boolean or null, convert it to a string. Note:
// typeof null does not produce 'null'. The case is included here in
// the remote chance that this gets fixed someday.

            return String(value);

// If the type is 'object', we might be dealing with an object or an array or
// null.

        case 'object':

// Due to a specification blunder in ECMAScript, typeof null is 'object',
// so watch out for that case.

            if (!value) {
                return 'null';
            }

// Make an array to hold the partial results of stringifying this object value.

            gap += indent;
            partial = [];

// Is the value an array?

            if (Object.prototype.toString.apply(value) === '[object Array]') {

// The value is an array. Stringify every element. Use null as a placeholder
// for non-JSON values.

                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }

// Join all of the elements together, separated with commas, and wrap them in
// brackets.

                v = partial.length === 0 ? '[]' : gap ?
                    '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']' :
                    '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }

// If the replacer is an array, use it to select the members to be stringified.

            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    k = rep[i];
                    if (typeof k === 'string') {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {

// Otherwise, iterate through all of the keys in the object.

                for (k in value) {
                    if (Object.prototype.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }

// Join all of the member texts together, separated with commas,
// and wrap them in braces.

            v = partial.length === 0 ? '{}' : gap ?
                '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}' :
                '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }

// If the JSON object does not yet have a stringify method, give it one.

    if (typeof JSON.stringify !== 'function') {
        JSON.stringify = function (value, replacer, space) {

// The stringify method takes a value and an optional replacer, and an optional
// space parameter, and returns a JSON text. The replacer can be a function
// that can replace values, or an array of strings that will select the keys.
// A default replacer method can be provided. Use of the space parameter can
// produce text that is more easily readable.

            var i;
            gap = '';
            indent = '';

// If the space parameter is a number, make an indent string containing that
// many spaces.

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

// If the space parameter is a string, it will be used as the indent string.

            } else if (typeof space === 'string') {
                indent = space;
            }

// If there is a replacer, it must be a function or an array.
// Otherwise, throw an error.

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                    typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

// Make a fake root object containing our value under the key of ''.
// Return the result of stringifying the value.

            return str('', {'': value});
        };
    }


// If the JSON object does not yet have a parse method, give it one.

    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {

// The parse method takes a text and an optional reviver function, and returns
// a JavaScript value if the text is a valid JSON text.

            var j;

            function walk(holder, key) {

// The walk method is used to recursively walk the resulting structure so
// that modifications can be made.

                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }


// Parsing happens in four stages. In the first stage, we replace certain
// Unicode characters with escape sequences. JavaScript handles many characters
// incorrectly, either silently deleting them, or treating them as line endings.

            text = String(text);
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

// In the second stage, we run the text against regular expressions that look
// for non-JSON patterns. We are especially concerned with '()' and 'new'
// because they can cause invocation, and '=' because it can cause mutation.
// But just to be safe, we want to reject all unexpected forms.

// We split the second stage into 4 regexp operations in order to work around
// crippling inefficiencies in IE's and Safari's regexp engines. First we
// replace the JSON backslash pairs with '@' (a non-JSON character). Second, we
// replace all simple value tokens with ']' characters. Third, we delete all
// open brackets that follow a colon or comma or that begin the text. Finally,
// we look to see that the remaining characters are only whitespace or ']' or
// ',' or ':' or '{' or '}'. If that is so, then the text is safe for eval.

            if (/^[\],:{}\s]*$/
                    .test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@')
                        .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                        .replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

// In the third stage we use the eval function to compile the text into a
// JavaScript structure. The '{' operator is subject to a syntactic ambiguity
// in JavaScript: it can begin a block or an object literal. We wrap the text
// in parens to eliminate the ambiguity.

                j = eval('(' + text + ')');

// In the optional fourth stage, we recursively walk the new structure, passing
// each name/value pair to a reviver function for possible transformation.

                return typeof reviver === 'function' ?
                    walk({'': j}, '') : j;
            }

// If the text is not JSON parseable, then a SyntaxError is thrown.

            throw new SyntaxError('JSON.parse');
        };
    }

// Augment the basic prototypes if they have not already been augmented.
// These forms are obsolete. It is recommended that JSON.stringify and
// JSON.parse be used instead.

    if (!Object.prototype.toJSONString) {
        Object.prototype.toJSONString = function (filter) {
            return JSON.stringify(this, filter);
        };
        Object.prototype.parseJSON = function (filter) {
            return JSON.parse(this, filter);
        };
    }
}());     s�<=s ������s s s s s s          ����i�                                         8a ?�   �        1          9   krnlnd09f2340818511d396f6aaf844c7e32553ϵͳ����֧�ֿ�8   specA512548E76954B6E92C21055517615B031���⹦��֧�ֿ�                   �z>	`I`�  � ��  R       ���ڳ���_��������    �   �`�`�`�`�`�`-a5a)a$a�`�`�`�`�`�`v`�`�`m`���@�@�������G@j@�@�@�@�@�@�@A"A2A                   hmac    �   B>C>D>E>F>G>H>I>J>K>L>M>N>O>P>Q>R>S>T>U>V>W>X>Y>Z>[>\>]>^>_>`>a>b>c>d>e>f>g>h>i>j>k>l>m>n>o>p>q>r>s>t>u>v>w>            ����   ��_json    `   ``````````` `!`"`#`$`%`&`'`(`)`*`+`,`   6   -`.`            �   dataName     0     ����  �  ���������B>C>D>E>F>G>H>I>J>K>L>M>N>O>P>Q>R>S>T>U>V>W>X>Y>Z>[>\>]>^>_>`>a>b>c>d>e>f>g>h>i>j>k>l>m>n>o>p>q>r>s>t>u>v>w>G@j@�@�@�@�@�@�@�@�@A"A2A``````````` `!`"`#`$`%`&`'`(`)`*`+`,`m`v`�`�`�`�`�`�`�`�`�`�`�`�`�`�`$a)a-a5a�� �  �  � @�  � @� `� �� �� �� �  �  � @� `� �� �� �� �  �  � @�  � @� `� �� �� �� ��  �  � @� `� �� �� �� ��  �  � @�  � @� `� �� �� �� ��  �  � @� `� �� �� �� ��  �  � @�  � @� `� �� �� �� ��  �  � @� `� �� �� �� ��  �  � @�  � @� `� �� �� �� ��  �  � @� `� �� �� �� ��  �  � @� 0q Pp �. �- �, �+  !@!`!�!�!�
!�	! 	! !@!`!�!�!�!�! ! !@ ! !�0          __��������_�������                           j   �                   Q  j              6R   ���������API����ӭʹ�ã������κ����ʻ�ӭ��ϵQQ519271175��˵����ѯ���������API�� j              6e   ���������ӳ����е�AccessKey��SecretKey��Ҫ����������п�����ȡ����Ҫ����������վ�и���ճ���������ɣ� j              6R   Դ������ܲ��ַ������⣬�����޸���������BUG������ϵQQ3846147 ע����AMO�������API �0          _��ť1_������                                           .   j    ��         ��ѯ��ǰ�û��������˻� (,) 6�0     �   ��ѯ��ǰ�û��������˻�
   �����˻�ID   �   �%>%>%!>%�?%�?%�@%�@%       $   7   J   [   k   |        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     `I   json       �   id     R   $>%%>%    "        �   AccessKey API ������Կ      �   SecretKey ǩ������Կ 8       p   �   �   �  �    �    i  �  �  .  F      (   +   =   �  �   �  (  L  �    .  h   �      �  �  �    �   �   #  w  �  �  �   @  �    	  !  ^  �  �  �    .  X  �      `  j4               68�?%7!`               6!v`��          6!�@��          6      �?        T ��j              68�?%7j4              2017-05-11T15%3A19%3A30 68>%7!m`��          68�?%7��j4               68!>%7!               66   GET\nbe.huobi.com\n/v1/account/accounts\nAccessKeyId= 8$>%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8>%7j4               68>%7!�@��          6!f               68!>%7!f               68%>%7j              68>%78>%7j4               68�?%7!               66   https://be.huobi.com/v1/account/accounts?AccessKeyId= 8$>%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8>%7   &Signature= !m`��          68>%7��j              68�?%7j4               68�%7!�`��          6!Z               6!�`��          68�?%7j          J   {"status":"ok","data":[{"id":123456789,"type":"spot","state":"working"}]} 68�%7j`��          8�@%78�%7j4               68�@%7!`��          8�@%7   data[0].id j,`��          8�@%7j               68�@%7�0     �   ��ѯָ���˻������   ����ETH�˻��������   �   �?%�?%�?%�?%�?%�?%�@%�@%       $   7   J   [   k   |        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     `I   json       �   trade     w   �?%�?%�?%       ?        �   accountid �˻� ID      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ ,       p   �   �  �  �  @  �  �          (   �   �  +   =   �  �  #  �  �    `   �   �   �     <  �  �  �  �     �  F  h  �  �  �  5  �  �  �  �    0  �      8  j4               68�?%7!`               6!v`��          6!�@��          6      �?        T ��j4              2017-05-11T15%3A19%3A30 68�?%7!m`��          68�?%7��j4               68�?%7!               6)   GET\nbe.huobi.com\n/v1/account/accounts/ 8�?%7   /balance\nAccessKeyId= 8�?%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8�?%7j4               68�?%7!�@��          6!f               68�?%7!f               68�?%7j4               68�?%7!               6*   https://be.huobi.com/v1/account/accounts/ 8�?%7   /balance?AccessKeyId= 8�?%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8�?%7   &Signature= !m`��          68�?%7��j4               68�?%7!�`��          6!Z               6!�`��          68�?%7j          A  {"status":"ok","data":{"id":123456789,"type":"spot","state":"working","list":[{"currency":"cny","type":"trade","balance":"100.4900000000"},{"currency":"cny","type":"frozen","balance":"0.0000000000"},{"currency":"eth","type":"trade","balance":"0.0000000000"},{"currency":"eth","type":"frozen","balance":"0.0000000000"}]}} 68�?%7j`��          8�@%78�?%7j4               68�@%7!`��          8�@%7   data.list[2].balance j,`��          8�@%7j               68�@%7�0     �   ����һ���µĶ�������   ���ش����Ķ���ID	   �   �?%�?%�?%�?%�?%�?%�@%A%	A%       $   7   J   [   k   |   �        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL       �   temp     `I   json       �   orderid     �  �?%�?%�?%�?%�?%�?%�?%       r   �   �   ,  N       �   accountid �˻� ID Q     �   amount �޼۵���ʾ�µ��������м���ʱ��ʾ�����Ǯ���м�����ʱ��ʾ�����ٱ� (     �  price �µ��۸��м۵������ò��� !     �   symbol ���׶ԣ��ethcny e     �   type �������ͣ�buy-market���м���, sell-market���м���, buy-limit���޼���, sell-limit���޼���      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ T       p   �   r  �  �  �  7  �  �  !  q  �    Y  �  7  o  �  �  �  	   �  �  (   +   =   �   �  �  �  �  o  �  �  �      �   �   �  �  �  �  5  {  �  �  �  )  I  b  w  �  �  �  �  �    �  �  �  �  �  �    8  K  3  c  k  �  �  �   #  i  �  �    g  o  �  �  �  �  �       L  �  j4               68�?%7!`               6!v`��          6!�@��          6      �?        T ��j4              2017-05-11T15%3A19%3A30 68�?%7!m`��          68�?%7��j4               68�?%7!               63   POST\nbe.huobi.com\n/v1/order/orders\nAccessKeyId= 8�?%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8�?%7j4               68�?%7!�@��          6!f               68�?%7!f               68�?%7j4               68�?%7!               62   https://be.huobi.com/v1/order/orders?AccessKeyId= 8�?%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8�?%7   &Signature= !m`��          68�?%7��mn               6!&               68�?%7    j4               68�@%7!`               6�@   [account-id] 8�?%7��j4               68�@%7!`               68�@%7	   [amount] 8�?%7��j4               68�@%7!`               68�@%7	   [symbol] 8�?%7��j4               68�@%7!`               68�@%7   [type] 8�?%7��Soj4               68�@%7!`               6�@   [account-id] 8�?%7��j4               68�@%7!`               68�@%7	   [amount] 8�?%7��j4               68�@%7!`               68�@%7	   [symbol] 8�?%7��j4               68�@%7!`               68�@%7   [type] 8�?%7��j4               68�@%7!`               68�@%7   [price] 8�?%7��Ttj4               68�?%7!�`��          6!Z               6!�`��          68�?%7      �?8�@%7   Content-Type:application/json j             {"status":"ok","data":552297} 68�?%7j`��          8A%78�?%7j4               68	A%7!`��          8A%7   data j,`��          8A%7j               68	A%7�0     �   ִ��һ������   ִ�гɹ����򷵻ض���ID   �   �?%�?%�?%�?%�?%�?%A%A%       $   7   J   [   k   |        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     `I   json       �   place_orderid     t   �%@%@%       <        �   orderid ����ID      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ ,       p   �   �  �  �  e  �  �  �        (   +   =   �   �  �  �  �  �  �    `      �   �   �     7  }  �  �  �  �  �  �  �  $  �  �  �  =  ]  �  �  �  *      ,  j4               68�?%7!`               6!v`��          6!�@��          6      �?        T ��j4              2017-05-11T15%3A19%3A30 68�?%7!m`��          68�?%7��j4               68�?%7!               6&   POST\nbe.huobi.com\n/v1/order/orders/ 8�%7   /place\nAccessKeyId= 8@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8�?%7j4               68�?%7!�@��          6!f               68�?%7!f               68@%7j4               68�?%7!               6&   https://be.huobi.com/v1/order/orders/ 8�%7   /place?AccessKeyId= 8@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8�?%7   &Signature= !m`��          68�?%7��j4               68�?%7!�`��          6!Z               6!�`��          68�?%7      �?   Content-Type:application/json j              {"status":"ok","data":"552297"} 68�?%7j`��          8A%78�?%7j4               68A%7!`��          8A%7   data j,`��          8A%7j               68A%7�0     �   ���볷��һ����������   ִ�гɹ����򷵻ض���ID   �   @%@%@%@%@%@% A%!A%       $   7   J   [   k   |        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     `I   json       �   cancel_orderid     t   	@%
@%@%       <        �   orderid ����ID      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ ,       p   �   �  �  �  s  �  �           (   +   =   �   �  �    &  �    �  `      �   �   �     >  �  �  �  �     D  k  �  �  �  8  �  �  �    �  �  2      :  j4               68@%7!`               6!v`��          6!�@��          6      �?        T ��j4              2017-05-11T15%3A19%3A30 68@%7!m`��          68@%7��j4               68@%7!               6&   POST\nbe.huobi.com\n/v1/order/orders/ 8	@%7   /submitcancel\nAccessKeyId= 8
@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8@%7j4               68@%7!�@��          6!f               68@%7!f               68@%7j4               68@%7!               6&   https://be.huobi.com/v1/order/orders/ 8	@%7   /submitcancel?AccessKeyId= 8
@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8@%7   &Signature= !m`��          68@%7��j4               68@%7!�`��          6!Z               6!�`��          68@%7      �?   Content-Type:application/json j              {"status":"ok","data":"552297"} 68@%7j`��          8 A%78@%7j4               68!A%7!`��          8 A%7   data j,`��          8 A%7j               68!A%7�0     �   ��ѯĳ����������   ��ѯ�ɹ����򷵻ض���״̬   �    @%!@%"@%#@%$@%%@%0A%1A%       $   7   J   [   k   |        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     `I   json       �   state     t   @%@%@%       <        �   orderid ����ID      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ ,       p   �     �  �  (  �  �  �        (   +   =   �   �  �  �  �  �  �    `      �   �   �     0  v  �  �  �  �  6  P  �  �  �  �  �  �    �  �  �          j4               68$@%7!`               6!v`��          6!�@��          6      �?        T ��j4              2017-05-11T15%3A19%3A30 68"@%7!m`��          68$@%7��j4               68#@%7!               6%   GET\nbe.huobi.com\n/v1/order/orders/ 8@%7   \nAccessKeyId= 8@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8"@%7j4               68!@%7!�@��          6!f               68#@%7!f               68@%7j4               68%@%7!               6&   https://be.huobi.com/v1/order/orders/ 8@%7   ?AccessKeyId= 8@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8"@%7   &Signature= !m`��          68!@%7��j4               68 @%7!�`��          6!Z               6!�`��          68%@%7j          I  {"status":"ok","data":{"id":552297,"symbol":"ethcny","account-id":127930,"amount":"1.0000000000","price":"0.0","created-at":1496822604374,"type":"buy-market","field-amount":"0.0005000000","field-cash-amount":"0.9119400000","field-fees":"0.0000002500","finished-at":1496823271102,"source":"api","state":"filled","canceled-at":0}} 68 @%7j`��          80A%78 @%7j4               681A%7!`��          80A%7   data.state j,`��          80A%7j               681A%7�0          ��ѯĳ�������ĳɽ���ϸ       �   8@%9@%:@%;@%<@%=@%       $   7   J   [        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     t   5@%6@%7@%       <        �   orderid ����ID      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ         p   �   �  �  �  B  M         +   =   �   �  �    %  H      �   �   �  �  �  �     =  �  �  C  j  �  �  E  �  7      `  j4               68<@%7!`               6!v`��          6!�@��          6      �?        T ��j4              2017-05-11T15%3A19%3A30 68:@%7!m`��          68<@%7��j4               68;@%7!               6%   GET\nbe.huobi.com\n/v1/order/orders/ 85@%7   /matchresults\nAccessKeyId= 86@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8:@%7j4               689@%7!�@��          6!f               68;@%7!f               687@%7j4               68=@%7!               6&   https://be.huobi.com/v1/order/orders/ 85@%7   /matchresults?AccessKeyId= 86@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8:@%7   &Signature= !m`��          689@%7��j4               688@%7!�`��          6!Z               6!�`��          68=@%7j          �   {"status":"ok","data":[{"id":888878,"order-id":552297,"match-id":790885,"symbol":"ethcny","type":"buy-market","source":"api","price":"1823.8800000000","filled-amount":"0.0005000000","filled-fees":"0.0000002500","created-at":1496823271112}]} 688@%7j    ��          6z>	     �   safe_add       K   >%�>%�>%               �   lsw      �   msw      �   return     ,   }>%~>%       
    �   x  
    �   y         s   	  |          ,   �    F  i  �   �   �   �      =   `       �  j4               68>%7!               6!1               68}>%7    ���@!1               68~>%7    ���@j4               68�>%7!               6!              68}>%7      0@!              68~>%7      0@!              68>%7      0@j4               68�>%7!2               6!~              68�>%7      0@!1               68>%7    ���@j               68�>%7z>	     �   bit_rol          �>%        �   return     0   �>%�>%           �   num      �   cnt         �          L         =   D   ^   �   �       �   j4               68�>%7!2               6!~              68�>%78�>%7!w>��          68�>%7!               6      @@8�>%7j               68�>%7z>	     �   sha1_kt                  �>%    
    �   t         7   T   �   �   �   �     	                %   x   �       ,  mn               6!(               68�>%7      4@j               6  @f���ASn               6!(               68�>%7      D@j               6  @�z��ASn               6!(               68�>%7      N@j               6   �9��Soj               6   ����Ttj    ��          6z>	     �   sha1_ft               X   �>%�>%�>%�>%          *   
    �   t  
    �   b  
    �   c  
    �   d  (       6   �   �   �   9  L  �              �   �   8  L        L   $   l   s   �   �   �      '  .  p  �  �  �  �  �    D  K  R      [  l               6!(               68�>%7      4@j               6!2               6!1               68�>%78�>%7!1               6!0               68�>%78�>%7Rsj    ��          6l               6!(               68�>%7      D@j               6!3               68�>%78�>%78�>%7Rsj    ��          6l               6!(               68�>%7      N@j               6!2               6!1               68�>%78�>%7!1               68�>%78�>%7!1               68�>%78�>%7Rsj    ��          6j               6!3               68�>%78�>%78�>%7z>	     �   sha256_S               ,   �>%�>%       
    �   X  
    �   n         T          x      �   �   �   �       �   j    ��      A   function sha256_S (X, n) {return ( X >>> n ) | (X << (32 - n));} 6j               6!2               6!w>��          68�>%78�>%7!~              68�>%7!               6      @@8�>%7z>	     �   sha256_R               ,   �>%�>%       
    �   X  
    �   n         B          T      f   m       v   j    ��      /   function sha256_R (X, n) {return ( X >>> n );} 6j               6!w>��          68�>%78�>%7z>	     �	   sha256_Ch               B   �>%�>%�>%          
    �   x  
    �   y  
    �   z         P              �   �   �   �       �   j    ��      =   function sha256_Ch(x, y, z) {return ((x & y) ^ ((~x) & z));} 6j               6!3               6!1               68�>%78�>%7!1               6!0               68�>%78�>%7z>	     �
   sha256_Maj               B   �>%�>%�>%          
    �   x  
    �   y  
    �   z         X              �   �   �   �   �   �       �   j    ��      E   function sha256_Maj(x, y, z) {return ((x & y) ^ (x & z) ^ (y & z));} 6j               6!3               6!1               68�>%78�>%7!1               68�>%78�>%7!1               68�>%78�>%7z>	     �   sha256_Sigma0256                  �>%    
    �   x         o          �   �   �      �   �   �       �   j    ��      \   function sha256_Sigma0256(x) {return (sha256_S(x, 2) ^ sha256_S(x, 13) ^ sha256_S(x, 22));} 6j               6!3               6!F>��          68�>%7       @!F>��          68�>%7      *@!F>��          68�>%7      6@z>	     �   sha256_Sigma1256                  �>%    
    �   x         o          �   �   �      �   �   �       �   j    ��      \   function sha256_Sigma1256(x) {return (sha256_S(x, 6) ^ sha256_S(x, 11) ^ sha256_S(x, 25));} 6j               6!3               6!F>��          68�>%7      @!F>��          68�>%7      &@!F>��          68�>%7      9@z>	     �   sha256_Gamma0256                  �>%    
    �   x         n          �   �   �      �   �   �       �   j    ��      [   function sha256_Gamma0256(x) {return (sha256_S(x, 7) ^ sha256_S(x, 18) ^ sha256_R(x, 3));} 6j               6!3               6!F>��          68�>%7      @!F>��          68�>%7      2@!G>��          68�>%7      @z>	     �   sha256_Gamma1256                  �>%    
    �   x         p          �   �   �      �   �   �       �   j    ��      ]   function sha256_Gamma1256(x) {return (sha256_S(x, 17) ^ sha256_S(x, 19) ^ sha256_R(x, 10));} 6j               6!3               6!F>��          68�>%7      1@!F>��          68�>%7      3@!G>��          68�>%7      $@z>	     �   sha256_Sigma0512                  �>%    
    �   x         p          �   �   �      �   �   �       �   j    ��      ]   function sha256_Sigma0512(x) {return (sha256_S(x, 28) ^ sha256_S(x, 34) ^ sha256_S(x, 39));} 6j               6!3               6!F>��          68�>%7      <@!F>��          68�>%7      A@!F>��          68�>%7     �C@z>	     �   sha256_Sigma1512                  �>%    
    �   x         p          �   �   �      �   �   �       �   j    ��      ]   function sha256_Sigma1512(x) {return (sha256_S(x, 14) ^ sha256_S(x, 18) ^ sha256_S(x, 41));} 6j               6!3               6!F>��          68�>%7      ,@!F>��          68�>%7      2@!F>��          68�>%7     �D@z>	     �   sha256_Gamma0512                  �>%    
    �   x         n          �   �   �      �   �   �       �   j    ��      [   function sha256_Gamma0512(x) {return (sha256_S(x, 1)  ^ sha256_S(x, 8) ^ sha256_R(x, 7));} 6j               6!3               6!F>��          68�>%7      �?!F>��          68�>%7       @!G>��          68�>%7      @z>	           sha256_Gamma1512                  �>%    
    �   x         o          �   �   �      �   �   �       �   j    ��      \   function sha256_Gamma1512(x) {return (sha256_S(x, 19) ^ sha256_S(x, 61) ^ sha256_R(x, 6));} 6j               6!3               6!F>��          68�>%7      3@!F>��          68�>%7     �N@!G>��          68�>%7      @z>	     �   md5_cmn               �   �>%�>%�>%�>%�>%�>%          *   8   F   
    �   q  
    �   a  
    �   b  
    �   x  
    �   s  
    �   t                   $   6   H   i      Z   a   {   �   �   �       �   j               6!B>��          6!C>��          6!B>��          6!B>��          68�>%78�>%7!B>��          68�>%78�>%78�>%78�>%7z>	     �   md5_ff               �   �>%�>%�>%�>%�>%�>%�>%          *   8   F   T   
    �   a  
    �   b  
    �   c  
    �   d  
    �   x  
    �   s  
    �   t                   $   H   O   {   �   �   �   �   �   �       �   j               6!R>��          6!2               6!1               68�>%78�>%7!1               6!0               68�>%78�>%78�>%78�>%78�>%78�>%78�>%7z>	     �   md5_gg               �   �>%�>%�>%�>%�>%�>%�>%          *   8   F   T   
    �   a  
    �   b  
    �   c  
    �   d  
    �   x  
    �   s  
    �   t                   $   H   O   i   �   �   �   �   �   �       �   j               6!R>��          6!2               6!1               68�>%78�>%7!1               68�>%7!0               68�>%78�>%78�>%78�>%78�>%78�>%7z>	     �   md5_hh               �   �>%�>%�>%�>%�>%�>%�>%          *   8   F   T   
    �   a  
    �   b  
    �   c  
    �   d  
    �   x  
    �   s  
    �   t                       6   =   D   L   S   Z   a   h       q   j               6!R>��          6!3               68�>%78�>%78�>%78�>%78�>%78�>%78�>%78�>%7z>	     �   md5_ii               �   �>%�>%�>%�>%�>%�>%�>%          *   8   F   T   
    �   a  
    �   b  
    �   c  
    �   d  
    �   x  
    �   s  
    �   t                       6   O   h   r   y   �   �   �       �   j               6!R>��          6!3               68�>%7!2               68�>%7!0               68�>%78�>%78�>%78�>%78�>%78�>%7z>	        	   rstr2binb       n   �>%�>%�>%�>%       1   ?       �   inputlength      �   outputlength  
    �   i      �   jp     5   �>%�>%            �   input      �  output  H       4   t   �   0  �  �  �  $  9  �  �  �    V  k  ~  �  -   �   �  �  �  �  8  �  �    j      p      +   F   b   �   �   �   	  B  �  �  �      K  d  �  �  �  *  C  �  �  �    T    �      �  j4               68�>%7!e               68�>%7j7               68�>%7  !              68�>%7       @j4               68�>%7!8               68�>%7l               6!(               68�>%7!               6!              6!               68�>%7       @      @      �?j7               68�>%7��!               6!              6!               68�>%7       @      @      �?Rsj    ��          6p	               6        8�>%7      �?8�>%7l               6!+               68�>%78�>%7j               6Rsj4               68�>%:!               68�>%7      �?7        Uq
               6j4               68�>%7        p	               6        !               68�>%7       @       @8�>%7l               6!+               68�>%7!               68�>%7       @j               6Rsj    ��          6j4               68�>%:!               6!              68�>%7      @      �?7!2               68�>%:!               6!              68�>%7      @      �?7!~              6!1               68�>%:!               6!               68�>%7       @      �?7     �o@!               6      8@!               68�>%7      @@Uq
               6z>	      �	   binb2rstr       L   �>%�>%�>%       &        �   output      �   length  
    �   i        �>%        �  input          P   �   �   �   �   �       P   �  �   �      G  0      =   k   {   �   �   �   
  Y  �  �          j4               68�>%7!               6!8               68�>%7      @@p	               6        8�>%7       @8�>%7l               6!+               68�>%78�>%7j               6Rsj    ��          6j4               68�>%7!               68�>%7!f               6!u              6!1               6!w>��          68�>%:!               6!              68�>%7      @      �?7!               6      8@!               68�>%7      @@     �o@Uq
               6j               68�>%7z>	      �   rstr2hex       ~   �>%�>%�>%�>%�>%       '   :   H        �   hex_tab       �   output      �   length  
    �   i  
    �   x        �>%         �   input  0       �   �     G  \  �  �  0  4  H  [     �   H    [     �  D      �   �   �     7  >  �      B  [  t  �  �          �  j4               68�>%7      H@     �H@      I@     �I@      J@     �J@      K@     �K@      L@     �L@     @X@     �X@     �X@      Y@     @Y@     �Y@ j4               68�>%7!e               68�>%7p	               6        8�>%7      �?8�>%7l               6!+               68�>%78�>%7j               6Rsj    ��         x = input.charCodeAt(i); 6j    ��      P   output += hex_tab.charAt((x >>> 4) & 0x0F) +  hex_tab.charAt( x        & 0x0F); 6j4               68�>%78�>%:!               68�>%7      �?7j4               68�>%7!               68�>%7!f               68�>%:!               6!1               6!w>��          68�>%7      @      .@      �?7!f               68�>%:!               6!1               68�>%7      .@      �?7j    ��          6Uq
               6j               6!Z               68�>%7z>	      �   rstr2b64       �   �>%�>%�>%�>%�>%�>%�>%       '   7   E   S   g        �      tab       �   output      �   len  
    �   i  
    �   j      �   triplet       �   input2        �>%         �   input  P       �    X  �  �  �  �    �  �  �    �  �  �  �  �  �    -   X  �  �  �    �  �  �    �     M  �      �    "  ;  s  �  �  �  �  $  =  �  �  �  �  /  @  H  a  �  �  Z  }  �  �  �      "  _  �        '  j4               68�>%7   A    B    C    D    E    F    G    H    I    J    K    L    M    N    O    P    Q    R    S    T    U    V    W    X    Y    Z    a    b    c    d    e    f    g    h    i    j    k    l    m    n    o    p    q    r    s    t    u    v    w    x    y    z    0    1    2    3    4    5    6    7    8    9    +    /  j4               68�>%7!e               68�>%7j4               68�>%7!               68�>%7                 p	               6        8�>%7      @8�>%7l               6!+               68�>%78�>%7j               6Rsj    ��          6j4               68�>%7!2               6!~              68�>%:!               68�>%7      �?7      0@!�               6!(               6!               68�>%7      �?8�>%7!~              68�>%:!               68�>%7       @7       @        !�               6!(               6!               68�>%7       @8�>%78�>%:!               68�>%7      @7        p	               6              @      �?8�>%7l               6!+               68�>%7      @j               6Rsj    ��          6k                6!)               6!               6!               68�>%7       @!               68�>%7      @!               68�>%7       @j4               68�>%7!               68�>%7   = Pj4               68�>%7!               68�>%78�>%:!               6!1               6!w>��          68�>%7!               6      @!               6      @8�>%7     �O@      �?7Qrj    ��          6Uq
               6j    ��          6Uq
               6j               68�>%7z>	           str2binl       g   �>%�>%�>%�>%       %   9       �      bin      �   mask      �   length8  
    �   i     3   �>%�>%            �   str      �  return  ,       #   s   �   �     I  ^  �  �  
     �   �    ]      L      5   `   �   �   �     9  @  �  �    A  �  �  �  �    #      +  j4               68�>%7     �o@j4               68�>%7!               6!e               68�>%7       @j7               68�>%7  !               6!              68�>%7      @      �?j    ��          6p	               6        8�>%7       @8�>%7l               6!+               68�>%78�>%7j               6Rsj    ��      :   bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (i%32) 6j4               68�>%:!               6!              68�>%7      @      �?7!2               68�>%:!               6!              68�>%7      @      �?7!~              6!1               68�>%:!               6!               68�>%7       @      �?78�>%7!               68�>%7      @@Uq
               6j4               68�>%78�>%7z>	      �   binl2str       {   �>%�>%�>%�>%�>%       !   3   A        �   str      �   mask      �   len32  
    �   i      �   index        �>%        �  bin  (       #   s   �   �   �     �    (     �     �        -  @      5   `   �   �   �   �     ?  j  �  �  �  �  	  :      B  j4               68�>%7     �o@j4               68�>%7!               6!8               68�>%7      @@j    ��          6p	               6        8�>%7       @8�>%7l               6!+               68�>%78�>%7j               6Rsj4               68�>%7!1               6!w>��          68�>%:!               6!              68�>%7      @      �?7!               68�>%7      @@8�>%7j4               68�>%7!               68�>%7!f               6!u              68�>%7Uq
               6j               68�>%7z>	      �   binl2hex       �   �>%�>%�>%�>%�>%�>%       !   /   C   Q        �   str      �   len4  
    �   i       �   hex_tab  
    �   a  
    �   b        �>%        �  binarray  ,       P   �     B  v  �  v  E  �  	       �  B  �      X      =   b   *  :  f  m  �  �  �  E  �  �  �    W  p  �  �  �  �        #  j4               68�>%7!               6!8               68�>%7      @j4               68�>%7      H@     �H@      I@     �I@      J@     �J@      K@     �K@      L@     �L@     @X@     �X@     �X@      Y@     @Y@     �Y@ j    ��          6p	               6        8�>%7      �?8�>%7l               6!+               68�>%78�>%7j               6Rsj4               68�>%7!1               6!              68�>%:!               6!              68�>%7       @      �?7!               6!               6!               68�>%7      @       @      @      .@j4               68�>%7!1               6!              68�>%:!               6!              68�>%7       @      �?7!               6!               68�>%7      @       @      .@j4               68�>%7!               68�>%7!P               68�>%:!               68�>%7      �?7!P               68�>%:!               68�>%7      �?7Uq
               6j               68�>%7z>	      �   binl2b64         �>%�>%�>%�>%�>%�>%�>%�>%�>%�>%�>%       $   5   G   U   c   q      �   �        �      tab       �   str      �   len4      �   len32  
    �   i  
    �   a  
    �   b  
    �   c      �   triplet  
    �   j      �      binarray2        �>%        �  binarray  \       �  ,  |  �  �  �  '  <  '  J  Q  �  �  �    &  �  �  �  �  �  �  -   �  �  �  ;  �  �  �    &  �      �      �    >  i  �  �  �  �  �      N  �  �  �  9  v  �    \  �  �  )  c  |  �  �  �  �  n  �  �  �  �  �      W  �  	      	  j4               68�>%7   A    B    C    D    E    F    G    H    I    J    K    L    M    N    O    P    Q    R    S    T    U    V    W    X    Y    Z    a    b    c    d    e    f    g    h    i    j    k    l    m    n    o    p    q    r    s    t    u    v    w    x    y    z    0    1    2    3    4    5    6    7    8    9    +    /  j4               68�>%7!               6!8               68�>%7      @j4               68�>%7!               6!8               68�>%7      @@j4               68�>%78�>%7j;               68�>%7        p	               6        8�>%7      @8�>%7l               6!+               68�>%78�>%7j               6Rsj4               68�>%7!~              6!1               6!              68�>%:!               6!              68�>%7       @      �?7!               6       @!               68�>%7      @     �o@      0@j4               68�>%7!~              6!1               6!              68�>%:!               6!              6!               68�>%7      �?       @      �?7!               6       @!               6!               68�>%7      �?      @     �o@       @j4               68�>%7!1               6!              68�>%:!               6!              6!               68�>%7       @       @      �?7!               6       @!               6!               68�>%7       @      @     �o@j4               68�>%7!2               68�>%78�>%78�>%7p	               6              @      �?8�>%7l               6!+               68�>%7      @j               6Rsj    ��          6k                6!)               6!               6!               68�>%7       @!               68�>%7      @8�>%7j4               68�>%7!               68�>%7   = Pj4               68�>%7!               68�>%78�>%:!               6!1               6!              68�>%7!               6      @!               6      @8�>%7     �O@      �?7Qrj    ��          6Uq
               6Uq
               6j               68�>%7z>	        	   binb_sha1       �  �>%�>%�>%�>%�>%�>%�>%�>% ?%?%?%?%?%?%?%?%?%           .   <   J   X   f   z   �   �   �   �   �   �   �   �       �  P   w  
    �   a  
    �   b  
    �   c  
    �   d  
    �   e  
    �   i      �   xlength      �   olda      �   oldb      �   oldc      �   oldd      �   olde  
    �   j  
    �   t       �   ret      �   tmp     I   �>%�>%�>%          
    �  x      �   len      �
  return  �       4   �   �     2  E  T  �  !  D  g  �  �  �  �    J  _  �  �  �  �    9  o  �  �  +  �  �  �  �  	  \	  }	  �	  �	  �	  �	  �	  &
  a
  �
  �
    &  9  _  �  �  �  �  6   �   1  �  &    ^    �	  9  �  �  �  8   h  �      9  i  {  �  8	  
  ?
  z
  �
  �
  �     +   F   �   �       (  W  �  �  �  ?  f  �  �  �    3  V  y  �  �  �    :  A  q  x  �  �  �  �  �  �  �  �  1  ]  �  �  �  �      =  V  �  �  �  �    E  a  �  �  (  K  R  Y  `  �  �  �  �  �  �  	  	  1	  J	  n	  u	  �	  �	  �	  
  
  8
  Q
  X
  s
  �
  �
  �
  �
  �
  �
    	  K  q  ~  �  �  �  �  �  �          "  j4               68�>%7!8               68�>%7j4               68?%7!               6!~              6!              6!               68�>%7      P@      "@      @      0@j    ��          6l               6!(               68�>%78?%7j7               68�>%7��8?%7Rsj    ��          6j4               68�>%:!               6!              68�>%7      @      �?7!2               68�>%:!               6!              68�>%7      @      �?7!~              6      `@!               6      8@!               68�>%7      @@j4               68�>%:!               6!~              6!              6!               68�>%7      P@      "@      @      0@78�>%7j4               68�>%7!8               68�>%7j4               68�>%7  @�H��Aj4               68�>%7   wT2��j4               68�>%7  ��H���j4               68�>%7   vT2�Aj4               68�>%7   ���j    ��          6p	               6        8�>%7      0@8�>%7l               6!+               68�>%78�>%7j               6Rsj4               68 ?%78�>%7j4               68?%78�>%7j4               68?%78�>%7j4               68?%78�>%7j4               68?%78�>%7p	               6              T@      �?8?%7l               6!+               68?%7      T@j               6Rsk                6!(               68?%7      0@j4               68�>%:!               68?%7      �?78�>%:!               68�>%78?%7      �?7Pj4               68�>%:!               68?%7      �?7!C>��          6!3               68�>%:!               6!               68?%7      @      �?78�>%:!               6!               68?%7       @      �?78�>%:!               6!               68?%7      ,@      �?78�>%:!               6!               68?%7      0@      �?7      �?Qrj    ��         w [j �� 1] �� 0 6j4               68?%7!B>��          6!B>��          6!C>��          68�>%7      @!E>��          68?%78�>%78�>%78�>%7!B>��          6!B>��          68�>%78�>%:!               68?%7      �?7!D>��          68?%7j4               68�>%78�>%7j4               68�>%78�>%7j4               68�>%7!C>��          68�>%7      >@j4               68�>%78�>%7j4               68�>%78?%7j    ��          6Uq
               6j    ��          6j    ��          6j4               68�>%7!B>��          68�>%78 ?%7j4               68�>%7!B>��          68�>%78?%7j4               68�>%7!B>��          68�>%78?%7j4               68�>%7!B>��          68�>%78?%7j4               68�>%7!B>��          68�>%78?%7j    ��          6Uq
               6j7               68�>%7        @j4               68�>%:;   78�>%7j4               68�>%:;   78�>%7j4               68�>%:;   78�>%7j4               68�>%:;   78�>%7j4               68�>%:;   78�>%7z>	           binb_sha256       �  ?%?%?%?%?%?%?%?%?%?%?%?%?%?%?%?%?%       .   @   N   \   j   x   �   �   �   �   �   �   �   �   �       �      sha256_K      �      HASH      �  @   W  
    �   a  
    �   b  
    �   c  
    �   d  
    �   e  
    �   f  
    �   g  
    �   h  
    �   i  
    �   j      �   T1      �   T2      �   tmp      �   mlength     G   	?%
?%?%          
    �  m  
    �   l      �
  return  �       \  �  Q  �  �  �  �    J  ]  �  �  �  �    :  a  �  �  �  �  $  Y  �  �  �  �  ^  
  ,
  1  �  �  �  �    Q  r  �  �  �    J  �  �    f  �  �  <  O  6   �  �  ]  <  �  �  $  �  Y  �  �  
  `   �  �  �  �  s	  E
  W
  i
  {
  �
  �
  J  \  v  /  �  "  i  �  �  >  �  �    �     n  �  !  c  |  �  �  �  �  �    J  u  �       (  A  x  �  �  �  �    %  ,  L  S  s  z  �  �  �  �  �  �      Q  }  �  �    *  C  J  p  �  �  	  +	  V	  �	  �	  �	  �	  >
  �
  �
  �
  �
  �
  �
  �
      C  n  �  �  �  �  �  �  �      (  A  H  c  j  �  �  �  �  �  �  �    4  ;  \  {  �  �  �  �  �  	    1  P  W  x  �  �  �  �  �    %  ,  a  h      p  j4               68?%7   拢�A  @$�M�A  @����   [$J��  �-a��A  @|D|�A   Wp��  �J�8��   �*���   [��A   ���A  �pC�A   ]���A  ��S���  @V���   F2��   ?�d��   z�A��   �;��A   �P�A  �7���A  �*!��A   w*,�A  �6b��A  ��k���  �d����   6���  @�)��  �����  �\7,��   D�)�A   g))�A  �B���A   ���A   K�A  �D��A   ՜B�A  �����A  ��M���  ��tc��  ��P��  @mf���   H:���  �.�I��  ��6��   �|���   ����   p�j�A   ���A   l7�A   �;��A  �Z^X�A  �Y��A  ��*��A  ��2��A  ����A  ���#�A  ��X)�A   �����   ~?���  �@���  @�����  @�A��   �C��� j4               68?%7  ��y��A  �^&��   �y7�A  �����  ���C�A   ݥ>��   �ك�A  @F3��A j4               68?%7!               6!~              6!              6!               68
?%7      P@      "@      @      0@j4               68?%7!8               68	?%7l               6!(               68?%78?%7j7               68	?%7��8?%7Rsj4               68	?%:!               6!              68
?%7      @      �?7!2               68	?%:!               6!              68
?%7      @      �?7!~              6      `@!               6      8@!               68
?%7      @@j4               68	?%:8?%778
?%7j4               68?%7!8               68	?%7j    ��          6p	               6        8?%7      0@8?%7l               6!+               68?%78?%7j               6Rsj    ��          6j4               68?%78?%:;   7j4               68?%78?%:;   7j4               68?%78?%:;   7j4               68?%78?%:;   7j4               68?%78?%:;   7j4               68?%78?%:;   7j4               68?%78?%:;   7j4               68?%78?%:;   7p	               6              P@      �?8?%7l               6!+               68?%7      P@j               6Rsj    ��          6k                6!(               68?%7      0@j4               68?%:!               68?%7      �?78	?%:!               68?%78?%7      �?7Pj4               68?%:!               68?%7      �?7!B>��          6!B>��          6!B>��          6!M>��          68?%:!               6!               68?%7       @      �?78?%:!               6!               68?%7      @      �?7!L>��          68?%:!               6!               68?%7      .@      �?78?%:!               6!               68?%7      0@      �?7Qrj    ��          6j4               68?%7!B>��          6!B>��          6!B>��          6!B>��          68?%7!K>��          68?%7!H>��          68?%78?%78?%78?%:!               68?%7      �?78?%:!               68?%7      �?7j4               68?%7!B>��          6!J>��          68?%7!I>��          68?%78?%78?%7j    ��          6j4               68?%78?%7j4               68?%78?%7j4               68?%78?%7j4               68?%7!B>��          68?%78?%7j4               68?%78?%7j4               68?%78?%7j4               68?%78?%7j4               68?%7!B>��          68?%78?%7Uq
               6j4               68?%:;   7!B>��          68?%78?%:;   7j4               68?%:;   7!B>��          68?%78?%:;   7j4               68?%:;   7!B>��          68?%78?%:;   7j4               68?%:;   7!B>��          68?%78?%:;   7j4               68?%:;   7!B>��          68?%78?%:;   7j4               68?%:;   7!B>��          68?%78?%:;   7j4               68?%:;   7!B>��          68?%78?%:;   7j4               68?%:;   7!B>��          68?%78?%:;   7Uq
               6j4               68?%78?%7z>	           core_md5          ?%!?%"?%#?%$?%%?%&?%'?%(?%)?%*?%       $   2   @   N   \   j   {   �   �       �   tmp      �   xlength  
    �   i  
    �   a  
    �   b  
    �   c  
    �   d      �   olda      �   oldb      �   oldc      �   oldd     I   ?%?%?%          
    �  x      �   len      �
  return  �      4   �     W  j  }  p  �  �  �    5  X  k  �  �  �    )  J  k  ~    �  +  �  I  �  g  �  �	  
  �
  2  �  P  �  n  �    �  .  �  L  �  j  �  �    �  5  �  S  �  q  �    �  1  �  O  �  m  �  �    �  8  �  V  �  t  �     �   4!  �!  R"  �"  p#  �#  �$  %  �%  ;&  �&  Y'  �'  w(  �(  �(   )  ;)  w)  �)  �)  �)  �)  *  8*     �   V  k  w)  �  �    q   �  &  �  D  �  b  �  �  	  �	  -
  �
  K  �  i  �  �  )  �  G  �  e  �  �    �  0  �  N  �  l  �  �  ,  �  J  �  h  �  �    �  3  �  Q  �  o  �  �  /   �   M!  �!  k"  �"  �#  $  �$  6%  �%  T&  �&  r'  (  �(  �(  )  T)  �     +   F   �   �     '  C  �  �  �    \  �  �  �  �  �    $  G  �  �  �  �  �       !  ;  B  \  c  �  �  �  �  �  �  �    8  ?  F  M  T  m  �  �  �  �  �  �  �  =  V  ]  d  k  r  �  �  �  �  �  �      [  t  {  �  �  �  �  �    
        8  y  �  �  �  �  �  �  	  !	  (	  /	  6	  =	  V	  �	  �	  �	  �	  �	  �	  �	  &
  ?
  F
  M
  T
  [
  t
  �
  �
  �
  �
  �
  �
    D  ]  d  k  r  y  �  �  �  �  �      !  b  {  �  �  �  �  �  �  
        &  ?  �  �  �  �  �  �  �  "  ;  B  I  P  W  p  �  �  �  �  �  �  �  @  Y  `  g  n  u  �  �  �  �  �  �      ^  w  ~  �  �  �  �  �          "  ;  |  �  �  �  �  �  �    $  +  2  9  @  Y  �  �  �  �  �  �  �  )  B  I  P  W  ^  w  �  �  �  �  �  �    G  `  g  n  u  |  �  �  �  �  �      $  e  ~  �  �  �  �  �  �        "  )  B  �  �  �  �  �  �  �  %  >  E  L  S  Z  s  �  �  �  �  �  �    C  \  c  j  q  x  �  �  �  �  �          a  z  �  �  �  �  �  �  	        %  >    �  �  �  �  �  �    '  .  5  <  C  \  �  �  �  �  �  �  �  ,  E  L  S  Z  a  z  �  �  �  �  �  �  	  J  c  j  q  x    �  �  �  �         '  h  �  �  �  �  �  �  �        %  ,  E  �  �  �  �  �  �  �  (   A   H   O   V   ]   v   �   �   �   �   �   �   !  F!  _!  f!  m!  t!  {!  �!  �!  �!  �!  �!  "  
"  #"  d"  }"  �"  �"  �"  �"  �"  �"  #  #  #  !#  (#  A#  �#  �#  �#  �#  �#  �#  �#  $  *$  1$  8$  ?$  F$  _$  �$  �$  �$  �$  �$  �$  �$  /%  H%  O%  V%  ]%  d%  }%  �%  �%  �%  �%  �%  �%  &  M&  f&  m&  t&  {&  �&  �&  �&  �&  �&  '  
'  '  *'  k'  �'  �'  �'  �'  �'  �'  �'  (  (  !(  ((  /(  H(  �(  �(  �(  �(  �(  �(  )  +)  2)  M)  f)  m)  �)  �)  �)  �)  	*  #*  0*  J*  W*      _*  j4               68!?%7!8               68?%7j4               68 ?%7!               6!~              6!w>��          6!               68?%7      P@      "@      @      .@l               6!(               68!?%7!               68 ?%7      �?j7               68?%7��!               68 ?%7      �?Rsj    ��          6j    ��          6j4               68?%:!               6!              68?%7      @      �?7!2               68?%:!               6!              68?%7      @      �?7!~              6      `@!               68?%7      @@j4               68?%:8 ?%778?%7j4               68!?%7!8               68?%7j4               68#?%7  @�H��Aj4               68$?%7   wT2��j4               68%?%7  ��H���j4               68&?%7   vT2�Aj    ��          6p	               6        8!?%7      0@8"?%7l               6!+               68"?%78!?%7j               6Rsj4               68'?%78#?%7j4               68(?%78$?%7j4               68)?%78%?%7j4               68*?%78&?%7j    ��          6j4               68#?%7!S>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7              �?7      @   ĭJ��j4               68&?%7!S>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      �?      �?7      (@   �H8��j4               68%?%7!S>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7       @      �?7      1@  �m8�Aj4               68$?%7!S>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      @      �?7      6@   �!��j4               68#?%7!S>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      @      �?7      @   ����j4               68&?%7!S>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      @      �?7      (@  �����Aj4               68%?%7!S>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      @      �?7      1@  @{����j4               68$?%7!S>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      @      �?7      6@   �W˅�j4               68#?%7!S>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7       @      �?7      @   6&`�Aj4               68&?%7!S>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      "@      �?7      (@  @�.��j4               68%?%7!S>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      $@      �?7      1@    ����j4               68$?%7!S>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      &@      �?7      6@  �ʨ��j4               68#?%7!S>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      (@      �?7      @  �H��Aj4               68&?%7!S>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      *@      �?7      (@   hs<��j4               68%?%7!S>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      ,@      �?7      1@  ��a��j4               68$?%7!S>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      .@      �?7      6@  @m�Aj    ��          6j4               68#?%7!T>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      �?      �?7      @   <�ã�j4               68&?%7!T>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      @      �?7      "@   `����j4               68%?%7!T>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      &@      �?7      ,@  �(-/�Aj4               68$?%7!T>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7              �?7      4@   V8I��j4               68#?%7!T>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      @      �?7      @  ��w���j4               68&?%7!T>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      $@      �?7      "@   �� �Aj4               68%?%7!T>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      .@      �?7      ,@  �����j4               68$?%7!T>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      @      �?7      4@   8,��j4               68#?%7!T>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      "@      �?7      @   ����Aj4               68&?%7!T>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      ,@      �?7      "@   |d��j4               68%?%7!T>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      @      �?7      ,@   ��U��j4               68$?%7!T>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7       @      �?7      4@  @;�V�Aj4               68#?%7!T>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      *@      �?7      @  �����j4               68&?%7!T>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7       @      �?7      "@   @����j4               68%?%7!T>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      @      �?7      ,@  @����Aj4               68$?%7!T>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      (@      �?7      4@  ��l���j    ��          6j4               68#?%7!U>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      @      �?7      @    ��j4               68&?%7!U>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7       @      �?7      &@  �_�#��j4               68%?%7!U>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      &@      �?7      0@  �HXg�Aj4               68$?%7!U>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      ,@      �?7      7@   �?ր�j4               68#?%7!U>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      �?      �?7      @   oE���j4               68&?%7!U>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      @      �?7      &@  @���Aj4               68%?%7!U>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      @      �?7      0@   @i���j4               68$?%7!U>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      $@      �?7      7@   �P��j4               68#?%7!U>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      *@      �?7      @   c�M�Aj4               68&?%7!U>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7              �?7      &@   �^��j4               68%?%7!U>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      @      �?7      0@  ��g���j4               68$?%7!U>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      @      �?7      7@   t �Aj4               68#?%7!U>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      "@      �?7      @  ����j4               68&?%7!U>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      (@      �?7      &@   f$��j4               68%?%7!U>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      .@      �?7      0@   �|��Aj4               68$?%7!U>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7       @      �?7      7@  ��ԩ��j    ��          6j4               68#?%7!V>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7              �?7      @   x����j4               68&?%7!V>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      @      �?7      $@  ����Aj4               68%?%7!V>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      ,@      �?7      .@  @���j4               68$?%7!V>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      @      �?7      5@   8�b��j4               68#?%7!V>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      (@      �?7      @  �p�V�Aj4               68&?%7!V>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      @      �?7      $@  ���<��j4               68%?%7!V>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      $@      �?7      .@    �0�j4               68$?%7!V>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      �?      �?7      5@  �����j4               68#?%7!V>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7       @      �?7      @  ����Aj4               68&?%7!V>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      .@      �?7      $@    �1}�j4               68%?%7!V>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7      @      �?7      .@   ;�?��j4               68$?%7!V>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      *@      �?7      5@  @h��Aj4               68#?%7!V>��          68#?%78$?%78%?%78&?%78?%:!               68"?%7      @      �?7      @   �Y��j4               68&?%7!V>��          68&?%78#?%78$?%78%?%78?%:!               68"?%7      &@      �?7      $@  �rC���j4               68%?%7!V>��          68%?%78&?%78#?%78$?%78?%:!               68"?%7       @      �?7      .@  �]�k�Aj4               68$?%7!V>��          68$?%78%?%78&?%78#?%78?%:!               68"?%7      "@      �?7      5@   o,y��j    ��          6j4               68#?%7!B>��          68#?%78'?%7j4               68$?%7!B>��          68$?%78(?%7j4               68%?%7!B>��          68%?%78)?%7j4               68&?%7!B>��          68&?%78*?%7Uq
               6j    ��          6j7               68?%7        @j4               68?%:;   78#?%7j4               68?%:;   78$?%7j4               68?%:;   78%?%7j4               68?%:;   78&?%7z>	      �	   rstr_sha1       <   ,?%-?%           �      ����1      �      ����2        +?%    
     �   s         !   x              !   �            3   ^   p   �       �   jW>��          68+?%78,?%7j_>��          68,?%7!               6!e               68+?%7       @8-?%7j               6!X>��          68-?%7z>	      �   rstr_sha256       <   /?%0?%           �      ����1      �      ����2        .?%    
     �   s         F   g   �          F   g   �      X   _   y   �   �   �       �   j    ��      3   binb2rstr(binb_sha256(rstr2binb(s), s.length * 8)) 6jW>��          68.?%78/?%7j`>��          68/?%7!               6!e               68.?%7       @80?%7j               6!X>��          680?%7z>	     �   rstr_hmac_sha1       �   3?%4?%5?%6?%7?%8?%9?%       (   =   R   `   y       �      bkey      �   length      �     ipad      �     opad  
    �   i      �      ��������      �      hash     1   1?%2?%            �   key       �   data  \       !   4   h   �   �   
  S  {  �  �    Y  m  �  �  �  �  H  b  �  �  �     h   �   
  z  �  m         �   �  �  �  �  p         F   _   �   �   �   �   @  e  �  �  �     @  �  �  �  �  �  -  @  Z  t  {  �  �         	  jW>��          681?%783?%7j    ��          6j4               684?%7!8               683?%7l               6!)               684?%7      0@j_>��          683?%7!               6!e               681?%7       @83?%7Rsj    ��          6l               6!(               6!8               683?%7      0@j7               683?%7��      0@Rsj    ��          6p	               6      �?      0@      �?87?%7j4               685?%:87?%77!3               683?%:87?%77   �Aj4               686?%:87?%77!3               683?%:87?%77   �Aj    ��          6Uq
               6jW>��          682?%788?%7j;               685?%788?%7j    ��          6j_>��          685?%7!               6      �@!               6!e               682?%7       @89?%7j>               688?%7j;               686?%789?%7j    ��          6j_>��          686?%7!               6      �@      d@88?%7j               6!X>��          688?%7z>	      �   rstr_hmac_sha256       �   <?%=?%>?%??%@?%A?%B?%       (   =   R   `   y       �      bkey      �   length      �     ipad      �     opad  
    �   i      �      ��������      �      hash     1   :?%;?%            �   key       �   data  \       !   4   h   �   �   
  S  {  �  �    Y  m  �  �  �  �  H  b  �  �  �     h   �   
  z  �  m         �   �  �  �  �  p         F   _   �   �   �   �   @  e  �  �  �     @  �  �  �  �  �  -  @  Z  t  {  �  �         	  jW>��          68:?%78<?%7j    ��          6j4               68=?%7!8               68<?%7l               6!)               68=?%7      0@j`>��          68<?%7!               6!e               68:?%7       @8<?%7Rsj    ��          6l               6!(               6!8               68<?%7      0@j7               68<?%7��      0@Rsj    ��          6p	               6      �?      0@      �?8@?%7j4               68>?%:8@?%77!3               68<?%:8@?%77   �Aj4               68??%:8@?%77!3               68<?%:8@?%77   �Aj    ��          6Uq
               6jW>��          68;?%78A?%7j;               68>?%78A?%7j    ��          6j`>��          68>?%7!               6      �@!               6!e               68;?%7       @8B?%7j>               68A?%7j;               68??%78B?%7j    ��          6j`>��          68??%7!               6      �@      p@8A?%7j               6!X>��          68A?%7z>	           core_hmac_md5       �   F?%G?%H?%I?%J?%K?%L?%       (   =   R   `   y       �      bkey      �   length      �     ipad      �     opad  
    �   i      �      ��������      �      hash     J   C?%D?%E?%       !        �   key       �   data      �  ����  \       !   4   h   �   �   
  S  {  �  �    Y  m  �  �  �  �  H  b  �  �  �     h   �   
  z  �  m         �   �  �  �  t         F   _   �   �   �   �   @  e  �  �  �     @  �  �  �  �  �  -  @  Z  t  {  �  �  �  �      �  j[>��          68C?%78F?%7j    ��          6j4               68G?%7!8               68F?%7l               6!)               68G?%7      0@ja>��          68F?%7!               6!e               68C?%7       @8F?%7Rsj    ��          6l               6!(               6!8               68F?%7      0@j7               68F?%7��      0@Rsj    ��          6p	               6      �?      0@      �?8J?%7j4               68H?%:8J?%77!3               68F?%:8J?%77   �Aj4               68I?%:8J?%77!3               68F?%:8J?%77   �Aj    ��          6Uq
               6j[>��          68D?%78K?%7j;               68H?%78K?%7j    ��          6ja>��          68H?%7!               6      �@!               6!e               68D?%7       @8L?%7j>               68K?%7j;               68I?%78L?%7j    ��          6ja>��          68I?%7!               6      �@      `@8K?%7j4               68E?%78K?%7z>	      �   hex_hmac_sha1               ,   M?%N?%       
     �   k  
     �   d            $             $      6   =       G   j              6!Y>��         6!d>��          68M?%78N?%7z>	      �   hex_hmac_sha256               1   O?%P?%            �   data       �   key                   $      6   =       G   j               6!Y>��          6!e>��          68P?%78O?%7z>	      �   hex_hmac_md5          S?%        �      ����     1   Q?%R?%            �   key       �   data         N              `      $   >   F   r       {   jf>��          6!f               68Q?%7!f               68R?%78S?%7j               6!]>��          68S?%7z>	      �   b64_hmac_sha1               ,   T?%U?%       
     �   k  
     �   d            $             $      H   b       m   j              6!Z>��         6!d>��          6!f               68T?%7!f               68U?%7z>	      �   b64_hmac_sha256               ,   V?%W?%       
     �   k  
     �   d                   $      H   b       m   j               6!Z>��          6!e>��          6!f               68V?%7!f               68W?%7z>	      �   b64_hmac_md5          Z?%        �      ����     1   X?%Y?%            �   key       �   data         N              `      $   >   F   r       {   jf>��          6!f               68X?%7!f               68Y?%78Z?%7j               6!^>��          68Z?%7z>	      �   hex_sha1                  [?%    
     �   s                   $      6       @   j               6!Y>��          6!b>��          68[?%7z>	      �
   hex_sha256                  \?%    
     �   s                   $      6       @   j               6!Y>��          6!c>��          68\?%7z>	      �   hex_md5       ^   ^?%_?%`?%       3       �      ��������      �      ��������2       �   �ֽڼ�        ]?%    
     �   s         !   x              !   �            3   ^   p   �       �   j[>��          68]?%78^?%7ja>��          68^?%7!               6!e               68]?%7       @8_?%7j               6!]>��          68_?%7z>	      �   b64_sha1                  a?%    
     �   s                   $      6       @   j               6!Z>��          6!b>��          68a?%7z>	      �
   b64_sha256                  b?%    
     �   s                   $      6       @   j               6!Z>��          6!c>��          68b?%7z>	      �   b64_md5       ^   d?%e?%f?%       3       �      ��������      �      ��������2       �   �ֽڼ�        c?%    
     �   s         E   f   �          E   f   �      W   ^   x   �   �   �       �   j    ��      2   binl2b64(core_md5(str2binl(s), s.length * chrsz)) 6j[>��          68c?%78d?%7ja>��          68d?%7!               6!e               68c?%7       @8e?%7j               6!^>��          68e?%7z>	      �   RC4����    
   �   i?%j?%k?%l?%m?%n?%o?%p?%q?%r?%           7   O   ]   k   y   �   �        �   key       �   box      �   pwd_length      �   data_length  
    �   a  
    �   i  
    �   j      �   tmp       �   cipher  
    �   k     1   g?%h?%            �   data       �   pwd  �       4   h   �   �   	  ?  T  �    0  e  �  �  �  i  �    ]  p  �  �  �  .  C  V  �  *  =  �  �  0  C    �  �  6   �     	  S  0  ]  e  �  �  �  �  B           +   F   _   z   �     -  f    �  �  �  �      ]  �  �          2  K  {  �  �  �  �  �    )  B  T  �  �  �  �  �    %  h  �  �  �  �    O  V  o  �  �  �  �  �    (  U  \  �  �  �  �    1  U  n  �  �      �  j4               68k?%7!e               68h?%7j4               68l?%7!e               68g?%7j4               68i?%7!o               6      p@j4               68j?%7!o               6      p@p	               6              p@      �?8n?%7l               6!+               68n?%7      p@j               6Rsj4               68i?%:!               68n?%7      �?78h?%:!               6!               68n?%78k?%7      �?7j4               68j?%:!               68n?%7      �?78n?%7Uq
               6p	               6              p@      �?8n?%7l               6!+               68n?%7      p@j               6Rsj    ��          6j4               68o?%7!               6!               68o?%78j?%:!               68n?%7      �?78i?%:!               68n?%7      �?7      p@j4               68p?%78j?%:!               68n?%7      �?7j4               68j?%:!               68n?%7      �?78j?%:!               68o?%7      �?7j4               68j?%:!               68o?%7      �?78p?%7Uq
               6j4               68o?%7        j4               68q?%7!o               68l?%7p	               6        8l?%7      �?8n?%7l               6!+               68n?%78l?%7j               6Rsj    ��          6j4               68m?%7!               6!               68m?%7      �?      p@j4               68o?%7!               6!               68o?%78j?%:!               68m?%7      �?7      p@j    ��          6j4               68p?%78j?%:!               68m?%7      �?7j4               68j?%:!               68m?%7      �?78j?%:!               68o?%7      �?7j4               68j?%:!               68o?%7      �?78p?%7j    ��          6j4               68r?%78j?%:!               6!               6!               68j?%:!               68m?%7      �?78j?%:!               68o?%7      �?7      p@      �?7j4               68q?%:!               68n?%7      �?7!3               68g?%:!               68n?%7      �?78r?%7Uq
               6j               68q?%7z>	      �   RC4_����               2   s?%t?%            �   ����       �   ��Կ                      $   =       G   j               6!s>��          68s?%7!f               68t?%7z>	      �   RC4_����               2   u?%v?%            �   ����       �   ��Կ                      $   =       G   j               6!s>��          68u?%7!f               68v?%7z>	     �   �߼�����   ���߼����ƣ� ���������ƣ�           D   w?%x?%           �   ���ƶ�������      �   �����ƶ���λ��         �                   �   j�              6     @T@     `a@     @Q@       @     @a@     @S@      (@     `j@      l@     @V@     `a@     �l@     @W@     @h@       @         j               6      �z>	     �   �߼�����#   ���߼����ƣ� ���������ƣ� �Ĵ�����1           D   y?%z?%           �   ���ƶ�������      �   �����ƶ���λ��         �                   �   j�              6     @T@     `a@     @Q@       @     @a@     @S@      (@     `j@      m@     @V@     `a@     �l@     @W@     @h@       @         j               6      ��0          ��ѯ��ǰί����ʷί��       �   K@%L@%M@%N@%O@%P@%       $   7   J   [        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL  
   �  Z@%[@%\@%]@%^@%_@%`@%a@%I@%J@%    %   �   �     �  �  *  `  �  !     �   symbol ���׶ԣ��ethcny ~     �  types ��ѯ�Ķ���������ϣ�ʹ��','�ָ buy-market���м���, sell-market���м���, buy-limit���޼���, sell-limit���޼��� 2     �  startdate ��ѯ��ʼ����, ���ڸ�ʽyyyy-mm-dd 0     �  enddate ��ѯ��������, ���ڸ�ʽyyyy-mm-dd �     �   states ��ѯ�Ķ���״̬��ϣ�ʹ��','�ָpre-submitted ׼���ύ, submitted ���ύ, partial-filled ���ֳɽ�, partial-canceled ���ֳɽ�����, filled ��ȫ�ɽ�, canceled �ѳ��� .     �  from ��ѯ��ʼ ID....�����̫����ɶ��˼ -     �  direct ��ѯ����prev ��ǰ��next ��� 2     �  size ��ѯ��¼��С,����Ҫ����������ݵ���˼      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ         p   �     g  �  6  �         +   =   �     �  �    x      �   �     C  ]  y  �  �  �    !  6  I  ^  �  �  �  +  �  �   "  h  }  �  �  �  �  �  �      �  j4               68O@%7!`               6!v`��          6!�@��          6      �?        T ��j4              2017-05-11T15%3A19%3A30 68M@%7!m`��          68O@%7��j4               68N@%7!               62   GET\nbe.huobi.com\n/v1/order/orders\nAccessKeyId= 8I@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8M@%7	   &direct= 8`@%7   &end-date= 8]@%7   &from= 8_@%7   &size= 8a@%7   &start-date= 8\@%7	   &states= 8^@%7	   &symbol= 8Z@%7j4               68L@%7!�@��          6!f               68N@%7!f               68J@%7j4               68P@%7!               62   https://be.huobi.com/v1/order/orders?AccessKeyId= 8I@%7	   &direct= 8`@%7   &end-date= 8]@%7   &from= 8_@%7   &start-date= 8\@%7	   &states= 8^@%7   &size= 8a@%7	   &symbol= 8Z@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8M@%7   &Signature= !m`��          68L@%7��j4               68K@%7!�`��          6!Z               6!�`��          68P@%7j          K  {"status":"ok","data":[{"id":552297,"symbol":"ethcny","account-id":127930,"amount":"1.0000000000","price":"0.0","created-at":1496822604374,"type":"buy-market","field-amount":"0.0005000000","field-cash-amount":"0.9119400000","field-fees":"0.0000002500","finished-at":1496823271102,"source":"api","state":"filled","canceled-at":0}]} 68K@%7j    ��          6�0          ��ѯ��ǰ�ɽ���ʷ�ɽ�       �   u@%v@%w@%x@%y@%z@%       $   7   J   [        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL  	     k@%l@%m@%n@%p@%q@%r@%s@%t@%    %   �   �     ,  ]  z  �  !     �   symbol ���׶ԣ��ethcny }     �   types ��ѯ�Ķ���������ϣ�ʹ��','�ָbuy-market���м���, sell-market���м���, buy-limit���޼���, sell-limit���޼��� 2     �   startdate ��ѯ��ʼ����, ���ڸ�ʽyyyy-mm-dd 0     �   enddate ��ѯ��������, ���ڸ�ʽyyyy-mm-dd      �   from ��ѯ��ʼ ID -     �   direct ��ѯ����prev ��ǰ��next ���      �   size ��ѯ��¼��С      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ $       p   �   �  X  �    #  6         +   =   �     �  �  �  p      �   �   	  4  N  j  �  �  �  �    +  @  �  �  �   (  n  �  �  �  �  �  �  �          I  j4               68y@%7!`               6!v`��          6!�@��          6      �?        T ��j4              2017-05-11T15%3A19%3A30 68w@%7!m`��          68y@%7��j4               68x@%7!               68   GET\nbe.huobi.com\n/v1/order/matchresults\nAccessKeyId= 8s@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8w@%7	   &direct= 8q@%7   &end-date= 8n@%7   &from= 8p@%7   &size= 8r@%7   &start-date= 8m@%7	   &symbol= 8k@%7j4               68v@%7!�@��          6!f               68x@%7!f               68t@%7j4               68z@%7!               68   https://be.huobi.com/v1/order/matchresults?AccessKeyId= 8s@%7	   &direct= 8q@%7   &end-date= 8n@%7   &from= 8p@%7   &start-date= 8m@%7   &size= 8r@%7	   &symbol= 8k@%7:   &SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp= 8w@%7   &Signature= !m`��          68v@%7��j4               68u@%7!�`��          6!Z               6!�`��          68z@%7j          �   {"status":"ok","data":[{"id":888878,"order-id":552297,"match-id":790885,"symbol":"ethcny","type":"buy-market","source":"api","price":"1823.8800000000","filled-amount":"0.0005000000","filled-fees":"0.0000002500","created-at":1496823271112}]} 68u@%7j    ��          6j    ��          6�0          ��ѯ��������ֵ�ַ_������
   ��ʱ������   �   �@%�@%�@%�@%�@%�@%       $   7   J   [        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     s   �@%�@%�@%       ;        �   currency ����      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ         _   �   �  �  �    @                  S  j    ��      L   ʱ�� �� ���ı��滻 (ʱ��_���ı� (ȡ����ʱ�� (), 1, ), �� ��, ��T��, , , ��) 6j    ��      ?   ʱ��� �� ����_URL���� (ʱ��, ��, )  ' 2017-05-11T15%3A19%3A30 6j    ��      �   Method �� ��GET\nbe.huobi.com\n/v1/dw/withdraw-virtual/addresses\nAccessKeyId=�� �� AccessKey �� ��&currency=�� �� currency �� ��&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=�� �� ʱ��� 6j    ��      ;   sign �� ����ǩ�� (���ֽڼ� (Method), ���ֽڼ� (SecretKey)) 6j    ��      �   URL �� ��https://be.huobi.com/v1/dw/withdraw-virtual/addresses?AccessKeyId=�� �� AccessKey �� ��&currency=�� �� currency �� ��&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=�� �� ʱ��� �� ��&Signature=�� �� ����_URL���� (sign, ��, ) 6j    ��      (   ticker �� ���ı� (��ҳ_����_���� (URL)) 6j    ��         ������� (ticker) 6j    ��          6�0          �������������_������
   ��ʱ������   �   �@%�@%�@%�@%�@%�@%       $   7   J   [        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     �   �@%�@%�@%�@%        ;   ]        �   addressid ���ֵ�ַID      �   amount �������      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ $       _   �   k  �       E  X                  k  j    ��      L   ʱ�� �� ���ı��滻 (ʱ��_���ı� (ȡ����ʱ�� (), 1, ), �� ��, ��T��, , , ��) 6j    ��      ?   ʱ��� �� ����_URL���� (ʱ��, ��, )  ' 2017-05-11T15%3A19%3A30 6j    ��      �   Method �� ��POST\nbe.huobi.com\n/v1/dw/withdraw-virtual/create\nAccessKeyId=�� �� AccessKey �� ��&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=�� �� ʱ��� 6j    ��      ;   sign �� ����ǩ�� (���ֽڼ� (Method), ���ֽڼ� (SecretKey)) 6j    ��      A   URL �� ��https://be.huobi.com/v1/dw/withdraw-virtual/addresses�� 6j    ��         ticker �� ���ı� (��ҳ_����_���� (URL, 1, ��AccessKeyId=�� �� AccessKey �� ��&address-id=�� �� addressid �� ��&amount=�� �� amount �� ��&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=�� �� ʱ��� �� ��&Signature=�� �� ����_URL���� (sign, ��, ))) 6j    ��         ������� (ticker) 6j    ��          6j    ��          6�0          ����ȡ�����������_������
   ��ʱ������   �   �@%�@%�@%�@%�@%�@%       $   7   J   [        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     w   �@%�@%�@%       ?        �   withdrawid ����ID      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ        _   �   �  �  8  3                  X  j    ��      L   ʱ�� �� ���ı��滻 (ʱ��_���ı� (ȡ����ʱ�� (), 1, ), �� ��, ��T��, , , ��) 6j    ��      ?   ʱ��� �� ����_URL���� (ʱ��, ��, )  ' 2017-05-11T15%3A19%3A30 6j    ��      �   Method �� ��POST\nbe.huobi.com\n/v1/dw/withdraw-virtual/�� �� withdrawid �� ��/cancel\nAccessKeyId=�� �� AccessKey �� ��&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=�� �� ʱ��� 6j    ��      ;   sign �� ����ǩ�� (���ֽڼ� (Method), ���ֽڼ� (SecretKey)) 6j    ��      U   URL �� ��https://be.huobi.com/v1/dw/withdraw-virtual/�� �� withdrawid �� ��/cancel�� 6j    ��      �   ticker �� ���ı� (��ҳ_����_���� (URL, 1, ��AccessKeyId=�� �� AccessKey �� ��&withdraw-id=�� �� withdrawid �� ��&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=�� �� ʱ��� �� ��&Signature=�� �� ����_URL���� (sign, ��, ))) 6j    ��         ������� (ticker) 6�0     �   ����ǩ��          �@%         �   data     =   �@%�@%            �   �����ֽڼ�       �   SecretKey         \   o   �            �   �         +   �   �       %  j4               68�@%7!n               68�@%7!f               6   \n       $@ j    ��          6j    ��          6j               6!`               6!Z               6!�`��          6!e>��          6!f               68�@%78�@%7      ��j    ��          6�8     �
   ȡ����ʱ��9   ���ʱ����õ��ǡ�Эͬ����ʱ�䡱����UTC��Ҳ����GMT����ʽ       �@%       �?A   SysTime                    �                 >   N   ^   n   ~   �          �   j�?
��          68�@%7j               6!�               68�@%9�?5�?A78�@%9�?5�?A78�@%9�?5�?A78�@%9�?5�?A78�@%9�?5�?A78�@%9�?5�?A7j    ��          6�0          ȷ���������������_������
   ��ʱ������   �   �@%�@%�@%�@%�@%�@%       $   7   J   [        �   ticker       �   sign       �   ʱ���       �   Method       �   ʱ��       �   URL     w   �@%�@%�@%       ?        �   withdrawid ����ID      �   AccessKey API ������Կ      �   SecretKey ǩ������Կ        _   �   �  �  6  1                  V  j    ��      L   ʱ�� �� ���ı��滻 (ʱ��_���ı� (ȡ����ʱ�� (), 1, ), �� ��, ��T��, , , ��) 6j    ��      ?   ʱ��� �� ����_URL���� (ʱ��, ��, )  ' 2017-05-11T15%3A19%3A30 6j    ��      �   Method �� ��POST\nbe.huobi.com\n/v1/dw/withdraw-virtual/�� �� withdrawid �� ��/place\nAccessKeyId=�� �� AccessKey �� ��&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=�� �� ʱ��� 6j    ��      ;   sign �� ����ǩ�� (���ֽڼ� (Method), ���ֽڼ� (SecretKey)) 6j    ��      T   URL �� ��https://be.huobi.com/v1/dw/withdraw-virtual/�� �� withdrawid �� ��/place�� 6j    ��      �   ticker �� ���ı� (��ҳ_����_���� (URL, 1, ��AccessKeyId=�� �� AccessKey �� ��&withdraw-id=�� �� withdrawid �� ��&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=�� �� ʱ��� �� ��&Signature=�� �� ����_URL���� (sign, ��, ))) 6j    ��         ������� (ticker) 6�0          _��ť2_������                           :                   M   j    ��      '   ��ѯָ���˻������ (��123456789��, , ) 6j    ��          6�0          _��ť3_������                                           e   j    ��      R   ����һ���µĶ������� (��123456789��, ��1��, ����, ��ethcny��, ��buy-market��, , ) 6�0          _��ť4_������                                           9   j    ��      &   ���볷��һ���������� (��552297��, , ) 6�0          _��ť5_������                                           �   j    ��      z   ��ѯ��ǰί����ʷί�� (��ethcny��, ��buy-market��, ��2017-06-06��, ��2017-06-08��, ��filled��, ��1��, ��prev��, ��1��, , ) 6�0          _��ť6_������                                           �   j    ��      n   ��ѯ��ǰ�ɽ���ʷ�ɽ� (��ethcny��, ��buy-market��, ��2017-06-06��, ��2017-06-08��, ��1��, ��prev��, ��1��, , ) 6`I0          _��ʼ��,   �����ڱ���Ķ��󱻴����󣬴˷����ᱻ�Զ�����                       "          "             5   j4               68-`7   da j`��          6`I0          _����,   �����ڱ���Ķ�������ǰ���˷����ᱻ�Զ�����                                               +   jI              8.`7j�`
��          6`I           ��ʼ��                              ]   �   �   �                    ]   �   4  �      �   F  j�`
��          6        jG             ���� 8.`7   MSScriptControl.ScriptControl jR              8.`7	   Language    JavaScript j    ��      '   ����.��ֵ���� (��AddCode��, #JSON����) 6jV              8.`7   AddCode �`jV              8.`7   Eval !               6   var  8-`7   ={} `I8     �   ����               +   /`%         �   �����ı� json���ı�����           n   �                 Z   n   �   �   �   #      -  j    ��      
   ��ʼ�� () 6jV              8.`7   Eval !               6   var  8-`7   =null jV              8.`7   AddCode !               6   var  8-`7   =eval( 8/`%7   ) j               6!W              8.`7   Eval !               6   null != 8-`7`I8     �
   ȡ�����ı�                           T              f   �       �   j    ��      A   ���� (����.�ı����� (��Eval��, dataName �� ��.toJSONString()��)) 6j               6!U              8.`7   Eval !               6   JSON.stringify( 8-`7   ) `I8          ������               n   0`%1`%2`%       ,        �   ���� ֧��a.b.c[0]      �   ֵ  &     �  Ϊ���� ���Խ���Ϊjson����,����           v   �   �   	       �       0   v   �   �   �      ,   W   m   �   $  2  A      Q  l               682`%7j4               681`%7!�               6!&               681`%7       {} 81`%7jS              8.`7   Eval !               68-`7   . 80`%7   = eval( 81`%7   ) j               6RsjS              8.`7   Eval !               68-`7   . 80`%7   =' 81`%7   ' `I8       
   �����Զ���   ���Խ���Ϊjson����,����           <   3`%4`%            �   ���� ֧��a.b.c[0]      �   ֵ                        3   A   U       e   jS              8.`7   Eval !               68-`7   . 83`%7   = eval( 84`%7   ) `I8       
   ��������ֵ               <   5`%6`%            �   ���� ֧��a.b.c[0]     �   ֵ                        3   A   a       q   jS              8.`7   Eval !               68-`7   . 85`%7   = !Z               686`%7    `I8    �
   ȡ������ֵ               %   7`%         �   ���� ֧��a.b.c[0]                      E   S       ]   j               6!V              8.`7   Eval !               68-`7   . 87`%7`I8     �
   ȡ���Զ���   ���ض����ı�           %   8`%         �   ���� ֧��a.b.c[0]        e   �              �   �   	        j    ��      R   ���� (����.�ı����� (��Eval��, dataName �� ��.�� �� ���� �� ��.toJSONString()��)) 6j    ��      )   ��JSON.stringify(�� �� dataName �� ��)�� 6j               6!U              8.`7   Eval !               6   JSON.stringify( 8-`7   . 88`%7   ) `I8     �
   ȡͨ������   �����ı�      ;`%    
     �   a     s   9`%:`%    (   $     �   ���� ֧��a.b.c[0]����[0].a.b 7     �  Ϊ���� Ϊ���������Ϊ ��ֵ,json{},��Ȼ��ת��"\"        P   s   �            r   s         ,   6   b   �   �   �   �   �     M  T  [      e  l               6!'               6!M               689`%7      �?   [ j4               68;`%7   . Rsl               68:`%7j               6!U              8.`7   Eval !               6   JSON.stringify( 8-`78;`%789`%7   ) Rsj               6!U              8.`7   Eval !               68-`78;`%789`%7`I8   `I   ȡ����       /   =`%>`%          `I   ��ʱ  
     �   a     0   <`%    $     �   ���� ֧��a.b.c[0]����[0].a.b        P   s   �   	       r      s       6   b   s   �   �   �   �           l               6!'               6!M               68<`%7      �?   [ j4               68>`%7   . Rsj`��          8=`%7!U              8.`7   Eval !               6   JSON.stringify( 8-`78>`%78<`%7   ) j               68=`%7`I8    �   ��Ա��               -   ?`%    !     �  ���� ֧��a.b.c,��Ŀ¼Ϊ��        3   �   �   	       �       $   $   E   ^   �   �   �   �     E      V  k                6!'               68?`%7    j4               68?`%7!               68-`7!�               6!&               6!M               68?`%7      �?   [        . 8?`%7Pj4               68?`%78-`7Qrj               6!V              8.`7   Eval !               6   get__count( 8?`%7   ) `I8          �ӳ�Ա       0   C`%D`%       
     �   a       �   _����     i   @`%A`%B`%       1        �   ��Աֵ ����      �  ���� ֧��a.b.c      �  Ϊ���� ��ֵ,json�ڵ�        3   v   �   �   �          �   �   �       <   $   �   �   E   ^   l   �   �   �   H  n  �  �  �  �      �  k                6!'               68A`%7    j4               68D`%7!               68-`7   . 8A`%7Pj4               68D`%78-`7Qrl               6!&               68B`%7  j4               68C`%7   ' RsjS              8.`7   Eval !               6$   if (Object.prototype.toString.call( 8D`%7   ) != '[object Array]') {  8D`%7   =new Array();}  8D`%7   .push( 8C`%78@`%78C`%7   ) `I8   `I   ȡ��Ա       3   G`%H`%          `I   ��ʱ       �   _����     H   E`%F`%           �   ����  #     �  ���� ֧��a.b.c,Ϊ���Ǹ��ڵ�        3   v   �   +  >  	       �      �   ,   $   E   ^   l   �   �   �   �   �     P      X  k                6!'               68F`%7    j4               68H`%7!               68-`7   . 8F`%7Pj4               68H`%78-`7Qrj`��          8G`%7!U              8.`7   Eval !               6   JSON.stringify( 8H`%7   [ !Z               68E`%7   ]) j    ��          6j               68G`%7`I8     �
   ȡ��Ա�ı�          L`%         �   _����     �   I`%J`%K`%       A       �   ���� ֧��a.b.c #     �  ���� ֧��a.b.c,Ϊ���Ǹ��ڵ� 1     �  Ϊ���� ����Ϊ��,���򷵻�obj,��ֵ,json�ڵ�        3   v   �   �   @  U         �   �   T      4   $   E   ^   l   �   �   �     -  g  �  �  �       �  k                6!'               68J`%7    j4               68L`%7!               68-`7   . 8J`%7Pj4               68L`%78-`7Qrl               68K`%7j               6!U              8.`7   Eval !               6   JSON.stringify( 8L`%7   [ !Z               68I`%7   ]) j    ��          6Rsj               6!U              8.`7   Eval !               68L`%7   [ !Z               68I`%7   ] `I8          �ó�Ա          P`%    
     �   a     e   M`%N`%O`%       -       �   ���� ֧��a.b.c      �   ��Աֵ       �  Ϊ���� ��ֵ,json�ڵ�        0   S   	       R           $   B   S   �   �   �   �   �       �   l               6!&               68O`%7  j4               68P`%7   ' RsjS              8.`7   Eval !               68-`7   [ !Z               68M`%7   ]= 8P`%78N`%78P`%7`I8          ɾ��Ա               "   Q`%        �   ���� ֧��a.b.c                       3   Z       m   jS              8.`7   Eval !               68-`7	   .splice( !Z               68Q`%7   ,1) `I8          ������               &   R`%        �   ֵ 0��,4����,5���� (       6   �   �   �      6  l  �  �         �   �   5  6  �      $   $   6   s   �   �     Z  l  �      �  l               6!&               68R`%7        jV              8.`7   Eval !               6   var  8-`7   ={} j               6Rsl               6!&               68R`%7      @jV              8.`7   Eval !               6   var  8-`7   ={} j               6Rsl               6!&               68R`%7      @jV              8.`7   Eval !               6   var  8-`7   =new Array() j               6Rsj    ��          6`I8          ��ֵ          U`%    
     �   a     ?   S`%T`%            �   ֵ       �  Ϊ���� ��ֵ,json�ڵ�        0   S   	       R          $   B   S   �   �   �   �       �   l               6!&               68T`%7  j4               68U`%7   ' RsjW              8.`7   Eval !               68-`7   = 8U`%78S`%78U`%7`I8     �   �����Ƿ����               "   V`%         �   ���� ֧��a.b.c                      E   S       j   j               6!W              8.`7   Eval !               68-`7   . 8V`%7    !=null `I8    �   ȡ����������       2   Y`%Z`%            �   obj       �   _����     F   W`%X`%            �
  ����������       �  ���� a.b,��Ϊ���ڵ� ,       3   v   �   -    �  �  :  g  �  	       �       D   $   E   ^   l   �   �   �   �     ?  X  �  �  �    )  ^      �  k                6!'               68X`%7    j4               68Z`%7!               68-`7   . 8X`%7Pj4               68Z`%78-`7Qrj4               68Y`%7!U              8.`7   Eval !               6   var ary=''; for (var key in  8Z`%7   ) {ary=ary+ key+','; } j4               68Y`%7!`               68Y`%7   toJSONString,     ��j4               68Y`%7!`               68Y`%7   parseJSON,     ��jT              8.`7   Eval 	   ary=null j4               68W`%7!d               68Y`%7   , j               6!8               68W`%7j    ��      '   var jsons = { name: "1111", age: 18 }; 6j    ��      8   "for (var key in jsons){alert(key);alert(jsons[key]);}" 6`I8    �   ȡ����"   ��=0����=2������=4������=5���ı�=6   I   \`%]`%^`%           
     �   l       �   _����       �   text        [`%         �  ����  D       3   v   �   �     ~  �  �    �  �  �  R  �  �  �  $       �   �     }  �    �     �  L   $   E   ^   l   �   �   �   �   �  $  +  l  �  9  s  �  �  v  $      �  k                6!'               68[`%7    j4               68]`%7!               68-`7   . 8[`%7Pj4               68]`%78-`7Qrl               6!W              8.`7   Eval !               68]`%7   ==null j               6        Rsj4               68\`%7!U              8.`7   Eval !               6	   typeof ( 8]`%7   ) mn               6!&               68\`%7   string j               6      @Sn               6!&               68\`%7   object l              ֻ��������� map ������� 6!W              8.`7   Eval !               6   = 8]`%7   .map j    ��      	   ���� (5) 6Rsj4               68^`%7!`��          68[`%7��j               6!�               6!&               6!M               68^`%7      �?   [       @      @Sn               6!&               68\`%7   number j               6       @Soj               6      �Ttj    ��          6`I8          ���                                          3       E   jS              8.`7   Eval !               68-`7   ={} �8     �   ����_URL����       j   q`%r`%s`%t`%       (   9        �   ����ı�       �   �ֽڼ�      �   �ƴ�       �   temp     �   n`%o`%p`%       `        �   ��������ı�  C     �  ��������ĸ���� ����Ҫ���롾��ĸ����.-�����԰Ѵ˲�������Ϊ�� 3     �  �Ƿ�UTF8 �Ȱ��ı�ת����UTF8����,�ٱ����URL t       3   N   b   |   �   �     T  �  �    (  C  �     U  i  �  <  P  �  #  8  |  �  �  �  �  6       M   a   �     �  �    (  �  B  {     �   �   $   t   �   �   �   �   ;  L  f    �  �  
  :  y  �  �    +  D  �  �  �    +  �  �  �  �    J  c  q    �  �  �        l               6!&               68n`%7    j               6    Rsj    ��          6mn               68p`%7j4               68r`%7!f               6!�`��          68n`%7Soj4               68r`%7!f               68n`%7Ttj    ��          6p	               6      �?!e               68r`%7      �?8s`%7j4               68t`%7!u               68r`%:8s`%77l               6!(               6!L               68t`%7       @j4               68t`%7!               6   0 8t`%7Rsj    ��          6k                68o`%7mn               6!-               6!)               68r`%:8s`%77      F@!(               68r`%:8s`%77      M@!'               68r`%:8s`%77     �G@j    ��         -.0-9 6j4               68q`%7!               68q`%7!P               68r`%:8s`%77j    ��          6Sn              A-Z 6!-               6!)               68r`%:8s`%77      P@!(               68r`%:8s`%77     �V@j4               68q`%7!               68q`%7!P               68r`%:8s`%77j    ��          6Sn              a-z 6!-               6!)               68r`%:8s`%77      X@!(               68r`%:8s`%77     �^@j4               68q`%7!               68q`%7!P               68r`%:8s`%77j    ��          6Soj4               68q`%7!               68q`%7   % 8t`%7Ttj    ��          6Pj4               68q`%7!               68q`%7   % 8t`%7Qrj    ��          6Uq
               6j               68q`%7�8     �   ʱ��_���ı�)   �����ı���ʽ������ʱ�䣬�磺2005053107123   x   z`%{`%|`%}`%       0   D        �   ��_���ڸ�ʽ       �   ��_ʱ���ʽ       �   ��_��ʽ      �   ��_��ʽ       w`%x`%y`%    )   �   %     �  ����ʱ�� �ɿա�����Ϊ����ʱ�� f    �  �����ʽ �ɿա�0=N��N��N�� NʱN��N��  1=��-��-�� ʱ:��:��  2=��/��/�� ʱ/��/��  3=������ʱ���� W    �  ȡ������ �ɿա�����Ϊȫ����1=ֻȡ�����գ�2=ȡ���գ�3=ֻȡʱ���룬4=ʱ�֣�5=���� H       a   �   �    �  <  r  �  �  ^  �    J  �  �  }  �  $   <  �  �  ]  ^      �     �  �  �      =   X   1  \  �  �    3  `  �  �  �  �    �  �  \  �  �  �    8  �  �  	  4  s   �   �   �   �  �  �  �  �  �  	  4  W  t      �  j4               68w`%7!�               6!�               68w`%7!�               68w`%7j4               68x`%7!�               6!-               6!+               68x`%7        !*               68x`%7      @8x`%7        j4               68z`%7!�               6!               68x`%7      �?   yyyy��MM��dd��     yyyy-MM-dd     yyyy/MM/dd  	   yyyyMMdd j4               68z`%7!�               6!-               6!+               68y`%7      @!*               68y`%7      @    8z`%7j4               68{`%7!�               6!               68x`%7      �?   hhʱmm��ss�� 	   hh:mm:ss 	   hh/mm/ss    hhmmss j4               68{`%7!�               6!-               6!+               68y`%7      �?!*               68y`%7       @    8{`%7l               6!&               68y`%7      �?j4               68z`%7!]               68z`%7Rsl               6!&               68y`%7       @j4               68z`%7!�               6!               68x`%7      �?	   MM��dd��    MM-dd    MM/dd    MMdd Rsl               6!&               68y`%7      @j4               68{`%7!�               6!               68x`%7      �?	   hhʱmm��    hh:mm    hh/mm    hhmm Rsl               6!&               68y`%7      @j4               68{`%7!�               6!               68x`%7      �?	   mm��ss��    mm:ss    mm/ss    mmss Rsj4               68}`%7!�`��          6j4               68{`%7!�               6!&               68}`%7      �?!`               68{`%7   hh    HH ��8{`%7j4               68|`%7!�`��          68w`%78z`%78{`%7j               68|`%7�8     �   ����_utf8��gb2312               !   �`%         �   ��ת����Դ��                !   3      E       X   j              ��utf8��gb2312 6!�`��          6!�`��          68�`%7     @�@�8     �   ��ҳ_����_����   ʹ��WinHttp����ķ�ʽ������ҳ   �   �`%�`%�`%�`%�`%�`%�`%       /   M   k      �        �   ��_���ʷ�ʽ     0     ��_WinHttp       �      ��_����Э��ͷ       �      ��_����Э��ͷ      �   ��_�ƴ�       �   ��_��ҳ����     1     ��_�����ύ     ?  �`%�`%�`%�`%�`%�`%�`%�`%�`%�`%�`%�`%�`%�`%�`%�`%    ;   m   �   �   �     >  �  �  �     +  D  Y  �  7     �   ��ַ ��������ҳ��ַ,�������http://����https:// .    �  ���ʷ�ʽ 0=GET 1=POST 2=HEAD 3=OPTIONS      �  �ύ��Ϣ "POST"ר�� :     �  �ύCookies ���������ݱ���ʱ���Զ��ش����ص�Cookie       �  ����Cookies ���ص�Cookie )     �  ����Э��ͷ һ��һ�����û��з�����      �  ����Э��ͷ ���ص�Э��ͷ >    �  ����״̬���� ��ҳ���ص�״̬���룬���磺200��302��404�� '     �  ��ֹ�ض��� Ĭ�ϲ���ֹ��ҳ�ض��� !     �  �ֽڼ��ύ �ύ�ֽڼ����� ,     �  ������ַ ������ַ����ʽΪ 8.8.8.8:88 '    �  ��ʱ ��|Ĭ��Ϊ15��,-1Ϊ���޵ȴ�      �  �û��� �û���      �  ���� ���� -    �  ������ʶ ������ʶ��Ĭ��Ϊ1��0Ϊ·���� 1   0    ����̳� �˴��������ṩ���󣬲����������� t         ]   �   �   D  W  �  �  �    D  j  �  �  �  
  l  �  �  �  �    O  s  �  �    ?  u  �  �  �  B  W  �  �  �  �  %  9  l  �  �  ?  T  g  �  	  &	  �	  �	  �	  Q
  �
  �
  C  �  �  �  <  P  �    @  t  �     4  I  ]  �  �  �    a  �    G  �  �  �  :  �    �  �  �  �  N  o  �  �  �   ]   �   W  �  �      i  j  �  �  �  
  �  �  �    �    V  u  A  �  �  �  �  8  S  �  >  g  	  &	  �	  �	  �
  �
  �  �  ;  O  H  @  4  t    \    �  �  �  �  9  �          �  �  �  �  �  N  �  �  �   �     .  �  �    =  a  �  �  �  �  �  �  �  0  ?  m  �  �  �  �  *  1  8  W  x    �  �  �  ]  ~  �      �  �  �  	  \	  �	  �	  )
  c
  |
    U  n  �  �  2  �  �  �  �    1  d  l  �  �  �    �  �  �  �  �  �  �      2  �  �    !  Y  r  �  �  �    s  z  {  �  �  �  2  V  �  �  p  �  �  �  1  J  u  �    :  `  g  o  �      �  j�`��          6j    ��      7   ��_���ʷ�ʽ �� ѡ�� (���ʷ�ʽ �� 1, ��POST��, ��GET��) 6l               6!.               6!(               68�`%7        !)               68�`%7       @j    ��         ���ʷ�ʽ �� 0 6Rsj    ��      E   ��_���ʷ�ʽ �� ����ѡ�� (���ʷ�ʽ �� 1, ��GET��, ��POST��, ��HEAD��) 6j    ��          6l               6!&               68�`%7        j4               68�`%7   GET Rsl               6!&               68�`%7      �?j4               68�`%7   POST Rsl               6!&               68�`%7       @j4               68�`%7   HEAD Rsl               6!&               68�`%7      @j4               68�`%7   OPTIONS Rsj    ��          6mn               6!�               68�`%7l               6!&               6!G              8�`%7   WinHttp.WinHttpRequest.5.1   j               6 Rsj    ��          6Soj4               68�`%78�`%7Ttj    ��         �ֲ�_WinHttp.�鿴 () 6l               6!'               68�`%7      �k                6!(               68�`%7      �?j4               68�`%7     L�@Pj4               68�`%7!               68�`%7     @�@QrjS              8�`%7   SetTimeouts 8�`%78�`%78�`%78�`%7Rsj    ��          6l               6!'               68�`%7    jS              8�`%7	   SetProxy        @8�`%7l               6!'               68�`%7    l               6!�               68�`%7j4               68�`%7      �?RsjS              8�`%7   SetProxyCredentials 8�`%78�`%78�`%7Rsj    ��          6RsjS              8�`%7   Open 8�`%78�`%7  l               68�`%7jR              8�`%7   Option       @        Rsj    ��          6jR              8�`%7   Option       @     ��@j    ��          6mn               6!&               68�`%7    j4               68�`%7   Accept: */* Sol               6!&               6!R               68�`%7   Accept:         �j4               68�`%7!               68�`%7     Accept: */* Rsj    ��          6Ttj    ��          6l               6!&               6!R               68�`%7	   Referer:         �j4               68�`%7!               68�`%7  
   Referer:  8�`%7Rsj    ��          6l               6!&               6!R               68�`%7   Accept-Language:         �j4               68�`%7!               68�`%7     Accept-Language: zh-cn Rsj    ��          6l               6!&               6!R               68�`%7   User-Agent:         �j4               68�`%7!               68�`%7  ?   User-Agent: Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 6.1) Rsj    ��          6l               6!&               6!R               68�`%7   Content-Type:         �j4               68�`%7!               68�`%7  0   Content-Type: application/x-www-form-urlencoded Rsj    ��          6l               6!'               68�`%7    jS              8�`%7   SetRequestHeader    Cookie 8�`%7Rsj    ��          6mn               6!&               6!R               68�`%7          �jS              8�`%7   SetRequestHeader !�`��          68�`%7!�`��          68�`%7Soj4               68�`%7!d               68�`%7  p               6!8               68�`%78�`%7l               6!'               68�`%:8�`%77    jS              8�`%7   SetRequestHeader !�`��          68�`%:8�`%77!�`��          68�`%:8�`%77Rsj    ��          6Uq               6Ttj    ��          6mn               6!&               68�`%7 jS              8�`%7   Send 8�`%7Sojj              8�`%78�`%7jS              8�`%7   Send 8�`%7Ttj4               68�`%7!t              8�� :!Q              8�`%7   ResponseBody 7j4               68�`%7!L              8�`%7   GetallResponseHeaders j4               68�`%7!`               68�`%7   Set-Cookie    Set-Cookie   j4               68�`%7!M              8�`%7   Status j4               68�`%7!d               68�`%7  j4               68�`%7    p               6!8               68�`%78�`%7l               6!'               6!R               68�`%:8�`%77   Set-Cookie         �mn               6!'               6!R               68�`%:8�`%77   ;         �j4               68�`%7!               68�`%7!]               6!�`��          68�`%:8�`%77   Set-Cookie:    ;    ;  Soj4               68�`%7!               68�`%7!]               6!`               68�`%:8�`%77   Set-Cookie:      ;  Ttj    ��          6Rsj    ��          6Uq               6j4               68�`%7!M               68�`%7!               6!L               68�`%7       @j�`��          68�`%78�`%7jI              8�`%7j�`��          6j               68�`%7�8     �   ����_BASE64����A   Api�棬����_BASE64����   f   �`%�`%�`%       4       �   ����_���ݳ���      �   ����_���볤��       �   �ֽ�_���ݻ���        �`%         �   ����������         4   �   �   �     	   4   �      X   �   4      +   �   �   *  j   q   �   �   �   �   	        2  j4               68�`%7!e               68�`%7l               6!&               6!�`
��          68�`%78�`%7      �?8�`%78�`%7  j               6 Rsj4               68�`%7!o               68�`%7j�`
��          68�`%78�`%7      �?8�`%78�`%7j               68�`%7�8     �   ����_gb2312��utf8               !   �`%         �   ��ת����Դ��                !   3      E       a   j              ��utf8��gb2312 6!�`��          6!�`��          68�`%7     @�@     ��@�8     �   ʱ��_��ʽ��$   ��ʽ��ָ��������ʱ�䣬ʧ�ܷ��ؿ��ı�   x   �`%�`%�`%�`%       0   D      �`A   ��_ϵͳʱ��            ��_��������       �   ��_����       �   ��_ʱ��     4  �`%�`%�`%       �        �   ��_����ʽ��ʱ��  k     �  ��_���ڸ�ʽ ����Ϊ�գ���ʽ��yyyy [��]��M [��],d [��],dddd [����]����;yyyy/M/d dddd(��/��/�� ���ڼ�) �     �  ��_ʱ���ʽ ����Ϊ�գ���ʽ��tt [���������],H [Сʱ],m [����], s [��]����;hh:mm:ss(Сʱ:����:��),tt hh:mm:ss(��������� Сʱ:����:��) (       ;   q   �   �   5  ~  �  �  /     ;   .  q   4  5  �     �   �     @   �       "  k  �  �  �  �    $     +   2   h   �       H  j4               68�`%7!�`
��          68�`%78�`%7l               6!&               6      �?8�`%7l               6!)               6!L               68�`%7       @j4               68�`%7!a               6      I@j�`
��          6                8�`%78�`%78�`%7      I@Rsl               6!)               6!L               68�`%7       @j4               68�`%7!a               6      I@ja
��          6                8�`%78�`%78�`%7      I@Rsj               6!               68�`%78�`%7Rsj               6    �8    �   ʱ��_ȡ��ʽ8   ȡ��ǰϵͳʱ����ʽ������ֵ��0��ʾ12Сʱ�ƣ�1��ʾ24Сʱ��      �`%         �   ��_������                 6   k          6         Z   �       �   j4               68�`%7!a               6      @ja
��          6             �A@8�`%7      @j               6!w              68�`%7�0     �   Unicode��Ansi       2   �`%�`%            �   Ansi      �   ����     9   �`%�`%            �   Unicode      �  Ŀ�����         -   R   �     �  	       Q      k     ,   $   ?   d   �   �   �   $  4  D  ]  �      �  l               6!�               68�`%7j4               68�`%7        Rsj4               68�`%7!a
��          6                8�`%7      �                            j4               68�`%7!a               6!               68�`%7       @ja
��          68�`%7        8�`%7      �8�`%7!               68�`%7       @                j               68�`%7�0     �   Ansi��Unicode       5   �`%�`%            �   Unicode      �   ����     6   �`%�`%            �   Ansi      �  ԭʼ����         -   R   �   �   =  	       Q      k   �   ,   $   ?   d   �   �   �       .  5  O      W  l               6!�               68�`%7j4               68�`%7     ��@Rsj4               68�`%7!a
��          6                8�`%7      �         j4               68�`%7!o               6!               68�`%7       @ja
��          68�`%7        8�`%7      �8�`%78�`%7j               68�`%7�8          �߳�_��ʼ��COM��e   ��ʱִ���̵߳�ʱ�򣬻��Զ��رգ���ʱ�������ڶ��̵߳ĳ����ﴴ��COM����ǰ�ȳ�ʼ����һ���߳�ֻ�ܵ���һ��                                             j�`
��          6        �8          �߳�_ȡ��COM��M   ȡ��COM��ĳ�ʼ������������߳�ͷ�������� �߳�_��ʼ��COM�� ����β�����������                                             j�`
��          6�0     �   �ڲ�_Э��ͷȡֵ       2   �`%�`%           �   λ��       �   ���        �`%         �   Э��ͷ         ?   u   �   	   ?   �           c   �   �   �   �      +           j4               68�`%7!R               68�`%7   :   l               6!'               68�`%7      �j4               68�`%7!N               68�`%7!               6!L               68�`%78�`%7Rsj               6!]               68�`%7�0     �   �ڲ�_Э��ͷȡ��       2   �`%�`%           �   λ��       �   ���        �`%         �   Э��ͷ         ?   u   �   	   ?   �          c   �   �   �      +   �       �   j4               68�`%7!R               68�`%7   :   l               6!'               68�`%7      �j4               68�`%7!M               68�`%7!               68�`%7      �?Rsj               6!]               68�`%7�8     �   �ı�_ȡ���м��ı�Q   ���磺��ȡȫ�ı�Ϊ��12345��,����Ҫȡ����3����<3>��ǰ��Ϊ��2����<3>�ĺ���Ϊ��4����   �   �`%�`%�`%�`%       8   P       �   ��_ǰ���ı�λ��      �   ��_�����ı�λ��       �   ��_ǰ���ı�       �   ��_�����ı�     �  �`%�`%�`%�`%�`%    /   �   �   "  +     �   ��ȡȫ�ı� ���磺��ȡȫ�ı�Ϊ 12345 S     �   ǰ���ı� 3��ǰ��Ϊ��2��������ֱ���� #���ţ��磺"<font color=#����red#����>" S     �   �����ı� 3�ĺ���Ϊ��4��������ֱ���� #���ţ��磺"<font color=#����red#����>" A    �  ��ʼ��Ѱλ�� �ɿ�,������ָ��Ѱ ������ ǰ���ı� �Ŀ�ʼλ�� 5     �  �Ƿ����ִ�Сд Ϊ�治���ִ�Сд��Ϊ�����֡� $       I   �   �     a  �    1     �   `  �  0      `      +   �   �   �   �   �   �   #  <  U  s  �  �  �  �  �    U  \  u  |  [   t       �  j4               68�`%7!`               68�`%7   #����   ��j4               68�`%7!`               68�`%7   #����   ��j4               68�`%7!R               68�`%78�`%78�`%78�`%7l               6!'               68�`%7      �j4               68�`%7!               68�`%7!L               68�`%7Rsj4               68�`%7!R               68�`%78�`%78�`%78�`%7l               6!.               6!&               68�`%7      �!&               68�`%7      �j               6    Rsj               6!O               68�`%78�`%7!               68�`%78�`%7�8     �   ��ҳ_Cookie�ϲ�����   ���ظ��º��Cookie   h   �`%�`%�`%       <        �      ��_��Cookie��       �      ��_��Cookie��      �   ��_�ƴ�     :   �`%�`%            �  ��Cookie       �   ��Cookie  X          R   �   �   �      T  �  �  �  	  -  M  �  �  +  ?  R  �  �  "  $      �  T  �  M  ?  �  *     �  x  �  l   0   I   d   }   �   �   �     D  L  �  �  ?  q  y  �  �  
    d  }  �  �    4  �  �      <  j    ��         ������ʽ�� 6j4               68�`%7!^               68�`%7j4               68�`%7!^               68�`%7j    ��         ��ʼ����Cookie 6j4               68�`%7!d               68�`%7   ; j4               68�`%7!d               68�`%7   ; p               6!8               68�`%78�`%7l               6!&               6!$a��          68�`%7!)a��          68�`%:8�`%77  j;               68�`%78�`%:8�`%77Rsj    ��          6Uq               6j    ��         ȥ����Ч��Cookie 6j4               68�`%7    p               6!8               68�`%78�`%7l               6!'               6!N               68�`%:8�`%77       @	   =deleted j4               68�`%7!               68�`%78�`%:8�`%77   ;  Rsj    ��          6Uq               6j4               68�`%7!M               68�`%7!               6!L               68�`%7       @j    ��         ���ظ���Cookie���кϲ� 6j4               68�`%7!-a��          68�`%7   ;  j               68�`%7�0     �   �ڲ�_�����Ա�Ƿ����1   Cookie����ר��      'a%        �   ��_�ƴ�     6   %a%&a%            �  ����       �   Ҫ�ж�ֵ         4   �   �   �   �          �   4   �      X      $   ,   j   y       �   p               6!8               68%a%78'a%7l               6!&               6!)a��          68%a%:8'a%778&a%7j               6��Rsj    ��          6Uq               6j               6  �8     �   �ڲ�_Cookieȡ��       2   +a%,a%           �   λ��       �   ���        *a%         �   Cookie         @   v   �   �   	   ?   �       $   d      +   �   �   �   �   �           j4               68+a%7!R               68*a%7   =   mn               6!'               68+a%7      �j4               68,a%7!M               68*a%7!               68+a%7      �?Soj4               68,a%78*a%7Ttj               6!]               68,a%7�8     �   �ı�_ȥ�ظ��ı�       y   0a%1a%2a%3a%       1   E        �      ��_����       �      ��_����1      �   ��_�ƴ�       �   ��_�ı�     6   .a%/a%            �   ԭ�ı�       �   �ָ��  $       <   p   �   �   :  N  a  �     <   N  p   9     �   H      +   2   `   h   �   �       !  /  s  �  �  �  �  �   �       �  j4               680a%7!d               68.a%78/a%7p               6!8               680a%782a%7l               6!&               6!5a��          681a%780a%:82a%77      �j;               681a%780a%:82a%77j4               683a%7!               683a%780a%:82a%778/a%7Rsj    ��          6Uq               6j4               683a%7!M               683a%7!               6!L               683a%7!L               68/a%7j               683a%7�0    �   �ڲ�_�����Ա�Ƿ����_�ı�          8a%        �   ��_�ƴ�     6   6a%7a%            �  ����       �   Ҫ�ж�ֵ         4   o   �   �   �          �   4   �          $   ,   X   f   �       �   p               6!8               686a%788a%7l               6!&               686a%:88a%7787a%7j               688a%7Rsj    ��          6Uq               6j               6      �           �`A�?A�!�!       ϵͳʱ��	   ϵͳʱ��;   �   �`5�`5�`5�`5�`5�`5�`5�`5          /   >   M   \   k       �   ��      �   ��      �   ����      �   ��      �   ʱ      �   ��      �   ��      �   ����      	   ϵͳʱ��_
   SYSTEMTIME   �   �?5�?5�?5�?5�?5�?5�?5�?5       )   D   W   m   �   �       �   �� wYear     �   �� wMonth     �   ���� wDayOfWeek     �   �� wDay     �   Сʱ wHour     �   �� wMinute     �   �� wSecond     �   ���� wMilliseconds P   a
a
a
a
�`
�`
�?
�`
�`
�`
P! !�!`!!�!p! !�!�!    �   MultiByteToWideChar           MultiByteToWideChar   �   aEaE aE!aE"aE#aE       )   D   ]   w       �   CodePage      �   dwFlags       �   lpMultiByteStr      �   cchMultiByte       �   lpWideCharStr      �   cchWideChar       �   _UnicodeתAnsi       kernel32.dll   WideCharToMultiByte     aEaEaEaEaEaEaEaE       *   D   _   z   �   �       �   CodePage      �   dwFlags 0      �   lpWideCharStr      �   cchMultiByte -1      �  lpMultiByteStr      �   cchMultiByte      �   Ĭ���ı� 0     �   ʹ��Ĭ���ı� 0      �   GetLocaleInfo       kernel32   GetLocaleInfoA   j   aEaEaEaE       $   5       �   �ط�ID      �   ����       �   ����      �   ���ݳߴ�      �   GetTimeFormatAH   _ϵͳ��ʱ����и�ʽ�� ���ָ���ġ����ء���ʽ����һ��ϵͳʱ����и�ʽ����   kernel32.dll   GetTimeFormatA   �  aE	aE
aEaEaEaE    u   �   /  �  �  q    �   �ط�ID Locale�����ھ�����ʽ�ĵط�ID��lpFormat������ָ�����κ���Ϣ����������NULL�����������ض��ڵط�����Ϣ s    �   ��־ dwFlags����ָ����lpFormat����ô�ò���Ӧ��Ϊ�㡣���򣬿���ΪLOCALE_NOUSEROVERRIDE��ǿ��ʹ��ϵͳ�ط����� ?   �`A   ʱ��ṹ lpDate��SYSTEMTIME�����ڰ���ϵͳʱ���һ���ṹ c     �   ��ʽ�� lpFormat��String������ΪNULL��ʹ���ض��ڲ�ͬ�ط���ֵ����vbNullString����һ��NULL���� `     �   �������ı� lpDateStr��ָ��һ�����������������ɸ�ʽ��������ִ���ע�����ȶ��ִ����г�ʼ�� U    �   �������ı����� cchDate���������ĳ��ȡ���Ϊ�㣬��ʾ�����᷵����Ҫ�������Ĵ�С;     �   VariantTimeToSystemTime_Date       oleaut32.dll   VariantTimeToSystemTime   ;   �`E�`E            �   vtime     �`A   lpSystemTime        �   CryptBinaryToStringA   ����_BASE64����A   Crypt32.dll   CryptBinaryToStringA   �   �`E�`E�`E�`E�`E    #   @   \   z        �   pbBinary ��Ҫת��������     �   cbBinary ���ݳ���     �   dwFlags �����־      �   pszString ���ݻ���     �  pcchString ���س���      �   ȡϵͳʱ��_       kernel32   GetSystemTime      �?E       �?A   ʱ���ʽ            CoInitialize   ����COM	   ole32.dll   CoInitialize   $   �`E        �   pvReserved ֵΪ0           CoUninitialize   ж��COM	   ole32.dll   CoUninitialize            �   GetDateFormatAJ   ���ָ���ġ����ء���ʽ����һ��ϵͳ���ڽ��и�ʽ��  ��ʽ��������ִ��ĳ��ȡ�   kernel32.dll   GetDateFormatA   �   aEaEaEaEaEaE    u     ;  �     q    �   �ط�ID Locale�����ھ�����ʽ�ĵط�ID��lpFormat������ָ�����κ���Ϣ����������NULL�����������ض��ڵط�����Ϣ �    �   ��־ dwFlags����ָ����lpFormat����ô�ò���Ӧ��Ϊ�㡣���򣬿���ΪLOCALE_NOUSEROVERRIDE��ǿ��ʹ��ϵͳ�ط�����������ʹ���������û�ȡ���� 1   �`A   ���ڽṹ lpDate��������һ��ϵͳ���ڵĽṹ }     �   ��ʽ�� lpFormat��String������ΪNULL��ʹ���ض��ڲ�ͬ�ط���ֵ����vbNullString����һ��NULL�����������һ�����ڸ�ʽ�ִ��� `     �   �������ı� lpDateStr��ָ��һ�����������������ɸ�ʽ��������ִ���ע�����ȶ��ִ����г�ʼ�� U    �   �������ı����� cchDate���������ĳ��ȡ���Ϊ�㣬��ʾ�����᷵����Ҫ�������Ĵ�С;                                         sI�CJs �׽��»��<s s s s s             �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          s��}Ds ��¥������s s s s s                                                               sڰ!s ˨���Ļ��9s s s s s         `I                                           `I   sjIKs �ɳ����գ��s s s s s         ����                                                                        ����s���s 	�൴��ƻ��;s 	s 	s 	s 	s   	      Đ�Ր                                                      R     �         z>	# � �          
  �            
  �            `I��  �            ���   �         s8�#s 
˨���Ż��;s 
s 
s 
s 
s   
      �@Pp                                            R      � R�    � R    �@ R    �@ R    A R    "A R    2Ass s                                                                                        