* C-Minus Compilation to TM Code
* File: sort_prototype.tm
* Standard prelude:
  0:    LD 6,0(0)	load gp with maxaddress
  1:   LDA 5,0(6)	copy gp to fp
  2:    ST 0,0(0)	clear value at location 0
* Jump around i/o routines here
* Code for input routine
  4:    ST 0,-1(5)	store return
  5:    IN 0, 0, 0	input
  6:    LD 7,-1(5)	return to caller
* Code for output routine
  7:    ST 0,-1(5)	store return
  8:    LD 0,-2(5)	load output value
  9:   OUT 0, 0, 0	output
 10:    LD 7,-1(5)	return to caller
  3:   LDA 7,7(7)	jump around i/o code
* End of standard prelude
* processing global var: x
 11:   LDC 1,10(1)	load array size
 12:    ST 1,-10(6)	store array size
* processing function: minloc
* jump around function body here
 14:    ST 0,-1(5)	store return
* processing local var: low
* processing local var: high
* -> compound statement
* processing local var: i
* processing local var: x
* processing local var: k
* -> op
* -> id
* looking up id: k
 15:   LDA 0,-7(5)	load id address
* <- id
 16:    ST 0,-8(5)	op: push left
* -> id
* looking up id: low
 17:    LD 0,-3(5)	load id value
* <- id
 18:    LD 1,-8(5)	op: load left
 19:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: x
 20:   LDA 0,-6(5)	load id address
* <- id
 21:    ST 0,-8(5)	op: push left
* -> id
* * -> subs
 22:    LD 0,-2(5)	load id value
 23:    ST 0,-9(5)	store array address
* -> id
* looking up id: low
 24:    LD 0,-3(5)	load id value
* <- id
 25:   JLT 0,1(7)	halt if subscript < 0
 26:   LDA 7,1(7)	absolute jump if not
 27:  HALT 0, 0, 0	halt if subscript < 0
 28:    LD 1,-9(5)	load array size
 29:   LDC 3,1(0)	load array size
 30:   SUB 1, 1, 3	get array size location
 31:    LD 1,0(1)	load array size
 32:   SUB 1, 1, 0	compare subscript with size
 33:   JLE 1,1(7)	halt if subscript equal or greater than size
 34:   LDA 7,1(7)	absolute jump if not
 35:  HALT 0, 0, 0	halt if subscript equal or greater than size
 36:    LD 1,-9(5)	load array base address
 37:   ADD 0, 0, 1	base is at the bottom of array
 38:    LD 0,0(0)	load value at array index
* *<- subs
* <- id
 39:    LD 1,-8(5)	op: load left
 40:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: i
 41:   LDA 0,-5(5)	load id address
* <- id
 42:    ST 0,-8(5)	op: push left
* -> op
* -> id
* looking up id: low
 43:    LD 0,-3(5)	load id value
* <- id
 44:    ST 0,-9(5)	op: push left
* -> constant
 45:   LDC 0,1(0)	load const
* <- constant
 46:    LD 1,-9(5)	op: load left
 47:   ADD 0, 1, 0	op +
* <- op
 48:    LD 1,-8(5)	op: load left
 49:    ST 0,0(1)	assign: store value
* <- op
* -> while
* -> op
* -> id
* looking up id: i
 50:    LD 0,-5(5)	load id value
* <- id
 51:    ST 0,-8(5)	op: push left
* -> id
* looking up id: high
 52:    LD 0,-4(5)	load id value
* <- id
 53:    LD 1,-8(5)	op: load left
 54:   SUB 0, 1, 0	op <
* <- op
 55:   JGE 0,58(7)	jump if true
* -> compound statement
* -> if
* -> op
* -> id
* * -> subs
 56:    LD 0,-2(5)	load id value
 57:    ST 0,-8(5)	store array address
* -> id
* looking up id: i
 58:    LD 0,-5(5)	load id value
