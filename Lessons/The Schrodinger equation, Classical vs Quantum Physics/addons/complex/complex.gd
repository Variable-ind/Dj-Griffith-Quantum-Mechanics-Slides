extends Object

var real: float
var imag: float

var Complex = get_script()

func _init(re: float, im: float):
	real = re
	imag = im

func sum(x):
	if typeof(x) == typeof(self):
		return Complex.new(real+x.real, imag+x.imag)
	else:
		return Complex.new(real+x, imag)

func sub(x):
	if typeof(x) == typeof(self):
		return Complex.new(real-x.real, imag-x.imag)
	else:
		return Complex.new(real-x, imag)

func mul(x):
	if typeof(x) == typeof(self):
		return Complex.new(real*x.real-imag*x.imag, real*x.imag+imag*x.real)
	else:
		return Complex.new(real*x, imag*x)
		
func div(x):
	if typeof(x) == typeof(self):
		var den = x.mod2()
		return Complex.new((real*x.real+imag*x.imag)/den, (imag*x.real-real*x.imag)/den)
	else:
		return Complex.new(real/x, imag/x)

func pow(x):
	var mo = mod()
	var ph = phase()
	
	if typeof(x) == typeof(self):
		mo = mo*exp(-ph*x.imag)
		ph = ph*x.real
	else:
		ph = ph*x
		
	return Complex.new(mo*cos(ph), mo*sin(ph))

func conj():
	return Complex.new(real, -imag)

func mod2():
	return real*real+imag*imag

func mod():
	return sqrt(mod2())

func phase():
	return atan2(imag, real)

func sqrt():
	return self.pow(0.5)

func exp():
	var m = exp(real)
	return Complex.new(cos(imag), sin(imag)).mul(m)

func log():
	var m = mod()
	var p = phase()
	return Complex.new(log(m), p)
	
func sin():
	return self.exp().sub(self.conj().exp()).div(Complex.new(0, 2))
	
func cos():
	return self.exp().sum(self.conj().exp()).div(2.0)

func repr():
	return str(real) + ('+' if imag >= 0 else '') + str(imag) + 'i'