* <- id
 59:   JLT 0,1(7)	halt if subscript < 0
 60:   LDA 7,1(7)	absolute jump if not
 61:  HALT 0, 0, 0	halt if subscript < 0
 62:    LD 1,-8(5)	load array size
 63:   LDC 3,1(0)	load array size
 64:   SUB 1, 1, 3	get array size location
 65:    LD 1,0(1)	load array size
 66:   SUB 1, 1, 0	compare subscript with size
 67:   JLE 1,1(7)	halt if subscript equal or greater than size
 68:   LDA 7,1(7)	absolute jump if not
 69:  HALT 0, 0, 0	halt if subscript equal or greater than size
 70:    LD 1,-8(5)	load array base address
 71:   ADD 0, 0, 1	base is at the bottom of array
 72:    LD 0,0(0)	load value at array index
* *<- subs
* <- id
 73:    ST 0,-8(5)	op: push left
* -> id
* looking up id: x
 74:    LD 0,-6(5)	load id value
* <- id
 75:    LD 1,-8(5)	op: load left
 76:   SUB 0, 1, 0	op <
* <- op
 77:   JGE 0,26(7)	jump if greater than or equal to zero
* -> compound statement
* -> op
* -> id
* looking up id: x
 78:   LDA 0,-6(5)	load id address
* <- id
 79:    ST 0,-8(5)	op: push left
* -> id
* * -> subs
 80:    LD 0,-2(5)	load id value
 81:    ST 0,-9(5)	store array address
* -> id
* looking up id: i
 82:    LD 0,-5(5)	load id value
* <- id
 83:   JLT 0,1(7)	halt if subscript < 0
 84:   LDA 7,1(7)	absolute jump if not
 85:  HALT 0, 0, 0	halt if subscript < 0
 86:    LD 1,-9(5)	load array size
 87:   LDC 3,1(0)	load array size
 88:   SUB 1, 1, 3	get array size location
 89:    LD 1,0(1)	load array size
 90:   SUB 1, 1, 0	compare subscript with size
 91:   JLE 1,1(7)	halt if subscript equal or greater than size
 92:   LDA 7,1(7)	absolute jump if not
 93:  HALT 0, 0, 0	halt if subscript equal or greater than size
 94:    LD 1,-9(5)	load array base address
 95:   ADD 0, 0, 1	base is at the bottom of array
 96:    LD 0,0(0)	load value at array index
* *<- subs
* <- id
 97:    LD 1,-8(5)	op: load left
 98:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: k
 99:   LDA 0,-7(5)	load id address
* <- id
100:    ST 0,-8(5)	op: push left
* -> id
* looking up id: i
101:    LD 0,-5(5)	load id value
* <- id
102:    LD 1,-8(5)	op: load left
103:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
* <- if
* -> op
* -> id
* looking up id: i
104:   LDA 0,-5(5)	load id address
* <- id
105:    ST 0,-8(5)	op: push left
* -> op
* -> id
* looking up id: i
106:    LD 0,-5(5)	load id value
* <- id
107:    ST 0,-9(5)	op: push left
* -> constant
108:   LDC 0,1(0)	load const
* <- constant
109:    LD 1,-9(5)	op: load left
110:   ADD 0, 1, 0	op +
* <- op
111:    LD 1,-8(5)	op: load left
112:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
113:   LDA 7,-64(7)	absolute jump to test
* <- while
* -> id
* looking up id: k
114:    LD 0,-7(5)	load id value
* <- id
115:    LD 7,-1(5)	return to caller
* <- compound statement
116:    LD 7,-1(5)	return to caller
 13:   LDA 7,103(7)	jump around fn body
* Leaving function minloc
* processing function: sort
* jump around function body here
118:    ST 0,-1(5)	store return
* processing local var: low
* processing local var: high
* -> compound statement
* processing local var: i
* processing local var: k
* -> op
* -> id
* looking up id: i
119:   LDA 0,-5(5)	load id address
* <- id
120:    ST 0,-7(5)	op: push left
* -> id
* looking up id: low
121:    LD 0,-3(5)	load id value
* <- id
122:    LD 1,-7(5)	op: load left
123:    ST 0,0(1)	assign: store value
* <- op
* -> while
* -> op
* -> id
* looking up id: i
124:    LD 0,-5(5)	load id value
* <- id
125:    ST 0,-7(5)	op: push left
* -> op
* -> id
* looking up id: high
126:    LD 0,-4(5)	load id value
* <- id
127:    ST 0,-8(5)	op: push left
* -> constant
128:   LDC 0,1(0)	load const
* <- constant
129:    LD 1,-8(5)	op: load left
130:   SUB 0, 1, 0	op -
* <- op
131:    LD 1,-7(5)	op: load left
132:   SUB 0, 1, 0	op <
* <- op
133:   JGE 0,103(7)	jump if true
* -> compound statement
* processing local var: t
* -> op
* -> id
* looking up id: k
134:   LDA 0,-6(5)	load id address
* <- id
135:    ST 0,-8(5)	op: push left
* -> call of function: minloc
* -> id
* looking up id: a
136:    LD 0,-2(5)	load id value
* <- id
137:    ST 0,-11(5)	store arg val
* -> id
* looking up id: i
138:    LD 0,-5(5)	load id value
* <- id
139:    ST 0,-12(5)	store arg val
* -> id
* looking up id: high
140:    LD 0,-4(5)	load id value
* <- id
141:    ST 0,-13(5)	store arg val
142:    ST 5,-9(5)	push ofp
143:   LDA 5,-9(5)	push frame
144:   LDA 0,1(7)	load ac with ret ptr
145:   LDA 7,-132(7)	jump to func loc
146:    LD 5,0(5)	pop frame
147:    ST 0,-9(5)	save return value to caller's stack frame
* <- call
148:    LD 1,-8(5)	op: load left
149:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: t
150:   LDA 0,-7(5)	load id address
* <- id
151:    ST 0,-8(5)	op: push left
* -> id
* * -> subs
152:    LD 0,-2(5)	load id value
153:    ST 0,-9(5)	store array address
* -> id
* looking up id: k
154:    LD 0,-6(5)	load id value
* <- id
155:   JLT 0,1(7)	halt if subscript < 0
156:   LDA 7,1(7)	absolute jump if not
157:  HALT 0, 0, 0	halt if subscript < 0
158:    LD 1,-9(5)	load array size
159:   LDC 3,1(0)	load array size
160:   SUB 1, 1, 3	get array size location
161:    LD 1,0(1)	load array size
162:   SUB 1, 1, 0	compare subscript with size
163:   JLE 1,1(7)	halt if subscript equal or greater than size
164:   LDA 7,1(7)	absolute jump if not
165:  HALT 0, 0, 0	halt if subscript equal or greater than size
166:    LD 1,-9(5)	load array base address
167:   ADD 0, 0, 1	base is at the bottom of array
168:    LD 0,0(0)	load value at array index
* *<- subs
* <- id
169:    LD 1,-8(5)	op: load left
170:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* * -> subs
171:    LD 0,-2(5)	load id value
172:    ST 0,-8(5)	store array address
* -> id
* looking up id: k
173:    LD 0,-6(5)	load id value
* <- id
174:   JLT 0,1(7)	halt if subscript < 0
175:   LDA 7,1(7)	absolute jump if not
176:  HALT 0, 0, 0	halt if subscript < 0
177:    LD 1,-8(5)	load array size
178:   LDC 3,1(0)	load array size
179:   SUB 1, 1, 3	get array size location
180:    LD 1,0(1)	load array size
181:   SUB 1, 1, 0	compare subscript with size
182:   JLE 1,1(7)	halt if subscript equal or greater than size
183:   LDA 7,1(7)	absolute jump if not
184:  HALT 0, 0, 0	halt if subscript equal or greater than size
185:    LD 1,-8(5)	load array base address
186:   ADD 0, 0, 1	base is at the bottom of array
* *<- subs
* <- id
187:    ST 0,-8(5)	op: push left
* -> id
* * -> subs
188:    LD 0,-2(5)	load id value
189:    ST 0,-9(5)	store array address
* -> id
* looking up id: i
190:    LD 0,-5(5)	load id value
* <- id
191:   JLT 0,1(7)	halt if subscript < 0
192:   LDA 7,1(7)	absolute jump if not
193:  HALT 0, 0, 0	halt if subscript < 0
194:    LD 1,-9(5)	load array size
195:   LDC 3,1(0)	load array size
196:   SUB 1, 1, 3	get array size location
197:    LD 1,0(1)	load array size
198:   SUB 1, 1, 0	compare subscript with size
199:   JLE 1,1(7)	halt if subscript equal or greater than size
200:   LDA 7,1(7)	absolute jump if not
201:  HALT 0, 0, 0	halt if subscript equal or greater than size
202:    LD 1,-9(5)	load array base address
203:   ADD 0, 0, 1	base is at the bottom of array
204:    LD 0,0(0)	load value at array index
* *<- subs
* <- id
205:    LD 1,-8(5)	op: load left
206:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* * -> subs
207:    LD 0,-2(5)	load id value
208:    ST 0,-8(5)	store array address
* -> id
* looking up id: i
209:    LD 0,-5(5)	load id value
* <- id
210:   JLT 0,1(7)	halt if subscript < 0
211:   LDA 7,1(7)	absolute jump if not
212:  HALT 0, 0, 0	halt if subscript < 0
213:    LD 1,-8(5)	load array size
214:   LDC 3,1(0)	load array size
215:   SUB 1, 1, 3	get array size location
216:    LD 1,0(1)	load array size
217:   SUB 1, 1, 0	compare subscript with size
218:   JLE 1,1(7)	halt if subscript equal or greater than size
219:   LDA 7,1(7)	absolute jump if not
220:  HALT 0, 0, 0	halt if subscript equal or greater than size
221:    LD 1,-8(5)	load array base address
222:   ADD 0, 0, 1	base is at the bottom of array
* *<- subs
* <- id
223:    ST 0,-8(5)	op: push left
* -> id
* looking up id: t
224:    LD 0,-7(5)	load id value
* <- id
225:    LD 1,-8(5)	op: load left
226:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: i
227:   LDA 0,-5(5)	load id address
* <- id
228:    ST 0,-8(5)	op: push left
* -> op
* -> id
* looking up id: i
229:    LD 0,-5(5)	load id value
* <- id
230:    ST 0,-9(5)	op: push left
* -> constant
231:   LDC 0,1(0)	load const
* <- constant
232:    LD 1,-9(5)	op: load left
233:   ADD 0, 1, 0	op +
* <- op
234:    LD 1,-8(5)	op: load left
235:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
236:   LDA 7,-113(7)	absolute jump to test
* <- while
* <- compound statement
237:    LD 7,-1(5)	return to caller
117:   LDA 7,120(7)	jump around fn body
* Leaving function sort
* processing function: main
* jump around function body here
239:    ST 0,-1(5)	store return
* -> compound statement
* processing local var: i
* -> op
* -> id
* looking up id: i
240:   LDA 0,-2(5)	load id address
* <- id
241:    ST 0,-3(5)	op: push left
* -> constant
242:   LDC 0,0(0)	load const
* <- constant
243:    LD 1,-3(5)	op: load left
244:    ST 0,0(1)	assign: store value
* <- op
* -> while
* -> op
* -> id
* looking up id: i
245:    LD 0,-2(5)	load id value
* <- id
246:    ST 0,-3(5)	op: push left
* -> constant
247:   LDC 0,10(0)	load const
* <- constant
248:    LD 1,-3(5)	op: load left
249:   SUB 0, 1, 0	op <
* <- op
250:   JGE 0,31(7)	jump if true
* -> compound statement
* -> op
* -> id
* * -> subs
251:   LDA 0,-9(6)	load id address
252:    ST 0,-3(5)	store array address
* -> id
* looking up id: i
253:    LD 0,-2(5)	load id value
* <- id
254:   JLT 0,1(7)	halt if subscript < 0
255:   LDA 7,1(7)	absolute jump if not
256:  HALT 0, 0, 0	halt if subscript < 0
257:    LD 1,-10(6)	load array size
258:   SUB 1, 1, 0	compare subscript with size
259:   JLE 1,1(7)	halt if subscript equal or greater than size
260:   LDA 7,1(7)	absolute jump if not
261:  HALT 0, 0, 0	halt if subscript equal or greater than size
262:    LD 1,-3(5)	load array base address
263:   ADD 0, 0, 1	base is at the bottom of array
* *<- subs
* <- id
264:    ST 0,-3(5)	op: push left
* -> call of function: input
265:    ST 5,-4(5)	push ofp
266:   LDA 5,-4(5)	push frame
267:   LDA 0,1(7)	load ac with ret ptr
268:   LDA 7,-265(7)	jump to func loc
269:    LD 5,0(5)	pop frame
* <- call
270:    LD 1,-3(5)	op: load left
271:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: i
272:   LDA 0,-2(5)	load id address
* <- id
273:    ST 0,-3(5)	op: push left
* -> op
* -> id
* looking up id: i
274:    LD 0,-2(5)	load id value
* <- id
275:    ST 0,-4(5)	op: push left
* -> constant
276:   LDC 0,1(0)	load const
* <- constant
277:    LD 1,-4(5)	op: load left
278:   ADD 0, 1, 0	op +
* <- op
279:    LD 1,-3(5)	op: load left
280:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
281:   LDA 7,-37(7)	absolute jump to test
* <- while
* -> call of function: sort
* -> id
* looking up id: x
282:   LDA 0,-9(6)	load id address
* <- id
283:    ST 0,-5(5)	store arg val
* -> constant
284:   LDC 0,0(0)	load const
* <- constant
285:    ST 0,-6(5)	store arg val
* -> constant
286:   LDC 0,10(0)	load const
* <- constant
287:    ST 0,-7(5)	store arg val
288:    ST 5,-3(5)	push ofp
289:   LDA 5,-3(5)	push frame
290:   LDA 0,1(7)	load ac with ret ptr
291:   LDA 7,-174(7)	jump to func loc
292:    LD 5,0(5)	pop frame
* <- call
* -> op
* -> id
* looking up id: i
293:   LDA 0,-2(5)	load id address
* <- id
294:    ST 0,-3(5)	op: push left
* -> constant
295:   LDC 0,0(0)	load const
* <- constant
296:    LD 1,-3(5)	op: load left
297:    ST 0,0(1)	assign: store value
* <- op
* -> while
* -> op
* -> id
* looking up id: i
298:    LD 0,-2(5)	load id value
* <- id
299:    ST 0,-3(5)	op: push left
* -> constant
300:   LDC 0,10(0)	load const
* <- constant
301:    LD 1,-3(5)	op: load left
302:   SUB 0, 1, 0	op <
* <- op
303:   JGE 0,30(7)	jump if true
* -> compound statement
* -> call of function: output
* -> id
* * -> subs
304:   LDA 0,-9(6)	load id address
305:    ST 0,-5(5)	store array address
* -> id
* looking up id: i
306:    LD 0,-2(5)	load id value
* <- id
307:   JLT 0,1(7)	halt if subscript < 0
308:   LDA 7,1(7)	absolute jump if not
309:  HALT 0, 0, 0	halt if subscript < 0
310:    LD 1,-10(6)	load array size
311:   SUB 1, 1, 0	compare subscript with size
312:   JLE 1,1(7)	halt if subscript equal or greater than size
313:   LDA 7,1(7)	absolute jump if not
314:  HALT 0, 0, 0	halt if subscript equal or greater than size
315:    LD 1,-5(5)	load array base address
316:   ADD 0, 0, 1	base is at the bottom of array
317:    LD 0,0(0)	load value at array index
* *<- subs
* <- id
318:    ST 0,-5(5)	store arg val
319:    ST 5,-3(5)	push ofp
320:   LDA 5,-3(5)	push frame
321:   LDA 0,1(7)	load ac with ret ptr
322:   LDA 7,-316(7)	jump to func loc
323:    LD 5,0(5)	pop frame
* <- call
* -> op
* -> id
* looking up id: i
324:   LDA 0,-2(5)	load id address
* <- id
325:    ST 0,-3(5)	op: push left
* -> op
* -> id
* looking up id: i
326:    LD 0,-2(5)	load id value
* <- id
327:    ST 0,-4(5)	op: push left
* -> constant
328:   LDC 0,1(0)	load const
* <- constant
329:    LD 1,-4(5)	op: load left
330:   ADD 0, 1, 0	op +
* <- op
331:    LD 1,-3(5)	op: load left
332:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
333:   LDA 7,-36(7)	absolute jump to test
* <- while
* <- compound statement
334:    LD 7,-1(5)	return to caller
238:   LDA 7,96(7)	jump around fn body
* Leaving function main
335:    ST 5,-11(5)	push ofp
336:   LDA 5,-11(5)	push frame
337:   LDA 0,1(7)	load ac with ret addr
338:   LDA 7,-100(7)	jump to main loc
339:    LD 5,0(5)	pop frame
* End of execution
340:  HALT 0, 0, 0	
